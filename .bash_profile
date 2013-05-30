#.bashrc

#Environment variables
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export HISTCONTROL=ignoredups #ignore duplicate commands in history
export CVS_RSH=ssh
export LESS="-RM"
export PATH=/usr/local/bin:$PATH
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby 1.9.3

# Bash
alias ll='ls -lahG'
alias f='find . -name'

# Git
alias gg='git status'
alias gb='git branch -va'
alias gcm='git commit -m'
alias gf='git fetch'
alias gp='git pull'
alias changes='git diff --numstat --shortstat start'
alias jcom='git commit --author="justin.x.reese@gmail.com"'
alias standup='git log --since yesterday --author `git config user.email` --pretty=short'

# Bundler
alias be='bundle exec'
alias rake='be rake'

# Rspec
alias respect='bundle exec rspec'

# Rails
alias r='bundle exec rails s'
alias rspec='rspec -c'
# Pow
alias rpow='touch tmp/restart.txt'

# Apps
alias v='vim'
alias vi='vim'
function onport() {
  (( $# )) || set -- 3000
  lsof -Pni :$*
}

# Search history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#command prompt customization
function prompt
{
	local WHITE="\[\033[1;37m\]"
	local GREEN="\[\033[0;32m\]"
	local CYAN="\[\033[0;36m\]"
	local GRAY="\[\033[0;37m\]"
	local BLUE="\[\033[0;34m\]"
	local LIGHT_BLUE="\[\033[1;34m\]"
	local YELLOW="\[\033[1;33m\]"
  export PS1="${YELLOW}\d \@ ${GREEN}\u@\h ${LIGHT_BLUE} ${CYAN}\w${GRAY}
$ "
}
export NODE_PATH="/usr/local/lib/node"
PATH=/usr/local/share/npm/bin:/usr/local/share/python/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/Users/jreese/bin
prompt

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
