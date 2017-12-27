#!/bin/bash
GZ_LOC="$HOME/.groundzero_test"
BOOTSTRAP_READY="no"

function get_platform {
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

if [[ "$(get_platform)" == "MAC" ]]; then
  # Install developer tools
  if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
  fi

  # Download and install Homebrew
  if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  fi

  # Download and install Ansible
  if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Info   | Install   | Ansible"
    brew update
    brew install ansible
  fi

  BOOTSTRAP_READY="yes"
fi

if [[ $BOOTSTRAP_READY == "yes" ]]; then
  git clone https://github.com/NonLogicalDev/GroundZERO $GZ_LOC
else
  echo "Error  | Bootstrap Failed" > &2
fi
