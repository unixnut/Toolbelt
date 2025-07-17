commands[azure-cli]="add_key_apt https://packages.microsoft.com/keys/microsoft.asc
  add_repository_apt azure-cli https://packages.microsoft.com/repos/azure-cli/ main
  $APT install $APT_OPTIONS azure-cli"
straplines[azure-cli]="Microsoft Azure command-line interface (Azure CLI)"
descriptions[azure-cli]="Azure CLI is a cross-platform command-line tool for managing Azure
resources with interactive commands or scripts.

https://learn.microsoft.com/en-us/cli/azure?view=azure-cli-latest"
dependencies[azure-cli]=$DISTRO:apt-transport-https
## messages[]=""

aliases[az]=azure-cli
