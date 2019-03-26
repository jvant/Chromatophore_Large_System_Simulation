import os
import sys

for line in file(sys.argv[1]):

	try:
		x = float(line[30:38])
		y = float(line[38:46])
		z = float(line[46:54])

		if x > -10.0 and x < 10.0: print line.strip()
	except: pass
