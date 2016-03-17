#!/usr/bin/env python
import sys
"""
This script requires two input files: 1. goodproteins.fasta (file used in OrthoMCL clustering) and 2. groups.txt (output of OrthoMCLtoGroups)

Useage: python groups_matrix.py <goodproteins.fasta> <groups.txt> >out.matrix


"""
class Cluster:
    def __init__(self, name):
        self.name = name
        self.members = {}

    def add(self, bug, member):
        self.members[bug] = member

all_proteins = {}
clusters = []
bugs = {}

for ln in open(sys.argv[1]):
    if ln.startswith('>'):
        protein = ln[1:].rstrip()
        all_proteins[protein] = False

n = 0
for ln in open(sys.argv[2]):
    prefix, proteins = ln.rstrip().split(':')
    proteins = proteins.split()

    c = Cluster(prefix)

    for p in proteins:
        bug, id = p.split("|")
        c.add(bug, id)
        bugs[bug] = bug

        all_proteins[p] = True

    clusters.append(c)

# add the singletones
i = 1
for p, already_counted in all_proteins.iteritems():
    if already_counted == False:
        c = Cluster("single%d" % (i))
        bug, id = p.split("|")
        c.add(bug, id)
        i += 1
        clusters.append(c)

first_cluster = clusters[0]
print " ".join(['"%s"' % (c.name) for c in clusters])

i = 0
for b in sorted(bugs):
    print '"%s"' % (b),

    for c in clusters:
        print " ",
        if b in c.members:
            print "1",
        else:
            print "0",
    print

    i += 1
