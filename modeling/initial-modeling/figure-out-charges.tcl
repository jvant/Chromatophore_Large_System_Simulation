mol load js Ves35nm-chromaMix-solvated-sphereCropped.js
set innerPsel [atomselect top "name P and x^2 + y^2 + z^2 < 102400"]
set outerPsel [atomselect top "name P and x^2 + y^2 + z^2 > 102400"]

# the only thing with a net charge is POPG, -1 for each lipid
set innerPGsel [atomselect top "resname POPG and name P and x^2 + y^2 + z^2 < 102400"]
set outerPGsel [atomselect top "resname POPG and name P and x^2 + y^2 + z^2 > 102400"]
set innerPGnum [$innerPGsel num]
set outerPGnum [$outerPGsel num]

puts "We have $innerPGnum negative charges on the inner surface, and $outerPGnum negative charges on the outer surface."





