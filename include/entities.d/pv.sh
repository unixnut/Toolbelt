aliases[pv]=${DISTRO}:pv
if [ $DISTRO_BASE = RedHat ] ; then
  dependencies[${DISTRO}:pv]=epel
fi
straplines[pv]="pipeview tool"
## descriptions[pv]=""
