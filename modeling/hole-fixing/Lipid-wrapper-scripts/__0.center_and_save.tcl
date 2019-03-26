# load the system. Use the js file to get the right resnames and such.
mol new ../step2.fix_patches/system.js type js first 0 last -1 step 1 filebonds 0 autobonds 0 waitfor all
mol addfile 5.step2.sim.coor type namdbin first 0 last -1 step 1 filebonds 0 autobonds 0 waitfor all

# center by the lipids
set lipids [atomselect top "resname POP POPC POPE POPG DSP DSPS CHL CHL1"]
set lipid_center [measure center $lipids]
set all [atomselect top "all"]
$all moveby [vecscale $lipid_center -1.0]

# add waters to fill in any vacume holes


# save the file
$all writepdb orig_system.lipid_centered.pdb

# quit
exit
