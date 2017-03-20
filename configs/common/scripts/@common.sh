
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
  describe "Setting up Java Version Manager..."
  brew install jenv

  # <<< NodeJS
  describe "Setting up Node Version Manager..."
  if [[ ! -a ~/.nvm/nvm.sh ]]; then
    info "< Downloading NVM..."
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
  else
    warn "< NVM Already Downloaded"
  fi
  source ~/.bashrc
  nvm install v7.7.3
  nvm use v7.7.3
  nvm alias default v7.7.3

  # <<< Ruby
  describe "Setting up Ruby Version Manager..."
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
