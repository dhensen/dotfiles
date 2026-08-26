# Three layers deep: tmux, kitty, and a washed-out mascot

Two things stopped working when I started a tmux session inside kitty:

1. **Shift+Enter** — submitted the line instead of inserting a newline.
2. **Colors** — Claude Code's little pink mascot went from a vibrant coral to a dull salmon.

Outside tmux, both worked fine. Inside, broken. This post is the debugging trail.

## Why shift+enter dies in tmux

The reflex fix is the standard snippet everyone pastes:

```tmux
set -s extended-keys always
set -s extended-keys-format csi-u
set -as terminal-features 'xterm-kitty:extkeys'
```

This tells tmux: "accept extended CSI-u key sequences from the outer terminal and forward them to inner apps." Perfectly correct. Didn't fix it.

The reason is a protocol mismatch that the usual tutorials gloss over. Kitty has **two** ways to report keys:

- **Legacy encoding.** `Enter` sends `\r`. `Shift+Enter` also sends `\r`. They're indistinguishable.
- **Kitty keyboard protocol.** A superset of CSI-u that reports every key unambiguously. Kitty only enables it when an app explicitly asks for it via `CSI > 1 u` ("progressive enhancement").

Outside tmux, the flow is:

1. Claude Code writes `CSI > 1 u` directly to kitty.
2. Kitty flips into enhanced mode.
3. Shift+Enter now reports as a distinct key.

Inside tmux, the flow is:

1. Claude Code writes `CSI > 1 u` — but the "terminal" it's writing to is tmux, not kitty.
2. tmux doesn't implement the kitty keyboard protocol. It silently swallows the request and never relays anything equivalent to kitty underneath.
3. Kitty stays in legacy mode. Shift+Enter is still `\r`. Indistinguishable.

`extended-keys csi-u` covers the *other* half — when something upstream *does* send a CSI-u sequence, tmux parses and forwards it — but tmux itself can't negotiate the kitty keyboard protocol, so kitty never emits CSI-u in the first place.

### The fix: bypass the negotiation

Add an explicit remap in `kitty.conf`:

```conf
map shift+enter send_text all \x1b[13;2u
map ctrl+enter  send_text all \x1b[13;5u
```

Now kitty always emits plain CSI-u for shift+enter, regardless of which keyboard protocol any app has or hasn't enabled. tmux speaks CSI-u via `extended-keys`, so it forwards cleanly. Claude Code (and neovim and anything else that understands CSI-u) decodes it. Three layers, one common wire format.

## Why colors looked dull (part 1: the obvious suspects)

Next problem: the mascot. Same pixel on the same screen, two kitty windows. The color picker:

- Outside tmux: `#d77757` (Claude's coral)
- Inside tmux: `#d78787` (a washed-out salmon)

First, the true-color propagation chain. Inside tmux, `$TERM` is `tmux-256color`. Its terminfo doesn't advertise RGB:

```sh
$ infocmp -x tmux-256color | grep -E 'RGB|Tc'
# (nothing)
```

Apps that consult terminfo will see no truecolor support and emit 256-color sequences. Fix by telling tmux the outer terminal handles truecolor, and setting `COLORTERM` so apps that check it (like most Node CLIs) see truecolor:

```tmux
set -g default-terminal "tmux-256color"
set -as terminal-features 'xterm-kitty:RGB,extkeys'
set-environment -g COLORTERM truecolor
```

`set-environment -g` only affects panes started after the config is loaded, so `tmux kill-server` and reattach.

To sanity-check the whole pipeline, the gradient test:

```sh
awk 'BEGIN{
  s="/\\";
  for(c=0; c<77; c++) {
    r=255-(c*255/76); g=(c*510/76); b=(c*255/76);
    if(g>255) g=510-g;
    printf "\033[48;2;%d;%d;%dm\033[38;2;%d;%d;%dm%s\033[0m",
      r,g,b, 255-r,255-g,255-b, substr(s,c%2+1,1);
  } print ""
}'
```

A smooth red→green→blue gradient = truecolor is flowing. Banding = something is downgrading. Inside tmux: smooth. So the pipe is fine.

But the mascot was still `#d78787`. At this point I thought I was going crazy.

## Why colors looked dull (part 2: the real answer)

The critical clue: `#d78787` is **color 174** of the standard xterm 256-color palette. It's not a close approximation — it's an exact entry. Which means whoever was rendering the mascot had chosen to emit a 256-color index instead of truecolor RGB, regardless of what the terminal claimed to support.

That narrows it from "tmux/kitty/terminfo" to "the app itself." I grepped Claude Code's source:

```typescript
// claude-code/src/ink/colorize.ts
function clampChalkLevelForTmux(): boolean {
  if (process.env.CLAUDE_CODE_TMUX_TRUECOLOR) return false
  if (process.env.TMUX && chalk.level > 2) {
    chalk.level = 2
    return true
  }
  return false
}
```

There it is. When `$TMUX` is set, Claude Code **intentionally** clamps chalk to level 2 (256 colors). The comment explains why: most tmux setups don't advertise `Tc`/`RGB` on the outer terminal, and when tmux re-emits a truecolor sequence to an outer terminal that hasn't declared support, the sequence gets dropped and you get black cells on a dark theme. Clamping to 256-color is a defensive choice — it renders consistently, even if duller.

And critically: `chalk.rgb(215, 119, 87)` at level 2 downgrades to the nearest 6×6×6 cube color, which is... index 174 = `(215, 135, 135)` = `#d78787`. The exact shade I was seeing.

The escape hatch is right there on line one of the function:

```tmux
set-environment -g CLAUDE_CODE_TMUX_TRUECOLOR 1
```

Because my `terminal-features` already declares RGB for xterm-kitty, the clamp's defensive rationale doesn't apply to me. Opting out yields the actual `#d77757`.

## The final config

tmux:

```tmux
set -s extended-keys always
set -s extended-keys-format csi-u
set -as terminal-features 'xterm-kitty:RGB,extkeys'
set -g default-terminal "tmux-256color"
set-environment -g COLORTERM truecolor
set-environment -g FORCE_COLOR 3
set-environment -g CLAUDE_CODE_TMUX_TRUECOLOR 1
```

kitty:

```conf
map shift+enter send_text all \x1b[13;2u
map ctrl+enter  send_text all \x1b[13;5u
```

## What I took away from this

**One "terminal problem" was actually three problems at three layers.** The key encoding lived in the kitty↔tmux seam, the color-depth advertisement lived in terminfo and environment variables, and the final dullness lived in a defensive clamp inside the app itself. A fix at any single layer was necessary but not sufficient.

**"Is truecolor flowing" and "is the app emitting truecolor" are different questions.** The gradient test proved the pipe was fine, which is what made me suspect and then grep the app. Without isolating the layers I'd have kept chasing tmux config forever.

**256-color palette values are a fingerprint.** `#d78787` being an exact palette entry, not an approximation, was the tell. If a dull color matches an entry in the xterm-256 table bit-for-bit, something upstream chose 256-color on purpose. That narrows the hunt from "the whole stack" to "the code doing the emission."

**Defensive downgrades are invisible until they aren't.** Claude Code's tmux clamp is a perfectly reasonable default — most people's tmux isn't configured for truecolor passthrough, and a dull mascot beats invisible text. But for anyone who *has* configured it, the clamp is indistinguishable from a bug until you read the source. Which is the nice thing about open source: you can.
