Toolbelt: Install anything

I'm sick of typing in lengthy and possibly insecure installation
commands from software project websites or even Q&A sites.  Toolbelt was
designed to install software simply and securely, by verifying downloaded
files against pre-installed keys or known sources.

Please note: Toolbelt is not intended to replace your OS package
manager.  The advantage of software packaged by your OS vendor is that
it receives security updates through the same channels as your system
packages, and will often benefit from dedicated security teams that
release patches before vulnerabilities are publicly disclosed.

If software isn't packaged by your OS vendor, or you need a newer
version, use Toolbelt.  In either case, you might instead be better off
activating the Backports package archive for your OS and get software
built for your OS release after it became available.

Toolbelt is written in Bash, so it will run anywhere.

Installation
============

To install from your workstation onto a server using Ansible (assuming
your inventory file is correctly set up), clone the repo to your
workstation, change into the working directory and then run:
**`ansible-playbook bootstrap/install.yaml -K -l *servername*`** .

To install locally on your workstation or a server: ***TBA*** .

To install in development mode (nothing to install except for
/var/lib/toolbelt), create a symlink called toolbelt somewhere in your
path pointing to `_toolbelt` in the repo working directory and then run
**`toolbelt setup`** .

Using Toolbelt
==============

To see what Toolbelt can install, run **`toolbelt list-entities`** .  So
see more detail about a given entity including its author and website,
run **`toolbelt show <entity>`** .

To install an entity and dependencies, run **`toolbelt install <entity>`** .

For other subcommands (not all of which are implemented yet), run
**`toolbelt --help`** .

Currently supported software as of v1.7.0
=========================================

Some of these are currently only available on Debian/Ubuntu/Mint.

  - aws-cli
  - aws-vault
  - azure-cli
  - [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
  - boring (Strip ANSI escape sequences)
  - certbot-apache
  - certbot-nginx
  - cloudflare-go a.k.a. flarectl
  - Composer (A Dependency Manager for PHP)
  - [fileprune](https://www.spinellis.gr/sw/unix/fileprune/)
  - Jenkins (An open source automation server)
  - mina (Blazing fast application deployment tool)
  - [Mozilla SeaMonkey](https://seamonkey-project.org/)
  - NodeJS
  - pgn-extract (for chess notation)
  - pipx for Python
  - pman for PHP
  - PowerShell
  - [Proxmox Backup Server](https://proxmox.com/en/products/proxmox-backup-server/overview)
  - pushb (Similar to pushd/popd, except on git branches within a repo)
  - pv (pipeview tool for CLI)
  - [serverless](https://www.serverless.com/)
  - [Steam software distribution service](http://www.steampowered.com/)
  - Terraform (High-level cloud provisioning tool)
  - wp-cli (WordPress command-line interface)
  - [yaml-lint](https://github.com/rasshofer/yaml-lint)
  - yarn (Package Manager for Node.js)
  - compression tools:
      - 7-Zip
      - arj
      - binutils
      - brotli
      - bzip2
      - cabextract
      - compress
      - cpio
      - dictzip
      - gzip
      - lhasa
      - lunzip
      - lz4
      - lzip
      - lzma
      - lzop
      - macutils
      - p7zip-rar
      - pax
      - pbzip2
      - pigz
      - pixz
      - tar
      - unar
      - unrar
      - xz
      - zip/unzip
      - zstandard

Future software
===============

  - is-http: `npm install -g is-http2-cli` (is-http2 command broken
    under Debian)

TO-DO
=====
  - On Debian, drop .gpg/.asc files into `/etc/apt/trusted.gpg.d` instead of using **`apt-key`** .
