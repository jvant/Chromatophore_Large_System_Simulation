mol load js overlap.js

set notBadWaters [atomselect top "not (same residue as (water and name OH2 and within 2.5 of lipids))"]
$notBadWaters writejs Ves30nm-POPE-solvated.js

exit

