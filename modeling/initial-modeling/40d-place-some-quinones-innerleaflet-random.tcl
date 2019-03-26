file delete -force -- random-picked-quinones-inner
file mkdir random-picked-quinones-inner


set bigmol [mol new Ves30-POPE-proteins-carved-0.5-quinoneholes-random1.js]


set all [atomselect top all]
$all set beta 1

# lipidP in inner leaflet
set lipidP [atomselect top "lipids and name P P1 and (x^2 + y^2 + z^2 < 270^2)"]
set indices [$lipidP get index]
set num [$lipidP num]

set alreadyPickedList {}
for {set counter 1} {$counter <= 100} {incr counter} {
  puts "doing number $counter of 100."
  #pick an index at random by picking one of the index list elements at random
  set random [expr int([expr [expr rand()]*$num])]

  #if by chance we already picked that one, keep picking until we get a new one
  while {[lsearch $alreadyPickedList $random] > -1} {
    set random [expr int([expr [expr rand()]*$num])]
  }

  lappend alreadyPickedList $random
  set chosenIndex [lindex $indices $random]
  #lappend finalList $chosenIndex

   set lipidsel [atomselect top "same residue as index $chosenIndex"]
   $lipidsel set beta 0
  set lipidcenter [measure center $lipidsel]
  $lipidsel delete

  set n [expr int([expr [expr rand()]*3 + 1])]
  set qmol [mol new quinone-templates/bottom-quinone-template-$n.js]
  set qsel [atomselect $qmol all]

  set M1 [transaxis x 90]
  set M2 [transaxis z 90]
  $qsel move $M1
  $qsel move $M2
  # now the quinone should point along +x

  set M3 [transvec $lipidcenter]
  # this should be the matrix that moves the x axis along vector v (lipidcenter)
  $qsel move $M3
  # now the quinone should point along v

  $qsel moveby $lipidcenter
  $qsel set segname QO
  $qsel set resid $counter
  $qsel writejs random-picked-quinones-inner/InnerQ-${counter}.js
  $qsel delete
  mol delete $qmol

}

set writesel [atomselect $bigmol "beta > 0"]
$writesel writejs Ves30-POPE-proteins-carved-0.5-quinoneholes-random2.js

exit


