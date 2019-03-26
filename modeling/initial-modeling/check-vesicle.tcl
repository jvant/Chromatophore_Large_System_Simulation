
mol load js Ves30nm-POPC.js
#for the 30nm version.
set middleR 270
set middleRsq [expr $middleR*$middleR]
set Pel [atomselect top "lipids and name P P1"]
set PGsel [atomselect top "resname POPG and name P P1"]
set PCsel [atomselect top "resname POPC and name P P1"]
set PEsel [atomselect top "resname POPE and name P P1"]
set innerPsel [atomselect top "lipids and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPsel [atomselect top "lipids and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]
set innerPGsel [atomselect top "resname POPG and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPGsel [atomselect top "resname POPG and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]
set innerPCsel [atomselect top "resname POPC and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPCsel [atomselect top "resname POPC and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]
set innerPEsel [atomselect top "resname POPE and name P P1 and (x^2 + y^2 + z^2 < $middleRsq)"]
set outerPEsel [atomselect top "resname POPE and name P P1 and (x^2 + y^2 + z^2 > $middleRsq)"]

set avgInner 0
foreach pIndex [$innerPsel get index] {
 puts "looking at $pIndex..."
 set sel [atomselect top "index $pIndex"]
 set coords [lindex [$sel get {x y z}] 0]
 set pDistance [veclength $coords]
 set avgInner [expr $avgInner + $pDistance]
 $sel delete
}
set avgInner [expr $avgInner/[$innerPsel num]]

set avgOuter 0
foreach pIndex [$outerPsel get index] {
 set sel [atomselect top "index $pIndex"]
 set coords [lindex [$sel get {x y z}] 0]
 set pDistance [veclength $coords]
 set avgOuter [expr $avgOuter + $pDistance]
 $sel delete
}
set avgOuter [expr $avgOuter/[$outerPsel num]]

set innerArea [expr 4*3.1415*$avgInner*$avgInner]
set outerArea [expr 4*3.1415*$avgOuter*$avgOuter]
set innerAPL [expr $innerArea/[$innerPsel num]]
set outerAPL [expr $outerArea/[$outerPsel num]]

puts "inner leaflet:"
puts "average P radius:  $avgInner"
puts "numbers: [$innerPsel num] total, [innerPGsel num] POPG, [innerPCsel num] POPC, [innerPEsel num] POPE"
puts "percentages:  [expr (1.0*[innerPGsel num]/[$innerPsel num])] POPG, [expr (1.0*[innerPCsel num]/[$innerPsel num])] POPC, [expr (1.0*[innerPEsel num]/[$innerPsel num])] POPE "
puts "charge: -[innerPGsel num]"
puts "area: $innerArea"
puts "APL:  $innerAPL"
puts ""

puts "outer leaflet:"
puts "average P radius:  $avgOuter"
puts "numbers: [$outerPsel num] total, [outerPGsel num] POPG, [outerPCsel num] POPC, [outerPEsel num] POPE"
puts "percentages:  [expr (1.0*[outerPGsel num]/[$outerPsel num])] POPG, [expr (1.0*[outerPCsel num]/[$outerPsel num])] POPC, [expr (1.0*[outerPEsel num]/[$outerPsel num])] POPE "
puts "charge: -[outerPGsel num]"
puts "area: $outerArea"
puts "APL:  $outerAPL"
puts ""

puts "full vesicle:"
puts "numbers: [$Psel num] total, [$PGsel num] POPG, [$PCsel num] POPC, [$PEsel num] POPE"
puts "percentages: [expr (1.0*[PGsel num]/[$Psel num])] POPG, [expr (1.0*[PCsel num]/[$Psel num])] POPC, [expr (1.0*[PEsel num]/[$Psel num])] POPE"
puts "charge: -[$PGsel num]"

exit





