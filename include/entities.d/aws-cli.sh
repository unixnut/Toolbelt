# Installs to /opt/aws/aws-cli-v2 using supplied installer
commands[aws-cli]="install_dir=/opt/aws/aws-cli-v2
  release_url=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
  sig_url=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig
  fetch \$SCRIPT_TMPDIR \$release_url \$sig_url
  pgp_verify \$SCRIPT_TMPDIR/\${release_url##*/} \$SCRIPT_TMPDIR/\${sig_url##*/}
  echo '*** Extracting Archive:' \$SCRIPT_TMPDIR/\${release_url##*/} ...
  unzip -q -d \$SCRIPT_TMPDIR/ \$SCRIPT_TMPDIR/\${release_url##*/}
  if [ -d \$install_dir ] ; then
    echo '*** Running AWS CLI installer in update mode'
    \$SCRIPT_TMPDIR/aws/install -i \$install_dir --update
  else
    echo '*** Running AWS CLI installer'
    \$SCRIPT_TMPDIR/aws/install -i \$install_dir
  fi"
straplines[aws-cli]="AWS Command Line Interface"
descriptions[aws-cli]="AWS CLI version 2

https://docs.aws.amazon.com/cli/index.html"
## dependencies[aws-cli]=
## messages[aws-cli]=""

aliases[awscli]=aws-cli
