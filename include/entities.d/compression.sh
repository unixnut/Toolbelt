case $OS in
  Linux)
    aliases[gnu_tar]=$DISTRO:tar

    if [ $DISTRO_BASE = Debian ] ; then
      aliases[binutils]=$DISTRO:binutils
      aliases[bzip2]=$DISTRO:bzip2
      aliases[cabextract]=$DISTRO:cabextract
      aliases[cpio]=$DISTRO:cpio
      aliases[gzip]=$DISTRO:gzip
      aliases[lhasa]=$DISTRO:lhasa
      aliases[xz]=$DISTRO:xz
      aliases[zstandard]=$DISTRO:zstd
      aliases[lzip]=$DISTRO:lzip  # Can decompress too
      aliases[lunzip]=$DISTRO:lunzip
      aliases[compress]=$DISTRO:ncompress
      aliases[lzma]=$DISTRO:lzma
      aliases[lzip]=$DISTRO:lzip
      aliases[lz4]=$DISTRO:lz4
      aliases[lzop]=$DISTRO:lzop
      aliases[brotli]=$DISTRO:brotli
      aliases[macutils]=$DISTRO:macutils
      aliases[7-Zip]=$DISTRO:p7zip-full
      aliases[p7zip-rar]=$DISTRO:p7zip-rar
      aliases[pax]=$DISTRO:pax
      aliases[pbzip2]=$DISTRO:pbzip2
      aliases[pigz]=$DISTRO:pigz
      aliases[pixz]=$DISTRO:pixz
      aliases[tar]=$DISTRO:tar
      aliases[unar]=$DISTRO:unar
      aliases[unrar]=$DISTRO:unrar
      aliases[unzip]=$DISTRO:unzip
      aliases[zip]=$DISTRO:zip
      aliases[arj]=$DISTRO:arj
      aliases[dictzip]=$DISTRO:dictzip

      case $DISTRO in
        Debian)
          if [ $DISTRO_RELEASE_MAJOR -ge 13 ] ; then
            # Packaged in trixie
            aliases[lzfse]=$DISTRO:lzfse
            aliases[snappy]=$DISTRO:snappy-tools
          elif [ $DISTRO_RELEASE_MAJOR -ge 12 ] ; then
            # Will build under bookworm
            :
          fi
          ;;

        Ubuntu)
          if [ $DISTRO_RELEASE_MAJOR -ge 24 ] ; then
            # Packaged in noble
            aliases[snappy]=$DISTRO:snappy-tools
            aliases[lzfse]=$DISTRO:lzfse
          elif [ $DISTRO_RELEASE_MAJOR -ge 22 ] ; then
            # Will build under jazzy
            :
          fi
          ;;
      esac
    fi
    ;;
esac

straplines[dictzip]="Compression utility for dictionary databases"
straplines[pbzip2]="Parallel (multi-threaded) bzip2 implementation"
straplines[pigz]="Parallel (multi-threaded) Implementation of GZip"
straplines[pixz]="Parallel (multi-threaded), indexing XZ compressor/decompressor"
descriptions[pixz]="Automatically indexes tarball metadata to allow targeted access
to the tarball's files without full decompression."
