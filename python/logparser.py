#!/bin/env python3
# -*- coding: utf-8 -*-

from time import sleep
import re
import requests
import math
from datetime import datetime
import mle_m
import json

def read_reps(fname):
    result = dict()
    with open(fname, 'r') as f:
	    for line in f:
	        t = line.split(' ')
	        result[t[0]] = int(t[1][:-1])
    return result

def get_time(d):
	return datetime(int(d[7:11]), months[d[3:6]], int(d[0:2]), int(d[12:14]), int(d[15:17]), int(d[18:20]))

months = {"Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6, "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12}
dist_names = ['cauchy', 'dweibull', 'expon', 'norm', 'powerlaw', 'trapz', 'uniform', 'wald', 'weibull_min', 'weibull_max']
bad_ua = ['-', 'Alexibot', 'Aqua_Products', 'b2w/0.1', 'BackDoorBot/1.0', 'Black Hole', 'BlowFish/1.0', 'Bookmark search tool', 'BotALot', 'BuiltBotTough', 'Bullseye/1.0', 'BunnySlippers', 'Cegbfeieh', 'CheeseBot', 'CherryPicker', 'CherryPickerElite/1.0', 'CherryPickerSE/1.0', 'Copernic', 'CopyRightCheck', 'cosmos', 'Crescent', 'Crescent Internet', 'ToolPak HTTP OLE Control v.1.0', 'DittoSpyder', 'dumbot', 'EmailCollector', 'EmailSiphon', 'EmailWolf', 'Enterprise_Search', 'Enterprise_Search/1.0', 'EroCrawler', 'es', 'ExtractorPro', 'FairAd Client', 'Flaming AttackBot', 'Foobot', 'Gaisbot', 'GetRight/4.2', 'grub', 'grub-client', 'Harvest/1.5', 'Hatena Antenna', 'hloader', 'httplib', 'humanlinks', 'ia_archiver', 'ia_archiver/1.6', 'InfoNaviRobot', 'Iron33/1.0.2', 'JennyBot', 'Kenjin Spider', 'Keyword', 'Density/0.9', 'larbin', 'LexiBot', 'libWeb/clsHTTP', 'libWeb/clsHTTPUser-agent: asterias', 'LinkextractorPro', 'LinkScan/8.1a Unix', 'LinkScan/8.1a Unix User-agent: Kenjin Spider', 'LinkWalker', 'LNSpiderguy', 'lwp-trivial', 'lwp-trivial/1.34', 'Mata Hari', 'Microsoft URL Control', 'Microsoft URL Control - 5.01.4511', 'Microsoft URL Control - 6.00.8169', 'MIIxpc', 'MIIxpc/4.2', 'Mister PiX', 'moget', 'moget/2.1', 'Morfeus', 'Mozilla', 'mozilla', 'mozilla/3', 'mozilla/4', 'Mozilla/4.0 (compatible; BullsEye; Windows 95)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows 9)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows 95)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows NT)', 'mozilla/5', 'MSIECrawler', 'naver', 'NetAnts', 'NetMechanic', 'NICErsPRO', 'Offline Explorer', 'Openbot', 'Openfind', 'Openfind data gathere', 'Oracle Ultra Search', 'okhttp/2.3.0', 'PerMan', 'ProPowerBot/2.14', 'ProWebWalker', 'psbot', 'Python-urllib', 'QueryN Metasearch', 'Radiation Retriever 1.1', 'RepoMonkey', 'RepoMonkey Bait & Tackle/v1.01', 'RMA', 'searchpreview', 'SiteSnagger', 'sootle', 'SpankBot', 'spanner', 'suzuran', 'Szukacz/1.4', 'Teleport', 'TeleportPro', 'Telesoft', 'The Intraformant', 'TheNomad', 'TightTwatBot', 'Titan', 'toCrawl/UrlDispatcher', 'True_Robot', 'True_Robot/1.0', 'turingos', 'URL Control', 'URL_Spider_Pro', 'URLy Warning', 'VCI', 'VCI WebViewer VCI WebViewer Win32', 'Web Image Collector', 'WebAuto', 'WebBandit', 'WebBandit/3.50', 'WebCopier', 'WebEnhancer', 'WebmasterWorld Extractor', 'WebmasterWorldForumBot', 'WebSauger', 'Website Quester', 'Webster Pro', 'WebStripper', 'WebZip', 'WebZip/4.0', 'Wget', 'Wget/1.5.3', 'WWW-Collector-E', 'Xenu\'s', 'Xenu\'s Link Sleuth 1.1c', 'Zeus', 'Zeus 32297 Webster Pro V2.9 Win32', 'Zeus Link Scout', 'ZmEu']
t = 1.0 / len(dist_names)
range_dist = {'cauchy': t, 'dweibull': 7 * t, 'expon': 4 * t, 'norm': 9 * t, 'powerlaw': 3 * t, 'trapz': 2 * t, 'uniform': 0, 'wald': 8 * t, 'weibull_min': 6 * t, 'weibull_max': 5 * t} 
data = dict()
test = dict()
total_request = 0
total = 60
start = 0
end = 0
reputation = read_reps("reputation")
reps_file = open("reputation", "a")
out_file = open("../data/sets/training-set", "w")
bad_ip = open("bad_ip", "r").read().split("\n")
is_first = True
training_set = []
# test_file kristall-kino.ru_access
with open("../data/log files/file1.log", 'r') as log:
	for i in log:
		#print(i)
		output = re.findall("(.*)\s-\s\S+\s+\[(\d{1,2}\/.*\/\d{4}:\d{2}:\d{2}:\d{2}).*\]\s\".*\"\s(\d{3})\s.*\"(\S*)\"\s\"(.*)\"", i)[0]
		if not(output[0] in data):
			data[output[0]] = []
		end = get_time(output[1])
		if is_first:
			start = end
			is_first = False
		data[output[0]].append([output[1], output[2], output[3], output[4]])

