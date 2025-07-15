# See https://pbs.proxmox.com/docs/installation.html#install-proxmox-backup-server-on-debian
# (Note that this doesn't install 'proxmox-backup', which installs the same set
# of packages as the installer including custom kernel, etc.)
if [ $DISTRO = Debian ] ; then
  if [ $DISTRO_RELEASE_MAJOR -ge 11 ] ; then
    commands[pbs]="add_key_apt https://enterprise.proxmox.com/debian/proxmox-release-$DISTRO_CODENAME.gpg
  add_repository_apt pbs http://download.proxmox.com/debian/pbs pbs-no-subscription $DISTRO_CODENAME
  $APT install $APT_OPTIONS proxmox-backup-server"
    ## ... -o Dpkg::Options::=--force-confnew
  fi
fi
straplines[pbs]="Proxmox Backup Server"
descriptions[pbs]="An enterprise-class, client-server backup solution that is
capable of backing up virtual machines, containers, and physical
hosts. It supports local and NFS datastores, backup content
encryption, deduplication and remote sync.  Provides a
sophisticated permissions model including namespaces and API keys
for use by network clients.

It is specially optimized for the Proxmox Virtual Environment platform.
https://proxmox.com/en/products/proxmox-backup-server/overview"
## dependencies[pbs]=
messages[pbs]="Go to https://$(hostname --long):8007/ and log in as root"

aliases[proxmox-backup-server]=pbs
