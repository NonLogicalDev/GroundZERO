CONFIG_LOCATION=~/Library/Preferences/kitty/kitty.conf

install:
	make -p ~/.terminfo
	tic -o ~/.terminfo xterm-kitty.terminfo
	ln -s $(shell pwd)/kitty.conf $(CONFIG_LOCATION)

