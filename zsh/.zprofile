PATH="$HOME/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  . ~/.env
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
else
  export npm_config_prefix="$HOME/.local"

  xinput set-prop "Logitech Wireless Receiver Mouse" 314 0 2>/dev/null
fi

export WINIT_X11_SCALE_FACTOR=1
