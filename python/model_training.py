#!/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import json
import random

global x_train 
global y_train
global x_test
global y_test

def load_set(file):
    data_set = {}
    data_set = json.loads(open(file, 'r').read())
    return data_set

def kneighbors(neigh_numb, w, alg, x_train, y_train, x_test):
    from sklearn.neighbors import KNeighborsClassifier
    knn = KNeighborsClassifier(n_neighbors = neigh_numb, weights = w, algorithm = alg)
    knn.fit(x_train, y_train)
    return knn.predict(x_test)

def svm_classificator(p, k, prob_enabled, x_train, y_train, x_test):
    from sklearn.svm import SVC
    svm_c = SVC(C = p, kernel = k, probability = prob_enabled)
    svm_c.fit(x_train, y_train)
    return svm_c.predict(x_test)

def decision_tree(c, strategy, depth, x_train, y_train, x_test):
    from sklearn.tree import DecisionTreeClassifier
    decision_tree_classifier = DecisionTreeClassifier(criterion = c, splitter = strategy, max_depth = depth)
    decision_tree_classifier.fit(x_train, y_train)
    return decision_tree_classifier.predict(x_test)

def prepare_data(test_size, is_print = False):
    bad_count = 0
    good_count = 0
    for d in data:
        x.append(d['data'])
        y.append(d['class'])
        if d['class']:
            bad_count += 1
        else:
            good_count += 1
    for i in range(len(x)):
        if (len(x_test) < int(len(x) * test_size)) and (random.randint(0, 1) == 1):
            x_test.append(x[i])
            y_test.append(y[i])
        else:
            x_train.append(x[i])
            y_train.append(y[i])
    if is_print:
        print("Всего данных {:3d}: из них 'хороших' {:3d}, а 'плохих' {:3d}".format(len(x_train) + len(x_test), good_count, bad_count))
        print("Данных в обучающей выборке {:3d}".format(len(x_train)))
        print("Данных в проверочной выборке {:3d}".format(len(x_test)))

if __name__ == "__main__":
    data = load_set('training_set')
    x = []
    y = []
    x_train = []
    y_train = []
    x_test = []
    y_test = []
    prepare_data(0.25, True)
    print("Дерево решений")
    for i in range(1, 15):
        print("\tГлубина " + str(i))
        for s in ['best', 'random']:
            print("\t\tСтратегия " + s)
            for crit in ['gini', 'entropy']:
                y_pred = decision_tree(crit, s, i, x_train, y_train, x_test)
                print("\t\t\tКритерий {:s}. Правильность на тестовом наборе: {:.2f}".format(crit, np.mean(y_pred == y_test)))
    print("Метод опорных векторов")
    for kern in ['linear', 'poly', 'rbf', 'sigmoid']:
        print("\tЯдро " + kern)
        for h in [True, False]:
            print("\t\tОценка вероятности " + str(h))
            for pen in range(1, 11):
                y_pred = svm_classificator(pen * 0.1, kern, h, x_train, y_train, x_test)
                print("\t\t\tШтраф {:.1f}. Правильность на тестовом наборе: {:.2f}".format(pen * 0.1, np.mean(y_pred == y_test)))
    print("Метод ближайших соседей")
    for i in range(1, 12):
        print("\tСоседей: " + str(i))
        for w in ['uniform', 'distance']:
            print("\t\tВес " + w)
            for alg in ['brute', 'kd_tree', 'ball_tree']:
                y_pred = kneighbors(i, w, alg, x_train, y_train, x_test)
                print("\t\t\tАлгоритм {:s}. Правильность на тестовом наборе: {:.2f}".format(alg, np.mean(y_pred == y_test)))