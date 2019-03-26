import glob
import os

# you need to divide the non water/ion files into segments too 
os.system('rm -r 5.make_new_psf_segs; mkdir 5.make_new_psf_segs')

# not get all the segs available
torun = 'cat orig_system.lipid_centered.fixed.lipids_and_protein.pdb  | grep "^ATOM"  | awk \'{print substr($0,73,4)}\' | awk \'{print $1}\' | uniq | sort | uniq > tmp3.unique_segs'
os.system(torun)

# now separate segs of old lipids and proteins
# Doesn't work for step3 #os.system('cat tmp3.unique_segs | awk \'{print "grep \\"" $1 "   $\\" orig_system.lipid_centered.fixed.lipids_and_protein.pdb > ./5.make_new_psf_segs/" $1 ".pdb"}\' > t')

# for some reason, the way to prepare step 3 required this: (no spaces after terminal letter, probably a stray trim somewhere)
torun = 'cat tmp3.unique_segs | awk \'{print "grep \\"" $1 "$\\" orig_system.lipid_centered.fixed.lipids_and_protein.pdb > ./5.make_new_psf_segs/" $1 ".pdb"}\' > t'
os.system(torun)
os.system('python /home/jdurrant/multiprocess.py.bak t 24')

# now further separate these into NA and HA. The ones that have LYS terminal residues are NA, and the ones with ILE terminal residues are HA.
os.system('rm -r 5.make_new_psf_segs/NAs; mkdir 5.make_new_psf_segs/NAs')
os.system('rm -r 5.make_new_psf_segs/HAs; mkdir 5.make_new_psf_segs/HAs')
torun = """cd 5.make_new_psf_segs/; ls *pdb | awk '{print "echo -n " $1 ";tail -n 1 " $1}' | bash | sed "s/ATOM/ /g" | grep "LYS" | awk '{print "mv " $1 " ./NAs/"}' | bash"""
os.system(torun)
os.system("""cd 5.make_new_psf_segs/; ls *pdb | awk '{print "echo -n " $1 ";tail -n 1 " $1}' | bash | sed "s/ATOM/ /g" | grep "ILE" | awk '{print "mv " $1 " ./HAs/"}' | bash""")

# now separate segs of new filler lipids
os.system('rm -r 5.make_new_psf_segs2; mkdir 5.make_new_psf_segs2')

for filename in glob.glob('filler?.pdb'):
	os.system('cat ' + filename + ' | grep "^ATOM"  | awk \'{print substr($0,73,4)}\' | awk \'{print $1}\' | uniq | sort | uniq > tmp3.unique_segs')
	
	# below used to work
	#os.system('cat tmp3.unique_segs | awk \'{print "grep \\"" $1 "   $\\" ' + filename + ' > ./5.make_new_psf_segs2/' + filename + '_" $1 ".pdb"}\' > t')
	os.system('cat tmp3.unique_segs | awk \'{print "grep \\"" $1 "  $\\" ' + filename + ' > ./5.make_new_psf_segs2/' + filename + '_" $1 ".pdb"}\' > t')	

	# changed to below
	#os.system('cat tmp3.unique_segs | awk \'{print "grep \\"" $1 "$\\" ' + filename + ' > ./5.make_new_psf_segs2/' + filename + '_" $1 ".pdb"}\' > t')

	os.system('python /home/jdurrant/multiprocess.py.bak t 24')

import re

# fix the filler atoms
# need to change names back, need to remove half molecules (sometimes happens)
os.system("rm ./5.make_new_psf_segs2/*fixed*") # remove all the old fixed ones so you can replace them with new ones
for filename in glob.glob('./5.make_new_psf_segs2/*.pdb'): #filler3.pdb_BKT.pdb'): #*pdb'):
	# you need to go through each of the atoms in this file
	
	last_resname = ""
	last_resid = ""
	last_atomname = ""
	
	molecules = []
	single_molecule = []
	
	for atom in open(filename):
		
		# fix the resnames
		atom = re.sub(r'.HL1', "CHL1",atom)
		atom = re.sub(r'.OPC', "POPC",atom)
		atom = re.sub(r'.OPE', "POPE",atom)
		atom = re.sub(r'.SPS', "DSPS",atom)
		
		resname = atom[17:21]
		resid = atom[22:26]
		#atomname = atom[6:11]
		
		new_mol = False

		if resname != last_resname:
			new_mol = True
		if resid != last_resid:
			new_mol = True
		
		if new_mol == True:
			molecules.append((last_resname,single_molecule))
			single_molecule = []
			
		single_molecule.append(atom)
		
		last_resname = resname
		last_resid = resid
		#last_atomname = atomname

	# need to get the last molecule too
	molecules.append((last_resname, single_molecule))
	
	# need to remove initial empty molecule
	molecules = molecules[1:]
	
	# identify any ones that are too small
	tokeep = []
	for mol in molecules:		
		resname = mol[0]
		num_atoms = len(mol[1])
		
		#print resname, num_atoms
		
		if resname == "CHL1" and num_atoms == 74: tokeep.append(mol[1])
		if resname == "DSPS" and num_atoms == 135: tokeep.append(mol[1])
		if resname == "POPE" and num_atoms == 125: tokeep.append(mol[1])
		if resname == "POPC" and num_atoms == 134: tokeep.append(mol[1])
			
	# write the good ones to a new file
	if len(tokeep) > 0:
		f = open(filename + '.fixed.pdb','w')
		for mol in tokeep: f.write("".join(mol))
		f.close()

