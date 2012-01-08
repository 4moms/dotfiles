export PATH=${PATH}:/Users/Justin/Documents/Programming/androidworkspace/android-sdk-mac_86/tools
[[ -s "/usr/local/rvm/scripts/rvm" ]] && . "/usr/local/rvm/scripts/rvm"  # This loads RVM into a shell session

source ~/.go/go        # adds to the 'go' script to your shell
source ~/.go/projects  # adds aliases for each of your projects
shopt -s cdable_vars   # set so that no '$' is required when cd'ing

function woman {
  man -t "grep" | sed -E 's/Times-Roman|Bold|Italic/Helvetica/g' | open -f -a /Applications/Preview.app/
}

alias mysql='/usr/local/mysql/bin/mysql -u root -p'
alias count='wc -l'
alias stats='cd ~/Documents/Work/Statsheet/ && ./connect'
