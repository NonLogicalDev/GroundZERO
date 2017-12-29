#!/bin/bash
set -e
set -x

GZ_LOC="$HOME/.groundzero_test"
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

function install_cl_tools() {
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" -v;
}

function install_homebrew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
}

function install_ansible() {
  brew update;
  brew install ansible;
}

if [[ "$(get_platform)" == "MAC" ]]; then
  # Install developer tools
  if ! $(pkgutil --pkgs | grep "CLTools" -q) ; then
    echo "Info   | Install   | xcode";
    install_cl_tools;
  fi

  # Download and install Homebrew
  if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew";
    install_homebrew;
  fi

  # Download and install Ansible
  if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Info   | Install   | Ansible";
    install_ansible;
  fi

  BOOTSTRAP_READY="yes"
fi

if [[ $BOOTSTRAP_READY == "yes" ]]; then
  git clone https://github.com/NonLogicalDev/GroundZERO $GZ_LOC;
else
  echo "Error  | Bootstrap Failed" > &2
fi
