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


# fetch [ -o <dest_file | <dest_dir> | - ] <url>
fetch()
{
  # TO-DO: support curl

  local dest="$1" file

  if [ "$1" = "-" ] ; then
    ## curl -f -sS -L "$2"
    wget -q -O - "$2"
  elif [ "$1" = "-o" ] ; then
    file=$2
    shift
    shift
    ## curl -f -sS -L --output "$file" "$@"
    wget -O "$file" "$@"
  else
    shift
    ## (cd "$dest" ; curl -f -sS -L -O "$@")
    wget -N -P "$dest" "$@"
  fi
}
