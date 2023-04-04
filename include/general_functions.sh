# *** DEFINITIONS ***
CURL_OPTIONS="--fail -sS --connect-timeout $CONNECT_TIMEOUT"
WGET_OPTIONS="--connect-timeout=$CONNECT_TIMEOUT"


# *** FUNCTIONS ***
setup()
{
  SCRIPT_TMPDIR=$(mktemp -d)
}


cleanup()
{
  if [ -d $SCRIPT_TMPDIR ] && [ $debug -eq 0 ] ; then
    rm -rf $SCRIPT_TMPDIR
  fi
}


# fetch [ -o <dest_file | <dest_dir> | - ] <url> [...]
fetch()
{
  # TO-DO: support curl

  local dest="$1" file

  if [ "$1" = "-" ] ; then
    ## curl $CURL_OPTIONS -L "$2"
    wget -q $WGET_OPTIONS -O - "$2"
  elif [ "$1" = "-o" ] ; then
    file=$2
    shift
    shift
    ## curl $CURL_OPTIONS -L --output "$file" "$@"
    wget $WGET_OPTIONS -O "$file" "$@"
  else
    shift
    ## (cd "$dest" ; curl $CURL_OPTIONS -L -O "$@")
    wget $WGET_OPTIONS -N -P "$dest" "$@"
  fi
}


get_redirect_url()
{
  local url

  ## curl $CURL_OPTIONS --head "$1" |
  ##   sed -n 's/^location: \([^ ]*\).*/\1/p'
  url=$(wget $WGET_OPTIONS -o - --method=HEAD --max-redirect=0 "$1" |
          sed -n 's/^Location: \([^ ]*\).*/\1/p')
  if [ -n "$url" ] ; then
    echo "$url"
  else
    return 1
  fi
}


pip_install_wrapper()
{
  # On pip 9.0.1 etc., use --system to avoid --user default
  # (pip 21.3.1 etc. doesn't have this option)
  pip3 install "$@"
}
