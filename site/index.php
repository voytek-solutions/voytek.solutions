<?php

$file = empty($_SERVER['PATH_INFO']) || '/' === $_SERVER['PATH_INFO'] ? '/index.html' : $_SERVER['PATH_INFO'];

$headers = array(
    'Cache-Control: max-age=604800, public'
);
$headersMap = array(
    'html' => 'Content-type: text/html',
    'css' => 'Content-type: text/css',
    'png' => 'Content-type: image/png',
    'jpg' => 'Content-type: image/jpg',
    'pdf' => 'Content-type: application/pdf',
);

$ext = pathinfo($file, PATHINFO_EXTENSION);
$headers[] = $headersMap[$ext];

foreach ($headers as $header) {
    header($header);
}
readfile(".${file}");
