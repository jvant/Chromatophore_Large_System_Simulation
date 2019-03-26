
mol new patch-with-hexwaterbox.js

set all [atomselect top all]
$all set beta 0

# this is just an example.  you should figure out how many ions you really want
# given the charge of the system and ion concentration

#set numions [expr -1*int(floor([get_total_charge]))]

set waters [atomselect top "name OH2"]

set indices [$waters get index]
set num [$waters num]

# don't try to do more than 500 or so at a time.
puts "Let's place some sodium ions..."
set counter 1
set alreadyPickedList {}
for {set n 1} {$n <= 100} {incr n} {
  puts "doing number $counter of 100."
  incr counter
  #pick an index at random by picking one of the index list elements at random
  set random [expr int([expr [expr rand()]*$num])]

  #if by chance we already picked that one, keep picking until we get a new one
  while {[lsearch $alreadyPickedList $random] > -1} {
    set random [expr int([expr [expr rand()]*$num])]
  }

  lappend alreadyPickedList $random
  set chosenIndex [lindex $indices $random]
  #lappend finalList $chosenIndex

  #mark the hydrogens for deletion
  set hydrogenSel [atomselect top "hydrogen and same residue as index $chosenIndex"]
  $hydrogenSel set beta 1
  $hydrogenSel delete


  #change the oxygen into a sodium ion
  set oxygenSel [atomselect top "index $chosenIndex"]
  $oxygenSel set name SOD
  $oxygenSel set charge 1
  $oxygenSel set mass 22.989770
  $oxygenSel set type SOD
  $oxygenSel set radius 1.36
  $oxygenSel set resname SOD
  $oxygenSel delete

}

# don't try to do more than 500 or so at a time.
puts "Let's place some chloride ions..."
set counter 1
set alreadyPickedList {}
for {set n 1} {$n <= 100} {incr n} {
  puts "doing number $counter of 100."
  incr counter
  #pick an index at random by picking one of the index list elements at random
  set random [expr int([expr [expr rand()]*$num])]

  #if by chance we already picked that one, keep picking until we get a new one
  while {[lsearch $alreadyPickedList $random] > -1} {
    set random [expr int([expr [expr rand()]*$num])]
  }

  lappend alreadyPickedList $random
  set chosenIndex [lindex $indices $random]
  #lappend finalList $chosenIndex

  #mark the hydrogens for deletion
  set hydrogenSel [atomselect top "hydrogen and same residue as index $chosenIndex"]
  $hydrogenSel set beta 1
  $hydrogenSel delete


  #change the oxygen into a chloride ion
  set oxygenSel [atomselect top "index $chosenIndex"]
  $oxygenSel set name CLA
  $oxygenSel set charge -1
  $oxygenSel set mass 35.450000
  $oxygenSel set type CLA
  $oxygenSel set radius 2.27
  $oxygenSel set resname CLA
  $oxygenSel delete

}


#get everything NOT marked for deletion, and write out a new .js
set writesel [atomselect top "beta < 1"]
$writesel writejs patch-with-hexwaterbox-reionized-temp1.js  

exit



