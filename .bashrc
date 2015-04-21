# Source .bash_profile if this is not a login shell
# (in which case it *should* already be sourced)
[[ $- != *l* ]] && . .bash_profile

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
