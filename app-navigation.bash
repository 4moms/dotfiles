app() {
  local app=$1 env=$2 dir
  local githome="$(dirname "$dotfiles")"
  local deployhome=/var/www
  local -a possible

  case "$app" in
    a|aa) app=aardmark ;;
    d) app=dragonfox ;;
    dz) app=dragonzorro ;;
  esac

  # if env is development or unspecified, try $githome and deployment dirs
  if [[ "${env:-development}" == development ]] ; then
    possible=(
      "$githome"/"$app"
      "$deployhome"/"$app"/development
      "$deployhome"/development/"$app"
    )
    if [ -z "$env" ] ; then
      possible+=(
        "$deployhome"/"$app"/production
        "$deployhome"/production/"$app"
      )
    fi
  else
    # otherwise, try deployment dirs
    possible=(
      "$deployhome"/"$app"/"$env"
      "$deployhome"/"$env"/"$app"
    )
  fi

  # `cd` into the first possible directory that exists
  for dir in "${possible[@]}" ; do
    if [ -e "$dir" ] ; then
      cd "$dir"
      return 0
    fi
  done

  # else check to see if the remote exists
  local repo=git@github.com:4moms/"$app"
  local dest="$githome"/"$app"
  if git ls-remote "$repo" &>/dev/null ; then
    printf 'Cloning %s into %s\n' "$repo" "$dest"
    git clone "$repo" "$dest" && cd "$dest"
  else
    warn "No directory found and $repo doesn't exist"
    return 1
  fi
}
