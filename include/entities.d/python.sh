case $OS in
  Linux)
    aliases[pip]=$DISTRO:python3-pip
    case $DISTRO in
      Debian)
        case $DISTRO_RELEASE_MAJOR in
          10|11|12|13)
              python_install_entity=$DISTRO:pipx
              if [ $DISTRO_RELEASE_MAJOR -eq 11 ] ; then
                # /etc/apt/sources.list.d/backports.list
                dependencies[$DISTRO:pipx]=meta:Debian:backports
              fi
              aliases[pipx]=Debian:pipx
              ;;

          *)
              python_install_entity=$DISTRO:python3-pip
              ;;
        esac
        ;;

      Ubuntu)
        ## case $DISTRO_RELEASE_MAJOR.$DISTRO_RELEASE_MINOR in
        aliases[pip]=Debian:python3-pip
        if [ $DISTRO_RELEASE_MAJOR -ge 20 ] ; then
          python_install_entity=Debian:pipx
          aliases[pipx]=Debian:pipx
        else
          python_install_entity=Debian:python3-pip
        fi
        ;;

      # Enterprise Linux
      RHEL|CentOS|OracleLinux)
        if [ $DISTRO_RELEASE_MAJOR -ge 9 ] ; then
          python_install_entity=$DISTRO:pipx
          dependencies[$DISTRO:pipx]=epel
          aliases[pipx]=$DISTRO:pipx
        else
          python_install_entity=$DISTRO:python3-pip
        fi
        ;;

      AmazonLinux)
        python_install_entity=$DISTRO:python3-pip
        ;;

      Fedora)
        if [ $DISTRO_RELEASE_MAJOR -ge 39 ] ; then
          # Also available in Fedora EPEL 9
          python_install_entity=$DISTRO:pipx
        else
          python_install_entity=$DISTRO:python3-pip
        fi
        ;;
    esac
    ;;
esac

# AmazonLinux
## amazon-linux-extras install python3.8
