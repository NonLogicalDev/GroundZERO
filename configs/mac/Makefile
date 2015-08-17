#######################################################################
#                        OSX Enhancement Tasks                        #
#######################################################################

.PHONY: osx.foldersOnTop osx.enableSuperpowers
.PHONY: osx.setUpScreencapture osx.cleanUpDuplicates

osx.foldersOnTop:
	bash scripts/folders-on-top.sh

osx.enableSuperpowers:
	bash scripts/osx-superpowers.sh

osx.setUpScreencapture:
	bash scripts/set-up-screencapture.sh

osx.cleanUpDuplicates:
	bash scripts/remove-open-with-duplicates.sh

#######################################################################
#                             Brew Tasks                              #
#######################################################################

.PHONY: brew.install brew.ensureBundle brew.installUtils brew.installApps

brew.install:
	bash scripts/install-brew.sh

brew.ensureBundle:
	brew tap Homebrew/bundle

brew.installUtils: brew.ensureBundle
	brew bundle -v --file=Brewfile

brew.installApps: brew.ensureBundle
	brew bundle -v --file=Caskfile
