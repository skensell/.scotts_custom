#!/usr/bin/env python

# This script takes output from uniq -c and prints ratios in front of the output

import sys

lines = sys.stdin.readlines()
ints = [ int(line.split()[0]) for line in lines ]
s = sum(ints)
ratios = [ x/float(s) for x in ints ]
for i in range(len(lines)):
    print "%6.2f%% %s"%(100*ratios[i], lines[i].rstrip())
