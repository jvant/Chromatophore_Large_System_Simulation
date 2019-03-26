package require psfgen
#source MakeGeometries.tcl
source MakeGeometries-changedAPL-0.85.tcl
topology top_all36_lipid.rtf

# top layer:  22% POPC, 56% POPE, 22% POPG;  bottom layer: 24% POPC, 66% POPC, 10% POPG
#makeVesicle {POPC 0.22 POPE 0.56 POPG 0.22} {POPC 0.24 POPE 0.66 POPG 0.10} 300 Ves30nm-chromaMix

# top layer: 100% POPE;  bottom layer: 100% POPE
makeVesicle {POPE 1.0} {POPE 1.0} 300 Ves30nm-POPE-APL85

exit

