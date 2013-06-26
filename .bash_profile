# Settings for all shells

#Environment variables
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export HISTCONTROL=ignoredups #ignore duplicate commands in history
export CVS_RSH=ssh
export LESS="-RM"
export NODE_PATH=/usr/local/lib/node

export PATH=/usr/local/share/npm/bin:/usr/local/share/python:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/Users/jreese/bin

source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby 1.9.3


# Settings for interactive shells

# return if not interactive
[[ $- != *i* ]] && return

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

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Pair-programming "driver" functions
git_set_user() {
  export GIT_AUTHOR_NAME="$1"
  export GIT_AUTHOR_EMAIL="$2"
  export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
}

driver_set_vars() {
  local username fullname email
  username="$1"
  fullname="$2"
  email="${3:-$username@4moms.com}"
  DRIVER=$username
  git_set_user "$fullname" "$email"
}

driver_reset_vars() {
  unset DRIVER
  git_set_user "Pairing Station - $(hostname -s)" software@4moms.com
}

driver() {
  local unrecognized=false wrong_usage=false

  case $# in
    2|3) ;;
    0|1)
      case "$1" in
        aland|drew) driver aland "Andrew Land" ;;
        ashenoy|ash|shenoy) driver ashenoy "Alex Shenoy" ;;
        asmith|andy|asm) driver asmith "Andy Smith" ;;
        athorne|ath|thorne) driver athorne "Alex Thorne" ;;
        bhaskell|ben|bh|benizi) driver bhaskell "Benjamin R. Haskell" ;;
        dcarper|dan|dc) driver dcarper "Dan Carper" dcarper@dreamagile.com ;;
        diachini|danny|di) driver diachini "Danny Iachini" ;;
        jreese|justin|jr) driver jreese "Justin Reese" justin.x.reese@gmail.com ;;
        mzalar|mark|mz) driver mzalar "Mark Zalar" ;;
        pwaddingham|patrick|pw) driver pwaddingham "Patrick Waddingham" ;;
        rvandervort|roger|rv) driver rvandervort "Roger Vandervort" rvandervort@gmail.com ;;
        reset|'') driver_reset_vars ; return 0 ;;
        *) unrecognized=true ;;
      esac

      if $unrecognized ; then
        printf 'Unrecognized driver alias: %s\n' "$1"
        driver_reset_vars
        return 1
      fi

      return 0
      ;;
    *) wrong_usage=true ;;
  esac

  if $wrong_usage ; then
    cat <<USAGE >&2
Sets or resets the current "driver" for a pair.

Usage: driver username "Full Name" [email@address]
       driver reset
Email address defaults to {username}@4moms.com
USAGE
    return 1
  fi

  driver_set_vars "$@"
}

alias me=driver
