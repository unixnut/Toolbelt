export SEAMONKEY_INSTALL_DIR=/opt/seamonkey
export SEAMONKEY_LINK=/usr/local/bin/seamonkey

# Note that the tarball contains a seamonkey/ subdirectory so extract it to the
# parent of $SEAMONKEY_INSTALL_DIR
commands[seamonkey]="ver=\$(seamonkey_ver); seamonkey_existing_check \$ver ; echo 'Downloading & installing' ; fetch - https://archive.mozilla.org/pub/seamonkey/releases/\$ver/linux-x86_64/en-US/seamonkey-\$ver.en-US.linux-x86_64.tar.bz2 | tar xjf - -C ${SEAMONKEY_INSTALL_DIR%/*} && { [ -L $SEAMONKEY_LINK ] || ln -s $SEAMONKEY_INSTALL_DIR/seamonkey $SEAMONKEY_LINK ; }"
straplines[seamonkey]="Mozilla SeaMonkey"
descriptions[seamonkey]="Gecko-based browser with a direct lineage to NCSA Mosaic and
Netscape Navigator.

https://seamonkey-project.org/"
## dependencies[seamonkey]=
## messages[]=""

aliases[mozilla]=seamonkey


seamonkey_ver()
{
  curl -sS https://archive.mozilla.org/pub/seamonkey/releases/ |
    sed -n -e 's@.*<td>\(.*\)</td>@\1@' \
           -e 's/<a href="[^"]*">[^/]\+<\/a>//g' \
           -e 's/<a href="[^"]*">[^<]*[^.[:digit:]][^<]*\/<\/a>//g' \
           -e 's/<a href="[^"]*">\([^<]\+\)\/<\/a>/\1/p' |
    sort -V |
    tail -n 1
}


seamonkey_existing_check()
{
  if [ -f $SEAMONKEY_INSTALL_DIR/application.ini ] &&
     grep -q "^Version=$1$" $SEAMONKEY_INSTALL_DIR/application.ini
  then
    echo "SeaMonkey v$1 already installed"
    exit $EXIT_NOP
  fi
}
