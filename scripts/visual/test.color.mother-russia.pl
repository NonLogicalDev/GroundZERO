#!/usr/bin/perl
# Author: Todd Larason <jtl@molehill.org>
# $XFree86: xc/programs/xterm/vttests/256colors2.pl,v 1.1 1999/07/11 08:49:54 dawes Exp $

# now the grayscale ramp


sub DrawRows { my ($red, $green, $blue, $numrows) = @_;
  my $fgbg = 48;
  for($row = 0; $row < $numrows; $row+=1) {
    my $r = $red;
    my $g = $green;
    my $b = $blue;
    for ($gray = 8; $gray < 256; $gray+=5) {
        $r = ($r > 1)? $r - 4 : 1;
        $g = ($g > 1)? $g - 4 : 1;
        $b = ($b > 1)? $b - 4 : 1;
        print "\x1b[${fgbg};2;${r};${g};${b}m  ";
    }
    print "\x1b[0m\n";
  }
}

DrawRows(255, 255, 255, 6);
DrawRows(0, 0, 255, 6);
DrawRows(255, 0, 0, 6);
