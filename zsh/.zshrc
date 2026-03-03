# PATH
export PATH="$HOME/.opencode/bin:/opt/homebrew/opt/libpq/bin:$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

export AI_COMMIT_ENV_FILE="$HOME/.env.ai-commit"
export DOCKER_CLI_HINTS=false
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"
SAVEHIST=100000
HISTSIZE=10000

plugins=(
  git
  autojump
  docker
)

source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"

# Aliases
alias gst='git status'
alias ga='git add'
alias gco='git checkout'
alias gl='git pull'
alias gc='git commit --verbose'
alias gp='git push'
alias gd='git diff'
alias gdca='git diff --cached'
alias grv='git remote --verbose'

alias nvim=nvim_auto_address
alias vim=nvim
alias vimdiff='nvim -d'
alias sudovimdiff='SUDO_EDITOR=vimdiff sudoedit'
alias zv="vim ~/.zshrc"
alias ta='tmux attach || tmux new'
alias tk='tmux kill-server'
alias hf='history | fzf'
alias ass=ssh-add
alias sa='ssh-add ~/.ssh/id_rsa'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias v=edit

function nvim_auto_address() {
    local socket_path="/tmp/nvim-$(date +%s%N)"
    NVIM_LISTEN_ADDRESS=$socket_path command nvim "$@"
}

function genpasswd() {
    local l=$1
    [ "$l" = "" ] && l=20
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

function aws-login() {
    if [ -n "$1" ]; then
        if [ "$(grep -c $1 ~/.aws/config)" -lt 1 ]; then
            echo "profile $1 not found"
        else
            unset AWS_ACCESS_KEY_ID
            unset AWS_SECRET_ACCESS_KEY
            unset AWS_SECURITY_TOKEN
            unset AWS_SESSION_EXPIRATION
            unset AWS_SESSION_TOKEN
            unset AWS_VAULT
            aws-vault exec $1 --
            export AWS_PROFILE=$1
            if [ -n "$TMUX_PANE" ]; then
                tmux rename-window -t${TMUX_PANE} ${AWS_PROFILE}
            fi
        fi
    else
        echo "profile as an argument required"
    fi
}

edit() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        WINDOW_NAME=$(basename $(git rev-parse --show-toplevel))
    else
        WINDOW_NAME=$(basename $PWD)
    fi
    echo ${WINDOW_NAME}
    tmux rename-window -t${TMUX_PANE} "${WINDOW_NAME}"
    tmux split-window -v -l 30%
    tmux select-pane -t0
    nvim "${1}"
}

if [[ "$OSTYPE" != "darwin"* ]]; then
    alias feh='feh --scale-down'
    alias bim=vim

    if [[ $TERM == xterm-termite && -n "$DISPLAY" ]]; then
        . /etc/profile.d/vte.sh
        __vte_osc7
    fi

    if [ -f ~/.dircolors ]; then
        eval "$(dircolors ~/.dircolors)"
    fi

    export BROWSER=firefox
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

    if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
fi

zstyle ":completion:*:commands" rehash 1

export RANGER_LOAD_DEFAULT_RC=FALSE
export LESS="-R -F -X $LESS"
export AWS_EC2_METADATA_DISABLED=true

if [ -f "$HOME/bin/zshrc_$HOST" ]; then
    . "$HOME/bin/zshrc_$HOST"
fi

if [ -f "$HOME/bin/aws_login" ]; then
    source "$HOME/bin/aws_login"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

source "$HOME/bin/tmux-auto-window-name"
