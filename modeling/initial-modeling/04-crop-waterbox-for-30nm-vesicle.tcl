mol new hugewat.js

set d 500
set h 500

set p1 [list [expr -$d*0.5] [expr $d*0.866025] 0]
set p2 [list [expr $d*0.5] [expr $d*0.866025] 0]
set p3 [list $d 0 0]
set p4 [list [expr $d*0.5] [expr -$d*0.866025] 0]
set p5 [list [expr -$d*0.5] [expr -$d*0.866025] 0]
set p6 [list -$d 0 0]

set all [atomselect top all]
$all set beta 1

# part 1: crop top and bottom
set deleteSelText1 "(same residue as name OH2 and (y > [expr $d*0.866025] or y < [expr -$d*0.866025]))"
set deleteSel1 [atomselect top $deleteSelText1]
set num1 [$deleteSel1 num]
puts "num1 is $num1"
$deleteSel1 set beta 0

# part 2: crop p2-p3 line
set p23Vec [vecsub $p2 $p3]
set slope [expr [lindex $p23Vec 1]/[lindex $p23Vec 0]]
set yIntercept [expr [lindex $p2 1] - $slope*[lindex $p2 0]]
set deleteSelText2 "(same residue as name OH2 and (y - $slope*x > $yIntercept))"
set deleteSel2 [atomselect top $deleteSelText2]
set num2 [$deleteSel2 num]
puts "num2 is $num2"
$deleteSel2 set beta 0

# part 3: crop p3-p4 line
set p34Vec [vecsub $p3 $p4]
set slope [expr [lindex $p34Vec 1]/[lindex $p34Vec 0]]
set yIntercept [expr [lindex $p3 1] - $slope*[lindex $p3 0]]
set deleteSelText3 "(same residue as name OH2 and (y - $slope*x < $yIntercept))"
set deleteSel3 [atomselect top $deleteSelText3]
set num3 [$deleteSel3 num]
puts "num3 is $num3"
$deleteSel3 set beta 0

# part 4: crop p5-p6 line
set p56Vec [vecsub $p5 $p6]
set slope [expr [lindex $p56Vec 1]/[lindex $p56Vec 0]]
set yIntercept [expr [lindex $p5 1] - $slope*[lindex $p5 0]]
set deleteSelText4 "(same residue as name OH2 and (y - $slope*x < $yIntercept))"
set deleteSel4 [atomselect top $deleteSelText4]
set num4 [$deleteSel4 num]
puts "num4 is $num4"
$deleteSel4 set beta 0

# part 5: crop p6-p1 line
set p61Vec [vecsub $p6 $p1]
set slope [expr [lindex $p61Vec 1]/[lindex $p61Vec 0]]
set yIntercept [expr [lindex $p6 1] - $slope*[lindex $p6 0]]
set deleteSelText5 "(same residue as name OH2 and (y - $slope*x > $yIntercept))"
set deleteSel5 [atomselect top $deleteSelText5]
set num5 [$deleteSel5 num]
puts "num5 is $num5"
$deleteSel5 set beta 0

# part 6: crop z-dir
set deleteSelText6 "(same residue as name OH2 and (z > [expr $h] or z < [expr -$h]))"
set deleteSel6 [atomselect top $deleteSelText6]
set num6 [$deleteSel6 num]
puts "num6 is $num6"
$deleteSel6 set beta 0



set writesel [atomselect top "beta > 0"]
$writesel writejs cropbox-hex.js
mol delete all

mol new cropbox-hex.js
set all [atomselect top all]
measure minmax $all

exit







