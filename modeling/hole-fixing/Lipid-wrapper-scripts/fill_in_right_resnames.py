def get_new_atom_line(f):
    l = "\n"
    while len(l) != 0:
        l = f.readline()
        if l[:4] == "ATOM": yield l.strip()
        
template_pdb = open("../step2.fix_patches/system.delmewhendone.pdb")
source_pdb = open("5019_min_200000_prod_all.fixed.lipid_centered.pdb")

#while get_new_atom_line(template_pdb):
template_lines = get_new_atom_line(template_pdb)
    
for source_line in get_new_atom_line(source_pdb):
    template_line = template_lines.next()
    print source_line,"\n",template_line,"\n"
    