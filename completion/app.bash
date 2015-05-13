_app_complete() {
  local word="${COMP_WORDS[COMP_CWORD]}"
  local githome="$(dirname "$dotfiles")"
  local deployhome=/var/www
  local -a devs deploys oldstyle

  case $COMP_CWORD in
    1)
      # complete app names

      # if any dirs in $githome, get their basenames
      if stat -t "$githome"/* >/dev/null 2>&1 ; then
        devs=( "$githome"/* )
        devs=( "${devs[@]##*/}" )
      fi

      # if any apps in $deployhome, get their app names
      if stat -t "$deployhome"/* >/dev/null 2>&1 ; then
        deploys=( "$deployhome"/* )
        deploys=( "${deploys[@]##*/}" )
      fi

      # if any apps in $deployhome, get their app names
      if stat -t "$deployhome"/*/* >/dev/null 2>&1 ; then
        oldstyle=( "$deployhome"/*/* )
        oldstyle=( "${oldstyle[@]##*/}" )
      fi
      ;;
    2)
      # complete environments
      local app="${COMP_WORDS[1]}"

      # only one dir for development
      if [[ -e "$githome"/"$app" ]] ; then
        devs=( development )
      fi

      # find deployment dirs: /var/www/$app/$env
      if stat -t "$deployhome"/"$app"/* >/dev/null 2>&1 ; then
        deploys=( "$deployhome"/"$app"/* )
        deploys=( "${deploys[@]##*/}" )
      fi

      # find old-style deployment dirs: /var/www/$env/$app
      if stat -t "$deployhome"/*/"$app" >/dev/null 2>&1 ; then
        oldstyle=( "$deployhome"/*/"$app" )
        oldstyle=( "${oldstyle[@]%/*}" )
        oldstyle=( "${oldstyle[@]##*/}" )
      fi
      ;;
    *)
      # unknown, so return no completions
      COMPREPLY=()
      return
      ;;
  esac

  COMPREPLY=( $(compgen -W "${devs[*]} ${deploys[*]} ${oldstyle[*]}" -- "$word") )
}

complete -F _app_complete app
