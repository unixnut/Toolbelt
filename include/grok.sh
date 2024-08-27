# TODO: Somehow also check files in $LIB_DIR/include/concepts.d


# *** DEFINITIONS ***
declare -A concept_aliases

# Extension to MIME type mappings
concept_aliases[a]=text/vnd.a
concept_aliases[gz]=application/gzip
concept_aliases[bz2]=application/x-bzip2
concept_aliases[hqx]=application/mac-binhex40
concept_aliases[cpt]=application/mac-compactpro
concept_aliases[cab]=application/vnd.ms-cab-compressed
concept_aliases[rar]=application/vnd.rar
concept_aliases[gtar]=application/x-gtar
concept_aliases[tgz]=application/x-gtar-compressed
concept_aliases[taz]=application/x-gtar-compressed
concept_aliases[tar.dz]=application/x-gtar-compressed  # Technically dictzip, but gzip can read it
concept_aliases[lzh]=application/x-lzh
concept_aliases[lzx]=application/x-lzx
concept_aliases[tar]=application/x-tar
concept_aliases[ustar]=application/x-ustar
concept_aliases[bcpio]=application/x-bcpio
concept_aliases[cpio]=application/x-cpio
concept_aliases[sv4cpio]=application/x-sv4cpio
concept_aliases[xz]=application/x-xz
concept_aliases[lzma]=application/x-lzma
concept_aliases[lzip]=application/x-lzip
concept_aliases[lz]=application/x-lzip
concept_aliases[7z]=application/x-7z-compressed
concept_aliases[lz4]=application/x-lz4
concept_aliases[lzop]=application/x-lzop
concept_aliases[lzo]=application/x-lzop
concept_aliases[zstd]=application/zstd
concept_aliases[zst]=application/zstd
concept_aliases[brotli]=application/x-brotli
concept_aliases[br]=application/x-brotli

concept_aliases[zoo]=application/x-zoo
concept_aliases[zip]=application/zip
concept_aliases[sit]=application/x-stuffit
concept_aliases[sitx]=application/x-stuffit
concept_aliases[xar]=application/x-xar
concept_aliases[dmg]=application/x-apple-diskimage
concept_aliases[iso]=application/x-iso9660-image
concept_aliases[vhd]=application/x-virtualbox-vhd
concept_aliases[wim]=application/x-ms-wim
## concept_aliases[pp]=  # PowerPacker
# Note: .z is something else
concept_aliases[Z]=application/x-compressed

# LZMA2 is used by the XZ file format, and is one of the available compression formats used by 7-Zip

# NSIS (Nullsoft Scriptable Installer System) presumably a .exe file; 7-Zip can decompress

# lzf is a compression/decompression utility written by Stefan Traby <stefan@hello-penguin.com>
# using liblzf-devel (RedHat) or liblzf-dev (Debian)
# See GNUmakefile and src/lzf/src/lzf.c in https://github.com/injinj/lzf

# LZRW: ?

# lzo1x: ?

# Simple to complete extension mappings
concept_aliases[tzst]=tar.zstd
concept_aliases[tbz2]=tar.bz2
concept_aliases[txz]=tar.xz
concept_aliases[tlz]=tar.lz
concept_aliases[tdz]=tar.dz

concept_aliases[pgn]=application/vnd.chess-pgn


# *** FUNCTIONS ***
resolve_concept()
{
  local concept=$1 resolved_alias

  # Expand concepts, recursively
  resolved_alias=:
  while [ -n "$resolved_alias" ] ; do
    resolved_alias=${concept_aliases[$concept]}
    if [ -n "$resolved_alias" ] ; then
      concept=$resolved_alias
    fi
  done

  echo $concept
}


