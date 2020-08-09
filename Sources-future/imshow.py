from __future__ import division
import pylab as p
from pandas import read_csv
import sys

"""
Usage: python imshow.py filename.png shouldSave shouldShow
"""

def str2bool(string):
    """ 
    Only true if string is one of "yes", "true", "t", "1". Returns false
    otherwise.
    """
    return string.lower() in ("yes", "true", "t", "1")

filename = sys.argv[1]
shouldSave = str2bool(sys.argv[2])
shouldShow = str2bool(sys.argv[3])

x = read_csv("temp.csv", header=None)
x = p.asarray(x)

p.figure()
p.imshow(x, interpolation='nearest')
p.tight_layout()
p.colorbar()

if shouldShow: p.show()
if shouldSave: p.savefig('../'+filename, dpi=300)
