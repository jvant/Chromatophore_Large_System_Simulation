package require psfgen

readmol psf wat.psf pdb wat.pdb
regenerate angles ;# initial structure has duplicates
set watsize 65.4195 ;# side length of the solvent box
writemol js hugewat.js 17 [list $watsize 0 0 ] 17 [list 0 $watsize 0] 17 [list 0 0 $watsize]

#center
#mol new hugewat.js
#set all [atomselect top all]
#$all moveby [vecscale -0.5  [eval vecadd [measure minmax $all]]]

#$all writejs hugewat.js

exit
