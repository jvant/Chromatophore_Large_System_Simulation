set bigmol [mol new Ves30-POPE-proteins-carved-0.5-quinoneholes1.js]


set all [atomselect top all]
$all set beta 1

set sel1 [atomselect top "same residue as segname BATM and resid 19"]
set sel2 [atomselect top "same residue as segname BAFV and resid 3"]
set sel3 [atomselect top "same residue as segname BMB and resid 5"]
set sel4 [atomselect top "same residue as segname BAQ and resid 7"]
set sel5 [atomselect top "same residue as segname BARB and resid 9"]
set sel6 [atomselect top "same residue as segname BATL and resid 15"]
set sel7 [atomselect top "same residue as segname BAAG and resid 5"]
set sel8 [atomselect top "same residue as segname BAS and resid 9"]
set sel9 [atomselect top "same residue as segname BAB and resid 11"]
set sel10 [atomselect top "same residue as segname BALD and resid 19"]


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
set innerIndices [$psel get index]

file delete -force -- hand-picked-quinones-inner
file mkdir hand-picked-quinones-inner

set innercounter 1
foreach ind $innerIndices {
  set sel [atomselect $bigmol "same residue as index $ind"]
  set lipidcenter [measure center $sel]
  set n [expr int([expr [expr rand()]*3 + 1])]
  set qmol [mol new quinone-templates/bottom-quinone-template-$n.js]
  set qsel [atomselect $qmol all]

set M1 [transaxis x 90]
set M2 [transaxis z 90]
$qsel move $M1
$qsel move $M2
# now the quinone should point along -x

set M3 [transvec $lipidcenter]
# this should be the matrix that moves the x axis along vector v (lipidcenter)
$qsel move $M3
# now the quinone should point along v

  $qsel moveby $lipidcenter
  $qsel set segname QI
  $qsel set resid $innercounter
  $qsel writejs hand-picked-quinones-inner/inq-${innercounter}.js
  incr innercounter
  $qsel delete
  mol delete $qmol
}

set writesel [atomselect $bigmol "beta > 0"]
$writesel writejs Ves30-POPE-proteins-carved-0.5-quinoneholes2.js

exit


