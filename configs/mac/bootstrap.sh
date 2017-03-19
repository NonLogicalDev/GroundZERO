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
  prep_cl_tools
  prep_homebrew

  # Dotfiles and misc configuration
  fetch_config_repo
  set_up_dev_env
  set_up_dotfiles

  # Mac Specific dev environment
  gain_osx_superpowers

  # Setup Apps and Utilities
  install_utils
  install_apps

  echo "]]] ((((((( END  )))))))"
}

######################################################################
##### Confugurator Modules:

function prep_cl_tools {
  describe "Configuring Commandline Tools so that this script will work...."
  if (($(status $INSTALL_CL -p) != 0)); then
    info "< Installing Command Line Tools...."
    $ISNTALL_CL --install
  else
    warn "< Command Line tools already installed"
  fi
}

function prep_homebrew {
  describe "Configuring Brew...."
  if ! exists brew; then
    info "< Installing brew...."
    $RUBY -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    warn "< Brew already exists"
  fi
}

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

function set_up_dev_env {
  describe "Setting up vim PluginManager..."

  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    error "Ground ZERO is missing"
  fi

  if [[ ! -a $HOME/.vim/autoload/plug.vim ]]; then
    pushd $GROUNDZERO_REPO_PATH
      info "< Installing VimPlug..."
      make -C configs/common install.vim.plugged
    popd
  else
    warn "< VimPlug Already installed"
  fi
  describe "Setting up ZPrezto..."
  if [[ ! -a $HOME/.zprezto ]]; then
    pushd $GROUNDZERO_REPO_PATH
      info "< Installing ZPrezto..."
      make -C configs/common install.zprezto
    popd
  else
    warn "< ZPrezto Already installed"
  fi
}

function set_up_dotfiles {
  describe "Configuring dotfiles..."

  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    error "Ground ZERO is missing"
  fi

  if [[ -a $GROUNDZERO_REPO_PATH ]]; then
    info "< Running Ground ZERO dotninja..."
    pushd $GROUNDZERO_REPO_PATH
      scripts/dot/dotninja link
    popd
  else
    error "< Ground ZERO is missing, can't run install dotfiles"
  fi
}

function gain_osx_superpowers {
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

function install_utils {
  describe "Attempting to install Utils..."

  if [[ ! -a $GROUNDZERO_REPO_PATH ]]; then
    error "Ground ZERO is missing"
  fi

  pushd $GROUNDZERO_REPO_PATH
    info "< Installing Utils..."
    make -C configs/common brew.installUtils || true
  popd
}

function install_apps {
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
