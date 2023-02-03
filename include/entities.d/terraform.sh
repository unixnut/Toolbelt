commands[terraform]="ver=\$(fetch - https://releases.hashicorp.com/terraform/ |
                              sed -n 's@^    <a href=\"/terraform/\\([0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\)/\".*@\\1@p ; T next ; q; :next')
  release_url=https://releases.hashicorp.com/terraform/\$ver
  sig_url=\$release_url/terraform_\${ver}_SHA256SUMS.72D7468F.sig checksums_url=\$release_url/terraform_\${ver}_SHA256SUMS
  fetch \$SCRIPT_TMPDIR \$sig_url \$checksums_url
  pgp_verify \$SCRIPT_TMPDIR/\${checksums_url##*/} \$SCRIPT_TMPDIR/\${sig_url##*/}
  fetch \$SCRIPT_TMPDIR \$release_url/terraform_\${ver}_linux_amd64.zip
  (cd \$SCRIPT_TMPDIR/ ; sha256sum --check --status --ignore-missing \${checksums_url##*/})
  unzip -d $dest/bin \$SCRIPT_TMPDIR/terraform_\${ver}_linux_amd64.zip"
straplines[terraform]="High-level cloud provisioning tool"
descriptions[terraform]="Terraform is an infrastructure as code (IaC) tool that allows you to build,
change, and version infrastructure safely and efficiently.  This
includes low-level components such as compute instances, storage, and
networking, as well as high-level components such as DNS entries, SaaS
features, etc. Terraform can manage both existing service providers and
custom in-house solutions.

By HashiCorp

https://www.terraform.io/"
## dependencies[terraform]=
messages[terraform]="terraform installed as $dest/bin/terraform"

## aliases[terraform]=
