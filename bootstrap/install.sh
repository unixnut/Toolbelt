#! /bin/sh
# install.sh (Bourne shell script) -- Install Toolbelt

DEST=/usr/local

cd "$(dirname "$(dirname "$0")")"

# == Install script ==
install -m 0755 toolbelt "$DEST/bin"

# == Install directories ==
mkdir -p "$DEST/share/toolbelt/include" "$DEST/share/toolbelt/installer_keys" "$DEST/share/toolbelt/package_keys"
install -m 0755 -d /var/lib/toolbelt

# == Install include files ==
(cd include && \
   install -m 0644 verify.sh general_functions.sh redhat.sh debian.sh context.sh entities.sh docs.sh \
           "$DEST/share/toolbelt/include")

# == Install include directories ==
install -m 0755 -d "$DEST/share/toolbelt/include/entities.d"
install -m 0644 include/entities.d/*.sh "$DEST/share/toolbelt/include/entities.d"

# == Install keys ==
(cd installer_keys/ && \
   install -m 0644 nodesource.asc composer.pem hashicorp.asc \
           "$DEST/share/toolbelt/installer_keys/")

# == Install package keys ==
(cd package_keys/ && \
   install -m 0644 steam.gpg \
           "$DEST/share/toolbelt/package_keys/")

# == Final preparation ==
echo "Running toolbelt in setup mode"
"$DEST/bin"/toolbelt setup
