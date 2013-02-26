$title	Aggregation Program for the GTAP8 Database and China data 

$if not set source $set source data
$if not set target $set target allprov
$if not set output $set output %target%

*.$set energydata
$set ds %source%

$if not set nd $set nd 0
$set nd %nd%

scalar nd	Number of decimals /%nd%/;

$include gtap8data 

$include ..\defines\%target%.map



alias (ii,jj), (rsrs,srsr), (ss,ssss);


set	gg(*)	All goods in aggregate model plus C - G - I /c,g,i,hh1,hh2/;
gg(ii) = yes;
abort$sum(ii$(sameas(ii,"c") or sameas(ii,"g") or sameas(ii,"i")),1) "Invalid identifier: C, G and I are reserved.";


parameters
	vom_(*,rsrs)	Aggretate output
	vomnhw_(nhwnhw,rsrs)
	vdfmnhw_(ii,nhwnhw,rsrs)
	vfmnhw_(ff,nhwnhw,rsrs)
	vfm_(ff,jj,rsrs)	Endowments - Firms' purchases at market prices,
	vdfm_(ii,*,rsrs)	Intermediates - firms' domestic purchases at market prices,
	vifm_(ii,*,rsrs,tradetrade)	Intermediates - firms' imports at market prices,
	vxmd_(ii,rsrs,srsr)	Trade - bilateral exports at market prices,
	vst_(ii,rsrs)	Trade - exports for international transportation
	vtwr_(ii,rsrs,srsr)	Trade - Margins for international transportation at world prices,	
	vdtrm_(ii,rsrs)	domestic trade margin,
	vdst_(ii,rsrs)	domestic transport service for trade margin,


	eco2_(ii,*,rsrs)	Volume of carbon emissions,

        evd_(ii,*,rsrs)    usage of domestic product by firms (mtoe)
	evt_(ii,rsrs,srsr)



	rto_(ii,rsrs)	Output (or income) subsidy rates
	rtf_(ff,jj,rsrs)	Primary factor and commodity rates taxes 
	rtfd_(ii,*,rsrs)	Firms domestic tax rates

	rtonhw_(nhwnhw,rsrs)
	rtfnhw_(ff,nhwnhw,rsrs)
	rtfdnhw_(ii,nhwnhw,rsrs)


	rtfi_(ii,*,rsrs)	Firms' import tax rates
	rtxs_(ii,rsrs,srsr)	Export subsidy rates
	rtms_(ii,rsrs,srsr)	Import taxes rates,


	esubd_(ii)	Elasticity of substitution (M versus D),
	esubva_(jj)	Elasticity of substitution between factors
	esubm_(ii)	Intra-import elasticity of substitution,
	etrae_(ff)	Elasticity of transformation,
	eta_(ii,rsrs)	Income elasticity of demand
	epslon_(ii)	Emission factor

	rescons_(rsrs,*,ii)
	population_(rsrs,yryr);
;


alias (i,j), (ii,jj);;
alias (rs,sr);
set mapsr(sr,srsr), mapj(j,jj), mapg(*,*)/c.c, i.i, g.g,hh1.hh1,hh2.hh2/;
mapsr(rs,rsrs) = maprs(rs,rsrs);
mapj(j,jj) = mapi(j,jj);
mapg(i,ii) = mapi(i,ii);

$batinclude aggr vst i rs vst_
$batinclude aggr vtwr i rs sr vtwr_
$batinclude aggr vom g rs vom_
$batinclude aggr vomnhw nhw rs vomnhw_
$batinclude aggr vfm f j rs vfm_
$batinclude aggr vfmnhw f nhw rs vfmnhw_
$batinclude aggr vdfm i g rs vdfm_
$batinclude aggr vdfmnhw i nhw rs vdfmnhw_
$batinclude aggr vifm i g rs trade vifm_
$batinclude aggr vxmd i rs sr vxmd_
$batinclude aggr vdtrm i rs vdtrm_
$batinclude aggr vdst i rs vdst_
$batinclude aggr eco2 i g rs eco2_
$batinclude aggr evd i g rs evd_
$batinclude aggr evt i rs sr evt_
$batinclude aggr rescons rs g i rescons_
$batinclude aggr population rs yr population_


parameters 
	rtonhw(nhw,rs),
	rtfnhw(f,nhw,rs),
	rtfdnhw(i,nhw,rs);



*	First, convert tax rates into tax payments:
rtonhw(nhw,rs)= rto("ele",rs)*vomnhw(nhw,rs);
rto(i,rs) = rto(i,rs)*vom(i,rs);


