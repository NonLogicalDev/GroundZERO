#!/bin/bash

RUBY=/usr/bin/ruby

printf "\n" | $RUBY -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
echo 'export PATH="$HOME/.linuxbrew/bin:$PATH"' >> ~/.bashrc
