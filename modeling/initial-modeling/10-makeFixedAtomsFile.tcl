# this is how fixed atoms works in the memory optimized NAMD.
# I'm not sure if restraints are implemented yet.

set fixedAtomsFile [open "lipidRestraintsFile.txt" w+]
set indexListFile [open "indexList.txt" w+]

#set mylist [list 1 5 8 2 9 17 88 4 6 15 90]
set mol [mol load js Ves30nm-solvated.js]
set sel [atomselect $mol "lipids"]
set mylist [$sel get index]
puts $indexListFile $mylist

set mySortedList [lsort -real $mylist]
set lengthOfList [llength $mySortedList]
for {set i 0} {$i < $lengthOfList} {incr i} {
  set first [lindex $mySortedList $i]
  set current $first
  set last -1
  set next [lindex $mySortedList [expr $i + 1]]

  while {$next == [expr $current + 1]} {
    set last $next
    incr i
    set current $next
    set next [lindex $mySortedList [expr $i + 1]]
  }

if {$last > 0} {
  set myString "$first-$last"
} else {
  set myString "$first"
}

puts $fixedAtomsFile "$myString"

}

close $indexListFile
close $fixedAtomsFile


exit

