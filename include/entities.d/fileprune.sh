# Installs to $PREFIX/bin/fileprune and $PREFIX/share/man/man1/fileprune.1.gz
# $PREFIX defaults to /usr/local/

# Tarball contains fileprune-master subdirectory
FILEPRUNE_TARBALL_URL=https://github.com/dspinellis/fileprune/archive/refs/heads/master.tar.gz
commands[fileprune]="fetch \$SCRIPT_TMPDIR $FILEPRUNE_TARBALL_URL
  tar xf \$SCRIPT_TMPDIR/${FILEPRUNE_TARBALL_URL##*/} -C /usr/local/src
  make -C /usr/local/src/fileprune-master
  make -C /usr/local/src/fileprune-master install"
straplines[fileprune]="Prune a file set according to a given age distribution"
descriptions[fileprune]="Fileprune will delete files from the specified set targetting a
given distribution of the files within time as well as size, number,
and age constraints.

By Diomidis Spinellis
https://www.spinellis.gr/sw/unix/fileprune/"
dependencies[fileprune]=${DISTRO}:build-essential
##... ${DISTRO}:git
## messages[]=""

## aliases[]=
