# saving waters

mol new tmp.pdb type pdb first 0 last -1 step 1 filebonds 0 autobonds 0 waitfor all

# note that the numbers below are to redefine the size of the box.
set sel [atomselect top "(all and not within 3 of (not water and not resname SOD CLA)) and (x > -600 and x < 600 and y > -600 and y < 600 and z > -600 and z < 600) and not ((within 13.5 of ((resname POPC POPE and name C218 C316) or (resname DSPS and name C218 C318))) and (not within 3 of (name P or (resname CHL1 and name O3))))"]
# note that 13.5 above used to be 25

$sel writepdb tmp2.pdb
quit