# Warning: sets globals $concept, $name and $entities unless calling function has made them local
decode_concept()
{
  concept=$(resolve_concept "$1")

  case $concept in
    text/vnd.a)                         entities=binutils ;;
    application/gzip)                   name="Gzip compression" ; entities="gzip pigz" ;;   # 7-Zip can handle
    application/x-bzip2)                name="bzip2 compression" ; entities="bzip2 pbzip2" ;;   # 7-Zip can handle
    application/mac-binhex40)           entities=macutils ;;
    application/mac-compactpro)         entities=unar ;;
    application/x-stuffit)              name="Stuffit Archive" ; entities=unar ;;
    application/vnd.ms-cab-compressed)  entities=cabextract ;;  # unar and 7-Zip can decompress
    application/vnd.rar)                entities=unrar ;;  # unar and 7-Zip (with p7zip-rar) can decompress
    application/x-gtar)                 name="GNU Tar Archive" ; entities=gnu_tar ;;   # 7-Zip can handle
    application/x-gtar-compressed)      name="Compressed GNU Tar Archive" ; entities="gnu_tar gzip" ;;   # 7-Zip can handle
    application/x-lzh)                  name="lzh compression" ; entities=lhasa ;;  # unar and 7-Zip can decompress
    application/x-lzx)                  entities=unar ;;
    application/x-lzma)                 name="lzma compression" ; entities="lzma" ;;  # unar, xz and 7-Zip can decompress
    application/x-lzip)                 name="lz LZMA compression" ; entities="lzip" ;;
    application/x-lz4)                  name="lz4 compression" ; entities=lz4 ;;
    application/x-lzop)                 name="lzop compression" ; entities=lzop ;;
    dz)                                 name="dictd compression" ; entities="dictzip" ;;  # gzip can decompress
    application/x-brotli)               name="Brotli compression" ; entities=brotli ;;
    application/x-compressed)           name="UNIX compression" ; entities=compress ;;
    application/x-tar)                  name="Tar Archive" ; entities=tar ;;  # unar can decompress
    application/x-ustar)                entities=pax ;;
    application/x-bcpio)                entities="cpio pax" ;;
    application/x-cpio)                 entities="cpio pax" ;;  # unar and 7-Zip can decompress
    application/x-sv4cpio)              entities="cpio pax" ;;
    application/x-xz)                   name="xz compression" ; entities="xz pixz" ;;  # unar can decompress, 7-Zip can handle
    application/x-7z-compressed)        name="7-Zip Archive" ; entities=7-Zip ;;  # unar can decompress
    application/arj)                    name="ARJ Archive" ; entities=arj ;;  # unar and 7-Zip can decompress
    application/zip)                    name="Zip Archive" ; entities="zip unzip" ;;   # 7-Zip can handle
    ace)                                name="ACE Archive" ; entities=unar ;;
    adf)                                name="ADF Archive" ; entities=unar ;;
    apm)                                name="APM Archive" ; entities=7-Zip ;;
    arc)                                name="ARC Archive" ; entities=unar ;;
    dms)                                name="DMS Archive" ; entities=unar ;;
    application/x-ms-compress-szdd)     name="Microsoft SZDD compressed Archive" ; entities=7-Zip ;; # Filename ends in .??_
    lbr)                                name="LBR Archive" ; entities=unar ;;
    pak)                                name="PAK Archive" ; entities=unar ;;
    pp)                                 name="PowerPacker Archive" ; entities=unar ;;
    application/x-ms-wim)               name="Windows Imaging Archive" ; entities=7-Zip ;;
    application/x-xar)                  name="eXtensible ARchiver Archive" ; entities=7-Zip ;;
    application/x-zoo)                  name="Zoo Archive" ; entities=unar ;;
    application/zstd)                   name="Zstandard compression" ; entities=zstandard ;;
    tar.zstd)                           name="Zstandard Tar Archive" ; entities="zstandard tar" ;;
    tar.bz2)                            name="bzip2 Tar Archive" ; entities="bzip2 tar" ;;
    tar.xz)                             name="xz Tar Archive" ; entities="xz tar" ;;
    tar.lzma)                           name="lzma Tar Archive" ; entities="lzma tar" ;;
    tar.lz|tar.lzip)                    name="lzip Tar Archive" ; entities="lzip tar" ;;
    tar.lz4)                            name="lz4 Tar Archive" ; entities="lz4 tar" ;;
    tar.br|tar.brotli)                  name="brotli Tar Archive" ; entities="brotli tar" ;;
    tar.lzo|tar.lzop)                   name="lzop Tar Archive" ; entities="lzop tar" ;;
    application/x-apple-diskimage)      name="Apple disk image" ; entities=7-Zip ;;
    application/x-iso9660-image)        name="ISO-9660 optical disc image" ; entities=7-Zip ;;
    application/x-virtualbox-vhd)       name="VirtualBox Virtual HD image" ; entities=7-Zip ;;
    application/vnd.chess-pgn)          name="Portable Game Notation (PGN) chess game file" ; entities=pgn-extract ;;
    *)
      return 1
      ;;
  esac
}


grok()
{
  local name entities concept=${1#.}
  local opt OPTIND=1 OPTARG process_opts

  while getopts n opt "$@"
  do
    case $opt in
      n) process_opts=-n ;;  # No act
    esac
  done
  shift $((OPTIND-1))   # Keep only arguments

  if ! decode_concept "$concept"
  then
    $DISTRO:echo "$SELF: Error: Unknown concept $concept" >&2
    exit $EXIT_INSTALL_HUH
  fi

  if [ $verbose -ge 0 ] ; then
    # Show progress message
    if [ -n "$name" ] ; then
      echo "* Preparing to handle '$name' ($concept)"
    else
      echo "* Preparing to handle '$concept'"
    fi
  fi
  for entity in $entities ; do
    ## process -p "*" $entity
    process -p "*" $process_opts $entity
  done
}


identify()
{
  local name entities concept filename basename
  local opt OPTIND=1 OPTARG brief=n

  while getopts b opt "$@"
  do
    case $opt in
      b) brief=y ;;
    esac
  done
  shift $((OPTIND-1))   # Keep only arguments

  # Filename or extension
  case "$1" in
    .*)  filename=dummy$1
         concept=${1#.}
         ;;
    *.*) filename=$1
         basename=${1##*/}
         concept=${basename#*.}
         ;;
    *)   # Assume an extension only
         filename=dummy.$1
         concept=$1
         ;;
  esac

  if decode_concept "$concept"
  then
    ## if [ "$1" != $concept ] ; then
    if [ -n "$name" ] ; then
      echo "$concept is a $name (would install $entities)"
    else
      echo "$concept is a mystery (would install $entities)"
    fi
  else
    ## case "$concept" in
    ##   */*
    if [ $verbose -ge 1 ] ; then
      printf "%s = " "$filename"
    fi
    if ! python3 -c 'import mimetypes, sys ; result = mimetypes.guess_type(sys.argv[1], strict=False); print(result[0]) if result[0] else sys.exit(2)' "$filename"
    then
      echo "UNKNOWN"
    fi
    ##   ;;
    ## esac
  fi
}
