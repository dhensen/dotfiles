# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH:$HOME/.local/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gianu"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

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

# PHP/Composer stuff
#export COMPOSER_HOME=~/.composer
#alias composer="composer --ansi"
#export PATH=$PATH:$HOME/.composer/vendor/bin

# Golang stuff
#export GOPATH=~/go
#export PATH=$PATH:/usr/local/go/bin
#export PATH=$PATH:$GOPATH/bin

# Yarn stuff
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

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
alias bim='vim'

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

# on an old docker version use docker ps instead of docker container list
docker_last () { docker container list -q -n 1 }
dkll () { docker logs $(docker_last) }
dkllf () { docker logs $(docker_last) -f }

export LESS="-F -X $LESS"

#if [ -x "$(command -v ksshaskpass)" ]; then
#    export SSH_ASKPASS=/usr/bin/ksshaskpass
#fi

#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
#fi
#if [[ ! "$SSH_AUTH_SOCK" ]]; then
#    eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
#fi

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# < /dev/null makes it prompt via an external input instead of on the tty
# ssh-add -q ~/.ssh/id_rsa < /dev/null
# This one only prompts if the key has not already been added
#ssh-add -l | grep -q `ssh-keygen -lf ~/.ssh/id_rsa  | awk '{print $2}'` || ssh-add -q ~/.ssh/id_rsa

export SA_PYTHON_PATH=/home/dino/.virtualenvs/standard-arbitrage-L4UDjNN2/bin/python

export PATH="$HOME/.poetry/bin:$PATH"
if ! [ -x "$(command -v pyenv)" ]; then
  echo 'Error: pyenv is not installed.' >&2
else
    eval "$(pyenv init -)"
fi

alias vim=nvim

export AWS_EC2_METADATA_DISABLED=true
