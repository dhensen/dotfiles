#!/bin/php
<?php

if (!isset($argv[1])) {
    die("argument must be timing file name");
}

$file = $argv[1];

if (!is_readable($file)) {
    die("file not readable");
}

$position = $argv[2];
$timings = array_map('str_getcsv', file($file));

$slide = null;
foreach ($timings as $timingData) {

    // if the position in the movie is smaller than current timingData
    if ($position < ($timingData[1]/1000)) {
        // this efectivly echos previous slide
        echo $slide;
        exit;
    }

    // now set the new
    $slide = $timingData[2];
}
