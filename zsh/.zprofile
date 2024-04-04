PATH="$HOME/.local/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export npm_config_prefix="$HOME/.local"

xinput set-prop "Logitech Wireless Receiver Mouse" 314 0 2>/dev/null

