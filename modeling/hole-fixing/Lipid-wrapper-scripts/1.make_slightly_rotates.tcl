mol new orig_system.lipid_centered.fixed.just_lipids.pdb type pdb first 0 last -1 step 1 filebonds 0 autobonds 0 waitfor all

set lipids [atomselect top "all"]

# rotate about X
$lipids move [trans bond {0 0 0} {1 0 0} 5 deg]
$lipids writepdb lipids1.pdb
$lipids move [trans bond {0 0 0} {1 0 0} -10 deg]
$lipids writepdb lipids2.pdb
$lipids move [trans bond {0 0 0} {1 0 0} 5 deg]

# rotate about Y
$lipids move [trans bond {0 0 0} {0 1 0} 5 deg]
$lipids writepdb lipids3.pdb
$lipids move [trans bond {0 0 0} {0 1 0} -10 deg]
$lipids writepdb lipids4.pdb
$lipids move [trans bond {0 0 0} {0 1 0} 5 deg]

# rotate about Z
$lipids move [trans bond {0 0 0} {0 0 1} 5 deg]
$lipids writepdb lipids5.pdb
$lipids move [trans bond {0 0 0} {0 0 1} -10 deg]
$lipids writepdb lipids6.pdb
$lipids move [trans bond {0 0 0} {0 0 1} 5 deg]