# Now parameterize this new system

tcl_file = open('param.tcl','w')

tcl_file.write("package require psfgen\n")

#tmp_files = glob.glob('/scratch/AdamLipidwrapper_EM/1.charmm-gui/toppar/*rtf')
#tmp_files.extend(glob.glob('../../../1.charmm-gui/toppar/*cholesterol.str'))
#tmp_files.append('../../../5.lipidwrapper_model_separated_ready_for_processing/0.fix_headgroups.MD.used_to_id_bad_CHL1/charmm_stuff/toppar_water_ions.modified.str')

tmp_files = ['top_all22_prot.rtf', 'top_all36_lipid.rtf', 'toppar_all36_lipid_cholesterol.str', 'toppar_water_ions.str']
tmp_files = ['/scratch/Influenza-super-project/build_patch/3.make_more_complex_model.v2/built_models/charmm_stuff/' + t for t in tmp_files]

for afile in tmp_files: tcl_file.write("topology " + afile + "\n")

tcl_file.write('pdbalias atom CAL CA CAL' + "\n")

label1 = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
labels = []
for l1 in label1:
	for l2 in label1:
		for l3 in label1:
			for l4 in label1:
				labels.append(l1+l2+l3+l4)

label_i = 0
pdb_files = glob.glob('./5.make_new_psf_segs/*.pdb')
pdb_files.extend(glob.glob('./5.make_new_psf_segs/HAs/*.pdb'))
pdb_files.extend(glob.glob('./5.make_new_psf_segs2/*.fixed.pdb'))
pdb_files.extend(glob.glob('./4.fix_waters_segs/*.fixed.pdb'))
pdb_files.extend(glob.glob('./4.fix_waters_bubble_segs/*.fixed.pdb'))
pdb_files.sort()

# Now we need to add the NA files, but we need to know which ones are paired to each other. It's going to be tricky!
CYS_S_coors = []
filenames_coors = []
CYS_lines = []

for NA_filename in glob.glob('./5.make_new_psf_segs/NAs/*.pdb'):
	filenames_coors.append(NA_filename)

	# below worked previously
	#CYS_line = [l for l in open(NA_filename) if "SG  CYS X 554" in l or "SG  CYS X1023" in l or "SG  CYS X1961" in l or "SG  CYS X1492" in l][0]
	
	# this one works now
	CYS_line = [l for l in open(NA_filename) if "SG  CYS X  49 " in l][0]
	
	CYS_lines.append(CYS_line)
	CYS_S_coors.append([float(t) for t in [CYS_line[30:38], CYS_line[38:46], CYS_line[46:54]]]) # checked, works

import numpy
import scipy
from scipy.spatial.distance import pdist
from scipy.spatial.distance import squareform
CYS_S_coors = numpy.array(CYS_S_coors)
dists = squareform(pdist(CYS_S_coors))
NA_pairs = []
for i,row in enumerate(dists):
	row[i] = 10e100
	index_of_partner = numpy.argmin(row)
	toadd = [filenames_coors[i], filenames_coors[index_of_partner]]
	toadd.sort()
	NA_pairs.append(" ".join(toadd))

NA_pairs = set(NA_pairs)
NA_pairs = [l.split(" ") for l in NA_pairs]

# now add the NA, but so that connected NAs are juxtaposed
for pair in NA_pairs:
	pdb_files.append(pair[0])
	pdb_files.append(pair[1])

