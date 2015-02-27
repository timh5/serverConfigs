<?
// Estimates how many hours worked on a project based on git commits
// Usage: 	php gitTimeSpent.php [path]
// Example: php gitTimeSpent.php pdf/	-	this will only calculate entries that have "pdf/" in 
//											the path of the changed filenames 
//
//
// How it works:
// 1. If two commits are made within a certain time period ($continuousWorkThreshold), 
//		then they are assumed to be time checkins in which all time in between was worked
// 2. Additionally, unless that first commit in the chain has a commit message of "start working"
//		an additional hour is added to that entry
// 3. If a single commit does not have any other commits within that threshold around it, 
//		it is assumed to be 1 hour of work
//
// 

if ( $argv[1] ) $pathInclude=$argv[1];

// How many minutes in between git commits, will be counted as continuous working time
$continuousWorkThreshold=120;


/**
 * Converts a GMT date in UTC format (ie. 2010-05-05 12:00:00)
 * Into the GMT epoch equivilent
 * The reason why this doesnt work: strtotime("2010-05-05 12:00:00")
 * Is because strtotime() takes the servers timezone into account
 */
function utc2epoch($str_date)
{
    $time = strtotime($str_date);
    //now subtract timezone from it
    return strtotime(date("Z")." sec", $time);
}

function epoch2utc($epochtime, $timezone="PST")
{
    $d=gmt2timezone($epochtime, $timezone);
    return $d->format('Y-m-d H:i:s');
}

/**
 * Convert the given UTC String format date (in GMT time) into a new timezone, as DateTime object
 * @param utcORepoch - ie. "2010-01-05 11:00:00" or "123123123"
 * @param timezone (String) - ie "PST", "US/Eastern", etc
 * @return a DateTime() object, ie. use $DateTime->format(), to output it
 */
function gmt2timezone($utcORepoch, $timezone)
{
    $prevtz = date_default_timezone_get();
    date_default_timezone_set("GMT");
    if(is_numeric($utcORepoch))
        $utcORepoch=date("Y-m-d H:i:s",$utcORepoch);

    $gmtTZ = new DateTimeZone('GMT');       //gmt timezone
    $tz = new DateTimeZone($timezone);      //target timezone

    $gmtTime = date_create($utcORepoch,$gmtTZ);
    $offset = $tz->getOffset($gmtTime);

    $newEpoch = $gmtTime->format('U') + $offset;
    $newDate = new DateTime(date('Y-m-d H:i:s',$newEpoch),$tz);
    date_default_timezone_set($prevtz);
    return $newDate;
}


/*
commit 53cbfe3b41721a2a8cf8325243d191f55e49cf1c
Author: root <info@vyew.com>
Date:   Thu Dec 23 19:40:22 2010 -0600

    got it working with sprinkler report... first field only
*/

// Look for any entries that are "start working"... and classify them so that 
// They do not tack on an hour in front 
$txt=shell_exec("git log --stat");
$entries=preg_split("/\ncommit [0-9a-zA-Z]{30,45}/",$txt);
$pathExcludes=$pathIncludes=0;
foreach($entries as $entry)
{
	$e=trim($entry);
	preg_match_all('/Date:[ \t]+(.*)/', $e, $m);
	$out=array('time'=>$m[1][0]);
	if(preg_match("/start ?work(ing)?\n/",$e)) 
		$out['start']=1;

	try{
		$e2=explode("\n",$e);
		array_shift($e2);
		array_shift($e2);
		array_shift($e2);
		array_shift($e2);
		$e=implode("\n",$e2);
	} catch(Exception $e) { }

	if(!empty($pathInclude)){
		if(preg_match("/$pathInclude.*\|/",$e)){ 
			$times[]=$out;
			$pathIncludes++;
		}else{
			$pathExcludes++;
		}
	}else{
		$times[]=$out;
	}
}



$tot=0;
foreach($times as $timeslot){
	$time=$timeslot['time'];	
	if( $timeslot['start'] ) $startMarkers++;
	if(empty($timeStart)){
		$timeStart=$time;
	}
	if(empty($lastTime)){ 
		$lastTime=$time;	
		continue;
	}
	$lt=strtotime($lastTime);
	$tt=strtotime($time);
	$diff_s=abs($lt-$tt);
	$diff_m=round($diff_s/60);

	//echo "::" . epoch2utc($time) . "\n";
	
	//past the thresh, so calculate the last, and start over
	if($diff_m>$continuousWorkThreshold){
		if($timeStart==$lastTime){
			echo "1\t".epoch2utc($time)."\n";
			$singleTot+=1;
			$timeStart=$time;
			$lastTime=$time;
			continue;
		}
		$diff=abs( strtotime($timeStart) - strtotime($lastTime) );	
		$diff=round($diff/60/60,1);
		$tot+=$diff;
		$xTot+=1;
		echo $diff . "\t" . epoch2utc($lastTime) . " - " . epoch2utc($timeStart) ."\n";
		$timeStart=$time;
	}

	$lastTime=$time;
}

$xTot-=$startMarkers;
$estTot=($tot+$singleTot+$xTot);
echo "-----\n";
echo $startMarkers . "\tExplicit 'start working' markers\n";
echo $pathIncludes . "\tEntries included in count\n";
echo $pathExcludes . "\tEntries excluded in count\n";
echo $tot . "\tRaw Total Hours\n";
echo ($tot+$singleTot) . "\tTotal + Single Entries\n";
echo "$estTot\tEstimated Total (Total + Single + 1hr Extended to Front)\n";
echo '  $'.round($estTot*100)."\n";


