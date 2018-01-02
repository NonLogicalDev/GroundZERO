#!/bin/bash
set -e
set -x

GZ_LOC="$HOME/.groundzero"
BOOTSTRAP_READY="no"

function get_platform() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "MAC"
  elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo "LINUX"
  elif [[ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]]; then
    echo "WIN"
  else
    echo "UNKNOWN"
  fi
}

function main() {
  if [[ "$(get_platform)" == "MAC" ]]; then
    # Install developer tools
    if ! $(pkgutil --pkgs | grep "CLTools" -q) ; then
      echo "Info   | Install   | xcode";

      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    fi 

    echo "Info   | Update   | xcode";
    local PROD=$(softwareupdate -l | grep -E '\* Command Line Tools' | perl -pe 's/.*\* //g');
    echo "$PROD" | xargs -I {} softwareupdate -i "{}" --verbose;

    # Download and install Homebrew
    if [[ ! -x /usr/local/bin/brew ]]; then
      echo "Info   | Install   | homebrew";

      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    fi

    # Download and install Ansible
    if [[ ! -x /usr/local/bin/ansible ]]; then
      echo "Info   | Install   | Ansible";

      brew update;
      brew install ansible;
    fi

    BOOTSTRAP_READY="yes";
  fi

  if [[ $BOOTSTRAP_READY == "yes" ]]; then
    git clone https://github.com/NonLogicalDev/GroundZERO $GZ_LOC;
    cd $GZ_LOC && git checkout ansible
    make -C ~/${GZ_LOC}/playbooks
  else
    echo "Error  | Bootstrap Failed"
  fi
}

####
main
