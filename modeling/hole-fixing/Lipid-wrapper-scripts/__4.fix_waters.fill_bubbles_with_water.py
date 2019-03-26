import numpy
import scipy.spatial as ss
import cPickle
import glob
import os
import multiprocess_v2

# make the directory if needed
os.system('rm -r 4.fix_waters_bubble_segs; mkdir 4.fix_waters_bubble_segs')

# first, load in the whole system. It will be huge. Need lots of memory.
'''
# assume huge numpy array is required.
system_pts = numpy.empty((250000000,3))

i = 0
for line in file('orig_system.lipid_centered.fixed.pdb'):
    
    if i % 1000000 == 0: print 100 * i / float(200000000), "%"
    
    x = float(line[30:38])
    y = float(line[38:46])
    z = float(line[46:54])
    
    system_pts[i][0] = x
    system_pts[i][1] = y
    system_pts[i][2] = z
    
    i = i + 1

numpy.save('system_pts.numpy', system_pts[:i])
'''

system_pts = numpy.load('system_pts.numpy.npy')

# now make this huge system a nice tree for fast distance comparisons
system_tree = ss.cKDTree(system_pts)

# now go through water blocks and hollow them out.
def get_pts_from_file(filename):
    pts = numpy.empty((700000,3))
    i = 0
    lines = file(filename).readlines()
    for line in lines:
        
        x = float(line[30:38])
        y = float(line[38:46])
        z = float(line[46:54])
        
        try:
            pts[i][0] = x
            pts[i][1] = y
            pts[i][2] = z
        except:
            print "ERROR:", line, x, y, z, "\n", i, len(lines)
            sdf
        
        i = i + 1
        
    return pts[:i], lines


class add_a(multiprocess_v2.general_task):

    def value_func(self, filename, results_queue): # so overwriting this function
        pts, lines = get_pts_from_file(filename)
        f = open('./4.fix_waters_bubble_segs/' + os.path.basename(filename), 'w')
        for i in range(0,len(pts),3):
            water_pts = pts[i:i+3]
    
            #print water_pts
            #water_lines = lines[i:i+3]
            #print water_lines
    
            dists_i = system_tree.query(water_pts)
            dist = numpy.min(dists_i[0])
            if dist > 3.0:
                f.write("".join(lines[i:i+3]))
        f.close()

tmp = multiprocess_v2.multi_threading(glob.glob('../water_box/*.pdb'),24, add_a)

