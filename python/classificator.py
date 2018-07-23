#!/bin/env python3
# -*- coding: utf-8 -*-

from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report
import json
import random

global x
global y
global ip
global x_test
global y_test

def load_set(file):
    data_set = {}
    data_set = json.loads(open(file, 'r').read())
    return data_set

def prepare_data(data, is_test = False):
	if is_test:
		for i in range(len(data)):
			if (len(x_test) < int(len(data) * 0.25)) and (random.randint(0, 1) == 1):
				x_test.append(data[i]['data'])
				y_test.append(data[i]['class'])
			else:
				x.append(data[i]['data'])
				y.append(data[i]['class'])
	else:
		for d in data:
			x.append(d['data'])
			y.append(d['class'])
			ip.append(d['ip'])

# Training model
x = []
y = []
x_test = []
y_test = []
data = load_set('training_set')
prepare_data(data, True)
knn = KNeighborsClassifier(n_neighbors = 3, weights = 'uniform', algorithm = 'kd_tree')
knn.fit(x, y)
#y_pred = knn.predict(x_test)
#report = classification_report(y_test, y_pred, target_names = ['Human', 'Robot'])
#print(report)
#exit()
# Use model for classification 
ip = []
x = []
y = []
bad_ip = []
data = load_set('set')
prepare_data(data)
y_pred = knn.predict(x)
for i in range(len(y_pred)):
	if y_pred[i] == 1:
		bad_ip.append(ip[i])
# Work with htaccess file
htaccess = open(".htaccess", "w")
str_temp = "order deny,allow\nallow from all\ndeny from"
for ip in bad_ip:
	str_temp += " " + str(ip) + ","
htaccess.write(str_temp[:-1])