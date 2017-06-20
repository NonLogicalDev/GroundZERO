#!/bin/bash
set -e

######################################################################
##### Configuration Variables:

# Commands
INSTALL_CL=/usr/bin/xcode-select

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

  # Minimum necesseary bootstrap for mac
  mac__bootstrap
  source $GROUNDZERO_CONFIG_DIR/common/bootstrap.sh

  # Finish setting up bootstrap environment
  mac__prep_homebrew
  common__finilize_post_brew

  # Dotfiles and misc configuration
  common__set_up_dev_env
  common__set_up_dotfiles

  # Mac Specific dev environment
  mac__gain_osx_superpowers

  # Setup Apps and Utilities
  common__install_utils
  mac__install_apps

  echo "]]] ((((((( END  )))))))"
}

######################################################################
##### Confugurator Modules:

# Annoyingly enough this command is needed in the bootstrap so I had
# to take it out of common library
function __status {
  local status=0
  $@ >/dev/null 2>/dev/null || status=$?
  echo $status
}

function mac__boostrap {
  echo "!!! Bootstrapping Mac..."
  echo "!!! Configuring Commandline Tools so that this script will work...."
  if (($(__status $INSTALL_CL -p) != 0)); then
    echo "!!! < Installing Command Line Tools...."
    $ISNTALL_CL --install
  else
    echo "!!! < Command Line tools already installed"
  fi

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

function mac__prep_homebrew {
  describe "Configuring Brew...."
  if ! exists brew; then
    info "< Installing brew...."
    make -C config/mac install.brew
  else
    warn "< Brew already exists"
  fi
}

function mac__gain_osx_superpowers {
  describe "Configuring OSX Superpowers..."

  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    error "Ground ZERO is missing"
  fi

  if [[ ! -a $BOOTSTRAPD/superpowers_stat ]]; then
    pushd $GROUNDZERO_REPO_PATH
      info "< Attaining Superpowers..."
      make -C configs/mac osx.enableSuperpowers
      info "< Setting up screen capture..."
      make -C configs/mac osx.setUpScreencapture
      touch $BOOTSTRAPD/superpowers_stat
    popd
  else
    warn "You already have superpowers"
  fi
}

function mac__install_apps {
  describe "Attempting to install simple Apps..."

  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    error "Ground ZERO is missing"
  fi

  pushd $GROUNDZERO_REPO_PATH
    info "< Installing Utils..."
    make -C configs/mac brew.installApps || true
  popd
}

############################################################
# Currently Impossible...
############################################################
# function install_mas_apps {
#   describe "Attempting to install App Store Apps..."
#
#   if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
#     error "Ground ZERO is missing"
#   fi
#
#   pushd $GROUNDZERO_REPO_PATH
#     info "< Installing Utils..."
#     make -C configs/mac mas.installApps || true
#   popd
# }

######################################################################
main $@
