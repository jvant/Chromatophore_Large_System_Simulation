import sys
import os
filename = sys.argv[1]

if os.path.exists(filename + ".fixed.pdb"):
	print filename + ".fixed.pdb already exists!"
	sys.exit(0)

if ".fixed.pdb" in filename:
	print filename + ' is already fixed.'
	sys.exit(0)

# group by residue
residues = {}
resid = 0
for line in open(filename):
	
	if "OH2" in line: resid = resid + 1 # sometimes this is needed
	if "CLA" in line: resid = resid + 1
	if "SOD" in line: resid = resid + 1
	
	#resid = int(line[22:27]) # now this is sometimes needed
	
	try: residues[resid].append(line)
	except: residues[resid] = [line]

for resid in residues.keys():
	resname = residues[resid][0][17:21]
	if resname == "TIP3" and len(residues[resid]) < 3:
		del residues[resid]

tmp = map(lambda x: (int(x),x), residues)
tmp.sort()

keys_in_order = [t[1] for t in tmp]

all = ""
for key in keys_in_order:
	# in this second version, I'm going to rewrite the resids, as I think they are causing problems (though not sure)
	for l in residues[key]:
		#print l.strip()
		#print (l[:22] + str(key).rjust(4) + ' ' + l[27:]).strip()
		#print "\n"
		
		if key < 10000: 
			all = all + l[:22] + str(key).rjust(4) + ' ' + l[27:]
		else:
			all = all + l[:22] + str(key) + l[27:]
	
	#all = all + "".join(residues[key])

open(filename + ".fixed.pdb",'w').write(all)
