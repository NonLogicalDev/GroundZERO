CONFIG_LOCATION=~/Library/Preferences/kitty/kitty.conf


default:
	echo Hello

#######################################################################
#                          Installing Stuff                           #
#######################################################################
.PHONY: install.zprezto install.vim.plugged

install.zprezto:
	bash scripts/install-zprezto.sh

install.vim.plugged:
	bash scripts/install-plugged.sh

install.kitty:
	mkdir -p ~/.terminfo
	tic -o ~/.terminfo files/kitty/xterm-kitty.terminfo
	-ln -s $(shell pwd)/files/kitty/kitty.conf $(CONFIG_LOCATION)

#######################################################################
#                             Brew Tasks                              #
#######################################################################

.PHONY: brew.ensureBundle brew.installUtils

brew.ensureBundle:
	brew tap Homebrew/bundle

brew.installUtils: brew.ensureBundle
	brew bundle -v --file=Brewfile
