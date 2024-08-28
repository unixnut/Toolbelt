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
    # TO-DO: Use -nv instead?
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


# == Python ==
# Splits `python3 -V` output into three separate version numbers
pyver()
{
  local IFS=.
  set $2
  # $1 $2 $3
  PYTHON_VERSION_MAJOR=$1
  PYTHON_VERSION_MINOR=$2
  PYTHON_VERSION_PL=$3
}


# /usr/local/lib/pythonX.Y
get_py_local_dir()
{
  echo /usr/local/lib/python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}
}


pip_install_wrapper()
{
  if [ -z "$PYTHON_VERSION_MAJOR" ] ; then
    python_setup
  fi

  case $python_install_entity in
    *pipx) # Includes Debian:pipx etc.
      pipx install "$@"
      ;;

    AmazonLinux:python3-pip)
      pip install $PIP_OPTIONS -U "$@"
      ;;

    *:python3-pip)
      pip3 install $PIP_OPTIONS -U "$@"
      ;;

    *)
      pip install $PIP_OPTIONS -U "$@"
      ;;
  esac
}


python_setup()
{
  pyver $(python3 -V)

  # On older Debian systems `pip --user`, is the default when running outside
  # of a virtual environment and not as root.
  case $python_install_entity in
    *pipx) # Includes Debian:pipx etc.
      ## if ...
      # Tie the system pipx venv location to the Python version
      py_local_dir=$(get_py_local_dir)
      # Overrides default pipx location. Virtual Environments will be installed
      # to $PIPX_HOME/venvs.
      export PIPX_HOME=$py_local_dir/pipx
      export PIPX_BIN_DIR=/usr/local/bin
      ## fi
      ;;

    Debian:python3-pip)
      if [ $DISTRO_RELEASE -le 11 -a $(which pip3) = /usr/bin/pip3 ] ; then
        # On pip 9.0.1 etc., use --system to avoid --user default
        # (pip 21.3.1 etc. doesn't have this option)
        PIP_OPTIONS=--system
      fi
      ;;

    $DISTRO:python3-pip)
      ;;

    *)
      echo "$SELF: Error: Unsupported Python package installer" >&2
      exit $EXIT_PYTHON
      ;;
  esac
}
