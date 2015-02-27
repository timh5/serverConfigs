#!/usr/bin/perl

#
#	Tim H 6/2007, adapted from someone elses original script found online
#
#	added regex conf file support, so you can condense logs more
#


if ( $#ARGV < 0 ) {
print "Usage: $0 <log file> [config filename] [options] \n";
print "Config file contains a list of regex matches to further condense\n";
print "Example file:\n";
print "-------------\n";
print "/Invalid login .* from/Invalid login *** from/\n";
print "/Error: db failed because .*/Error:db failed because ***/\n";
print "\n";
print "Options\n";
print "-s  Sort by occurrances, instead of alphabetically\n";
print "\n";
exit 0;
} 


$logf=$ARGV[0];
if( $ARGV[1] ){
	if ( substr($ARGV[1],0,1) eq "-"  ){
		$opt=$ARGV[1];
	}else {
		$cfile=$ARGV[1];
	}
}

if( $cfile ){ 
	$cregex0=`cat $ARGV[1]`; 
	@cregex=split(/\n/,$cregex0);
}

@logf=( `cat $logf` ); 					# read log f into an array
print "----- START LOG: $ARGV[0] -----\n";

foreach $line ( @logf ) {				
	$line=~s/\d+/#/g; 						# change digits to # signs 
		if(@cregex){	
		foreach $cre (@cregex) {
			$cc=substr($cre,0,1);
			if ( $cc eq "#" ) {
				next;
			}
			@cre=split(/$cc/, $cre);
			$line=~ s/@cre[1]/@cre[2]/i;
		}
	}
	$count{$line}++;	 					# count repeats 
}

#We then sort the array, copying it into a new array.

@alpha=sort @logf; # sort the errors

#In the next phase, we remove duplicates from the sorted array by copying it to yet another array and using a grep command.

$prev = 'null'; # remove duplicates
@uniq = grep($_ ne $prev && ($prev = $_), @alpha);

#$uniqs=[];
#$uc=0;
#foreach $line (@uniq){	
#	$uniqs[$uc]=[$count{$line}, $line];
#	$uc++;
#}

#$uniqs2 = sort @uniqs;


#In the last phase, we print the count associated with each pattern and then the line itself.

$lc=0;
foreach $line (@uniq) { # uniq lines w counts
	print "$count{$line}: "; print "$line"; 
	$lc++;
}

$lorig=`cat $ARGV[0] | wc -l | awk '{print $1}'`;
chomp $lorig;
$ldif=((1-$lc/$lorig)*100);
$ldif=substr($ldif,0,2);

print "----- END LOG: $ARGV[0] -----\n";
print "Lines condensed $lorig to $lc lines. ($ldif%)  \n";
print "\n";

#The final output looks like this:

#24: Nov # #:#:# boson cvs[#]: login failure (for
#/cvsroot) 2: Nov # #:#:# boson cvs[#]: login refused for #/cvsroot 1: Nov # #:#:# boson last message repeated # time 12: Nov # #:#:# boson su: 'su root' failed for demian on /dev/pts/#

#This script uses a number of arrays, but each operation is fairly quick and the entire script with blanks and all is only 24 lines long. My 800,000+ line log file ended up as roughly 24 lines of text. I can peruse that much data before I've consumed my first half cup of coffee each morning.


