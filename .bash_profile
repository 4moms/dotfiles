# Settings for all shells

#Environment variables
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export CVS_RSH=ssh
export LESS="-RM"
export NODE_PATH=/usr/local/lib/node

export PATH=$HOME/bin:/usr/local/share/npm/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 1.9.3


# Settings for interactive shells

# return if not interactive
[[ $- != *i* ]] && return

# History settings
# ignoreboth=ignoredups:ignorespace
# ignoredups = ignore duplicate commands in history
# ignorespace = ignore commands that start with space
HISTCONTROL=ignoreboth

# Save (effectively) all commands ever
HISTSIZE=10000000
HISTFILESIZE=10000000

# only append the history at the end (shouldn't actually be needed - histappend)
shopt -s histappend

source /usr/local/opt/chruby/share/chruby/auto.sh

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

# Simulate Zsh's preexec hook (see: http://superuser.com/a/175802/73015 )
# (This performs the histappend at a better time)
simulate_preexec() {
  [ -n "$COMP_LINE" ] || # skip if doing completion
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] || # skip if generating prompt
    history -a
}
trap simulate_preexec DEBUG

#command prompt customization
prompt() {
  local WHITE="\[\033[1;37m\]"
  local GREEN="\[\033[0;32m\]"
  local CYAN="\[\033[0;36m\]"
  local GRAY="\[\033[0;37m\]"
  local BLUE="\[\033[0;34m\]"
  local LIGHT_BLUE="\[\033[1;34m\]"
  local YELLOW="\[\033[1;33m\]"
  local RED="\[\033[1;31m\]"
  local branch
  if [ -d .git ] ; then
    branch=$(git branch | awk '/^\*/ { print $2 }')
  else
    unset branch
  fi
  local driver
  if test -n "$DRIVER" ; then
    driver="$LIGHT_BLUE($DRIVER)"
  else
    driver="${RED}NO DRIVER"
  fi
  PS1="${YELLOW}\d \@ ${GREEN}\u@\h ${branch:+$LIGHT_BLUE$branch }$driver ${CYAN}\w${GRAY}
$ "
}
PROMPT_COMMAND=prompt
# retain $PROMPT_DIRTRIM directory components when the prompt is too long
PROMPT_DIRTRIM=3

if [[ -n "${BASH_SOURCE[0]}" ]] ; then
  dotfiles="$(dirname "$(readlink "${BASH_SOURCE[0]}")")"
fi

# Finished if we couldn't find our root directory
[[ -z "$dotfiles" ]] && return

# Load completion files from $dotfiles/completion/{function}.bash
if (( BASH_VERSINFO[0] < 4 )) ; then
  # For old versions of Bash, preload them all
  for script in "$dotfiles/completion/"*.bash ; do
    . "$script" > /dev/null 2>&1
  done
else
  # If we have version >= 4, we can load these as needed
  _completion_load() {
    . "$dotfiles/completion/$1.bash" > /dev/null 2>&1 && return 124
  }
  complete -D -F _completion_load
fi

# Pair-programming "driver" functions
. $dotfiles/driver.bash

alias me=driver
driver load

# Workaround for broken chruby
chruby 1.9.3p392
