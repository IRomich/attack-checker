#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys, scipy.stats
import numpy as np

def distribution_estimate(data, distributions, verb_level=3):
	''' Estimates best fit parameters and likelihood of given data
	for each distribution from list.
	'''
	# Arrays to store results
	parameters = []; llvalue = []
	# Verify distributions
	for dist in distributions:
		# Choose distribution family
		d = getattr(scipy.stats, dist)
		# Fit parameters
		params = d.fit(data)
		parameters.append(params)
		# Estimate likelihood
		llvalue.append(LL_estimate(data, d, *params))
	assert(len(llvalue) == len(parameters))
	xranged_indexes = np.argsort(llvalue)
	return distributions[xranged_indexes[-1]]

def LL_estimate(data, distribution, *params):
	''' Estimates log-likelihood value of defined probability law.
	'''
	return sum(np.log(distribution.pdf(data, *params)))

def loadData(filename):
	'''Loads timeseries from file'''
	t = open(filename, 'r')
	t = [x.strip() for x in t]
	x = []; y = []
	del t[-1]
	for i in t:
		d = i.split(' ')
		x.append(float(d[0]))
		y.append(float(d[1]))
	return np.asarray(x), np.asarray(y)

if __name__ == "__main__":
	# Check input arguments
	if len(sys.argv) < 2 or len(sys.argv) > 3:
		print("\nUsage: ./timeseries_analyze <file_name> [-s]\n")
		exit(1)

	# Load data from file
	x, y = loadData(sys.argv[1])
	timestep = (x[x.size - 1] - x[1]) / (x.size - 1) # -1 => x.size - 1    17.10.17 00:04
	print("Timeseries length: {} points".format(y.size))
	print("Timestep: {} sec".format(timestep))
	
	# Obtain data probability distribution law by MLE
	print("\n\t\tData distribution test\n")
	distribution_estimate(y, dist_names)