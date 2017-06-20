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

#######################################################################
#                             Brew Tasks                              #
#######################################################################

.PHONY: brew.ensureBundle brew.installUtils

brew.ensureBundle:
	brew tap Homebrew/bundle

brew.installUtils: brew.ensureBundle
	brew bundle -v --file=Brewfile
