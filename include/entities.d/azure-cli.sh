case $DISTRO_BASE in
  Debian)
    # Already available on Ubuntu on Azure thanks to http://azure.archive.ubuntu.com/ubuntu archive
    commands[azure-cli]="add_key_apt https://packages.microsoft.com/keys/microsoft.asc
  add_repository_apt azure-cli https://packages.microsoft.com/repos/azure-cli/ main
  $APT install $APT_OPTIONS azure-cli"
    ;;

  RHEL)
    case $DISTRO_RELEASE_MAJOR in
      8)      commands[azure-cli]="add_repository_dnf -k https://packages.microsoft.com/keys/microsoft.asc \
                                  microsoft-prod https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
  dnf install azure-cli" ;;
      9)      commands[azure-cli]="add_repository_dnf -k https://packages.microsoft.com/keys/microsoft.asc \
                                  microsoft-prod https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
  dnf install azure-cli" ;;
      1[0-9]) commands[azure-cli]="add_repository_dnf -k https://packages.microsoft.com/keys/microsoft-2025.asc \
                                  microsoft-prod https://packages.microsoft.com/config/rhel/$DISTRO_RELEASE_MAJOR/packages-microsoft-prod.rpm
        dnf install azure-cli" ;;
    esac
    ;;
esac

straplines[azure-cli]="Microsoft Azure command-line interface (Azure CLI)"
descriptions[azure-cli]="Azure CLI is a cross-platform command-line tool for managing Azure
resources with interactive commands or scripts.

https://learn.microsoft.com/en-us/cli/azure?view=azure-cli-latest"
dependencies[azure-cli]=$DISTRO:apt-transport-https
## messages[]=""

aliases[az]=azure-cli
