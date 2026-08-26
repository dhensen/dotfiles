typeset -U path

if [[ "$OSTYPE" == "darwin"* ]]; then
  . ~/.env
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"

  # Stable symlink to launchd's ssh-agent socket. Modern macOS no longer
  # propagates SSH_AUTH_SOCK to GUI apps or sshd children, so ask launchd
  # directly and refresh the symlink on each login shell.
  _ssh_sock=$(launchctl print "gui/$(id -u)/com.openssh.ssh-agent" 2>/dev/null \
    | awk '/SSH_AUTH_SOCK =>/{print $3; exit}')
  if [[ -S "$_ssh_sock" && "$_ssh_sock" != "$HOME/.ssh/agent.sock" ]]; then
    ln -sf "$_ssh_sock" "$HOME/.ssh/agent.sock"
  fi
  unset _ssh_sock
  export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
else
  export npm_config_prefix="$HOME/.local"

  xinput set-prop "Logitech Wireless Receiver Mouse" 314 0 2>/dev/null
fi

export WINIT_X11_SCALE_FACTOR=1
PATH="$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
