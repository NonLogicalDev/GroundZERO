#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null
#   scripts/dot/dotninja $*
  env/bin/dotter "$@"
popd > /dev/null
