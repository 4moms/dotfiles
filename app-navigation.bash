app() {
  local name=$1 env=$2 dev deploy

  case "$name" in
    a|aa) name=aardmark ;;
    d) name=dragonfox ;;
    dz) name=dragonzorro ;;
  esac

  dev="$(dirname "$dotfiles")/$name"
  deploy="/var/www/${env:-production}/$name/current"
  if [ -e "$dev" ]
  then cd "$dev"
  elif [ -e "$deploy" ]
  then cd "$deploy"
  else printf 'No directory found\n'
  fi
}
