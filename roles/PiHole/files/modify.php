<?php

$list = @$_GET['list'];
$ip = @$_GET['ip'];

if ($list) {
    $hosts = file_get_contents($list);
    $hosts = preg_replace('/^([^#\s]+\s+)?([^#].*)$/m', $ip ? "{$ip} \$2" : '$2', $hosts);
} else {
    $hosts = '# Usage: modify.php?list=https://example.org/hosts[&ip=192.168.0.1]';
}

header('Content-Type: text/plain');
echo $hosts;
