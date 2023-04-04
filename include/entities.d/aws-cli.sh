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
  local release_file sig_file

  if [ -f /usr/bin/aws ] ; then
    echo 'ERROR: AWS CLI v1 installed (from system package); uninstall before proceeding' >&2
    return 2
  fi

  if [ -f /usr/local/bin/aws ] && [ ! -L /usr/local/bin/aws ] ; then
    echo 'ERROR: AWS CLI v1 installed (via PIP); uninstall before proceeding' >&2
    return 3
  fi

  if [ -n "${install_options[--aws-cli-file]}" ] ; then
    release_file="${install_options[--aws-cli-file]}"
    sig_file="$release_file.sig"
  else
    fetch $SCRIPT_TMPDIR $release_url $sig_url
    release_file=$SCRIPT_TMPDIR/${release_url##*/}
    sig_file=$SCRIPT_TMPDIR/${sig_url##*/}
  fi
  pgp_verify "$release_file" "$sig_file"

  echo '*** Extracting Archive:' "$release_file"  ...
  unzip -q -d $SCRIPT_TMPDIR/ "$release_file"

  if [ -d $install_dir ] ; then
    echo '*** Running AWS CLI installer in update mode'
    $SCRIPT_TMPDIR/aws/install -i $install_dir --update
  else
    echo '*** Running AWS CLI installer'
    $SCRIPT_TMPDIR/aws/install -i $install_dir
    ln -s $install_dir/v2/current/bin/aws_completer /usr/local/bin
  fi
}
