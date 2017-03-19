#!/bin/bash
set -e
source ../common/scripts/@common.sh

######################################################################
##### Variables:

INSTALL_CL=/usr/bin/xcode-select

######################################################################
##### Entry Point:

function main {
  echo "]]] ((((((( START )))))))"
  mkdir -p $BOOTSTRAPD

  # Package managers and dev support
  mac__bootstrap
  mac__prep_homebrew
  common__finilize_post_brew

  # Dotfiles and misc configuration
  common__fetch_config_repo
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

function mac__bootstrap {
  describe "Configuring Commandline Tools so that this script will work...."
  if (($(status $INSTALL_CL -p) != 0)); then
    info "< Installing Command Line Tools...."
    $ISNTALL_CL --install
  else
    warn "< Command Line tools already installed"
  fi
}

function mac__prep_homebrew {
  describe "Configuring Brew...."
  if ! exists brew; then
    info "< Installing brew...."
    $RUBY -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
