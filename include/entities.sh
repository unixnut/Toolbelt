# == Aliases and commands ==
aliases[awscli]=aws-cli
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

commands[aws-cli]="pip3 install --upgrade --system awscli"
dependencies[aws-cli]=pip

aliases[certbot]=certbot-apache
certbot_dl="fetch /usr/local/sbin https://dl.eff.org/certbot-auto && chmod a+x /usr/local/sbin/certbot-auto && ln -s certbot-auto /usr/local/sbin/certbot"
commands[certbot-apache]=$certbot_dl
commands[certbot-nginx]=$certbot_dl

commands[mina]="gem install mina"    # http://nadarei.co/mina/
dependencies[mina]=gem

commands[aws-vault]="go get github.com/99designs/aws-vault"
dependencies[aws-vault]=${DISTRO}:Go

# https://github.com/pwoolcoc/pushb
commands[pushb]="cargo install pushb"
dependencies[pushb]=${DISTRO}:Rust

commands[wp-cli]="fetch $dest/lib https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fetch $completions_dir https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
chmod a+x $dest/lib/wp-cli.phar && ln -s ../lib/wp-cli.phar $dest/bin/wp"

commands[composer]="fetch -o $SCRIPT_TMPDIR/composer-setup.php https://getcomposer.org/installer
fetch $SCRIPT_TMPDIR https://composer.github.io/installer.sig
digest_verify $SCRIPT_TMPDIR/composer-setup.php $SCRIPT_TMPDIR/installer.sig
php $SCRIPT_TMPDIR/composer-setup.php --install-dir=$dest/bin --filename=composer"
digest_alg[composer]=sha384

aliases[pwsh]=powershell

# Debian/Ubuntu only
messages[jenkins]="** Default admin password is in /var/lib/jenkins/secrets/initialAdminPassword
   See /etc/default/jenkins for tunable settings."

## commands[]=""

case $OS in
  Linux)
    case $DISTRO in
      Debian)
        aliases[pip]=Debian:python3-pip
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
             commands[powershell]="fetch $SCRIPT_TMPDIR https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb && dpkg -i $SCRIPT_TMPDIR/packages-microsoft-prod.deb && $APT update && $APT install $APT_OPTIONS powershell"
             ;;
        esac

        # 'default-jre-headless' resolves to openjdk-11-jdk-headless in Buster onwards
        # (available in stretch-backports)
        dependencies[jenkins]=Debian:default-jre-headless
        commands[jenkins]="add_repository_apt -k https://pkg.jenkins.io/debian-stable/jenkins.io.key \
                                       jenkins https://pkg.jenkins.io/debian-stable - binary/
            $APT install $APT_OPTIONS jenkins"
        ;;

      Ubuntu)
        case $DISTRO_RELEASE_MAJOR.$DISTRO_RELEASE_MINOR in
          14.04|16*|17*)
            ubuntu_certbot_prep="$APT update && $APT install $APT_OPTIONS software-properties-common && add-apt-repository -y ppa:certbot/certbot && $APT update"
            commands[certbot-apache]="$ubuntu_certbot_prep && $APT install $APT_OPTIONS python-certbot-apache"
            commands[certbot-nginx]="$ubuntu_certbot_prep &&  $APT install $APT_OPTIONS python-certbot-nginx"
          ;;

          18*|19*|[23456789][0-9]*)
            commands[certbot-apache]="$APT install $APT_OPTIONS python3-certbot-apache"
            commands[certbot-nginx]="$APT install $APT_OPTIONS python3-certbot-nginx"
          ;;
        esac

        commands[powershell]="snap install powershell --classic"

        # 'default-jre-headless' resolves to openjdk-11-jdk-headless in 20.04 (Xenial) onwards
        dependencies[jenkins]=Debian:default-jre-headless
        commands[jenkins]="add_repository_apt -k https://pkg.jenkins.io/debian-stable/jenkins.io.key \
                                       jenkins https://pkg.jenkins.io/debian-stable - binary/
            $APT install $APT_OPTIONS jenkins"
        ;;

      # RedHat and derivatives
      RHEL|CentOS|OracleLinux|AmazonLinux)
        case $DISTRO_RELEASE_MAJOR in
          [789])
            dependencies[${DISTRO}:certbot-apache]=meta:${DISTRO}:epel
            dependencies[${DISTRO}:certbot-nginx]=meta:${DISTRO}:epel
            aliases[certbot-apache]=${DISTRO}:certbot-apache
            aliases[certbot-nginx]=${DISTRO}:certbot-nginx
            ;;
        esac
        commands[powershell]="add_repository_yum -k https://packages.microsoft.com/keys/microsoft.asc \\
                                      microsoft https://packages.microsoft.com/config/rhel/7/prod.repo
                                  yum install -y powershell"
        commands[nodejs]="add_repository_yum -k https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL \\
                              nodesource-el7 https://rpm.nodesource.com/pub/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
                          yum install -y nodejs"
        ;;

      Fedora)
        case $DISTRO_RELEASE_MAJOR in
          2[456789]|[3456789]?)
          aliases[certbot-apache]=Fedora:certbot-apache
          aliases[certbot-nginx]=Fedora:certbot-nginx
          ;;
        esac
        commands[powershell]="add_repository_dnf -k https://packages.microsoft.com/keys/microsoft.asc \\
                                  microsoft https://packages.microsoft.com/config/rhel/7/prod.repo
                              dnf install -y powershell"
        commands[nodejs]="add_repository_dnf -k https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL \\
                              nodesource-el7 https://rpm.nodesource.com/pub/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
                          dnf install -y nodejs"
        ;;
    esac
    ;;
esac
