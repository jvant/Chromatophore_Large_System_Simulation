import sys

def get_new_atom_line(f):
    l = "\n"
    while len(l) != 0:
        l = f.readline()
        if l[:4] == "ATOM": yield l.strip()
        
# used to be this, but can find file now: source_pdb = open("5019_min_200000_prod_all.fixed.lipid_centered.pdb")
source_pdb = open("orig_system.lipid_centered.pdb")

source_lines = get_new_atom_line(source_pdb)

# separate into molecules
lipids = []
water_ions = []
amino_acids = []
calciums = []

def atom_and_resname(line):
    return line[12:21]

#print "Separating residues... Could take a while..."

while True:
    try:
        first_line_of_mol = source_lines.next()
        #print first_line_of_mol
        if atom_and_resname(first_line_of_mol) == " OH2 TIP3":
            tmp = [first_line_of_mol]
            for t in range(2): tmp.append(source_lines.next())
            water_ions.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " SOD SOD ":
            water_ions.append([first_line_of_mol])
            continue
        if atom_and_resname(first_line_of_mol) == " CLA CLA ":
            water_ions.append([first_line_of_mol])
            continue
        if atom_and_resname(first_line_of_mol) == " CAL CAL ":
            calciums.append([first_line_of_mol])
            continue
        if atom_and_resname(first_line_of_mol) == " C3  CHL1":
            tmp = [first_line_of_mol]
            for t in range(73): tmp.append(source_lines.next())
            lipids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   POPC":
            tmp = [first_line_of_mol]
            for t in range(133): tmp.append(source_lines.next())
            lipids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   DSPS":
            tmp = [first_line_of_mol]
            for t in range(134): tmp.append(source_lines.next())
            lipids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   POPE":
            tmp = [first_line_of_mol]
            for t in range(124): tmp.append(source_lines.next())
            lipids.append(tmp)
            continue
    
        if atom_and_resname(first_line_of_mol) == " N   ALA ":
            tmp = [first_line_of_mol]
            for t in range(9): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   ARG ":
            tmp = [first_line_of_mol]
            for t in range(23): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   ASP ":
            tmp = [first_line_of_mol]
            for t in range(11): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   ASN ":
            tmp = [first_line_of_mol]
            for t in range(13): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   HSD ":
            tmp = [first_line_of_mol]
            for t in range(16): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " CB  CYS " or atom_and_resname(first_line_of_mol) == " SG  CYS ":
            # so strange that otherwise identical cysteins sometimes start with CB, sometimes with SG
            tmp = [first_line_of_mol]
            for t in range(9): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   CYS ": # the protonated cysteines
            tmp = [first_line_of_mol]
            for t in range(10): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   GLU ":
            tmp = [first_line_of_mol]
            for t in range(14): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   GLN ":
            tmp = [first_line_of_mol]
            for t in range(16): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " C   GLY ": # terminal glycine
            tmp = [first_line_of_mol]
            for t in range(7): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   GLY ":
            tmp = [first_line_of_mol]
            for t in range(6): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   HSE ":
            tmp = [first_line_of_mol]
            for t in range(16): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   ILE ":
            tmp = [first_line_of_mol]
            for t in range(18): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " C   ILE ": # terminal ILE
            tmp = [first_line_of_mol]
            for t in range(19): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   LEU ":
            tmp = [first_line_of_mol]
            for t in range(18): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   LYS ":
            tmp = [first_line_of_mol]
            for t in range(21): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " C   LYS ": # extra atoms (OT1, OT2)
            tmp = [first_line_of_mol]
            for t in range(22): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   PHE ":
            tmp = [first_line_of_mol]
            for t in range(19): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   PRO ":
            tmp = [first_line_of_mol]
            for t in range(13): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   SER ":
            tmp = [first_line_of_mol]
            for t in range(10): tmp.append(source_lines.next())
            
            # if "HT1 SER" in this, add two more. It's a terminal one with extra hydrogens
            if "HT1 SER" in "".join(tmp):
                for t in range(2): tmp.append(source_lines.next())
    
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   TRP ":
            tmp = [first_line_of_mol]
            for t in range(23): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   TYR ":
            tmp = [first_line_of_mol]
            for t in range(20): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   VAL ":
            tmp = [first_line_of_mol]
            for t in range(15): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   THR ":
            tmp = [first_line_of_mol]
            for t in range(13): tmp.append(source_lines.next())
            amino_acids.append(tmp)
            continue
        if atom_and_resname(first_line_of_mol) == " N   MET ":
            tmp = [first_line_of_mol]
            for t in range(16): tmp.append(source_lines.next())
    
            # if "HT1 MET" in this, add two more. It's a terminal one with extra hydrogens
            if "HT1 MET" in "".join(tmp):
                for t in range(2): tmp.append(source_lines.next())
    
            amino_acids.append(tmp)
            continue
    except: break
    print "REMARK NOT CATEGORIZED: " + first_line_of_mol
    sys.exit(0)


#print "Combining residues into segments..."
def break_into_segs_if_residues_not_connected(residue_list):
    segs = []
    seg_atom_count = 0
    current_seg = []
    atom_cutoff = 25000
    for residue in residue_list:
        seg_atom_count = seg_atom_count + len(residue) # potential number of atoms in this seg if you add the current residue to it
        if seg_atom_count < atom_cutoff: # you haven't exceeded the cutoff. Go ahead and add the segment.
            current_seg.append(residue)
        else: # too many atoms. Save the current segment, and then start a new one containing just this residue
            segs.append(current_seg)
            current_seg = [residue]
            seg_atom_count = len(residue) # reset the count 
    segs.append(current_seg) # get the last segment saved
    
    return segs

lipid_segs = break_into_segs_if_residues_not_connected(lipids)
water_ions_segs = break_into_segs_if_residues_not_connected(water_ions)
calciums_segs = break_into_segs_if_residues_not_connected(calciums)

# Now, amino acids are more complicated, because you have to divide by chain.
def get_resname(line): return line[17:20].strip()

protein_segs = []
while len(amino_acids) != 0:
    if get_resname(amino_acids[0][0]) == "SER": # M2
        protein_segs.append(amino_acids[:41])
        amino_acids = amino_acids[41:]
        continue
    
    if get_resname(amino_acids[0][0]) == "MET" and get_resname(amino_acids[1][0]) == "LYS": # HA
        protein_segs.append(amino_acids[:566])
        amino_acids = amino_acids[566:]
        continue

    if get_resname(amino_acids[0][0]) == "MET" and get_resname(amino_acids[1][0]) == "ASN": # NA
        protein_segs.append(amino_acids[:469])
        amino_acids = amino_acids[469:]
        continue

# merge all these segs into one
all_segs = protein_segs
all_segs.extend(lipid_segs)
all_segs.extend(water_ions_segs)
all_segs.extend(calciums_segs)

# now, we need to fix indexing and residue indexing and segids
segids = []
letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
for l1 in letters:
    for l2 in letters:
        for l3 in letters:
            segids.append(l1 + l2 + l3)

current_index = 1
seg_index = 1
for seg in all_segs:
    segname = segids[seg_index]
    current_resid = 1
    for residue in seg:
        for line in residue:
            print line[:6] + str(current_index).rjust(5) + line[11:22] + str(current_resid).rjust(4) + line[26:-3] + segname
            
            if current_index == 99999 or current_index == "*****": current_index = "*****"
            else: current_index = current_index + 1
        current_resid = current_resid + 1
    seg_index = seg_index + 1
