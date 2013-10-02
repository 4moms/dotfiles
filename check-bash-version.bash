running_modern_bash() {
  [ -n "$BASH_VERSINFO" ] && (( ${BASH_VERSINFO[0]} >= 4 ))
}

warn_old_bash() {
  warn
  warn "You are using a stupidly old version of Bash."
  warn "Run update_bash for more info (and/or to install a newer one)."
  warn
}

running_modern_bash || warn_old_bash

confirm() {
  local confirm
  printf '%s' "$1"
  [[ "$1" = *\?* ]] || printf ' (y/N)? '
  read -n 1 confirm
  echo
  [[ "$confirm" = [Yy] ]]
}

with_prompt() {
  local query=$1
  shift
  if confirm "$(printf '\nMay I run this command:\n%s\nin order to %s (y/N)? ' "$*" "$query")" ; then
    "$@"
  else
    warn "Aborted"
    return 1
  fi
}

update_bash() {
  # Abort if update not needed
  if running_modern_bash ; then
    # Unless any flags are passed
    if [ $# -eq 0 ] ; then
      echo "You have a relatively recent version of bash"
      return
    fi
  else
    warn "Your really old version of bash:"
    $BASH --version
  fi

  # Can only handle updates through homebrew right now
  case "$(uname)" in
    *Darwin*) : fall through ;;
    *)
      warn "Update bash through your system package manager"
      return
      ;;
  esac

  local good_bash=/usr/local/bin/bash

  # Check to see if good bash is first in PATH
  if [ "$(which bash 2>/dev/null)" != $good_bash ] ; then
    with_prompt \
      'update bash through homebrew' \
      brew install bash \
      || return
  fi

  # Ensure good bash can be used as a login shell
  if ! grep -qxF "$good_bash" /etc/shells ; then
    with_prompt \
      'add homebrew bash as an allowed shell' \
      sudo perl -i -nwe 'print; print q@'"$good_bash"'@ if eof' /etc/shells \
      || return
  fi

  # Set the user's shell to good bash
  if perl -we 'exit !!(shift eq (getpwnam $ENV{USER})[7])' "$good_bash" ; then
    with_prompt 'set your default shell to the new one' chsh -s "$good_bash" || return
  fi

  printf 'You should be running the new version of bash when you start a new shell\n'
}
