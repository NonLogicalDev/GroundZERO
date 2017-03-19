set -e

######################################################################
##### Configuration Variables:

# Commands
RUBY=/usr/bin/ruby

# Locations
GROUNDZERO_REPO_URL=https://github.com/NonLogicalDev/GroundZERO
GROUNDZERO_REPO_PATH=$HOME/.groundzero

BOOTSTRAPD=$HOME/.__bootstrap
######################################################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

######################################################################
##### Common Configuration Modules:

function common__finilize_post_brew {
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

function common__fetch_config_repo {
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

function common__set_up_dev_env {
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

function common__set_up_dotfiles {
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

function common__install_utils {
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
##### UTILS:

function status {
  local status=0
  $@ >/dev/null 2>/dev/null || status=$?
  echo $status
}

function exists {
  return $([ -x "$(which $1)" ])
}

function info {
  echo "$(tput setaf 3)>>> $(tput setaf 2)$@$(tput sgr0)"
}

function error {
  echo "$(tput setaf 3)!!! $(tput setaf 1)$@$(tput sgr0)"
  echo "PANICING!!! ABORTING!!! X_X"
  exit 1
}

function describe {
  echo "$(tput setaf 3)]]] $(tput setaf 5)$@$(tput sgr0)"
}

function warn {
  echo "$(tput setaf 3)### $(tput setaf 4)$@$(tput sgr0)"
}

