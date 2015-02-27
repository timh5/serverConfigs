#!/bin/php
<?
# Compare table row counts for 2 databases on same server
# (Using maatkit tools)
# IDEA: for testing if a backup was successful, check row counts with wc line counts of .txt backup files
# Check that data matches with randome checks of data from txt columns against reporting db rows


if( $argv[3] == "" ){
	echo "
Compares table row counts for 2 databases on the same server
Usage: diffTableCounts db1 db2 dbpasswd [host]
";
die();
}


$db1=$argv[1];
$db2=$argv[2];
$pw=$argv[3];
$host = ($argv[4]) ? $argv[4] : "localhost";

$cmd="mk-table-checksum h=$host,u=root,p=$pw --count --nocrc";

echo "Checking $db1\n";
$res1=shell_exec("$cmd --database $db1 |grep '$db1'|awk '{print $2 \"=\" $6 }'");
echo "Checking $db2\n";
$res2=shell_exec("$cmd --database $db2 |grep '$db2'|awk '{print $2 \"=\" $6 }'");

/** convert checksum results into assoc arras */
function convertToArr($res)
{
	$a=explode("\n",$res);
	$b=array();
	foreach($a as $k=>$v){
		$c=explode("=",$v);
		$b[$c[0]]=$c[1];
	}
	return $b;
}

$res1=convertToArr($res1);
$res2=convertToArr($res2);
var_dump($res1);
echo "DIFF\t\t$db1\t\t$db2\t\tTABLE\n";
foreach($res1 as $k=>$v){
	$d1=$v;
	$d2=$res2[$k];
	$diff=$d2-$d1;
	echo "$diff\t\t$d1\t\t$d2\t\t$k\n";
}

