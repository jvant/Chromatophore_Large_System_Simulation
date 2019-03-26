mol new cropbox-hex.js

set a [atomselect top all]
#renumber
set resid [list]
set cur_residue -1
set cur_resid 0
foreach res [$a get residue] {
  if { $res != $cur_residue } {
    set cur_residue $res
    incr cur_resid
    if { $cur_resid % 10000 == 0 } {
      puts -nonewline .
      flush stdout
    }
  }
  lappend resid $cur_resid
}
puts .
$a set resid $resid
$a set segid "BWAT"

$a writejs cropbox-hex-renumbered.js

$a delete

exit



