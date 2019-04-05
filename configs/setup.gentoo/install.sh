#!/bin/bash
set -x

ln -sT "$(pwd)/config.i3/" ~/.config/i3
ln -sT "$(pwd)/config.gtk-3.0/" ~/.config/gtk-3.0
ln -sT "$(pwd)/config.X/Xresources" ~/.Xresources
