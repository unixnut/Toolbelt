# Aliases and commands

# All substitutions evaluated within this file are of variables defined in
# include/context.sh (or a related file) or the toolbelt script file,
# before/during command-line parsing.  Expansions of variables defined within
# this file should be quoted.
#
# E.g.: $dest, $completions_dir and $SCRIPT_TMPDIR are available, but the
# latter should be quoted (to avoid being expanded when the commands are
# printed) as its value is unimportant to the user.

aliases[letsencrypt]=certbot-apache
aliases[certbot]=certbot-apache


aliases[Debian:Go]=Debian:gccgo-go
aliases[Ubuntu:Go]=Ubuntu:gccgo-go
# TO-DO: Fedora, etc.

aliases[Debian:Rust]=Debian:cargo
aliases[Ubuntu:Rust]=Ubuntu:cargo
# TO-DO: Fedora, etc.

# Package name is common across distros
aliases[gem]=${DISTRO}:rubygems

aliases[certbot]=certbot-apache
certbot_dl="fetch /usr/local/sbin https://dl.eff.org/certbot-auto
  chmod a+x /usr/local/sbin/certbot-auto
  ln -s certbot-auto /usr/local/sbin/certbot"
commands[certbot-apache]=$certbot_dl
commands[certbot-nginx]=$certbot_dl

commands[mina]="gem install mina"
straplines[mina]="Blazing fast application deployment tool"
descriptions[mina]="Blazing fast application deployment tool.

By Stjepan Hadjić
https://mina-deploy.github.io/mina/"
dependencies[mina]=gem

commands[aws-vault]="go get github.com/99designs/aws-vault"
dependencies[aws-vault]=${DISTRO}:Go
 
commands[pushb]="cargo install pushb"
dependencies[pushb]=${DISTRO}:Rust
straplines[pushb]="Similar to pushd/popd, except on git branches within a repo"
descriptions[pushb]=https://github.com/pwoolcoc/pushb

commands[wp-cli]="fetch $dest/lib https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  fetch \$completions_dir https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
  chmod a+x $dest/lib/wp-cli.phar
  ln -s ../lib/wp-cli.phar $dest/bin/wp"
straplines[wp-cli]="WordPress command-line interface"

commands[composer]="fetch -o \$SCRIPT_TMPDIR/composer-setup.php https://getcomposer.org/installer
  fetch \$SCRIPT_TMPDIR https://composer.github.io/installer.sig
  digest_verify \$SCRIPT_TMPDIR/composer-setup.php \$SCRIPT_TMPDIR/installer.sig
  php \$SCRIPT_TMPDIR/composer-setup.php --install-dir=$dest/bin --filename=composer"
digest_alg[composer]=sha384
straplines[composer]="A Dependency Manager for PHP"
descriptions[composer]="Uses composer.json and composer.lock to manage dependencies in the
same way as Pipenv or Bundler.

By Nils Adermann, Jordi Boggiano
https://getcomposer.org/ or https://composer.github.io/"

aliases[pwsh]=powershell

aliases[JavaServerRuntime]=$DISTRO:JavaServerRuntime
aliases[Debian:JavaServerRuntime]=Debian:default-jre-headless
aliases[Ubuntu:JavaServerRuntime]=Ubuntu:default-jre-headless

straplines[jenkins]="An open source automation server"
descriptions[jenkins]="Jenkins enables developers around the world to reliably automate their
development lifecycle processes of all kinds, including build, document, test,
package, stage, deployment, static analysis and many more.

Jenkins is being widely used in areas of Continous Integration, Continuous
Delivery, DevOps, and other areas. And it is not only about software, the same
automation techniques can be applied in other areas like Hardware Engineering,
Embedded Systems, BioTech, etc.

https://jenkins.io"
dependencies[jenkins]=JavaServerRuntime
# Debian/Ubuntu only
messages[jenkins]="** Default admin password is in /var/lib/jenkins/secrets/initialAdminPassword
   See /etc/default/jenkins for tunable settings."

commands[boring]="gem install boring"
straplines[boring]="Strip ANSI escape sequences"
descriptions[boring]="Shake free the shackles of color; resist the tyranny of fun! Easily strips
ANSI escape sequences.

By Adam Sanderson
https://github.com/adamsanderson/boring"
dependencies[boring]=gem

## commands[]=""

case $OS in
  Linux)
    case $DISTRO in
      Debian)
        case $DISTRO_RELEASE_MAJOR in
