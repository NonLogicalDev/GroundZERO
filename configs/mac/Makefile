default:
	echo Hello

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

.PHONY: brew.ensureBundle brew.installApps

brew.ensureBundle:
	brew tap Homebrew/bundle

brew.installApps: brew.ensureBundle
	brew bundle -v --file=Caskfile
