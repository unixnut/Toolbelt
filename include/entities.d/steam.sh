commands[steam]="add_repository_apt -k steam.gpg \
                                       steam https://repo.steampowered.com/steam/ steam stable
  $APT install $APT_OPTIONS -o Dpkg::Options::=--force-confnew steam"

straplines[steam]="Launcher for the Steam software distribution service"
descriptions[steam]="Steam is a software distribution service with an online store, automated
installation, automatic updates, achievements, SteamCloud synchronized
savegame and screenshot functionality, and many social features.

(This Toolbelt entity downloads 'steam' from the Valve package archive.  It is
an alternative to 'steam-installer' in the Ubuntu package archive and 
'steam-launcher' (a.k.a steam.deb) from https://store.steampowered.com/ .) 

http://www.steampowered.com/"
## dependencies[steam]=
## messages[steam]=""

## aliases[steam]=
