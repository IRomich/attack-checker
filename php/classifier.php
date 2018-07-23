<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/connection.php';

use Phpml\Classification\KNearestNeighbors;
use Phpml\ModelManager;

/*
	ip - IP адрес
	sequence_request - Частота запросов с данного IP (Количество запросов с данного IP / общее количество запросов со всех IP адресов)
	sequence_404 - Частота 404 ошибок с данного IP (Количество запросов c 404 ошибкой с данного IP / общее количество запросов с данного только IP)
	user_agent - использовался хотя бы в 1 запросе плохой юзер агент с данного IP (0 - нет, 1 - да)
	method_request - шли ли запросы, хотя бы один, с данного IP c типом не GET и не POST (0 - нет, 1 - да)
	t_avg - взять интервал interval_t минимальное и максимальное время запросов с данного IP и поделить на их количество ((MAX(t) - MIN(t))/число запросов с этого IP в этот интервал)
	interval_t - Максимальное время запроса - минимальное время запроса с данного IP
	count_request - число запросов с данного IP в этот интервал interval_t
	count_0_9_1_1_request - число запросов со средним временем между t_avg * 0.9 AND t_avg * 1.1 и поделенное на общее число запросов со всех IP
*/
$sql = "SELECT sequence_request, sequence_404, user_agent, method_request, count_0_9_1_1_request FROM apache_analysis_ml";
$data = $conn->query($sql);
$x = [];
foreach ($data as $row) {
	array_push()
}
// восстановление модели из файла
$modelManager = new ModelManager();
$classifier = $modelManager->restoreFromFile('model');
// создание списка подозртительных IP-адресов
$black_ip = [];
$y_pred = $classifier->predict($x);

foreach ($y_pred as $key => $value) {
	if ($value == 1){
		array_push($black_ip, $train_data[$key]['ip']);
	}
}

/* Изменение файла .htaccess */
if (!empty($black_ip)){
	$htaccess = file_get_contents("htaccess");
	/* Поиск позиций начала и конца подстроки запрета */
	$start = strpos($htaccess, "Deny from");
	if ($start){
		$finish = strpos($htaccess, "\n", $start);
		if (empty($finish)){
			$finish = strlen($htaccess);
		}
		/* Извлечение подстроки запрета */
		$temp = substr($htaccess, $start, $finish - $start);
		/* Формирование строки IP адресов для блокировки*/
		$r = "";
		foreach ($black_ip as $key => $value) {
			/* Проверка забблокирован ли уже данный IP адрес */
			if (stripos($temp, $value) === False){
				$r .= ", " .$value; 
			}
		}
		if (strlen($r) != 0) {
		file_put_contents("ddos_check.log", date("Y-m-d H:i:s") . " Add: ". substr($r, 2), FILE_APPEND);
		$htaccess = str_replace($temp, $temp . $r , $htaccess);
		file_put_contents("../.htaccess", $htaccess);
	}
	}
	else{
		$htaccess .= "\n\nOrder Allow,Deny\nAllow from all\nDeny from " . implode(', ', $black_ip);
		file_put_contents("htaccess", $htaccess);
	}	
}
?>