<?php

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/connection.php';

use Phpml\Classification\KNearestNeighbors;
use Phpml\ModelManager;


// подготовка обучающей выборки
$x_train = [];
$y_train = [];
$sql = "SELECT sequence_request, sequence_404, user_agent, method_request, count_0_9_1_1_request, ip FROM apache_analysis_ml";
$data = $conn->query($sql);

foreach ($data as $row) {
	$sql = "SELECT id FROM ip_black_list WHERE ip = " . $row["ip"];
	$is_robot = $conn->query($sql);
	if (!$is_robot){
		array_push($y_train, 0);
	} else{
		array_push($y_train, 1);
	}
	unset($row["ip"]);
	array_push($x_train, $row);
}

var_dump($x_train);
die();
// создание модели
$knn_classifier = new KNearestNeighbors($k = 3);
// обучение модели
$knn_classifier->train($x_train, $y_train);
// сохраненеи модели
$filepath = 'model';
$modelManager = new ModelManager();
$modelManager->saveToFile($knn_classifier, $filepath);

?>