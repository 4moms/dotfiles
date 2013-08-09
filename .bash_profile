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

# set a default terminal type for deficient systems or weird terminals
tput longname >/dev/null 2>&1 || export TERM=xterm

## Set up $dotfiles directory
# simulates GNU-style `readlink -f` (-f = follow components to make full path)
# then takes the `dirname` of it. directory must exist
dirname_readlink() {
  local target="$1" wd="$(pwd)"
  if cd -L "$(dirname "$(readlink "$target")")" >/dev/null 2>&1 ; then
    pwd -P
    cd "$wd" >/dev/null 2>&1
  fi
}

if [[ -n "${BASH_SOURCE[0]}" ]] ; then
  dotfiles="$(dirname_readlink "${BASH_SOURCE[0]}")"
fi

# Finished if we couldn't find our root directory
if [[ -z "$dotfiles" ]] || [[ ! -d "$dotfiles" ]] ; then
  tput setaf 1 >&2
  echo "Couldn't find root of dotfiles directory. Exiting .bash_profile early." >&2
  tput sgr0 >&2
  return
fi

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
bind "\"$(tput kcuu1)\": history-search-backward"
bind "\"$(tput kcud1)\": history-search-forward"

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
  local no_color='\[\033[0m\]'

  local time="${YELLOW}\d \@$no_color"
  local whoami="${GREEN}\u@\h$no_color"
  local dir="${CYAN}\w$no_color"

  local branch
  if [ -d .git ] ; then
    branch=$(git branch | awk '/^\*/ { print $2 }')
    branch="${branch:+$LIGHT_BLUE$branch }"
  else
    unset branch
  fi

  local driver
  if test -n "$DRIVER" ; then
    driver="$LIGHT_BLUE($DRIVER)"
  else
    driver="${RED}NO DRIVER"
  fi

  PS1="$time $whoami $branch$dir\n$driver$no_color \$ "
}
PROMPT_COMMAND=prompt
# retain $PROMPT_DIRTRIM directory components when the prompt is too long
PROMPT_DIRTRIM=3

# Load completion files from $dotfiles/completion/{function}.bash
for script in "$dotfiles/completion/"*.bash ; do
  . "$script" > /dev/null 2>&1
done

# Pair-programming "driver" functions
. $dotfiles/driver.bash

# Workaround for broken chruby
chruby 1.9.3p392
