mol new tmp.pdb type pdb first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
set sel [atomselect top "(not (same residue as (all within 2.0 of (not resname FHL1 FSPS FOPC FOPE))))"]

$sel writepdb tmp2.pdb
quit
