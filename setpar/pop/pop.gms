$call gdxxrw i=chnpop.xlsx o=chnpop1.gdx par=population_ rng="Estimation!A1:Y31" rdim=1 cdim=1
$call gdxxrw i=chnpop.xlsx o=chnpop2.gdx par=popgrowth_ rng="Growthrate!D1:F31" rdim=1 cdim=1
$call gdxmerge *.gdx