*rto(i,rs)$(not sameas(i,"ele"))  = rto(i,rs)*vom(i,rs);
*rto("ele",rs)= rto("ele",rs)*(vom("ele",rs);
*+sum(nhw,vomnhw(nhw,rs)));

rtfnhw("lab",nhw,rs)=rtf("lab","ele",rs)*vfmnhw("lab",nhw,rs);
rtfnhw("cap",nhw,rs)=rtf("cap","ele",rs)*vfmnhw("cap",nhw,rs);
rtfnhw("res",nhw,rs)=rtf("cap","ele",rs)*vfmnhw("res",nhw,rs);
rtf(f,j,rs)  = rtf(f,j,rs) * vfm(f,j,rs);


*rtf(f,j,rs)$(not sameas(j,"ele"))  = rtf(f,j,rs) * vfm(f,j,rs);
*rtf("lab","ele",rs)= rtf("lab","ele",rs) * vfm("lab","ele",rs);
*+sum(nhw,rtf("lab","ele",rs)*vfmnhw("lab",nhw,rs));
*rtf("cap","ele",rs)= rtf("cap","ele",rs) * vfm("cap","ele",rs);
*+rtf("cap","ele",rs)*(sum(nhw,vfmnhw("cap",nhw,rs))+sum(nhw,vfmnhw("res",nhw,rs)));
* No rtf for resource in ele!!!

rtfdnhw(i,nhw,rs)=rtfd(i,"ele",rs)*vdfmnhw(i,nhw,rs);
rtfd(i,g,rs) = rtfd(i,g,rs) * vdfm(i,g,rs);


*rtfd(i,g,rs)$(not sameas(g,"ele")) = rtfd(i,g,rs) * vdfm(i,g,rs);
*rtfd(i,"ele",rs)=rtfd(i,"ele",rs)*vdfm(i,"ele",rs)+sum(nhw,rtfd(i,"ele",rs)*vdfmnhw(i,nhw,rs));

rtfi(i,g,rs) = rtfi(i,g,rs) * sum(trade,vifm(i,g,rs,trade));
rtms(i,rs,sr) = rtms(i,rs,sr)*((1-rtxs(i,rs,sr)) * vxmd(i,rs,sr) + vtwr(i,rs,sr));
rtxs(i,rs,sr) = rtxs(i,rs,sr) * vxmd(i,rs,sr);

*	Aggregate:

$batinclude aggr rto i rs  rto_
$batinclude aggr rtf f j rs rtf_
$batinclude aggr rtfd i g rs rtfd_
$batinclude aggr rtonhw nhw rs   rtonhw_
$batinclude aggr rtfnhw f nhw rs rtfnhw_
$batinclude aggr rtfdnhw i nhw rs rtfdnhw_
$batinclude aggr rtfi i g rs rtfi_
$batinclude aggr rtxs i rs sr rtxs_
$batinclude aggr rtms i rs sr rtms_
$batinclude aggr epslon i epslon_

parameter profit;
profit(gg,rsrs) = vom_(gg,rsrs)
		- sum(ii, vdfm_(ii,gg,rsrs) + rtfd_(ii,gg,rsrs))
		- sum(ii, sum(trade,vifm_(ii,gg,rsrs,trade)) + rtfi_(ii,gg,rsrs));



profit(jj,rsrs) = vom_(jj,rsrs) - rto_(jj,rsrs) 
		- sum(ii, vdfm_(ii,jj,rsrs) + rtfd_(ii,jj,rsrs))
		- sum(ii, sum(trade,vifm_(ii,jj,rsrs,trade)) + rtfi_(ii,jj,rsrs))
		- sum(ff, vfm_(ff,jj,rsrs)  + rtf_(ff,jj,rsrs));


profit(nhwnhw,rsrs) = vomnhw_(nhwnhw,rsrs)- rtonhw_(nhwnhw,rsrs) 
		- sum(ii,vdfmnhw_(ii,nhwnhw,rsrs) + rtfdnhw_(ii,nhwnhw,rsrs))
		- sum(ff, vfmnhw_(ff,nhwnhw,rsrs) + rtfnhw_(ff,nhwnhw,rsrs));



profit(gg,rsrs) = round(profit(gg,rsrs),6);
profit(jj,rsrs) = round(profit(jj,rsrs),6);
profit(nhwnhw,rsrs) = round(profit(nhwnhw,rsrs),6);
display profit;


*	Convert back to rates:

