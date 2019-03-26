# Melih's thing needs to be rotated 90 degrees, so the ATPases have more room
set M [transaxis x 90]

mol new ves29/Vesicle29_LH2_full.pdb waitfor all
set all [atomselect top all]
$all move $M
mol new ves29/Vesicle29_LH1RC_full.pdb waitfor all
set all [atomselect top all]
$all move $M
mol new ves29/Vesicle29_LH1RCmonomerc.pdb waitfor all
set all [atomselect top all]
$all move $M
mol new ves29/Vesicle29_bc1.pdb waitfor all
set all [atomselect top all]
$all move $M
mol new ves29/Vesicle29_atps.pdb waitfor all
set all [atomselect top all]
$all move $M

mol new Ves30nm-POPC-solvated.js waitfor all




