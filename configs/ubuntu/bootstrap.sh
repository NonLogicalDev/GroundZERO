#!/bin/bash
set -e

######################################################################
##### Configuration Variables:

# Commands
RUBY=/usr/bin/ruby

# Locations
GROUNDZERO_REPO_URL=https://github.com/NonLogicalDev/GroundZERO
GROUNDZERO_REPO_PATH=$HOME/.groundzero
GROUNDZERO_CONFIG_DIR=$GROUNDZERO_REPO_PATH/configs

BOOTSTRAPD=$HOME/.__bootstrap
######################################################################

######################################################################
##### Entry Point:

function main {
  echo "]]] ((((((( START )))))))"
  mkdir -p $BOOTSTRAPD

  # Minimum necesseary bootstrap for ubuntu
  ubuntu__bootstrap
  ubuntu__prep_linuxbrew

  # Get the actual repo and load common modules
  fetch_config_repo
  source $GROUNDZERO_CONFIG_DIR/common/scripts/@common.sh

  # Finish setting up bootstrap environment
  common__finilize_post_brew

  # Dotfiles and misc configuration
  common__set_up_dev_env
  common__set_up_dotfiles

  # Setup Utilities
  common__install_utils

  echo "]]] ((((((( END  )))))))"
}

######################################################################
##### Confugurator Modules:

function fetch_config_repo {
  describe "Configuring Ground ZERO..."
  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    info "< Cloning Ground ZERO repo into $GROUNDZERO_REPO_PATH..."
    git clone $GROUNDZERO_REPO_URL $GROUNDZERO_REPO_PATH
  else
    warn "< Ground ZERO is already set up"
  fi
  if [[ -a $GROUNDZERO_REPO_PATH ]]; then
    info "< Updating Ground ZERO submodules..."
    pushd $GROUNDZERO_REPO_PATH
      git submodule update --init --recursive
    popd
  else
    error "< Ground ZERO is missing, even though it was just pulled, there be BLACK MAGIC ROUND THIS BEND!!!"
  fi
}


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
    echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bashrc
  else
    warn "< Brew already exists"
  fi
}

######################################################################
main $@
