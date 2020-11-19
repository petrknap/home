<?php

set_time_limit(600);

$list = @$_GET['list'];

if ($list) {
    $hosts = file_get_contents($list);
    $hosts = preg_replace('/^([^#\h]+\h+)?([^#\v][^\v]*)$/mu', '$2', $hosts);
} else {
    $hosts = '# Usage: remove-ips-from-list.php?list=https://example.org/hosts';
}

header('Content-Type: text/plain');
echo $hosts;
