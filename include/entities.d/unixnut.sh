commands[bincalc]="pip_install_wrapper bincalc"
straplines[bincalc]="Binary calculator"
descriptions[bincalc]="CLI calculator for IEEE 1541-2002 / ISO/IEC 80000-13:2008 Prefixes
for Binary Multiples

https://pypi.org/project/bincalc/"
dependencies[bincalc]=$python_install_entity
## messages[bincalc]=""

## aliases[]=


commands[cloud-shepherd]="pip_install_wrapper cloud-shepherd"
straplines[cloud-shepherd]="Shepherd for cloud VM control"
descriptions[cloud-shepherd]="https://pypi.org/project/cloud-shepherd/"
dependencies[cloud-shepherd]=$python_install_entity
## messages[cloud-shepherd]=""

aliases[shepherd]=cloud-shepherd


# colorls
commands[colorls]="pip_install_wrapper colorls"
straplines[colorls]="c*ls commands that use colour and pipe output to less"
descriptions[colorls]="Commands: cls, clls, cllls, cals, calls, callls, csls, cslls,
 csllls, csals, csalls, csallls

Commands provide zero or more of the following features, in required order:
  s: run as superuser
  a: use -A to show hidden files (but not self/parent directory entries)
  l: extra long listing, show nanosecond file times
  l: long listing (like \`ls -l\`), with ISO8601 file times and
     syntax-higlighted file sizes

With no extra 'l's, i.e. just the ls suffix, c*ls operates like \`ls -FC\`.

https://pypi.org/project/colorls/"
dependencies[colorls]=$python_install_entity
## messages[colorls]=""

aliases[cls]=colorls


commands[Postfix-tools]="pip_install_wrapper Postfix-tools"
straplines[Postfix-tools]="Tools, scripts and config for use with the Postfix MTA"
descriptions[Postfix-tools]="https://pypi.org/project/postfix-tools/"
dependencies[Postfix-tools]=$python_install_entity
## messages[Postfix-tools]=""

aliases[postresolve]=Postfix-tools
aliases[postscan]=Postfix-tools


commands[text-justifier]="pip_install_wrapper text-justifier"
straplines[text-justifier]="Justify and hyphenate text in files and/or standard input"
descriptions[text-justifier]="https://pypi.org/project/text-justifier/"
dependencies[text-justifier]=$python_install_entity
## messages[text-justifier]=""

aliases[justifier]=text-justifier
aliases[justify]=text-justifier
