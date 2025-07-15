DEBIAN_ARCHIVE_URL=http://ftp.debian.org/debian/
APT=apt-get
APT_OPTIONS=-y

commands[meta:Debian:backports]="add_repository_apt backports $DEBIAN_ARCHIVE_URL main $(lsb_release -cs)-backports"
commands[Debian:]=apt_soft_install
commands[Ubuntu:]=apt_soft_install

add_key_apt()
{
  local filename=${1##*/}

  case $1 in
      *.gpg) if [ ! -f /etc/apt/trusted.gpg.d/$filename ] ; then
                fetch /etc/apt/trusted.gpg.d/ "$1"
             fi
             ;;
      *)     echo "$SELF: Error: Unsupported URL"
             exit $EXIT_BAD_URL
             ;;
  esac
}


# Usage: add_repository_apt [ -f ] [ -k <key_url> ] <name> <url> [ <component> [ <dist> ] ]
#
# Creates /etc/apt/sources.list.d/<name>.list .  Optionally downloads a package
# verification key.  If <dist> is missing it will be replaced by the distro
# codename.  If it is "-" then a dist won't be included on the `deb` line.
add_repository_apt()
{
  local force_fetch=n
  local key_str

  if [ "$1" = -f ] ; then
    # Force fetch even if done before
    force_fetch=y
    shift
  fi

  if [ "$1" = -k ] ; then
    case $2 in
      */*)   key_str=$(fetch - $2) ;;
      *.gpg) if [ ! -f /etc/apt/trusted.gpg.d/$2 ] ; then
                install -m 644 $LIB_DIR/package_keys/$2 /etc/apt/trusted.gpg.d/
             fi ;;
      *)     key_str=$(cat $LIB_DIR/package_keys/$2) ;;
    esac
    shift
    shift
  fi

  local name=$1 url=$2 component=${3:-main} dist=${4:-$(lsb_release -cs)}

  if [ -f /etc/apt/sources.list.d/$name.list ] && [ $force_fetch = n ] ; then
    return 0
  fi

  if [ -n "$key_str" ] ; then
    echo "$key_str" | apt-key add -
  fi

  if [ $dist = - ] ; then
    dist=
  fi

  echo "deb [arch=amd64] $url $dist $component" > /etc/apt/sources.list.d/$name.list
  $APT update
}


apt_soft_install()
{
  # Only run the installer command if at least one package is missing,
  # i.e. dpkg-query displays an error
  # Note: due to file descriptor copy semantics; order is correct
  if [ -n "$(dpkg -s "$@" 2>&1 >/dev/null)" ] ; then
    $APT install $APT_OPTIONS "$@"
  fi
}
