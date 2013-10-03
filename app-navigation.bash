app() {
  local name=$1 env=$2 dir
  local githome="$(dirname "$dotfiles")"
  local deployhome=/var/www
  local -a possible

  case "$name" in
    a|aa) name=aardmark ;;
    d) name=dragonfox ;;
    dz) name=dragonzorro ;;
  esac

  # if env is development or unspecified, try $githome and deployment dirs
  if [[ "${env:-development}" == development ]] ; then
    possible=(
      "$githome"/"$name"
      "$deployhome"/"$name"/development
      "$deployhome"/development/"$name"
    )
    if [ -z "$env" ] ; then
      possible+=(
        "$deployhome"/"$name"/production
        "$deployhome"/production/"$name"
      )
    fi
  else
    # otherwise, try deployment dirs
    possible=(
      "$deployhome"/"$name"/"$env"
      "$deployhome"/"$env"/"$name"
    )
  fi

  # `cd` into the first possible directory that exists
  for dir in "${possible[@]}" ; do
    if [ -e "$dir" ] ; then
      cd "$dir"
      return 0
    fi
  done

  # else print an error message
  warn 'No directory found'
  return 1
}
