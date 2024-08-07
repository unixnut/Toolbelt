# TODO: Somehow also check files in $LIB_DIR/include/concepts.d


# *** DEFINITIONS ***


# *** FUNCTIONS ***
grok()
{
  local name entities concept=${1#.}

  case $concept in
    text/vnd.a|a)                               entities=$DISTRO:binutils ;;
    application/gzip|gz)                        name="Gzip compression" ; entities="$DISTRO:gzip $DISTRO:pigz" ;;
    application/x-bzip2|bz2)                    name="bzip2 compression" ; entities="$DISTRO:bzip2 $DISTRO:pbzip2" ;;
    application/mac-binhex40|hqx)               entities=$DISTRO:macutils ;;
    application/mac-compactpro|cpt)             entities=$DISTRO:unar ;;
    application/vnd.ms-cab-compressed|cab)      entities=$DISTRO:cabextract ;;
    application/vnd.rar|rar)                    entities="$DISTRO:p7zip-rar $DISTRO:unrar" ;;
    application/x-gtar|gtar)                    name="GNU Tar Archive" ; entities=$DISTRO:gnu_tar ;;
    application/x-gtar-compressed|tgz|taz)      name="Compressed GNU Tar Archive" ; entities="$DISTRO:gnu_tar $DISTRO:gzip" ;;
    application/x-lzh|lzh)                      name="lzh compression" ; entities="$DISTRO:lhasa $DISTRO:unar" ;;
    application/x-lzx|lzx)                      entities=$DISTRO:unar ;;
    application/x-tar|tar)                      name="Tar Archive" ; entities=$DISTRO:tar ;;
    application/x-ustar|ustar)                  entities=$DISTRO:pax ;;
    application/x-bcpio|bcpio)                  entities="$DISTRO:cpio $DISTRO:pax" ;;
    application/x-cpio|cpio)                    entities="$DISTRO:cpio $DISTRO:pax" ;;
    application/x-sv4cpio|sv4cpio)              entities="$DISTRO:cpio $DISTRO:pax" ;;
    application/x-xz|xz)                        name="xz compression" ; entities="$DISTRO:xz $DISTRO:pixz" ;;
    application/x-7z-compressed|7z)             name="7-Zip Archive" ; entities=$DISTRO:p7zip-full ;;
    application/zip|zip)                        name="Zip Archive" ; entities="$DISTRO:zip $DISTRO:unzip" ;;
    application/zstd|zstd|zst)                  name="Zstandard compression" ; entities=$DISTRO:zstd ;;
    tar.zstd|tzst)                              name="Zstandard Tar Archive" ; entities="$DISTRO:zstd $DISTRO:tar" ;;
    application/vnd.chess-pgn|pgn)              name="Portable Game Notation (PGN) chess game file" ; entities=$DISTRO:pgn-extract ;;
    *)
      $DISTRO:echo "$SELF: Error: Unknown concept $concept" >&2
      exit $EXIT_INSTALL_HUH
      ;;
  esac

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
    process -p "*" $entity
  done
}
