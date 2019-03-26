set mol1 [mol new Ves30-keptlipids-0.5.js waitfor all]
set mol2 [mol new Ves30-removedlipids-0.5.js waitfor all]
set mol3 [mol new Ves30nm-POPE.js waitfor all]

set sel1 [atomselect $mol1 all]
set sel2 [atomselect $mol2 all]
set sel3 [atomselect $mol3 all]

set sasa1 [measure sasa 2.4 $sel1]
set sasa2 [measure sasa 2.4 $sel2]
set sasa3 [measure sasa 2.4 $sel3]

set middleR 270
set middleRsq [expr $middleR*$middleR]

set innerPEsel1 [atomselect $mol1 "resname POPE and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPEsel1 [atomselect $mol1 "resname POPE and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]

set innerPEsel2 [atomselect $mol2 "resname POPE and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPEsel2 [atomselect $mol2 "resname POPE and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]

set innerPEsel3 [atomselect $mol3 "resname POPE and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPEsel3 [atomselect $mol3 "resname POPE and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]


puts "Full sphere:"
puts ""
puts "SASA (bead size 2.4 A):  $sasa3"
puts ""
puts "# lipids outer leaflet:  [$outerPEsel3 num]"
puts ""
puts "# lipids inner leaflet:  [$innerPEsel3 num]"
puts ""
puts "calc. SA per lipid, outer leaflet:  [expr $sasa3/[$outerPEsel3 num]]"
puts ""
puts "calc. SA per lipid, inner leaflet:  [expr $sasa3/[$innerPEsel3 num]]"
puts ""
puts "-------------------------------------------------------------"
puts ""

puts "Kept lipids:"
puts ""
puts "SASA (bead size 2.4 A):  $sasa1"
puts ""
puts "# lipids outer leaflet:  [$outerPEsel1 num]"
puts ""
puts "# lipids inner leaflet:  [$innerPEsel1 num]"
puts ""
puts "calc. SA per lipid, outer leaflet:  [expr $sasa1/[$outerPEsel1 num]]"
puts ""
puts "calc. SA per lipid, inner leaflet:  [expr $sasa1/[$innerPEsel1 num]]"
puts ""
puts "-------------------------------------------------------------"
puts ""


puts "Removed lipids:"
puts ""
puts "SASA (bead size 2.4 A):  $sasa2"
puts ""
puts "# lipids outer leaflet:  [$outerPEsel2 num]"
puts ""
puts "# lipids inner leaflet:  [$innerPEsel2 num]"
puts ""
puts "calc. SA per lipid, outer leaflet:  [expr $sasa2/[$outerPEsel2 num]]"
puts ""
puts "calc. SA per lipid, inner leaflet:  [expr $sasa2/[$innerPEsel2 num]]"
puts ""
puts "-------------------------------------------------------------"
puts ""

exit