rto_(ii,rsrs)$(vom_(ii,rsrs))= rto_(ii,rsrs)/vom_(ii,rsrs);
rtonhw_(nhwnhw,rsrs)$(rtonhw_(nhwnhw,rsrs))= rtonhw_(nhwnhw,rsrs)/vomnhw_(nhwnhw,rsrs);


rtf_(ff,jj,rsrs)$(vfm_(ff,jj,rsrs)) = rtf_(ff,jj,rsrs) / vfm_(ff,jj,rsrs);
rtfnhw_(ff,nhwnhw,rsrs)$(vfmnhw_(ff,nhwnhw,rsrs)) = rtfnhw_(ff,nhwnhw,rsrs) / vfmnhw_(ff,nhwnhw,rsrs);


rtfd_(ii,gg,rsrs)$ (vdfm_(ii,gg,rsrs))= rtfd_(ii,gg,rsrs) / vdfm_(ii,gg,rsrs);
rtfdnhw_(ii,nhwnhw,rsrs)$(vdfmnhw_(ii,nhwnhw,rsrs))= rtfdnhw_(ii,nhwnhw,rsrs) / vdfmnhw_(ii,nhwnhw,rsrs);

rtfi_(ii,gg,rsrs)$ sum(trade,vifm_(ii,gg,rsrs,trade)) = rtfi_(ii,gg,rsrs) / sum(trade,vifm_(ii,gg,rsrs,trade));
rtxs_(ii,rsrs,srsr)$ vxmd_(ii,rsrs,srsr) = rtxs_(ii,rsrs,srsr) / vxmd_(ii,rsrs,srsr);
rtms_(ii,rsrs,srsr)$((1-rtxs_(ii,rsrs,srsr)) * vxmd_(ii,rsrs,srsr) + vtwr_(ii,rsrs,srsr))
	 = rtms_(ii,rsrs,srsr)/((1-rtxs_(ii,rsrs,srsr)) * vxmd_(ii,rsrs,srsr) + vtwr_(ii,rsrs,srsr));


esubd_(ii)$sum(mapi(i,ii), sum((j,rs), vdfm(i,j,rs)+sum(trade,vifm(i,j,rs,trade))))
	= sum(mapi(i,ii), sum((j,rs), vdfm(i,j,rs)+sum(trade,vifm(i,j,rs,trade)))*esubd(i)) /
	     sum(mapi(i,ii), sum((j,rs), vdfm(i,j,rs)+sum(trade,vifm(i,j,rs,trade))));

esubva_(jj)$sum(mapi(j,jj), sum((f,rs), vfm(f,j,rs)))
	= sum(mapi(j,jj), sum((f,rs), vfm(f,j,rs)*esubva(j))) /
	      sum(mapi(j,jj), sum((f,rs), vfm(f,j,rs)));

esubm_(ii)$sum((rs,mapi(i,ii)), sum(trade,vim(i,rs,trade))) 
	= sum((rs,mapi(i,ii)), sum(trade,vim(i,rs,trade))*esubm(i)) / sum((rs,mapi(i,ii)), sum(trade,vim(i,rs,trade)));


parameter	vp(i,rs)	Value of private expenditure;
vp(i,rs) = vdfm(i,"c",rs)*(1+rtfd0(i,"c",rs)) + sum(trade,vifm(i,"c",rs,trade))*(1+rtfi0(i,"c",rs));

eta_(ii,rsrs)$sum((maprs(rs,rsrs),mapi(i,ii)),vp(i,rs))
	= sum((maprs(rs,rsrs),mapi(i,ii)),vp(i,rs)*eta(i,rs)) /
	  sum((maprs(rs,rsrs),mapi(i,ii)),vp(i,rs));




execute_unload '%datadir%%output%.gdx', 
	r_=r,s_=s,rs_=rs,c,h,e,pe,trade,nhw,
	gg=g, ff=f, ii=i, 
	vfm_=vfm, vfmnhw_=vfmnhw,vdfm_=vdfm, vdfmnhw_=vdfmnhw,vifm_=vifm,vxmd_=vxmd, vst_=vst, vtwr_=vtwr, vdtrm_=vdtrm, vdst_=vdst,vom_=vom,vomnhw_=vomnhw,
	rto_=rto, rtf_=rtf, rtfd_=rtfd, rtonhw_=rtonhw, rtfnhw_=rtfnhw, rtfdnhw_=rtfdnhw, 
	rtfi_=rtfi, rtxs_=rtxs, rtms_=rtms, 
	eco2_=eco2, evd_=evd, evt_=evt,
	rescons_=rescons, population_=population,
	esubd_=esubd, esubva_=esubva, esubm_=esubm,  eta_=eta,
	epslon_=epslon;

