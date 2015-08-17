ZSHELL_LOC=/bin/zsh

main() {
  Log0 "Setting up Shell"
  SetUpShell
}

SetUpShell() {
  Log1 "Deleting Directories and Files"
  rm -rf ${ZDOTDIR:-$HOME}/.zprezto
  rm -rf ${ZDOTDIR:-$HOME}/.zshrc
  rm -rf ${ZDOTDIR:-$HOME}/.zlogin
  rm -rf ${ZDOTDIR:-$HOME}/.zlogout
  rm -rf ${ZDOTDIR:-$HOME}/.zpreztorc
  rm -rf ${ZDOTDIR:-$HOME}/.zprofile
  rm -rf ${ZDOTDIR:-$HOME}/.zshenv

read -r -d '' ZSH_CLONE <<'EOS'
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
EOS

read -r -d '' ZSH_SETUP <<'EOS'
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
EOS

  Log1 "Installing Zprezto"
  zsh -c "$ZSH_CLONE" && zsh -c "$ZSH_SETUP"

  sudo chsh -s $ZSHELL_LOC $USER
}

Log0() {
    echo "$(tput setaf 1)>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<$(tput sgr0)"
}

Log1() {
    echo ">>> $(tput setaf 2)$1$(tput sgr0)"
}

define(){ IFS='\n' read -r -d '' ${1} || true; }

main "$@"
