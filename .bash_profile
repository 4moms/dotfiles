function woman {
  man -t "grep" | sed -E 's/Times-Roman|Bold|Italic/Helvetica/g' | open -f -a /Applications/Preview.app/
}

# Bash
alias ll='ls -lahG'
alias f='find . -name'

# Git
alias gb='git branch -va'
alias gf='git fetch'
alias gp='git pull'
alias gg='git status'
alias changes='git diff --numstat --shortstat start'

# Bundler
alias be='bundle exec'

# Rspec
alias respect='bundle exec rspec'

# Rails
alias r='bundle exec rails s'

# Search history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
#bind '"\M-[A":history-search-backward'
#bind '"\M-[B":history-search-forward'

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
  export PS1="${YELLOW}\@ ${GREEN}\u@\h ${LIGHT_BLUE}(${RUBY}) ${CYAN}\w${GRAY}
$ "
}
prompt

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/Users/jreese/bin

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

eval "$(rbfu --init --auto)"

rbfu-env @1.9.3-p194
