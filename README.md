[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/dhensen/dotfiles)

# Dotfiles

# Install

Run install script

## Manually

Or select subfolders to stow selectively:

```
stow zsh -t "$HOME"
stow tmux -t "$HOME"
```

## TPM

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Private API keys

API keys belong in `$HOME/.config/dotfiles/secrets.env`, outside this repository.
The file is loaded automatically by `zsh/.zprofile` for new login shells.

Create it with permissions that allow only your user to read and write it:

```sh
mkdir -p "$HOME/.config/dotfiles"
chmod 700 "$HOME/.config/dotfiles"
touch "$HOME/.config/dotfiles/secrets.env"
chmod 600 "$HOME/.config/dotfiles/secrets.env"
```

Add keys using shell export syntax, replacing the placeholders with real values:

```sh
export ANTHROPIC_API_KEY='...'
export OPENAI_API_KEY='...'
export TAVILY_API_KEY='...'
```

Start a new login shell or load the file into the current shell with:

```sh
source "$HOME/.config/dotfiles/secrets.env"
```

Never commit `secrets.env` or paste real keys into tracked configuration files.