for ip in data:
	total_request += len(data[ip])
#total_average_request_time = 1.0 * (end - start).total_seconds() / total_request

for ip in data:
	test[ip] = []
	total_time = 0
	ref_count = 0
	err_count = 0
	prev_date = 0
	ua_count = 0
	tmp = [0 for i in range(24)]
	start = get_time(data[ip][0][0])
	end = get_time(data[ip][len(data[ip]) - 1][0])
	t_time = (end - start).total_seconds()
	aver_time = t_time / len(data[ip]) 
	step = t_time / total + 1
	t = [0 for i in range(total)]
	count_req = 0
	for d in data[ip]:
		tmp[int(d[0][12:14])] += 1
		#print(ip)
		#print(d[0])
		#print(data[ip][0][0])
		#print(int((get_time(d[0]) - start).total_seconds() / step))
		t[int((get_time(d[0]) - start).total_seconds() / step)] += 1
		if prev_date != 0:
			t_time = (get_time(d[0]) - get_time(prev_date)).total_seconds()
			if math.fabs(t_time - aver_time) <= aver_time * 0.1:
				count_req += 1
		if d[2] in bad_ua:
			ref_count += 1
		if d[1] == 404:
			err_count += 1
		if d[3] == '-':
			ua_count += 1
		prev_date = d[0]
	# Определение закона распределения за сутки
	test[ip].append(range_dist[mle_m.distribution_estimate(tmp, dist_names)])
	# Определение закона распределения только на промежутке с запросами
	test[ip].append(range_dist[mle_m.distribution_estimate(t, dist_names)])
	# Частота IP-адреса
	test[ip].append(1.0 * len(data[ip]) / total_request)
	# Среднее время между запросами
	test[ip].append(1.0 * count_req / len(data[ip]))
	#if total_time:
	#	test[ip].append(1.0 * math.fabs(total_time - total_average_request_time) / total_time)
	#else:
	#	test[ip].append(0.0)
	# Частота плохих реферов
	test[ip].append(1.0 * ref_count / len(data[ip]))
	# Частота ошибок 404
	test[ip].append(1.0 * err_count / len(data[ip]))
	# Частота плохих юзер-агентов
	test[ip].append(1.0 * ua_count / len(data[ip]))
    # IP reputation
	rep = 0
	if not (ip in reputation):
		rep = 0
		r = requests.post("http://ip.pentestit.ru", data={'ip': ip})
		print(r.status_code, r.reason)
		if r.status_code == 200:
			rep = re.findall("REPUTATION: (\d+)", r.text)
			if not rep:
				rep = 0
			else:
				rep = rep[0]
			reps_file.write(str(ip) + ' ' + str(rep) + '\n')
		#sleep(3)
	else:
		rep = reputation[ip]
	test[ip].append(rep)
	training_set.append({'ip': ip, 'data': test[ip], 'class': 1 if ip in bad_ip else 0})

training_set = json.dumps(training_set)
out_file.write(training_set)
reps_file.close()
out_file.close()