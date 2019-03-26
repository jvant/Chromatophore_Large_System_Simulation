import sys

while True:
	line = sys.stdin.readline()
	if len(line) == 0: break

	if line.strip() != "": print line.strip().ljust(78)
