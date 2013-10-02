app() {
  local name=$1 env=$2 dev deploy
  dev="$(dirname "$dotfiles")/$name"
  deploy="/var/www/${env:-production}/$name/current"
  if [ -e "$dev" ]
  then cd "$dev"
  elif [ -e "$deploy" ]
  then cd "$deploy"
  else printf 'No directory found\n'
  fi
}