##           8) dependencies[certbot-apache]=meta:Debian:backports
##               dependencies[certbot-nginx]=meta:Debian:backports
##               commands[certbot-apache]="$APT install $APT_OPTIONS python-certbot-apache -t ${DISTRO_CODENAME}-backports"
##               commands[certbot-nginx]="$APT install $APT_OPTIONS python-certbot -t ${DISTRO_CODENAME}-backports"
##               ;;

          9) dependencies[certbot-apache]=meta:Debian:backports
             dependencies[certbot-nginx]=meta:Debian:backports
             commands[certbot-apache]="$APT install $APT_OPTIONS python-certbot-apache -t ${DISTRO_CODENAME}-backports"
             commands[certbot-nginx]="$APT install $APT_OPTIONS python-certbot-nginx -t ${DISTRO_CODENAME}-backports"
             # TO-DO: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7#debian-9
             ;;

          10|11|12|13)
             commands[certbot-apache]="$APT install $APT_OPTIONS python3-certbot-apache"
             commands[certbot-nginx]="$APT install $APT_OPTIONS python3-certbot-nginx"
             commands[powershell]="fetch \$SCRIPT_TMPDIR https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
  dpkg -i \$SCRIPT_TMPDIR/packages-microsoft-prod.deb
  $APT update
  $APT install $APT_OPTIONS powershell"
             ;;
        esac

        # 'default-jre-headless' resolves to openjdk-11-jdk-headless in Buster onwards
        # (available in stretch-backports)
        commands[jenkins]="add_repository_apt -k https://pkg.jenkins.io/debian-stable/jenkins.io.key \
                                       jenkins https://pkg.jenkins.io/debian-stable binary/ -
  $APT install $APT_OPTIONS jenkins"

        # -- Node.js --
        commands[nodejs]="add_repository_apt -k https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
                              nodesource https://deb.nodesource.com/node_16.x main $DISTRO_CODENAME
  $APT install $APT_OPTIONS nodejs"
        ;;

      Ubuntu)
        case $DISTRO_RELEASE_MAJOR.$DISTRO_RELEASE_MINOR in
          14.04|16*|17*)
            ubuntu_certbot_prep="$APT update
  $APT install $APT_OPTIONS software-properties-common
  add-apt-repository -y ppa:certbot/certbot
  $APT update"
            commands[certbot-apache]="$ubuntu_certbot_prep
  $APT install $APT_OPTIONS python-certbot-apache"
            commands[certbot-nginx]="$ubuntu_certbot_prep
  $APT install $APT_OPTIONS python-certbot-nginx"
          ;;

          18*|19*|[23456789][0-9]*)
            commands[certbot-apache]="$APT install $APT_OPTIONS python3-certbot-apache"
            commands[certbot-nginx]="$APT install $APT_OPTIONS python3-certbot-nginx"
          ;;
        esac

        commands[powershell]="snap install powershell --classic"

        # 'default-jre-headless' resolves to openjdk-11-jdk-headless in 20.04 (Xenial) onwards
        commands[jenkins]="add_repository_apt -k https://pkg.jenkins.io/debian-stable/jenkins.io.key \
                                       jenkins https://pkg.jenkins.io/debian-stable binary/ -
  $APT install $APT_OPTIONS jenkins"

        # -- Node.js --
        commands[nodejs]="add_repository_apt -k https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
                              nodesource https://deb.nodesource.com/node_16.x main $DISTRO_CODENAME
  $APT install $APT_OPTIONS nodejs"
        ;;

      # RedHat and derivatives
      RHEL|CentOS|OracleLinux|AmazonLinux)
        case $DISTRO_RELEASE_MAJOR in
          [789])
            # Enterprise Linux only
            dependencies[${DISTRO}:certbot-apache]=meta:${DISTRO}:epel
            dependencies[${DISTRO}:certbot-nginx]=meta:${DISTRO}:epel
            aliases[certbot-apache]=${DISTRO}:certbot-apache
            aliases[certbot-nginx]=${DISTRO}:certbot-nginx
            ;;

            # TODO: AmazonLinux
        esac

        commands[powershell]="add_repository_yum -k https://packages.microsoft.com/keys/microsoft.asc \
                                      microsoft https://packages.microsoft.com/config/rhel/7/prod.repo
  yum install -y powershell"

        # -- Node.js --
        if [ $DISTRO = CentOS ] || [ $DISTRO = redhat ] ; then
          rel=$DISTRO_RELEASE_MAJOR
        else
          rel=7
        fi
        # Use LTS (v16.x)
        commands[nodejs]="add_repository_yum -k https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL \
                              nodesource-el$rel https://rpm.nodesource.com/pub_16.x/el/$rel/x86_64/nodesource-release-el$rel-1.noarch.rpm
  yum install -y nodejs"

        # .. Node.js Tweaks ..
        # Disable AppStream's version of Node.js
        if [ $DISTRO = CentOS ] && [ $DISTRO_RELEASE_MAJOR = 8 ] ; then
          commands[nodejs]="yum module disable -y nodejs
  ${commands[nodejs]}"
        fi
        ;;

      Fedora)
        case $DISTRO_RELEASE_MAJOR in
          2[456789]|[3456789]?)
          aliases[certbot-apache]=Fedora:certbot-apache
          aliases[certbot-nginx]=Fedora:certbot-nginx
          ;;
        esac

        commands[powershell]="add_repository_dnf -k https://packages.microsoft.com/keys/microsoft.asc \
                                  microsoft https://packages.microsoft.com/config/rhel/7/prod.repo
  dnf install -y powershell"

        # -- Node.js --
        rel=$DISTRO_RELEASE_MAJOR
        commands[nodejs]="add_repository_dnf -k https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL \
                              nodesource-fc$rel https://rpm.nodesource.com/pub/fc/$rel/x86_64/nodesource-release-fc$rel-1.noarch.rpm
  dnf install -y nodejs"
        ;;

      # See "RedHat and derivatives" above
      ## AmazonLinux)
      ##   ;;
    esac
    ;;
esac

if [ "$(ls $LIB_DIR/include/entities.d)" != entity.sh.template ] ; then
  for file in $LIB_DIR/include/entities.d/*.sh ; do
    . "$file"
  done
fi
