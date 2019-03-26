mol new cropbox-hex-renumbered.js
set all [atomselect top all]

set M [transaxis z 90]
$all move $M

$all writejs waterbox-hex-for-30nm-final.js

exit
