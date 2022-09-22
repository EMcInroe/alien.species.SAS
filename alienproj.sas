
proc import datafile='C:\Users\eudoc\Documents\Statistics\Stats502\Project\Alien_Species.xlsx'
	dbms=xlsx
	out=alien replace;
	sheet=yosemite;
	getnames=yes;
Run;

Proc print data=alien;
run;

ods graphics on / attrpriority=none;

title "Scatterplot of Elevation vs Species Richness by Site Type";

proc sgplot data = alien noautolegend;
	styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=log_elevation y=Alien_Species_Richness / group=Site_Type;
   keylegend / location=inside position=NE across=1;
run;
title;
proc sgplot data = alien noautolegend;
	styleattrs datasymbols=(circlefilled squarefilled starfilled);
   scatter x=Elevation_Category y=Alien_Species_Richness / group=Site_Type;
   keylegend / location=inside position=NE across=1;
   title "Elevation Category vs. Species Richness by Site Type";
run;
title;


proc mixed data=alien method=type3;
class Elevation_Category Site_Type;
model Alien_Species_Richness = Site_Type Elevation_Category Site_Type*Elevation_Category;
store alienout;
run;

ods graphics on;
ods html style=statistical sge=on;
proc plm restore=alienout;
lsmeans Site_Type*Elevation_Category / adjust=tukey plot=meanplot cl lines;
/*Because the 2-factor interaction is significant, we need to work with the treatment combination means*/ 
ods exclude diffs diffplot;
run; title; run;


proc mixed data=alien method=type3;
class Site_Type;
model Alien_Species_Richness = Site_Type log_elevation Site_Type*log_elevation / noint solution;
ods select SolutionF;
title "ANCOVA Species Richness";
run;
