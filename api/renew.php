<?php
$zip = $_GET['zipcode'];
mysql_connect('localhost', 'root', 'renew');
mysql_select_db('renew');

$result = mysql_query('select * from zipcodes where zipcode="' . $zip . '"');
$row = mysql_fetch_assoc($result);
$state = $row['state_abbr'];

$result = mysql_query('select * from energy where state="' . $state . '"');
$row = mysql_fetch_assoc($result);
$index = $row['percentile'];
print "index: " . $index;
?>