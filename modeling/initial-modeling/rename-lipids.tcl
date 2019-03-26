mol new Ves30nm-POPE-APL85.js

# I messed up the lipid renaming, so I need to do it again.

# lipids
set psel [atomselect top "name P and (x < 0 and y < 0 and z < 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z1I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y < 0 and z > 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z2I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y > 0 and z < 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z3I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y > 0 and z > 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z4I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y < 0 and z < 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z5I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y < 0 and z > 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z6I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y > 0 and z < 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z7I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}


set psel [atomselect top "name P and (x > 0 and y > 0 and z > 0) and (x^2 + y^2 + z^2 < 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z8I
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}


set psel [atomselect top "name P and (x < 0 and y < 0 and z < 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z1E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y < 0 and z > 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z2E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y > 0 and z < 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z3E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x < 0 and y > 0 and z > 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z4E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y < 0 and z < 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z5E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y < 0 and z > 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z6E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y > 0 and z < 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z7E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}

set psel [atomselect top "name P and (x > 0 and y > 0 and z > 0) and (x^2 + y^2 + z^2 > 270^2)"]
set pIndices [$psel get index]
set rescounter 1
foreach ind $pIndices {
  set tempsel [atomselect top "same residue as index $ind"]
  $tempsel set segname Z8E
  $tempsel set resid $rescounter
  incr rescounter
  $tempsel delete
}


set all [atomselect top all]
$all writejs Ves30nm-POPE-APL85-renamed-Z.js

exit

