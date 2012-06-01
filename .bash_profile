source ~/.rvm/scripts/rvm

[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm"  # This loads RVM into a shell session

function woman {
  man -t "grep" | sed -E 's/Times-Roman|Bold|Italic/Helvetica/g' | open -f -a /Applications/Preview.app/
}

# Git
alias gb='git branch -va'
alias gf='git fetch'
alias gp='git pull'

# Bundler
alias be='bundle exec'
