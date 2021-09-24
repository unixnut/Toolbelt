# Verify using X.509 public key
# Only uses binary signatures; if someone publishes it as text (pure hex), convert with
#     xxd -r -p signature.txt signature.bin
#
# Usage: pem_verify <target> <sigfile>
pem_verify()
{
  openssl dgst -${digest_alg[$entity]} -verify $LIB_DIR/installer_keys/$entity.pem -signature "$2" "$1" > /dev/null
}


# Verify using a basic digest
# Digest must be in pure hex
#
# Usage: pem_verify <target> <dgstfile>
digest_verify()
{
  ## local foo
  ## set -x
  [ "$(openssl dgst -${digest_alg[$entity]} "$1" | cut -d' ' -f2)" = "$(cat "$2")" ]
  ## foo=$?
  ## set +x
  ## return $foo
}


# Verify using PGP public key
# Assumes key has already been loaded into keyring $VAR_DIR/trustedkeys.gpg
#
# Usage: pgp_verify <target> <sigfile>
pgp_verify()
{
  if ! output=$(gpgv --keyring $VAR_DIR/trustedkeys.gpg "$2" "$1" 2>&1)
  then
    echo "$output" >&2
    echo $EXIT_UNVERIFIED
  fi
}


gpgkey_setup()
{
  local file

  if [ ! -d $VAR_DIR ] ; then
    echo "$SELF: $VAR_DIR missing" >&2
    exit $EXIT_VERIFY_SETUP
  fi

  for file in $(ls $LIB_DIR/installer_keys/*.key 2>/dev/null) $(ls $LIB_DIR/installer_keys/*.asc 2>/dev/null) ; do
    gpg --no-default-keyring --keyring $VAR_DIR/trustedkeys.gpg --import < "$file"
  done
}

gpgkey_prep()
{
  if [ ! -f $VAR_DIR/trustedkeys.gpg ] ; then
    return
  fi
  if [ -n "$(find "$LIB_DIR/installer_keys" \( -name "*.key" -o -name "*.asc" \) \
                  -newer $VAR_DIR/trustedkeys.gpg)" ] ; then
    # Should have run `gpg --no-default-keyring --keyring $VAR_DIR/trustedkeys.gpg --import < ...`
    echo "$SELF: Unimported GPG keys found"
    exit $EXIT_VERIFY_PREP
  fi
}
