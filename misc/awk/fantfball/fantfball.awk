# Fantasy Football Projections
# Adds up ff points for each player and adds mulipliers for extra
# properties of each, and give totals for each, such as 
# recommended picks, teams repuation, playoff projections, etc
# @author timh@vyew
#
# INPUT file format:
# 1  	2     3		4		5	6		7
# rank	first last	    team	opp	    pts	pos
# 12    Tony Scheffler  DEN     @OAK    6.2 TE

BEGIN {
	IGNORECASE=1;
	playoffTeams="/|SD|BUF|NYG|NYJ|DEN|PIT|BAL|CLE|CIN|TB|FB|SEA|WAS|PHI|IND|dal|/"
	studs="/|peyton_manning|tony_romo|steven_jackson|frank_gore|marshawn_lyn|adrian_peters|brian_westb|marques_colsoton|braylon_edw|reggie_wayne|terrell_ow|antonio_gates|jason_witten|/"
	superSolid="/|drew_brees|derek_anderson|carson_palmer|ben_roeth|matt_hasselbeck|joseph_addai|larry_johnson|clinton_portis|willis_mcgah|maruice_jones|larry_fitz|houshmand|steve_smith|/"
	teamRep="/|GB|NYG|WAS|PIT|SF|STL|DET|ARI|PHI|CLE|CHI|/"

	# multiplier values
	mult["stud"]=1.3;
	mult["solid"]=1.25;
	mult["playoffTeam"]=1.25;
	mult["teamRep"]=1.1;
	posMult["RB"]=1.2;
	posMult["QB"]=1.15;
	posMult["WR"]=1;
	posMult["DEF"]=1.1;
	posMult["TE"]=1.05;
	posMult["K"]=1;
	
}

################## MAIN PRG {{{
{
	player = $2 "_" $3;
	pPoints[player] += $6
	pCount[player] += 1
	pRankTot[player] += $1
	pPos[player] = $7
	pTeam[player] = $4

	# If player in a projected playoff team
	#if( player ~ studs ) mStuds[player] = 1.3
	#if( player ~ superSolid ) mSuperSolid[player] = 1.25
	#if( $4 ~ playoffTeams ) mPlayoffTeam[player] = 1.25
	#if( $4 ~ teamRep ) mTeamRep[player] = 1.1

	# rank by position of importance: RB, QB, WR, DEF, TE, K
	#mPos[player] = posMult[$7];
	
#	print "----------------- " length(pPoints) " -------------------";
#	for (pl in pPoints) {
#		n = n "," pl 
#	}
#	print n;
}
################## }}} MAIN PRG

END {
	for (player in pPoints){
		isST="."; isSS="."; isPT="."; isTR="."; isPOS=".";
		pRankAvr=pRankTot[player] / pCount[player]

		#add multipliers
		pProjPts=pPoints[player];
		if( player ~ studs ){ isST="X"; pProjPts=pProjPts * mult["stud"] }
		if( player ~ superSolid ){ isSS="X"; pProjPts=pProjPts * mult["solid"] }
		if( pTeam[player] ~ playoffTeams ){ isPT="X"; pProjPts=pProjPts * mult["playoffTeam"] }
		if( pTeam[player] ~ teamRep ){ isTR="X"; pProjPts=pProjPts * mult["teamRep"] }
		if( posMult[ pPos[player] ] > 1 ){ isPOS="X"; pProjPts=pProjPts * posMult[ pPos[player] ] }

		#		 rnk  ct  name p tm
		printf( "%2i (%d) %18s %s %3s	%3d %2s %2s %2s %2s %2s %3d \n", 
				pRankAvr, pCount[player], player, pPos[player], pTeam[player] ,
				pPoints[player], isST, isSS, isPT, isTR, isPOS, pProjPts);
	}
    printf( "%2s (%d) %18s %s %3s	%3s %2s %2s %2s %2s %2s %3d %s\n",
            "rk", 0, "player", "Po", "TM",
            "pts", "St", "SS", "PT", "TR", "Po", 999, "Projected Pts" );

}


# to run : awk -f fantfball.awk te.fb | sort -nr -k5
# to concat lines of teams together into one line |delim:
# cat playoff.teams | awk '{x=x $1 "|" ;} END {print "teams: " x}'

