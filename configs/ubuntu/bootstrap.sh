#!/bin/bash
set -e
source ../common/scripts/@common.sh

######################################################################
##### Entry Point:

function main {
  echo "]]] ((((((( START )))))))"
  mkdir -p $BOOTSTRAPD

  # Minimum necesseary bootstrap for ubuntu
  ubuntu__bootstrap
  ubuntu__prep_linuxbrew
  common__finilize_post_brew

  # Dotfiles and misc configuration
  common__fetch_config_repo
  common__set_up_dev_env
  common__set_up_dotfiles

  # Setup Utilities
  common__install_utils

  echo "]]] ((((((( END  )))))))"
}

######################################################################
##### Confugurator Modules:

function ubuntu__bootstrap {
  describe "Bootstrapping(ensuring the apt dendencies are installed)..."
  sudo apt install \
    git \
    build-essential \
    python-setuptools \
    ruby \
    file \
    curl \
    wget
}

function ubuntu__prep_linuxbrew {
  describe "Configuring Brew...."
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  if ! exists brew; then
    info "< Installing brew...."
    $RUBY -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >>~/.bash_profile
  else
    warn "< Brew already exists"
  fi
}

######################################################################
main $@
