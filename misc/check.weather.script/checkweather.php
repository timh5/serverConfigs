<?

## SETTINGS
$emails=""; // who to send to
$weather_url="http://www.wrh.noaa.gov/forecast/MapClick.php?site=mtr&textField1=37.8672&textField2=-122.2973&smap=1";
$log=dirname($argv[0])."/checkweather.log";


## Download html
$s1=file_get_contents($weather_url);
if (!$fp = @fopen($log,"a"))
	error_log ("checkweather: Couldn't open log file ");
fwrite($fp,"\n\n\n----------\n".date('l jS \of F Y h:i:s A'));
fwrite($fp,"\n$s1");

## Scrape
$s2=str_replace("\n","",$s1);
$s1=str_replace("\r","",$s2);
preg_match("|images/wtf/fcst.jpg\">.*?<b>([^:]*.{1,500})|mi",$s1,$s2);	  	## relevent chunk
$s2=$s2[1];
if( preg_match("|.*?<b>[^:]*.*?<b>[^:]*.*?<b>|mi",$s2,$s3)) 
	$s3=$s3[0];
else
	$s3=$s2;

$s3=strip_tags($s3);
if(strlen($s3)>400) $s3=substr($s3,0,400)."...";

fwrite($fp,"\n\n--Parsed Data--\n$s3");

$subj="Weather:".date('D,Md');
$mx=shell_exec("echo $s3 | mail -s '$subj' $emails");

fwrite($fp,"\n\n--Mailed--\n$mx");
fclose($fp);

?>
