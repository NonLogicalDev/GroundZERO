#!/bin/bash
set -e

######################################################################
##### Configuration Variables:

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
  source $GROUNDZERO_CONFIG_DIR/common/bootstrap.sh

  # Finish setting up bootstrap environment
  ubuntu__prep_linuxbrew
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

function ubuntu__bootstrap {
  echo "!!! Bootstrapping Ubuntu..."
  sudo apt install -y \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    python-setuptools \
    ruby \
    file \
    curl \
    wget \
    zsh

  echo "!!! Configuring Ground ZERO..."
  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    echo "!!! < Cloning Ground ZERO repo into $GROUNDZERO_REPO_PATH..."
    git clone $GROUNDZERO_REPO_URL $GROUNDZERO_REPO_PATH
  else
    echo "!!! < Ground ZERO is already set up"
  fi
  if [[ -a $GROUNDZERO_REPO_PATH ]]; then
    echo "!!! < Updating Ground ZERO submodules..."
    pushd $GROUNDZERO_REPO_PATH
      git submodule update --init --recursive
    popd
  else
    echo "!!! < Ground ZERO is missing, even though it was just pulled, there be BLACK MAGIC ROUND THIS BEND!!!"
    exit 1
  fi
}

function ubuntu__prep_linuxbrew {
  describe "Configuring Brew...."
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  if ! exists brew; then
    info "< Installing brew...."
    make -C config/ubuntu install.brew
  else
    warn "< Brew already exists"
  fi
}

######################################################################
main $@
