# Installs to /opt/aws/aws-cli-v2 using supplied installer
commands[aws-cli]="install_aws_cli /opt/aws/aws-cli-v2"
straplines[aws-cli]="AWS Command Line Interface"
descriptions[aws-cli]="AWS CLI version 2

https://docs.aws.amazon.com/cli/index.html"
## dependencies[aws-cli]=
## messages[aws-cli]=""

aliases[awscli]=aws-cli

install_aws_cli()
{
  local install_dir=$1
  local release_url=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
  local sig_url=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig

  if [ -f /usr/bin/aws ] ; then
    echo 'ERROR: AWS CLI v1 installed (from system package); uninstall before proceeding' >&2
    return 2
  fi

  if [ -f /usr/local/bin/aws ] && [ ! -L /usr/local/bin/aws ] ; then
    echo 'ERROR: AWS CLI v1 installed (via PIP); uninstall before proceeding' >&2
    return 3
  fi

  fetch $SCRIPT_TMPDIR $release_url $sig_url
  pgp_verify $SCRIPT_TMPDIR/${release_url##*/} $SCRIPT_TMPDIR/${sig_url##*/}

  echo '*** Extracting Archive:' $SCRIPT_TMPDIR/${release_url##*/} ...
  unzip -q -d $SCRIPT_TMPDIR/ $SCRIPT_TMPDIR/${release_url##*/}

  if [ -d $install_dir ] ; then
    echo '*** Running AWS CLI installer in update mode'
    $SCRIPT_TMPDIR/aws/install -i $install_dir --update
  else
    echo '*** Running AWS CLI installer'
    $SCRIPT_TMPDIR/aws/install -i $install_dir
    ln -s $install_dir/v2/current/bin/aws_completer /usr/local/bin
  fi
}
