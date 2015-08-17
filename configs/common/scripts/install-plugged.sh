#!/bin/bash
################################################--++
# INSTALL: curl -L https://goo.gl/L7y6vD | bash
################################################--++

main() {
  Log0 "Setting up Plugged" && SetUpVim
}
 
SetUpVim() {
  Log1 "Installing Plugin Manager"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
 
Log0() {
    echo "$(tput setaf 1)>>>>>>>>>>>>> $1 <<<<<<<<<<<<<<<$(tput sgr0)"
}
 
Log1() {
    echo ">>> $(tput setaf 2)$1$(tput sgr0)"
}
 
define(){ IFS='\n' read -r -d '' ${1} || true; }
 
main "$@"
