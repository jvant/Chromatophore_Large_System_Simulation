#!/usr/bin/python

'''
big_pb.py
Automatically generates necessary files for large PB electrostatics runs. Requires APBS and inputgen.py. 
inputgen.py should be callable directly from the terminal

Usage:
python big_pb.py [--arg_name=arg_value ... ] pqr
Arguments:
-help: prints this message and exits
-gmemceil: memory allowed for PB solver. Default=7500. NOTE: feature broken in APBS

'''



#automatically runs the preparation programs for big PDB files

import sys, os, re, random
from string import Template

apbs_template = """read
    mol pqr %s
end
elec
    mg-para
%s%s    async %d
    ofrac 0.1
%s%s    cgcent mol 1
    fgcent mol 1
    mol 1
    npbe
    bcfl sdh
    pdie 2.0000
    sdie 78.5400
    ion charge -1.00 conc ${conc} radius 1.670
    ion charge 1.00 conc ${conc} radius 1.160
    srfm spl2
    chgm spl2
    sdens 10.00
    srad 1.40
    swin 0.30
    temp 298.15
    calcenergy total
    calcforce no
    write pot dx pot%d_
end
quit"""

gmemceil = '7500'
space = '1.0'
fadd = '100'
conc = '0.04'
inputgenfile = '/Scr/scr-test-abarrag2/abhi/MDFF_att_rep/Abhi/Lane/APBS-1.4.1-binary/bin/apbs-pdb2pqr-1.4.1-binary-release/apbs/tools/manip/inputgen.py' # change this to a another path if inputgen cannot be called properly
trash = '~/tmp/'
inputgen = 'python '+inputgenfile
dontrun = False
#workdir = './'

def which(pgm):
  path=os.getenv('PATH')
  for p in path.split(os.path.pathsep):
    p=os.path.join(p,pgm)
    if os.path.exists(p) and os.access(p,os.X_OK):
      return p

def product(x,y):
  return x*y

for i in range(1, len(sys.argv)-1): # NOTE: marked for improvement using argparse
  arg = sys.argv[i]
  #print arg
  if arg == '-help' or arg=='-h':
    print __doc__
    exit()
  elif arg.startswith('--gmemceil='):
    gmemceil = arg.split('=')[1]
  elif arg.startswith('--space='):
    space = arg.split('=')[1]
  elif arg.startswith('--fadd='):
    fadd = arg.split('=')[1]
  elif arg.startswith('--dontrun'):
    dontrun = True
  elif arg.startswith('--conc='):
    conc = arg.split('=')[1]
    
  else:
    print "incorrect arguments"
    print __doc__
    exit()
    
s=Template(apbs_template)
apbs_template = s.substitute(conc=conc)

apbs_dir = 'apbs_async_all' + conc

structure = sys.argv[-1] # pqr structure

basename = os.path.splitext(os.path.basename(structure))[0].split('.')[0] # get the name of the output that inputgen is going to spit out
strucdir = os.path.dirname(structure)
#print 'basename: ', basename
#print 'gmemceil', gmemceil
#print 'space', space

if not os.path.exists(inputgenfile):
  print "Error: inputgen not found. You may want to specify the absolute path inside the big_pb.py script"
  
inputcommand = inputgen + ' --gmemceil=%s --space=%s --fadd=%s ' % (gmemceil,space,fadd) + structure
print "running command: ", inputcommand
if not dontrun:
  rc = os.system(inputcommand)

print "strucdir:", strucdir
# this should have generated the input file
infilename = None
print "checking to see if structure exists in", os.path.join(strucdir,basename+'.in')
if not os.path.exists(os.path.join(strucdir,basename+'.in')):
  # then we are going to have to go to extra effort to find it
  filelist = os.listdir('./')
  for name in filelist:
    if name.endswith('.in'):
      infilename = name
      break
      
  if not infilename:
    print "There was an error running inputgen: no APBS input file created."
    exit()
    
else:
  infilename = os.path.join(strucdir,basename+'.in')
  
# now we have to run through the input file and gather relevant information
dimestring = pdimestring = cglenstring = fglenstring = None
infile = open(infilename,'r')
for line in infile:
  if re.search(' dime', line) and not dimestring:
    dimestring = line
  if re.search('pdime', line) and not pdimestring:
    pdimestring = line
  if re.search('cglen', line) and not cglenstring:
    cglenstring = line
  if re.search('fglen', line) and not fglenstring:
    fglenstring = line


infile.close()
# from now on its just like virus_async.bash
dimensions = pdimestring.split()[1:]
totaljobs = reduce(product, map(int,dimensions))
struct_abs = os.path.abspath(structure) # get the absolute path of the structure

if os.path.exists(apbs_dir): # then move it somewhere else
  newname = trash + apbs_dir + str(int(random.random()*100000))
  print "moving old apbs_async_all folder to the trash:", newname
  os.rename(apbs_dir, newname)
os.mkdir(apbs_dir)
os.chdir(apbs_dir)
run_all = open("run_all.bash",'w')



for i in range(totaljobs):
  apbsfilename = 'apbs%d.in' % i
  apbsfile = open(apbsfilename,'w')
  apbsfile.write(apbs_template % (struct_abs, dimestring, pdimestring, i, cglenstring, fglenstring, i))
  run_all.write("echo 'now running apbs job %d'\n" % i)
  run_all.write("apbs %s > apbs%d.out\n" % (apbsfilename,i))
  apbsfile.close()

run_all.close()
print "Complete"

    
