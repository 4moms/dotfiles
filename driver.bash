drivers_dir=$dotfiles/drivers

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
  driver_rm_file
}

driver_load_file() {
  if [[ -f ~/.driver ]] ; then
    driver "$(<~/.driver)"
  fi
}

driver_rm_file() {
  rm -f ~/.driver
}

driver_save_file() {
  if [[ -n "$DRIVER" ]] ; then
    printf '%s' "$DRIVER" > ~/.driver
  fi
}

driver_usage() {
  cat <<USAGE >&2
Manages the current "driver" for a pair.

Usage:

Set driver variables:
  driver username "Full Name" email  -- set driver variables
  driver username "Full Name"        -- email defaults to {username}@4moms.com
  driver {alias}                     -- set driver variables by nickname

Other commands:
  driver show                        -- show driver variables
  driver                             --        "
  driver load                        -- load driver from ~/.driver (if present)
  driver reset                       -- reset variables to default values
  driver --help                      -- show this help
USAGE
}

driver_show_vars() {
  local var
  for var in DRIVER GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL ; do
    printf '%s=%s\n' $var "${!var:-"(unset)"}"
  done
}

driver() {
  if [[ $# -gt 1 ]] ; then
    driver_set_vars "$@"
  else
    # handle commands
    local handled=true
    case "$1" in
      ''|show) driver_show_vars ;;
      load) driver_load_file ;;
      reset) driver_reset_vars ;;
      save) driver_save_file ;;
      -h|--help) driver_usage ;;
      *) handled=false ;;
    esac

    $handled && return 0

    # handle aliased users
    if [[ -f "$drivers_dir/$1" ]] ; then
      . "$drivers_dir/$1"
      driver_save_file
    else
      printf 'Unrecognized driver alias: %s\n' "$1"
      driver_reset_vars
      return 1
    fi
  fi
}

alias me=driver
driver load
