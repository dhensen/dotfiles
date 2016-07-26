#zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH=/home/dino/.oh-my-zsh

ZSH_THEME="gianu"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

SAVEHIST=100000
HISTSIZE=1000

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump zsh-autosuggestions)

# User configuration
# PATH is already populated, next line should be commented unless you know what you are doing
#export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export PATH="/home/$USER/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Default programs
export EDITOR='vim'
export BROWSER=firefox

# Composer stuff
export COMPOSER_HOME=~/.composer
alias composer="composer --ansi"
export PATH=$PATH:$HOME/.composer/vendor/bin

# Golang stuff
export GOPATH=~/go
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

# Yarn stuff
export PATH="$HOME/.yarn/bin:$PATH"

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
if [ -f '/home/dino/.google-cloud-sdk/path.zsh.inc' ]; then source '/home/dino/.google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/dino/.google-cloud-sdk/completion.zsh.inc' ]; then source '/home/dino/.google-cloud-sdk/completion.zsh.inc'; fi

# Jarvis environment vars
export DOCKER_IMAGE_REPOSITORY_CREDENTIALS_FILE=~/riddles/secrets/jarvis-google-keys.json
export TEST_PROJECT_CREDENTIALS_FILE=~/riddles/secrets/google-keys.test.json

# Python virtualenvwrapper vars
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/work
source /usr/bin/virtualenvwrapper_lazy.sh

#zprof
