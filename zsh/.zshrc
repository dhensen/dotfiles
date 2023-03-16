# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH:$HOME/.local/bin

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="norm"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
SAVEHIST=100000
HISTSIZE=10000

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  autojump
  docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export LANG=en_US.UTF-8
export EDITOR='vim'


# Yarn stuff
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

# Password generator
function genpasswd() {
    local l=$1
    [ "$l" = "" ] && l=20
    tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

# Aliases
alias sudovimdiff='SUDO_EDITOR=vimdiff sudoedit'
alias feh='feh --scale-down'
alias ta='tmux attach || tmux new'
alias tk='tmux kill-server'
alias bim=vim
alias vim=nvim

# Termite stuff
if [[ $TERM == xterm-termite && -n "$DISPLAY" ]]; then
	. /etc/profile.d/vte.sh
	__vte_osc7
fi

if [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi

zstyle ":completion:*:commands" rehash 1

# Ranger stuff
export RANGER_LOAD_DEFAULT_RC=FALSE

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/.google-cloud-sdk/completion.zsh.inc"; fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

export BROWSER=firefox
export LESS="-F -X $LESS"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# this one disables some ec2 lookup that makes aws cli very slow in some cases
export AWS_EC2_METADATA_DISABLED=true