# start creating the TCL file
filename_to_segid = {}
for afile in pdb_files:
	filename_to_segid[afile] = labels[label_i]
	
	# First, we need to determine if this is a protein
	is_protein = "moose"
	
	if "4.fix_waters_segs" in afile: is_protein = False
	elif "HAs" in afile: is_protein = True
	elif "NAs" in afile: is_protein = True
	elif "5.make_new_psf_segs2" in afile: is_protein = False
	else: # need to determine from file
		if "SER" in open(afile).readline(): is_protein = True
		else: is_protein = False
		
	
	if is_protein == False:
		tcl_file.write("""segment """ + labels[label_i] + """ {
		first none
		last none
		auto angles dihedrals
		pdb """ + afile + """
}
""")
	else:
		tcl_file.write("""segment """ + labels[label_i] + """ {
		first NTER
		last CTER
		auto angles dihedrals
		pdb """ + afile + """
}
""")

	label_i = label_i + 1

# now we need to identify all the hemmagultinin and add in sulfide-bond patches
HA_filenames = []
HA_offset = []
NA_filenames = []
NA_offset = {}
for filename in glob.glob('./5.make_new_psf_segs/?As/*.pdb'):
	lines = open(filename).readlines()
	first_line = lines[0]
	last_line = lines[-1]
	if last_line[17:20] == "ILE":
		#HA_offset.append(int(first_line[22:26])) # used to work
		HA_offset.append(1) # now this
		HA_filenames.append(filename)
	if last_line[17:20] == "LYS":
		NA_filenames.append(filename)
		# NA_offset[filename] = int(first_line[22:26]) - 506 # used to work
		NA_offset[filename] = -505 # now this

# add in DISU for HA
for i,HA_filename in enumerate(HA_filenames):
	
	output = """patch DISU SEGID:""" + str(106 + HA_offset[i]) + """ SEGID:""" + str(152 + HA_offset[i]) + """
patch DISU SEGID:""" + str(71 + HA_offset[i]) + """ SEGID:""" + str(83 + HA_offset[i]) + """ 
patch DISU SEGID:""" + str(295 + HA_offset[i]) + """ SEGID:""" + str(319 + HA_offset[i]) + """ 
patch DISU SEGID:""" + str(291 + HA_offset[i]) + """ SEGID:""" + str(58 + HA_offset[i]) + """ 
patch DISU SEGID:""" + str(491 + HA_offset[i]) + """ SEGID:""" + str(487 + HA_offset[i]) + """ 
patch DISU SEGID:""" + str(20 + HA_offset[i]) + """ SEGID:""" + str(480 + HA_offset[i]) + "\n\n"

	output = output.replace('SEGID',filename_to_segid[HA_filename])
	tcl_file.write(output)

# add in intra DISU for NA
for filename in NA_filenames:
	offset = NA_offset[filename]

	output = """patch DISU SEGID:""" + str(634 + offset) + """ SEGID:""" + str(629 + offset) + """
patch DISU SEGID:""" + str(926 + offset) + """ SEGID:""" + str(951 + offset) + """ 
patch DISU SEGID:""" + str(922 + offset) + """ SEGID:""" + str(597 + offset) + """ 
patch DISU SEGID:""" + str(743 + offset) + """ SEGID:""" + str(738 + offset) + """ 
patch DISU SEGID:""" + str(786 + offset) + """ SEGID:""" + str(795 + offset) + """ 
patch DISU SEGID:""" + str(784 + offset) + """ SEGID:""" + str(797 + offset) + """
patch DISU SEGID:""" + str(823 + offset) + """ SEGID:""" + str(840 + offset) + """
patch DISU SEGID:""" + str(689 + offset) + """ SEGID:""" + str(736 + offset) + "\n\n"

	output = output.replace('SEGID',filename_to_segid[filename])
	tcl_file.write(output)

# now add in ther inter DISU for NA, drawing upon pairs
for pair in NA_pairs:
	segid1 = filename_to_segid[pair[0]]
	segid2 = filename_to_segid[pair[1]]
	
	offset1 = NA_offset[pair[0]]
	offset2 = NA_offset[pair[1]]
	
	tcl_file.write("patch DISU " + segid1 + ":" + str(554 + offset1) + " " + segid2 + ":" + str(554 + offset2) + "\n\n")

label_i = 0
for afile in pdb_files:
	tcl_file.write("coordpdb " + afile + " " + labels[label_i] + "\n")
	label_i = label_i + 1

tcl_file.write("""guesscoord
writepdb system.pdb
writepsf system.psf

quit""")

tcl_file.close()


print "I'm leaving it up to you to ensure electrical neutrality!!!!!!!!!!"
