set bigmol [mol new Ves30-POPE-proteins-carved-0.5.js]


set all [atomselect top all]
$all set beta 1

set sel1 [atomselect top "same residue as segname TAAP and resid 5"]
set sel2 [atomselect top "same residue as segname TWL and resid 19"]
set sel3 [atomselect top "same residue as segname TBPD and resid 17"]
set sel4 [atomselect top "same residue as segname TAUD and resid 11"]
set sel5 [atomselect top "same residue as segname TAEG and resid 19"]
set sel6 [atomselect top "same residue as segname TBAG and resid 7"]
set sel7 [atomselect top "same residue as segname TASB and resid 1"]
set sel8 [atomselect top "same residue as segname TAHK and resid 11"]
set sel9 [atomselect top "same residue as segname TYN and resid 1"]
set sel10 [atomselect top "same residue as segname TDM and resid 5"]

$sel1 set beta 0
$sel2 set beta 0
$sel3 set beta 0
$sel4 set beta 0
$sel5 set beta 0
$sel6 set beta 0
$sel7 set beta 0
$sel8 set beta 0
$sel9 set beta 0
$sel10 set beta 0

set psel [atomselect top "name P P1 and beta < 1"]
set outerIndices [$psel get index]

file delete -force -- hand-picked-quinones-outer
file mkdir hand-picked-quinones-outer

set outercounter 1
foreach ind $outerIndices {
  set sel [atomselect $bigmol "same residue as index $ind"]
  set lipidcenter [measure center $sel]
  set n [expr int([expr [expr rand()]*3 + 1])]
  set qmol [mol new quinone-templates/top-quinone-template-$n.js]
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
  $qsel set resid $outercounter
  $qsel writejs hand-picked-quinones-outer/outq-${outercounter}.js
  incr outercounter
  $qsel delete
  mol delete $qmol
}

set writesel [atomselect $bigmol "beta > 0"]
$writesel writejs Ves30-POPE-proteins-carved-0.5-quinoneholes1.js

exit


