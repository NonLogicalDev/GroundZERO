set -e

######################################################################
##### Configuration Variables:

# Commands
RUBY=/usr/bin/ruby

# Locations
GROUNDZERO_REPO_URL=https://github.com/NonLogicalDev/GroundZERO
GROUNDZERO_REPO_PATH=$HOME/.groundzero

BOOTSTRAPD=$HOME/.__bootstrap
######################################################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

######################################################################
##### UTILS:

function status {
  local status=0
  $@ >/dev/null 2>/dev/null || status=$?
  echo $status
}

function exists {
  return $([ -x "$(which $1)" ])
}

function info {
  echo "$(tput setaf 3)>>> $(tput setaf 2)$@$(tput sgr0)"
}

function error {
  echo "$(tput setaf 3)!!! $(tput setaf 1)$@$(tput sgr0)"
  echo "PANICING!!! ABORTING!!! X_X"
  exit 1
}

function describe {
  echo "$(tput setaf 3)]]] $(tput setaf 5)$@$(tput sgr0)"
}

function warn {
  echo "$(tput setaf 3)### $(tput setaf 4)$@$(tput sgr0)"
}

