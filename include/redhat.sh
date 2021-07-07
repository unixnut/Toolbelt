commands[meta:RHEL:epel]="yum-config-manager --enable rhel-${DISTRO_RELEASE_MAJOR}-server-optional-rpms && yum-config-manager --enable rhel-${DISTRO_RELEASE_MAJOR}-server-extras-rpms && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
aliases[meta:CentOS:epel]=${DISTRO}:epel-release
aliases[meta:OracleLinux:epel]=${DISTRO}:epel-release

commands[RHEL:]="yum install"
commands[CentOS:]="yum install"
commands[OracleLinux:]="yum install"
commands[Fedora:]="dnf install"


safe_rpm_install()
{
  local pkg_basename=${1##*/}

  fetch $SCRIPT_TMPDIR "$1"
  if rpmkeys --checksig $SCRIPT_TMPDIR/$pkg_basename
  then
    rpm -Uvh $SCRIPT_TMPDIR/$pkg_basename
  else
    echo "$SELF: Error: No signing key installed for $1" >&2
    exit $EXIT_INSECURE_PACKAGE
  fi
}


# Usage: add_repository_yum [ -f ] [ -k <key_url> ] <name> <url>
add_repository_yum()
{
  local force_fetch=n

  if [ "$1" = -f ] ; then
    # Force fetch even if done before
    force_fetch=y
    shift
  fi

  if [ "$1" = -k ] ; then
    rpm --import $2
    shift
    shift
  fi

  local name=$1 url=$2

  if [ -f /etc/yum.repos.d/$name.repo ] && [ $force_fetch = n ] ; then
    return 0
  fi

  case $url in
    *.rpm)
      # Package that contains .repo file etc.
      safe_rpm_install "$url"
      ;;

    *)
      # Downloadable .repo file
      # TO-DO: check first
      yum install -y yum-utils

      yum-config-manager --add-repo "$url"
  esac

  [ -f /etc/yum.repos.d/$name.repo ]
}


# Usage: add_repository_dnf [ -f ] [ -k <key_url> ] <name> <url>
add_repository_dnf()
{
  local name=$1 url=$2

  if [ "$1" = -f ] ; then
    # Force fetch even if done before
    force_fetch=y
    shift
  fi

  if [ "$1" = -k ] ; then
    rpm --import $2
    shift
    shift
  fi

  local name=$1 url=$2

  if [ -f /etc/yum.repos.d/$name.repo ] && [ $force_fetch = n ] ; then
    return 0
  fi

  case $url in
    *.rpm)
      # Package that contains .repo file etc.
      rpm -Uvh $url
      ;;

    *)
      dnf_setup
      dnf config-manager --add-repo "$url"
  esac

  ## dnf check-update

  [ -f /etc/yum.repos.d/$name.repo ]
}


dnf_setup()
{
  if [ "$DNF_SET_UP" != y ] ; then
    dnf install -y dnf-plugins-core compat-openssl10
    DNF_SET_UP=y
  fi
}
