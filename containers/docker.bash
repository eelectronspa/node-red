#!/bin/bash
# Absolute path to this script, e.g. /home/user/bin/foo.sh
if [[ $OSTYPE == 'darwin'* ]]; then
    SCRIPT=`[[ $0 = /* ]] && echo "$0" || echo "$PWD/${0#./}"`
else
    SCRIPT=`readlink -f $0`
fi
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`
# Script Name
SCRIPTNAME=`basename "$0"`

GID=$(id -g)

env UID=${UID} GID=${GID} docker $@


