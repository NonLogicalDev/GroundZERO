#!/bin/bash
set -e
source ../common/scripts/@common.sh

######################################################################
##### Entry Point:

function main {
  echo "]]] ((((((( START )))))))"
  mkdir -p $BOOTSTRAPD

  # Minimum necesseary bootstrap for ubuntu
  bootstrap_ubuntu

  # Package managers and dev support
  prep_linuxbrew
  finilize_brew

  # Dotfiles and misc configuration
  fetch_config_repo
  set_up_dev_env
  set_up_dotfiles

  # Setup Utilities
  install_utils

  echo "]]] ((((((( END  )))))))"
}

######################################################################
##### Confugurator Modules:

function bootstrap_ubuntu {
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

function prep_linuxbrew {
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

function finilize_brew {
  describe "Install developer essentials from brew..."
 
  # Insall version managers
  # <<< Java
  brew install jenv
  # <<< NodeJS
  brew install nvm
  mkdir ~/.nvm
  nvm install v7.7.3
  nvm use v7.7.3
  nvm alias default v7.7.3
  # <<< Ruby
  brew install rbenv
  eval "$(rbenv init -)"
  rbenv install -v 2.4.0
  rbenv global 2.4.0

  # Neovim integrations
  pip install neovim
  gem instal neovim

  # misc
  gem instal lolcat
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

######################################################################
main $@
