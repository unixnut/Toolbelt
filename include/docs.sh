show_help()
{
cat << EOT_HELP
Usage: toolbelt install <entity>
       toolbelt remove <entity>
       toolbelt list-installed
       toolbelt show <available-entity>
       toolbelt build ...
       toolbelt package ...
       toolbelt factory <entity>
       toolbelt list-entities
       toolbelt update

Options:
  -t dir | --target=dir | --dest=dir  Prefix for installed files (default: /usr/local)
  -v | --verbose                      Increase verbosity (default: level 1)
  -q | --quiete                       Increase verbosity
  -l LIB_DIR                          Location of toolbelt files (default: /usr/local/share/toolbelt)

Subcommands:
  install | i
    Installs an entity that Toolbelt knows how to install.

  remove
    Remove an entity that Toolbelt installed.

  list-installed
    Show all global entities that Toolbelt installed.

  show
    Show details of an entity that Toolbelt knows how to install.

  build | b
    TBA

  package | p
    TBA

  factory | f
    Output an Ansible playbook to install the entity.

  list-entities
    Show names of all entities entity that Toolbelt knows how to install.

  update
    Fetch new entity recipies from toolbelt.unixnut.tech .
EOT_HELP
}

