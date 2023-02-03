commands[bfg]="ver=\$(get_redirect_url https://github.com/rtyley/bfg-repo-cleaner/releases/latest |
                        sed 's@.*/v\\([^/]*\\)\$@\\1@')
  release_url=https://repo1.maven.org/maven2/com/madgag/bfg/\$ver/bfg-\$ver.jar
  fetch $dest/lib/ \$release_url

  echo \"#!/bin/sh\"\$'\\n'\"java -jar $dest/lib/bfg-\$ver.jar\" |
    install /dev/stdin $dest/bin/bfg"
straplines[bfg]="BFG Repo-Cleaner"
descriptions[bfg]="The BFG is a simpler, faster alternative to git-filter-branch for cleansing bad data out of your Git repository history.

https://rtyley.github.io/bfg-repo-cleaner/"
dependencies[bfg]=JavaServerRuntime
## messages[bfg]="*** $dest/bin/bfg installed."

aliases[bfg-repo-cleaner]=bfg
