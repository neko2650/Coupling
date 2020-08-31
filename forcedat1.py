#!/usr/bin/python

import os
import sys
import math
import glob

forces_file = glob.glob('/home/sreekanth/OpenFOAM/sreekanth-7/run/work/Test3.7/postProcessing/forces/[0-9]*/*.dat')
latest_file=max(forces_file, key=os.path.getctime)

def line2dict(line):
	tokens_unprocessed = line.split()
	tokens = [x.replace(")","").replace("(","") for x in tokens_unprocessed]
	floats = [float(x) for x in tokens]
	data_dict = {}
	data_dict['time'] = floats[0]
	force_dict = {}
	force_dict['pressure'] = floats[1:4]
	force_dict['viscous'] = floats[4:7]
	force_dict['porous'] = floats[7:10]
	moment_dict = {}
	moment_dict['pressure'] = floats[10:13]
	moment_dict['viscous'] = floats[13:16]
	moment_dict['porous'] = floats[16:19]
	data_dict['force'] = force_dict
	data_dict['moment'] = moment_dict
	return data_dict

time = []
force = []
with open(latest_file,"r") as datafile:
	for line in datafile:
		if line[0] == "#":
			continue
		data_dict = line2dict(line)
		time += [data_dict['time']]
		force += [data_dict['force']['pressure'][1] ]
datafile.close()

outputfile = open('/home/sreekanth/OpenFOAM/sreekanth-7/run/work/Test3.7/forcesplot.txt','a+')
for i in range(0,len(time)):
	outputfile.write(str(time[i])+' '+str(force[i])+'\n')
outputfile.close()
outputfile = open('/home/sreekanth/OpenFOAM/sreekanth-7/run/work/Test3.7/forces.txt','w')
for i in range(0,len(time)):
	outputfile.write(str(time[i])+' '+str(force[i])+'\n')
outputfile.close()
