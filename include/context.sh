# set OS, DISTRO, DISTRO_BASE and DISTRO_RELEASE{,_MAJOR,_MINOR,_PL}
# also set DISTRO_CODENAME (only useful for Debian/Ubuntu)
export OS=`uname`
# Before running lsb_release, ensure LSB config files are present to avoid
# botched output.
if [ -n "$(type -p lsb-release)" -a \
     \( -r /etc/lsb-release -o -d /etc/lsb-release.d/ -o \
        -r /etc/dpkg/origins/default \) ] ; then
  export DISTRO=`lsb_release --id --short | sed 's/ LINUX//'`
  export DISTRO_CODENAME=`lsb_release --codename --short`
  export DISTRO_RELEASE=`lsb_release --release --short`

  # Fix Ubuntu flavours
  case "$DISTRO" in
    LinuxMint) DISTRO=Ubuntu ;;
  esac
fi

if [ -z "$DISTRO" -o \
     "$DISTRO" = Debian -a "$DISTRO_RELEASE" = stable-updates ] ; then
  case $OS in
    Linux)
      if [ -f /etc/os-release ] ; then
        export DISTRO=$(sed -n -e 's/Debian .*/Debian/' -e 's/^NAME="\?\([^"]*\).*/\1/p' /etc/os-release)
        export DISTRO_CODENAME=$(sed -n -e 's/^VERSION_CODENAME="\?\([^"]*\).*/\1/p' /etc/os-release)
        export DISTRO_RELEASE=$(sed -n -e 's/^VERSION_ID="\?\([^"]*\).*/\1/p' /etc/os-release)
      elif [ -f /etc/debian_version ] ; then
        export DISTRO=Debian
        export DISTRO_RELEASE=`sed 's@/.*@@' /etc/debian_version`  # everything prior to a slash
        case $DISTRO_RELEASE in
          3.1)  export DISTRO_CODENAME=sarge ;;
          4.0)  export DISTRO_CODENAME=etch ;;
          5.*) export DISTRO_CODENAME=lenny ;;
          6.*) export DISTRO_CODENAME=squeeze ;;
          7.*) export DISTRO_CODENAME=wheezy ;;
          8.*) export DISTRO_CODENAME=jessie ;;
          9.*) export DISTRO_CODENAME=stretch ;;
          10.*) export DISTRO_CODENAME=buster ;;
          *)  # anything else is assumed to be a codename
              # (e.g. /etc/debian_version contents is "blah/sid")
              export DISTRO_CODENAME=$DISTRO_RELEASE
              export DISTRO_RELEASE=11.0.beta 
              ;;
        esac
      elif [ -f /etc/redhat-release ] ; then
        # this file contains a string like one of the following:
        #   CentOS Linux release 6.0 (Final)
        #   CentOS release 5.8 (Final)
        #   Red Hat Enterprise Linux Server release 5 (Final)
        #   Red Hat Enterprise Linux Server release 5.7 Beta (Tikanga)
        #   VirtuozzoLinux release 7.0                     -- NOT SUPPORTED!!
        export DISTRO=`awk 'NR==1 { if (/^Red Hat Enterprise Linux Server/) print "RHEL"; else print $1 }' /etc/redhat-release`
        export DISTRO_RELEASE=`awk 'NR==1 { if ($(NF) ~ /^\(/) { if ($(NF-1) == "Beta") print $(NF-2); else print $(NF-1); } else print "b0rk"; }' /etc/redhat-release`
      elif [ -f /etc/system-release ] ; then
        # this file contains a string like one of the following:
        #   Amazon Linux AMI release 2014.09
        export DISTRO=`awk 'NR==1 { if (/^Amazon Linux AMI/) print "Amazon"; else print $1; }' /etc/system-release`
        export DISTRO_RELEASE=`awk 'NR==1 { print $(NF); }' /etc/system-release`
      else
        export DISTRO=unknown DISTRO_RELEASE=0
      fi
      ;;

    *BSD)
      # remove the suffix, e.g. -STABLE
      export DISTRO=non-linux DISTRO_RELEASE=$(uname -r | sed -e s/-.*//)
      ;;

    Darwin)
      export DISTRO=non-linux DISTRO_RELEASE=$(sw_vers -productVersion)
      case $DISTRO_RELEASE in
        10.0.*)  export DISTRO_CODENAME=Cheetah ;;
        10.1.*)  export DISTRO_CODENAME=Puma ;;
        10.2.*)  export DISTRO_CODENAME=Jaguar ;;
        10.3.*)  export DISTRO_CODENAME=Panther ;;
        10.4.*)  export DISTRO_CODENAME=Tiger ;;
        10.5.*)  export DISTRO_CODENAME=Leopard ;;
        10.6.*)  export DISTRO_CODENAME=Snow_Leopard ;;
        10.7.*)  export DISTRO_CODENAME=Lion ;;
        10.8.*)  export DISTRO_CODENAME=Mountain_Lion ;;
        10.9.*)  export DISTRO_CODENAME=Mavericks ;;
        10.10.*) export DISTRO_CODENAME=Yosemite ;;
        10.11.*) export DISTRO_CODENAME=El_Capitan ;;
        10.12.*) export DISTRO_CODENAME=Sierra ;;
        10.13.*) export DISTRO_CODENAME=High_Sierra ;;
        10.14.*) export DISTRO_CODENAME=Mojave ;;
        10.15.*) export DISTRO_CODENAME=Catalina ;;
        *)  export DISTRO_CODENAME=unknown ;;
      esac
      ;;

    *)
      export DISTRO=non-linux DISTRO_RELEASE=0
  esac
fi

# -- DISTRO_BASE --
case $DISTRO in
  # EnterpriseEnterpriseServer is Oracle Enterprise Linux (now called Oracle Linux)
  CentOS|RHEL|Fedora|Amazon*|VirtuozzoLinux|EnterpriseEnterpriseServer|\
  Scientific*|XenServer|cloudlinux)
    export DISTRO_BASE=RedHat
    ## export DISTRO_CODENAME=unknown
    ;;

  Ubuntu)
    export DISTRO_BASE=Debian
    ;;

  *)
    export DISTRO_BASE=$DISTRO
    ;;
esac

if [ -z "$DISTRO_CODENAME" -o "$DISTRO_CODENAME" = "n/a" ] ; then
  export DISTRO_CODENAME=unknown
fi

# -- DISTRO_RELEASE_{MAJOR,MINOR,PL} --
set_distro_ver_vars()
{
  export DISTRO_RELEASE_MAJOR=$1
  export DISTRO_RELEASE_MINOR=$2
  export DISTRO_RELEASE_PL=$3
}
set_distro_ver_vars ${DISTRO_RELEASE//./ }
unset -f set_distro_ver_vars


if [ -z "$EUID" -a -x /usr/bin/id ]; then
  export EUID=`id -u`
  export UID=`id -ru`
fi
