DEBIAN_ARCHIVE_URL=http://ftp.debian.org/debian/
APT=apt-get
APT_OPTIONS=-y

commands[meta:Debian:backports]="add_repository_apt backports $DEBIAN_ARCHIVE_URL main $(lsb_release -cs)-backports"
commands[Debian:]="$APT install $APT_OPTIONS"
commands[Ubuntu:]="$APT install $APT_OPTIONS"


# Usage: add_repository_apt [ -f ] [ -k <key_url> ] <name> <url> [ <component> [ <dist> ] ]
#
# Creates /etc/apt/sources.list.d/<name>.list .  Optionally downloads a package
# verification key.  If <dist> is missing it will be replaced by the distro
# codename.  If it is "-" then a dist won't be included on the `deb` line.
add_repository_apt()
{
  local force_fetch=n

  if [ "$1" = -f ] ; then
    # Force fetch even if done before
    force_fetch=y
    shift
  fi

  if [ "$1" = -k ] ; then
    fetch - $2 | apt-key add -
    shift
    shift
  fi

  local name=$1 url=$2 component=${3:-main} dist=${4:-$(lsb_release -cs)}

  if [ -f /etc/apt/sources.list.d/$name.list ] && [ $force_fetch = n ] ; then
    return 0
  fi

  if [ $dist = - ] ; then
    dist=
  fi

  echo "deb [arch=amd64] $url $dist $component" > /etc/apt/sources.list.d/$name.list
  $APT update
}
