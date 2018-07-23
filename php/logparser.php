<?php

function get_time($str){
	$months = ["Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12];
	return strtotime($str);
}

$bad_ua = ['-', 'Alexibot', 'Aqua_Products', 'b2w/0.1', 'BackDoorBot/1.0', 'Black Hole', 'BlowFish/1.0', 'Bookmark search tool', 'BotALot', 'BuiltBotTough', 'Bullseye/1.0', 'BunnySlippers', 'Cegbfeieh', 'CheeseBot', 'CherryPicker', 'CherryPickerElite/1.0', 'CherryPickerSE/1.0', 'Copernic', 'CopyRightCheck', 'cosmos', 'Crescent', 'Crescent Internet', 'ToolPak HTTP OLE Control v.1.0', 'DittoSpyder', 'dumbot', 'EmailCollector', 'EmailSiphon', 'EmailWolf', 'Enterprise_Search', 'Enterprise_Search/1.0', 'EroCrawler', 'es', 'ExtractorPro', 'FairAd Client', 'Flaming AttackBot', 'Foobot', 'Gaisbot', 'GetRight/4.2', 'grub', 'grub-client', 'Harvest/1.5', 'Hatena Antenna', 'hloader', 'httplib', 'humanlinks', 'ia_archiver', 'ia_archiver/1.6', 'InfoNaviRobot', 'Iron33/1.0.2', 'JennyBot', 'Kenjin Spider', 'Keyword', 'Density/0.9', 'larbin', 'LexiBot', 'libWeb/clsHTTP', 'libWeb/clsHTTPUser-agent: asterias', 'LinkextractorPro', 'LinkScan/8.1a Unix', 'LinkScan/8.1a Unix User-agent: Kenjin Spider', 'LinkWalker', 'LNSpiderguy', 'lwp-trivial', 'lwp-trivial/1.34', 'Mata Hari', 'Microsoft URL Control', 'Microsoft URL Control - 5.01.4511', 'Microsoft URL Control - 6.00.8169', 'MIIxpc', 'MIIxpc/4.2', 'Mister PiX', 'moget', 'moget/2.1', 'Morfeus', 'Mozilla', 'mozilla', 'mozilla/3', 'mozilla/4', 'Mozilla/4.0 (compatible; BullsEye; Windows 95)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows 9)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows 95)', 'Mozilla/4.0 (compatible; MSIE 4.0; Windows NT)', 'mozilla/5', 'MSIECrawler', 'naver', 'NetAnts', 'NetMechanic', 'NICErsPRO', 'Offline Explorer', 'Openbot', 'Openfind', 'Openfind data gathere', 'Oracle Ultra Search', 'okhttp/2.3.0', 'PerMan', 'ProPowerBot/2.14', 'ProWebWalker', 'psbot', 'Python-urllib', 'QueryN Metasearch', 'Radiation Retriever 1.1', 'RepoMonkey', 'RepoMonkey Bait & Tackle/v1.01', 'RMA', 'searchpreview', 'SiteSnagger', 'sootle', 'SpankBot', 'spanner', 'suzuran', 'Szukacz/1.4', 'Teleport', 'TeleportPro', 'Telesoft', 'The Intraformant', 'TheNomad', 'TightTwatBot', 'Titan', 'toCrawl/UrlDispatcher', 'True_Robot', 'True_Robot/1.0', 'turingos', 'URL Control', 'URL_Spider_Pro', 'URLy Warning', 'VCI', 'VCI WebViewer VCI WebViewer Win32', 'Web Image Collector', 'WebAuto', 'WebBandit', 'WebBandit/3.50', 'WebCopier', 'WebEnhancer', 'WebmasterWorld Extractor', 'WebmasterWorldForumBot', 'WebSauger', 'Website Quester', 'Webster Pro', 'WebStripper', 'WebZip', 'WebZip/4.0', 'Wget', 'Wget/1.5.3', 'WWW-Collector-E', 'Xenu\'s', 'Xenu\'s Link Sleuth 1.1c', 'Zeus', 'Zeus 32297 Webster Pro V2.9 Win32', 'Zeus Link Scout', 'ZmEu'];

$total_request = 0;
$total = 60;
$start = 0;
$end = 0;
$is_first = True;
$training_set = [];

$data_file = file_get_contents("../data/log files/file.log");
preg_match_all("/(.*)\s-\s\S+\s+\[(\d{1,2}\/.*\/\d{4}:\d{2}:\d{2}:\d{2}).*\]\s\".*\"\s(\d{3})\s.*\"(\S*)\"\s\"(.*)\"/Ui", $data_file, $tmp);

$data = [];
$total_request = count($tmp[1]);
for ($i = 0; $i < count($tmp[1]); $i++) { 
	$row = [];
	for ($j = 2; $j < count($tmp); $j++) { 
		array_push($row, $tmp[$j][$i]);
	}
	if (array_key_exists($tmp[1][$i], $data)){
		$data[$tmp[1][$i]] = array_merge($data[$tmp[1][$i]], [$row]);
	} else{
		$data = array_merge($data, [$tmp[1][$i] => [$row]]);
	}
}

$vectors = [];
foreach ($data as $ip => $rows) {
	$vector= [];
	$total_time = 0;
	$ref_count = 0;
	$err_count = 0;
	$prev_date = 0;
	$ua_count = 0;
	$tmp = array_fill(0, 24, 0);
	$start = get_time($data[$ip][0][0]);
	$end = get_time($data[$ip][count($data[$ip]) - 1][0]);
	#$t_time = ($end - $start).total_seconds();
	$aver_time = $t_time / count($data[$ip]) ;
	$step = $t_time / $total + 1;
	$t = array_fill(0, $total, 0);
	$count_req = 0;
	foreach ($rows as $row) {
		$tmp[int(d[0][12:14])] += 1
		$t[int((get_time(d[0]) - $start).total_seconds() / step)] += 1
		if prev_date != 0:
			t_time = (get_time(d[0]) - get_time(prev_date)).total_seconds()
			if math.fabs($t_time - $aver_time) <= $aver_time * 0.1:
				count_req += 1
		if d[2] in $bad_ua:
			$ref_count += 1
		if d[1] == 404:
			$err_count += 1
		if d[3] == '-':
			$ua_count += 1
		prev_date = d[0]
	}
	# Частота IP-адреса
	array_push($vector, count($rows) / $total_request);
	# Среднее время между запросами
	array_push($vector, $count_req / count($rows));
	# Частота плохих реферов
	array_push($vector, $ref_count / count($rows));
	# Частота ошибок 404
	array_push($vector, $err_count / count($rows));
	# Частота плохих юзер-агентов
	array_push($vector, $ua_count / count($rows));
	array_push($vectors, ["ip" => $ip, "data" => $vector]);
};

file_put_contents("../data/sets/dataset", json_encode($vectors));

?>