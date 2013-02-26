$title  Report parameters

$title Report parameters 

r_kap(r,i) = Y.l(i,r)*PMK.l*vfm("cap",i,r);
r_kap(s,i) = Y.l(i,s)*PF.l("cap",s)*vfm("cap",i,s);

r_nhwkap(r,nhw) = YNHW.l(nhw,r)*PMK.l*vfmnhw("cap",nhw,r);
r_nhwkap(s,nhw) = YNHW.l(nhw,s)*PF.l("cap",s)*vfmnhw("cap",nhw,s);

r_labor(rs,i) = Y.l(i,rs)*PF.l("lab",rs)*vfm("lab",i,rs);
r_nhwlabor(rs,nhw) = YNHW.l(nhw,rs)*PF.l("lab",rs)*vfmnhw("lab",nhw,rs);


aya(rs) =  sum(c,PFS.l("cap",c,rs)*vfms("cap",c,rs))
		+  sum(c,PFS.l("lab",c,rs)*vfms("lab",c,rs))
		+ sum(c,PSNHW.l("nuc",rs)*vfmsnhw("nuc",c,rs))
		+ sum(c,PSNHW.l("hyd",rs)*vfmsnhw("hyd",c,rs))
		+ sum(c,PSNHW.l("wind",rs)*vfmsnhw("wind",c,rs))
		+ sum((i,v,c)$vintg(i,rs), PKSUPVS.l(i,c,v,rs)*v_kh(i,c,v,rs))
*           + sum((vbt,v)$vintgbs(vbt,r), bv_k.l(vbt,v,r))
*           + sum((vbt,v)$vintgbs(vbt,r), bvm_k.l(vbt,v,r))
*           + (shale(r))$active("synf-oil",r)
           + sum((pe,c),PS.l("res",c,rs)*vfmresh(pe,c,rs));


*	Government and tax revenue:
*govinc(rs,pb) = govt.l(pb,rs);

*	Government consumption:
govinc(rs) = vom("g",rs)*P.l("g",rs);




*-----------------------------------------------------------------------------------
*	ENERGY STATISTICS

*	Energy production:
e_prd(rs,i)$vom(i,rs) = eprod(i,rs)*(y.l(i,rs)*vom(i,rs) + sum(v, dv_out.l(i,v,rs)))/vom(i,rs);
e_prod(pe,rs,t)=e_prd(rs,pe);

*	Only fossil energy electricity production
e_prd(rs,"ele") = (eprod("ele",rs)*(1-sum(nhw,shrnhw(nhw,"output",rs)))) * (y.l("ele",rs)*vom("ele",rs) 
+ sum(v, dv_out.l("ele",v,rs)))/vom("ele",rs);	



*	Energy demand by industrial sector by fuel (mtce):
en_neleinput(rs,fe,i)$vafm(fe,i,rs) = (r_enbnele.l(rs,fe,i)+sum(v,ei_v.l(rs,fe,i,v)))*euse(fe,i,rs)/vafm(fe,i,rs);
en_eleinput(rs,i)$vafm("ele",i,rs) = (r_enbnele.l(rs,"ele",i)+sum(v,ei_v.l(rs,"ele",i,v)))*euse("ele",i,rs)/vafm("ele",i,rs);

*	Total sectoral energy demand (mtce):
eeii(rs,i) = sum(fe, en_neleinput(rs,fe,i))+en_eleinput(rs,i);

*	Energy demand by household(mtce):
eeci(rs,e,c)$vafm(e,c,rs)= r_afgc.l(rs,e,c)*euse(e,c,rs)/vafm(e,c,rs);
eecii(rs,c) = sum(e, eeci(rs,e,c));



*	Compute the efficiency of fossil electricity:
ele_eff(rs)$(sum(fe, en_neleinput(rs,fe,"ele"))+en_eleinput(rs,"ele"))
			= e_prd(rs,"ele")/(sum(fe, en_neleinput(rs,fe,"ele"))+en_eleinput(rs,"ele"));


*	NEED DOUBLE-CHECK...	EUR, ROW, CAA are super efficient...
*	ASI 0.356,    ROW 0.755,    CN2 0.413,    EUR 0.655,    APD 0.428,    NAM 0.438,    CAA 0.525



*-----------------------------------------------------------------------------------
*	PRICES

* how to calculate CPI ?
* Sebastian does :
cpi1 = sum(rs$rnum(rs),P.l("c",rs));

* Justin :
*cpi1 = sum((c,rs),P.L(c,rs)*vom(c,rs))/sum((c,rs),vom(c,rs));


report_prices1p(rs,"pinv") = P.l("i",rs)/cpi1;	
report_prices1p(rs,"pl") = PF.l("lab",rs)/cpi1;
report_prices1p(r,"pk") = PF.l("cap",r)/cpi1;
report_prices1p(s,"pk") = PMK.l/cpi1;



report_prices2p(rs,"p",i) = P.l(i,rs)/cpi1;
report_prices2p(rs,"pa",i) = PA.l(i,rs)/cpi1;
report_prices2p(rs,"pgov","g") = P.l("g",rs)/cpi1;
report_prices2p(rs,"pcons",c) = P.l(c,rs)/cpi1;
report_prices2p(rs,"pw",c) = PW.l(c,rs)/cpi1;

*	WHAT IS THIS....???
report_prices3p(rs,"pa_carb",fe,i)$(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe)) 
= (PA.l(fe,rs)*vafm(fe,i,rs)/(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe))
+ PTCARB.l$cbtrade(rs)*euse(fe,i,rs)*epslon(fe)/(vafm(fe,i,rs)+euse(fe,i,rs)*epslon(fe)))/cpi1;



report_pghg1(s,"ptcarb") = PTCARB.l$cbtrade(s)/cpi1;




*-----------------------------------------------------------------------------------


*	Consumption:
aca(rs,c) = p.l(c,rs)*vom(c,rs)*y.l(c,rs)/cpi1;
aca_allh(rs) = sum(c,aca(rs,c));

*	Investment:

aia(rs) = p.l("i",rs)*vom("i",rs)*y.l("i",rs)/cpi1;

*       Government:
aga(rs,"g") = p.l("g",rs)*vom("g",rs)*y.l("g",rs)/cpi1;

*display aca,aia,aga;


*	Aggregate net exports:

axa(rs)= sum((i,sr),imports_f.l(i,rs,sr)*P.l(i,rs)*(1+(rtms(i,rs,sr)*(1-rtxs(i,rs,sr))))
	-imports_f.l(i,sr,rs)*P.l(i,sr)*(1+(rtms(i,sr,rs)*(1-rtxs(i,sr,rs)))))+
	sum((i,sr),imports_c.l(i,rs,sr)*P.l(i,rs)*(1+(rtms(i,rs,sr)*(1-rtxs(i,rs,sr))))
	-imports_c.l(i,sr,rs)*P.l(i,sr)*(1+(rtms(i,sr,rs)*(1-rtxs(i,sr,rs)))));


axa(rs) = axa(rs) / cpi1;

*	Why not use vb??? Different from vb...
*       GNP accounting:
agnp(rs) = sum(c,aca(rs,c)) + aia(rs) + aga(rs,"g")+ axa(rs);



*----------------------------------------------------------------------------------- 
*	CONVERT ENERGY OUTPUT INTO HEAT UNITS AND TO CO2 EMISSIONS (CHAIN RULE):

*	Energy consumption (mtce, industrial +residential use):

ee(rs,e) = sum(i$(vafm(e,i,rs) and (not(econv(e,i)))),
	(r_enbnele.l(rs,e,i)+sum(v,ei_v.l(rs,e,i,v)))*euse(e,i,rs)/vafm(e,i,rs))
		+sum(c$vafm(e,c,rs),r_afgc.l(rs,e,c)*euse(e,c,rs)/vafm(e,c,rs));


*sectco2(ener,i,rs)$(not sameas(ener, "ele")) = epslon(ener)*(r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs);
*sectco2(ener, "ele")) = epslon(ener)*(r_enbnele.l(rs,ener,i)+sum(v,ei_v.l(rs,ener,i,v)))*euse(ener,i,rs)/vafm(ener,i,rs);

		

*+sum(c$vafm(ener,c,rs),r_afgc.l(rs,ener,c)*euse(ener,c,rs)/vafm(ener,c,rs));


*NB: Fix this for dynamic model to correctly account for CRU emissions in electricity for GTAP regions. 

*	CO2 emissions --- EXCLUDING emissions from backstops:
*	DOUBLE COUNTING??? Therefore, Da added set econv to exclude energy use in conversion process (Sep 22, 2012)
co2f(rs,e) = epslon(e)* ee(rs,e) ;
totco2(rs) = sum(e,co2f(rs,e));


*	Sectoral CO2 emissions (million metric tons):
ceei(rs,e,i)$vafm(e,i,rs) = (r_enbnele.l(rs,e,i)+sum(v,ei_v.l(rs,e,i,v)))*euse(e,i,rs)/vafm(e,i,rs);

*	CO2 from private consumption (million metric tons):
ceeci(rs,e) = sum(c$vafm(e,c,rs),r_afgc.l(rs,e,c)*euse(e,c,rs)/vafm(e,c,rs));

*	Total sectoral CO2 emissions (million metric tons):
sectem(rs,i) = sum(e, epslon(e)*ceei(rs,e,i));

*	Total emissions from private consumption (million metric tons):
houem(rs) = sum(e, epslon(e)*ceeci(rs,e)); 


*	Electricity generation by fossil fuel:
eleccoal(rs) = (e_prd(rs,"ele")* en_neleinput(rs,"col","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);
elecgas(rs) = (e_prd(rs,"ele")*en_neleinput(rs,"gas","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);
elecoil(rs) = (e_prd(rs,"ele")*en_neleinput(rs,"oil","ele")
		/(en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele"))
		)$((en_neleinput(rs,"col","ele")+en_neleinput(rs,"gas","ele")+en_neleinput(rs,"oil","ele")) gt 0);


*	Electricity generation from nuclear and hydro:
*ele_nh(rs,nh) = YNH.l(nh,rs)$vomnh(nh,rs)*P.l("ele",rs)*vomnh(nh,rs)/vomnh(nh,rs) * shrnh(nh,"output",rs)*eprod("ele",rs);
ele_nhw(rs,nhw) = YNHW.l(nhw,rs)$vomnhw(nhw,rs) * shrnhw(nhw,"output",rs)*eprod("ele",rs);



*----------------------------------------------------------------------------------- 
*	Welfare:
welfare_indx(rs,c,"w") = w.l(c,rs);
welfare_indx(rs,c,"cons") = r_consh.l(rs,c);
welfare_indx(rs,c,"cons+leis") = r_consh.l(rs,c)+r_leish.l(rs,c);

* No data right now for investment by household... !!!
*welfare_indx(rs,c,"inv") = r_invh.l(rs,c);

hhinc_ref(rs,c) = rh.l(c,rs);



*	WHAT IS 1.055???
*	Report electricity generation by fuel:
elec_preg(rs,"coal") = eleccoal(rs);
*1.055;
elec_preg(rs,"gas") = elecgas(rs);
*1.055;
elec_preg(rs,"oil") = elecoil(rs);
*1.055;
elec_preg(rs,"nuclear") = ele_nhw(rs,"nuc");
*1.055;
elec_preg(rs,"hydro") = ele_nhw(rs,"hyd");
*1.055;
elec_preg(rs,"wind") = ele_nhw(rs,"wind");
*elec_preg(s,"renewables")$flagcaexp(s) = r_bs.l(s) * sum(g,euse("ele",g,s)) / sum(g,vafm("ele",g,s));


*	Report primary energy use:
*	Regional enery use:

prim_ener(rs,e) = sum(i,en_neleinput(rs,e,i))+sum(c,eeci(rs,e,c));
*1.055;

**	Refined oil demand excluding energy produced from biofuels (this is biofuels production. need to address trade issues!):
*prim_ener(r,"oil", t) = sum(g, en_neleinput(r,"oil",g,t)) +  sum(h,EECI(r,"oil",h,t)) - bbsoilout("oil", r, t) -bbbigasout("oil",r,t) + energy_htrn(r,t);
*prim_ener(r,"shale", t) = bbsoilout("cru", r, t);

prim_ener(rs,nhw)
*$ele_eff2004(rs) 
= ele_nhw(rs,nhw);
*/ele_eff2004(rs)*1.055;

*prim_ener(r,"sol_wind", t)$ele_pe(r,t) = BBWOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"WINDBIO", t)$ele_pe(r,t) = BBWBIOOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"WINDGAS", t)$ele_pe(r,t) = BBWGASOUT("ele",R,T)/ele_pe(r,t);
*prim_ener(r,"bio-oil", t)$ele_pe(r,t) = BBBIOELEOUT("ele",R,T)/ele_pe(r,t) + bio_imq(r,t) + bio_dq(r,t);

display prim_ener;

$ontext
*wchange(g,rs) = 100*(w.l(g,rs)-1);
wchange(c,rs)$windex(c,rs) = 100*(w.l(c,rs)/windex(c,rs)-1);

wchange_chn("1") = sum((c,r),  (vom(c,s)+b_leis(c,s))/(sum((c.local,r.local), vom(c,r)+b_leis(c,r))) * wchange(c,r));
wchange_chn("2") = sum((c,r),  (pop2007(r,c))/(sum((c.local,r.local), pop2007(r,c))) * wchange(c,r));
wchange_tot = sum((c,rs),  (vom(c,rs)+b_leis(c,rs))/(sum((c.local,rs.local), vom(c,rs)+b_leis(c,rs))) * wchange(c,rs));
$offtext



* ---------------------------------------------------------------------------------------
* new reporting

* reminder : everything CO2 related must be re-multiplied by "carbscale"

bmkco2(i,g,rs) = bmkco2(i,g,rs) ;
refco2(rs) = refco2(rs);


$ontext
* ------------ INDIRECT CARBON INTENSITY CALCULATION -------


*make A(to,from) matrix containing share of j going to i 
Amatrix(i,j,rs)$vom(j,rs) = vdfm(i,j,rs)/vom(j,rs);
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
* FOR US, NOT TAKING IN ACCOUNT VIFM(DTRD) TO DO!!!

loop(rs,
* create (I-A) matrix which will be inverted
IA(i,i)$vom(i,rs) = (1-Amatrix(i,i,rs)); 
IA(i,j)$(vom(i,rs) and not sameas(i,j))= -Amatrix(i,j,rs);

* now invert this matrix:

execute_unload 'gdxforinverse.gdx' i,IA;
execute 'invert gdxforinverse.gdx i IA gdxfrominverse.gdx IAinverse';
execute_load 'gdxfrominverse.gdx' , IAinverse;
IAinverted(i,j,rs) = IAinverse(i,j);
);


co2intdir(i,rs)$vom(i,rs) = sum(fe,bmkco2(fe,i,rs)) /(vom(i,rs));


* calculate INDIRECT carbon intensity : including co2 to all intermediates (need to produce one unit of final demand or export)
* = e * (I-A)-1
co2int(j,rs) = sum(i, co2intdir(i,rs)*iainverted(i,j,rs));


*----------------------------------------------------

* some reporting sets

ncc(rs) = yes;
ncc(rs)$cc(rs) = no;
ccint(cc) =yes;
ccint(s) =no;
nccint(ncc) =yes;
nccint(s) =no;
regions(rs) = yes;
regions("us") = yes;
regions("cc") = yes;
regions("ncc") = yes;
regions("int") = yes;
regions("ccint") = yes;
regions("nccint") = yes;
i_(i) = yes;
i_("all") = yes;
i_("cru") = no;


*adjust vafm to add vintaged stuff :
vafm_.L(j,i,rs) =  vafm_.L(j,i,rs) + sum(v, ei_v.l(rs,j,i,v));	

pnum = cpi1;


byreg("Pcarb","scn",rs) = 1000/carbscale*Pcarb.L(rs)/pnum;

* this should include only one element :
byreg("wchange","scn",rs) = sum(c, wchange(c,rs));
byreg("wchange","scn","us1") = wchange_us("1");
byreg("wchange","scn","us2") = wchange_us("2");


byreg("emit","bmk",rs) = refco2(rs);
byreg("emit","bmk",rs)$byreg_("emit","scn",rs) = byreg_("emit","scn",rs);
byreg("emit","scn",rs) = sum((fe,g)$vafm(fe,g,rs),bmkco2(fe,g,rs) * vafm_.L(fe,g,rs)/vafm(fe,g,rs));
byreg("emit", "%chg",rs) = 100 * (byreg("emit","scn",rs) / byreg("emit","bmk",rs) -1);


byreg("emit","bmk","us") = sum(s, refco2(s));
byreg("emit","bmk","us") = sum(s, byreg("emit","bmk",s));
byreg("emit","scn","us") = sum(s, sum((fe,g)$vafm(fe,g,s),bmkco2(fe,g,s) * vafm_.L(fe,g,s)/vafm(fe,g,s)));
byreg("emit","%chg","us") = 100 * (byreg("emit","scn","us") / byreg("emit","bmk","us") -1);


* why are these not the same ?
*byreg("emit - test vafm_",rs) = sum((fe,g)$vafm(fe,g,rs), vafm_.L(fe,g,rs));
*byreg("emit - test vafm",rs) = sum((fe,g)$vafm(fe,g,rs), vafm(fe,g,rs));

*bilat("vafm diff",fe,g,rs) = vafm(fe,g,rs) - vafm_.L(fe,g,rs);

*byreg("emit",rs) = totco2(rs);

scns("bmk") = yes;
scns("scn") = yes;

byregsectelem("output") = yes;
byregsectelem("imports") = yes;
byregsectelem("exports") = yes;
byregsectelem("int imports") = yes;
byregsectelem("int exports") = yes;
byregsectelem("us imports") = yes;
byregsectelem("us exports") = yes;


byregsect("output","bmk",i,rs) = vom(i,rs);
byregsect("output","bmk",i,rs)$byregsect_("output","scn",i,rs) = byregsect_("output","scn",i,rs);
byregsect("output","scn",i,rs) = Y.L(i,rs) * vom(i,rs) + sum(v,dv_out.l(i,v,rs));
*byregsect("output","scn",i,rs) = Y.L(i,rs) * vom(i,rs);



* for electricity, need to add nuclear and hydro :
byregsect("output","bmk","ele",rs) = vom("ele",rs) + sum(nh, vomnh(nh,rs));
byregsect("output","bmk","ele",rs)$byregsect_("output","scn","ele",rs) = byregsect_("output","scn","ele",rs);
byregsect("output","scn","ele",rs) = Y.L("ele",rs) * vom("ele",rs) + sum(v, dv_out.l("ele",v,rs))+ sum(nh, YNH.L(nh,rs) * vomnh(nh,rs)); 
*byregsect("output","scn","ele",rs) = Y.L("ele",rs) * vom("ele",rs) +  sum(nh, YNH.L(nh,rs) * vomnh(nh,rs)); 


byregsect("imports","bmk",i,rs) = sum(rsrs, vxmd(i,rsrs,rs));
byregsect("imports","bmk",i,rs)$byregsect_("imports","scn",i,rs) = byregsect_("imports","scn",i,rs);
byregsect("exports","bmk",i,rs) = sum(rsrs, vxmd(i,rs,rsrs));
byregsect("exports","bmk",i,rs)$byregsect_("exports","scn",i,rs) = byregsect_("exports","scn",i,rs);

byregsect("imports","scn",i,rs) = sum(r, imports_f.L(i,r,rs)) + sum(s, imports_c.L(i,s,rs));
byregsect("exports","scn",i,r) = sum(rs, imports_f.L(i,r,rs));
byregsect("exports","scn",i,s) = sum(rs, imports_c.L(i,s,rs));


byregsect("int imports","bmk",i,rs) = sum(r, vxmd(i,r,rs));
byregsect("int imports","bmk",i,rs)$byregsect_("int imports","scn",i,rs) = byregsect_("int imports","scn",i,rs);
byregsect("int exports","bmk",i,rs) = sum(r, vxmd(i,rs,r));
byregsect("int exports","bmk",i,rs)$byregsect_("int exports","scn",i,rs) = byregsect_("int exports","scn",i,rs);

byregsect("int imports","scn",i,rs) = sum(r, imports_f.L(i,r,rs)) ;
byregsect("int exports","scn",i,r) = sum(rr, imports_f.L(i,r,rr)) ;
byregsect("int exports","scn",i,s) = sum(r, imports_c.L(i,s,r)) ;

*byregsect("int exports","scn",i,s) = sum(rs, imports_f.L(i,s,rs)) ;


byregsect("us imports","bmk",i,rs) = sum(s, vxmd(i,s,rs));
byregsect("us imports","bmk",i,rs)$byregsect_("us imports","scn",i,rs) = byregsect_("us imports","scn",i,rs);
byregsect("us exports","bmk",i,rs) = sum(s, vxmd(i,rs,s));
byregsect("us exports","bmk",i,rs)$byregsect_("us exports","scn",i,rs) = byregsect_("us exports","scn",i,rs);

byregsect("us imports","scn",i,rs) = sum(s, imports_c.L(i,s,rs)) ;
*byregsect("us exports","scn",i,r) = sum(rs, imports_c.L(i,r,s)) ;
byregsect("us exports","scn",i,r) = sum(s, imports_f.L(i,r,s)) ;
byregsect("us exports","scn",i,s) = sum(ss, imports_c.L(i,s,ss)) ;


*%chges :
byregsect(byregsectelem,"%chg",i,rs)$byregsect(byregsectelem,"bmk",i,rs) = 100*( byregsect(byregsectelem,"scn",i,rs) / byregsect(byregsectelem,"bmk",i,rs) -1); ;
byregsect(byregsectelem,"diff",i,rs)=  byregsect(byregsectelem,"scn",i,rs) - byregsect(byregsectelem,"bmk",i,rs) ; ;


byregsect("intl trade intensity","bmk", i,s)$(vom(i,s) +sum(r,vxmd(i,s,r))) = (sum(r,vxmd(i,r,s))+sum(r,vxmd(i,s,r)))/(vom(i,s)+sum(r,vxmd(i,r,s)));
byregsect("intl trade intensity","bmk", i,s)$byregsect_("intl trade intensity","scn", i,s) = byregsect_("intl trade intensity","scn", i,s);

byregsect("emit","bmk",g,rs) = sum((fe)$vafm(fe,g,rs), bmkco2(fe,g,rs) );
byregsect("emit","bmk",g,rs)$byregsect_("emit","scn",g,rs) = byregsect_("emit","scn",g,rs);
byregsect("emit","scn",g,rs) = sum((fe)$vafm(fe,g,rs), bmkco2(fe,g,rs) * vafm_.L(fe,g,rs)/vafm(fe,g,rs));


* competitiveness :
byregsect("competitiveness int","%chg",i,s)  = 100* (PM.L(i,s)/P.L(i,s) -1);
byregsect("competitiveness int","%chg",i,"all")  =  100* ( ( SUM(s, PM.L(i,s)* sum(r, vxmd(i,r,s))) / sum((s,r),vxmd(i,r,s)))
 	/ (sum(s, P.L(i,s)*vom(i,s)) / sum(s, vom(i,s))) -1);

byregsect("competitiveness dom","%chg",i,s)  = 100* (PMUSA.L(i,s)/P.L(i,s) -1);
byregsect("competitiveness dom","%chg",i,"all")  =  100* ( ( SUM(s, PMUSA.L(i,s)* sum(ss, vxmd(i,ss,s))) / sum((s,ss),vxmd(i,ss,s)))
			/ (sum(s, P.L(i,s)*vom(i,s)) / sum(s, vom(i,s))) -1);

* prices :
byregsect("PM","scn",i,rs)$vim(i,rs,"ftrd") = PM.L(i,rs)/pnum;
byregsect("P","scn",g,rs)$vom(g,rs) =  P.L(g,rs)/pnum;

* leakage rates:
*byreg("leakage","scn",rs)$(not cc(rs) and card(cc)) = 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
*		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));
* with EU in baseline:
byreg("leakage","scn",rs)$((not cc(rs) and card(cc))$(sum(cc(rsrs)
			$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs))))
		= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));


* for EU alone:
byreg("leakage","scn",rs)$(not byreg_("emit","scn",rs) and (not cc(rs)))
		= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs));


byreg("leakage","scn","all")$card(cc) = sum(rs,byreg("leakage","scn",rs));
byreg("leakage","scn","int")$card(cc) = sum(r,byreg("leakage","scn",r));
byreg("leakage","scn","us")$card(cc) = sum(s,byreg("leakage","scn",s));


*byreg("leakage_db","scn",rs)$(not cc(rs) and card(cc)) = 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
*		sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
*			- emisreduc("CA",t)*byreg("emit","bmk",rsrs)$(sameas(rsrs,"ca"))  );
* with EU in baseline:
byreg("leakage_db","scn",rs)$((not cc(rs) and card(cc))$(sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca")))) )

			= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		
			sum(cc(rsrs)$(not sameas(rsrs,"eur")), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca"))  );

* for EU alone:
byreg("leakage_db","scn",rs)$((not byreg_("emit","scn",rs))$(not cc(rs) and card(cc))$(sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*byreg("emit","bmk",rsrs)$(sameas(rsrs,"ca")))) )

			= 100 * (byreg("emit","scn",rs) - byreg("emit","bmk",rs)) /
		
			sum(cc(rsrs), byreg("emit","bmk",rsrs) - byreg("emit","scn",rsrs)$(not sameas(rsrs,"ca")) 
			- emisreduc("CA",t)*refco2(rsrs)$(sameas(rsrs,"ca"))  );


byreg("leakage_db","scn","all")$card(cc) = sum(rs,byreg("leakage_db","scn",rs));
byreg("leakage_db","scn","int")$card(cc) = sum(r,byreg("leakage_db","scn",r));
byreg("leakage_db","scn","us")$card(cc) = sum(s,byreg("leakage_db","scn",s));


* TRADE FLOWS :

* IGNORE TRADE OF CRUDE OIL FOR NOW !
bilatelem("exports")=yes;
bilatelem("imports")=yes;
bilatelem("exports - embco2")=yes;
bilatelem("imports - embco2")=yes;


* to, from :
bilat("imports","bmk",i,rs,rsrs) = vxmd(i,rsrs,rs);
bilat("imports","bmk",i,rs,rsrs)$bilat_("imports","scn",i,rs,rsrs) = bilat_("imports","scn",i,rs,rsrs);
bilat("imports - embco2","bmk",i,rs,rsrs) = co2int(i,rsrs) * vxmd(i,rsrs,rs);

* exports : from, to:
bilat("exports","bmk",i,rs,rsrs) = vxmd(i,rs,rsrs);
bilat("exports","bmk",i,rs,rsrs)$bilat_("exports","scn",i,rs,rsrs) = bilat_("exports","scn",i,rs,rsrs);
bilat("exports - embco2","bmk",i,rs,rsrs) = co2int(i,rs) * vxmd(i,rs,rsrs);

* scenario :
* imports to, from :
bilat("imports","scn",i,rs,r) = imports_f.L(i,r,rs);
bilat("imports","scn",i,rs,s) = imports_c.L(i,s,rs);

bilat("imports - embco2","scn",i,rs,r) = co2int(i,r) * imports_f.L(i,r,rs) ;
bilat("imports - embco2","scn",i,rs,s) = co2int(i,s) * imports_c.L(i,s,rs) ;


* exports : from, to:
bilat("exports","scn",i,r,rs) = imports_f.L(i,r,rs) ;
bilat("exports","scn",i,s,rs) = imports_c.L(i,s,rs) ;

bilat("exports - embco2","scn",i,r,rs) = co2int(i,r) * imports_f.L(i,r,rs) ;
bilat("exports - embco2","scn",i,s,rs) = co2int(i,s) * imports_c.L(i,s,rs) ;


bilat(bilatelem,scns,i,rs,"US") = sum(s,bilat(bilatelem,scns,i,rs,s));
bilat(bilatelem,scns,i,rs,"CC") = sum(cc,bilat(bilatelem,scns,i,rs,cc));
bilat(bilatelem,scns,i,rs,"NCC") = sum(ncc,bilat(bilatelem,scns,i,rs,ncc));
bilat(bilatelem,scns,i,rs,"INT") = sum(r,bilat(bilatelem,scns,i,rs,r));
bilat(bilatelem,scns,i,rs,"CCINT") = sum(ccint,bilat(bilatelem,scns,i,rs,ccint));
bilat(bilatelem,scns,i,rs,"NCCINT") = sum(nccint,bilat(bilatelem,scns,i,rs,nccint));
bilat(bilatelem,scns,"all",rs,regions) = sum(i_, bilat(bilatelem,scns,i_,rs,regions));

* % changes
bilat(bilatelem,"%chg",i_,rs,regions)$bilat(bilatelem,"bmk",i_,rs,regions) = 100 * (bilat(bilatelem,"scn",i_,rs,regions) / bilat(bilatelem,"bmk",i_,rs,regions) - 1);

bilat(bilatelem,"diff",i_,rs,regions) =  bilat(bilatelem,"scn",i_,rs,regions) - bilat(bilatelem,"bmk",i_,rs,regions);


* TERMS OF TRADE 

*parameter Pnet price net of carbon permit;

pnet(g,rs)$vom(g,rs) = (P.L(g,rs)*vom(g,rs) -pcarb.L(rs) * sum(fe, bmkco2(fe,g,rs))) / vom(g,rs);

*parameter pctPcarb percent of price which is not pcarb;
pctPcarb(g,rs)$p.L(g,rs) = 100 * (pnet(g,rs) / p.L(g,rs));

display pnet, pctPcarb;

* BEWARE : DONT WANT TO CAPTURE CRUDE HERE !
* DONT UNDERSTAND WHY CRUDE IS COUNTED..

byregsect("tot - int","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (P.L(i,s)/pnum-1)) - sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - int","scn","cru",s) =  (pcru.L/pnum-1) * sum(r,  vxmd("cru",s,r) -  vxmd("cru",r,s));  


byregsect("int (pnet)","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (Pnet(i,s)/pnum-1)) - sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
* ADD CRUDE!

byregsect("tot - int - imports","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,r,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - int - imports","scn","cru",s) = (pcru.L/pnum-1) * sum(r, vxmd("cru",r,s));  

byregsect("tot - int - exports","scn",i,s)$(not sameas("cru",i)) = sum(r, vxmd(i,s,r) * (P.L(i,s)/pnum-1)) ;
byregsect("tot - int - exports","scn","cru",s) = (pcru.L/pnum-1) * sum(r, vxmd("cru",S,R));  

byregsect("tot - cc","scn",i,s)$(not sameas("cru",i))  = sum(cc, vxmd(i,s,cc) * (P.L(i,s)/pnum-1)) - sum(cc, vxmd(i,cc,s) * (PM.L(i,s)/pnum-1));
byregsect("tot - ncc","scn",i,s)$(not sameas("cru",i)) = sum(rsrs.local$ncc(rsrs), vxmd(i,s,rsrs) * (P.L(i,s)/pnum-1)) - sum(rsrs.local$ncc(rsrs), vxmd(i,rsrs,s) * (PM.L(i,s)/pnum-1));

byregsect("tot - dom","scn",i,s)$(not sameas("cru",i)) = sum(ss, vxmd(i,s,ss) * (P.L(i,s)/pnum-1)) - sum(ss, vxmd(i,ss,s) * (PMUSA.L(i,s)/pnum-1));
*tot("dom cc",i,s) = sum(cc, vxmd(i,s,cc) * (P.L(i,s)-1)) - sum(cc, vxmd(i,cc,s) * (PM.L(i,s)-1));
*tot("dom ncc",i,s) = sum(ncc, vxmd(i,s,ncc) * (P.L(i,s)-1)) - sum(ncc, vxmd(i,ncc,s) * (PM.L(i,s)-1));


byreg("tot - int",scns,s) = sum(i, byregsect("tot - int",scns,i,s));
byreg("tot - int - imports",scns,s) = sum(i, byregsect("tot - int - imports",scns,i,s));
byreg("tot - int - exports",scns,s) = sum(i, byregsect("tot - int - exports",scns,i,s));
     
     
byreg("tot - int (pnet)",scns,s) = sum(i, byregsect("tot - int (pnet)",scns,i,s));
     
     
byreg("tot - dom",scns,s) = sum(i, byregsect("tot - dom",scns,i,s));
byreg("tot - cc",scns,s) = sum(i, byregsect("tot - cc",scns,i,s));
byreg("tot - ncc",scns,s) = sum(i, byregsect("tot - ncc",scns,i,s));


$offtext



*report


marginals("y",g,rs) = y.m(g,rs)$(abs(y.m(g,rs)) gt 1e-4);
marginal3("a",i,g,rs) = a.m(i,rs)$(abs(a.m(i,rs)) gt 1e-4);
marginal3("at",i,g,rs) = at.m(i,g,rs)$(abs(at.m(i,g,rs)) gt 1e-4);
marginal3("m",i,rs,trade) = m.m(i,rs,trade)$(abs(m.m(i,rs,trade)) gt 1e-4);
marginal2("yt",i) = yt.m(i)$(abs(yt.m(i)) gt 5e-5);
marginals("ynhw",nhw,rs) = ynhw.m(nhw,rs)$(abs(ynhw.m(nhw,rs)) gt 1e-4);
marginals("w",c,rs) = w.m(c,rs)$(abs(w.m(c,rs)) gt 1e-4);
marginal3("dv",i,v,rs) = dv.m(i,v,rs)$(abs(dv.m(i,v,rs)) gt 1e-4);
marginals("p",g,rs) = p.m(g,rs)$(abs(p.m(g,rs)) gt 5e-5);
marginals("pa",i,rs) = pa.m(i,rs)$(abs(pa.m(i,rs)) gt 1e-4);
marginal3("pat",i,g,rs) = pat.m(i,g,rs)$(abs(pat.m(i,g,rs)) gt 1e-4);
marginal3("pm",i,rs,trade) = pm.m(i,rs,trade)$(abs(pm.m(i,rs,trade)) gt 1e-4);
marginals("pf",f,rs) = pf.m(f,rs)$(abs(pf.m(f,rs)) gt 5e-5);
marginal2("pt",i) = pt.m(i)$(abs(pt.m(i)) gt 5e-5);
marginals("pw",c,rs) = pw.m(c,rs)$(abs(pw.m(c,rs)) gt 1e-4);


*$exit
*report



report("CO2emis",t,rs,"bmk") = sum((fe,g),bmkco2(fe,g,rs));
report("CO2emis",t,"CHN","bmk") = sum(r,report("CO2emis",t,r,"bmk"));
report("Intensity",t,rs,"bmk") = bmkint(rs);
report("Intensity",t,"CHN","bmk") = bmkint("CHN");


*	CARBON INTENSITY
report("Intensity",t,rs,"pol") = sum((fe,g)$(vafm(fe,g,rs)>1e-8),AT.l(fe,g,rs)*bmkco2(fe,g,rs))/
(Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("c",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("Intensity",t,"CHN","pol") = sum((rs,i,g)$(fe(i)$province(rs)), AT.l(i,g,rs)*bmkco2(i,g,rs))  /
sum(rs$province(rs),Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("c",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("Intensity",t,rs,"pol%") = 100*(report("Intensity",t,rs,"pol")/report("Intensity",t,rs,"bmk")-1);
report("Intensity",t,"CHN","pol%") = 100*(report("Intensity",t,"chn","pol")/report("Intensity",t,"chn","bmk")-1);


*	CO2 EMISSION
report("CO2emis",t,rs,"pol") = sum((fe,g)$(vafm(fe,g,rs)>1e-8),AT.l(fe,g,rs)*bmkco2(fe,g,rs));
report("CO2emis",t,"CHN","pol") = sum(r,report("CO2emis",t,r,"pol"));
report("CO2emis",t,rs,"pol%") = 100*(report("CO2emis",t,rs,"pol")/report("CO2emis",t,rs,"bmk")-1);
report("CO2emis",t,"CHN","pol%") = 100*(report("CO2emis",t,"chn","pol")/report("CO2emis",t,"chn","bmk")-1);



*	WELFARE CHANGE

report2("Wchange",t,c,rs,"pol%")= 100*(W.l(c,rs)-1);
report2("Wchange",t,c,"CHN","pol%")$(sum(sr$province(sr),vom(c,sr)+thetals*(vfms("lab",c,sr))))
=sum(rs$province(rs),
report2("Wchange",t,c,rs,"pol%")*(vom(c,rs)+thetals*(vfms("lab",c,rs)))
/sum(sr$province(sr),vom(c,sr)+thetals*(vfms("lab",c,sr)))
);

*	GDP
report("GDP",t,rs,"bmk")=vom("c",rs)+vom("g",rs)+vom("i",rs)-vb(rs);
report("GDP",t,rs,"pol")=Y.l("c",rs)*vom("c",rs)*P.l("c",rs)+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)-vb(rs);
report("GDP",t,rs,"pol%")=100*(report("GDP",t,rs,"pol")/report("GDP",t,rs,"bmk")-1);



*	FINAL FOSSIL ENERGY CONSUMPTION BY TYPE BY REGION

egyreport("egycons",t,fe,rs,"bmk")$province(rs)=sum(g,evd(fe,g,rs));
egyreport("egycons",t,"COL",rs,"bmk")$province(rs)
=sum(g$(not sameas(g,"OIL") and (not sameas(g,"GDT"))),evd("COL",g,rs));
egyreport("egycons",t,"GAS",rs,"bmk")$province(rs)
=sum(g$((not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("GAS",g,rs));
egyreport("egycons",t,fe,"CHN","bmk")=sum(rs$province(rs),egyreport("egycons",t,fe,rs,"bmk"));
egyreport("egycons",t,"CRU",rs,"bmk")$province(rs)
=sum(g$((not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("CRU",g,rs));
egyreport("egycons",t,fe,"CHN","bmk")=sum(rs$province(rs),egyreport("egycons",t,fe,rs,"bmk"));


egyreport("egycons",t,fe,rs,"pol")$province(rs)=sum(g,evd(fe,g,rs)*AT.l(fe,g,rs));
egyreport("egycons",t,"COL",rs,"pol")$province(rs)
=sum(g$((vafm("COL",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("COL",g,rs)*AT.l("COL",g,rs));
egyreport("egycons",t,"GAS",rs,"pol")$province(rs)
=sum(g$((vafm("GAS",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("GAS",g,rs)*AT.l("GAS",g,rs));
egyreport("egycons",t,"CRU",rs,"pol")$province(rs)
=sum(g$((vafm("CRU",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("CRU",g,rs)*AT.l("CRU",g,rs));

egyreport("egycons",t,fe,"CHN","pol")=sum(rs$province(rs),egyreport("egycons",t,fe,rs,"pol"));

egyreport("egycons",t,fe,rs,"pol%")$(province(rs) and egyreport("egycons",t,fe,rs,"bmk"))=100*(egyreport("egycons",t,fe,rs,"pol")/egyreport("egycons",t,fe,rs,"bmk")-1);
egyreport("egycons",t,fe,"CHN","pol%")$(egyreport("egycons",t,fe,"CHN","bmk")>1e-8)=100*(egyreport("egycons",t,fe,"CHN","pol")/egyreport("egycons",t,fe,"CHN","bmk")-1);


*	FINAL FOSSIL ENERGY CONSUMPTION BY REGION
report("egycons",t,rs,"bmk")$province(rs)=sum(fe,egyreport("egycons",t,fe,rs,"bmk"));
report("egycons",t,"CHN","bmk")=sum(fe,egyreport("egycons",t,fe,"CHN","bmk"));
report("egycons",t,rs,"pol")$province(rs)=sum(fe,egyreport("egycons",t,fe,rs,"pol"));
report("egycons",t,"CHN","pol")=sum(fe,egyreport("egycons",t,fe,"CHN","pol"));
report("egycons",t,rs,"pol%")$province(rs)=(report("egycons",t,rs,"pol")/report("egycons",t,rs,"bmk")-1)*100;
report("egycons",t,"CHN","pol%")=(report("egycons",t,"CHN","pol")/report("egycons",t,"CHN","bmk")-1)*100;

$exit

*	PRIMARY FOSSIL ENERGY SUPPLY BY TYPE BY REGION
egyreport("egysup",pe,rs,"bmk")$province(rs)=sum(g,evd(pe,g,rs));
egyreport("egysup",pe,"CHN","bmk")=sum(rs$province(rs),egyreport("egysup",pe,rs,"bmk"));
egyreport("egysup",pe,rs,"pol")$province(rs)=sum(g,evd(pe,g,rs)*AT.l(pe,g,rs));
egyreport("egysup",pe,"CHN","pol")=sum(rs$province(rs),egyreport("egysup",pe,rs,"pol"));
egyreport("egysup",pe,rs,"pol%")$(province(rs) and egyreport("egysup",pe,rs,"bmk"))=100*(egyreport("egysup",pe,rs,"pol")/egyreport("egysup",pe,rs,"bmk")-1);
egyreport("egysup",pe,"CHN","pol%")$(egyreport("egysup",pe,"CHN","bmk")>1e-8)=100*(egyreport("egysup",pe,"CHN","pol")/egyreport("egysup",pe,"CHN","bmk")-1);

*	PRIMARY FOSSIL ENERGY SUPPLY BY REGION
report("egysup",rs,"bmk")$province(rs)=sum(pe,egyreport("egysup",pe,rs,"bmk"));
report("egysup","CHN","bmk")=sum(pe,egyreport("egysup",pe,"CHN","bmk"));
report("egysup",rs,"pol")$province(rs)=sum(pe,egyreport("egysup",pe,rs,"pol"));
report("egysup","CHN","pol")=sum(pe,egyreport("egysup",pe,"CHN","pol"));
report("egysup",rs,"pol%")$province(rs)=(report("egysup",rs,"pol")/report("egysup",rs,"bmk")-1)*100;
report("egysup","CHN","pol%")=(report("egysup","CHN","pol")/report("egysup","CHN","bmk")-1)*100;


*	NUC, HYDRO AND WIND PRODUCTION BY TYPE BY REGION
*	Electricity generation efficiency is needed (334g/kwh,http://news.163.com/08/0422/10/4A4JV026000120GU.html)
egyreport("nhwprod",nhw,rs,"bmk")$province(rs)=vomnhw(nhw,rs)*334/123;
egyreport("nhwprod",nhw,"CHN","bmk")=sum(rs$province(rs),egyreport("nhwprod",nhw,rs,"bmk"));
egyreport("nhwprod",nhw,rs,"pol")$province(rs)=vomnhw(nhw,rs)*YNHW.L(nhw,rs)/P.l("ele",rs)*334/123;
egyreport("nhwprod",nhw,"CHN","pol")=sum(rs$province(rs),egyreport("nhwprod",nhw,rs,"pol"));
egyreport("nhwprod",nhw,rs,"pol%")$(province(rs) and (egyreport("nhwprod",nhw,rs,"bmk")>1e-8))
=100*(egyreport("nhwprod",nhw,rs,"pol")/egyreport("nhwprod",nhw,rs,"bmk")-1);
egyreport("nhwprod",nhw,"CHN","pol%")=100*(egyreport("nhwprod",nhw,"CHN","pol")/egyreport("nhwprod",nhw,"CHN","bmk")-1);


*	NUC, HYDRO AND WIND PRODUCTION BY REGION
report("nhwprod",rs,"bmk")$province(rs)=sum(nhw,egyreport("nhwprod",nhw,rs,"bmk"));
report("nhwprod","CHN","bmk")=sum(nhw,egyreport("nhwprod",nhw,"CHN","bmk"));
report("nhwprod",rs,"pol")$province(rs)=sum(nhw,egyreport("nhwprod",nhw,rs,"pol"));
report("nhwprod","CHN","pol")=sum(nhw,egyreport("nhwprod",nhw,"CHN","pol"));
report("nhwprod",rs,"pol%")$(province(rs) and (report("nhwprod",rs,"bmk")>1e-8))=(report("nhwprod",rs,"pol")/report("nhwprod",rs,"bmk")-1)*100;
report("nhwprod","CHN","pol%")=(report("nhwprod","CHN","pol")/report("nhwprod","CHN","bmk")-1)*100;

*	GDP PER CAPITA
report("PGDP",t,rs,"bmk")$province(rs)=(vom("c",rs)+vom("g",rs)+vom("i",rs)-vb(rs))/pop2007(rs,"c");
report("PGDP",rs,"pol")$province(rs)=(Y.l("c",rs)*vom("c",rs)*P.l("c",rs)+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)-vb(rs))
/pop2007(rs,"c");
report("PGDP",rs,"pol%")$province(rs)=100*(report("PGDP",rs,"pol")/report("PGDP",rs,"bmk")-1);



$exit


*	ENERGY INTENSITY
report("EGYIntensity","CHN","bmk")=(report("egycons","CHN","bmk")+report("nhwprod","CHN","bmk"))/
sum(rs$province(rs),gdp("exp",rs));
report("EGYIntensity","CHN","pol") = (report("egycons","CHN","pol")+report("nhwprod","CHN","pol"))  /
sum(rs$province(rs),Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("c",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("EGYIntensity","CHN","pol%")=(report("EGYIntensity","CHN","pol")/report("EGYIntensity","CHN","bmk")-1)*100;


*	CARBON INTENSITY IN ENERGY
report("CIntinEGY","CHN","bmk")=report("CO2emis","CHN","bmk")/(report("egycons","CHN","bmk")+report("nhwprod","CHN","bmk"));
report("CIntinEGY","CHN","pol")=report("CO2emis","CHN","pol")/(report("egycons","CHN","pol")+report("nhwprod","CHN","pol"));
report("CIntinEGY","CHN","pol%")=(report("CIntinEGY","CHN","pol")/report("CIntinEGY","CHN","bmk")-1)*100;



*	CO2 EMISSION BY FUEL TYPE BY SECTOR BY REION

co2rpt("bmk",fe,g,rs)=bmkco2(fe,g,rs);
co2rpt("pol",fe,g,rs)=at.l(fe,g,rs)*bmkco2(fe,g,rs);
co2rpt("pol%",fe,g,rs)$(co2rpt("bmk",fe,g,rs)>1e-8)=(co2rpt("pol",fe,g,rs)/co2rpt("bmk",fe,g,rs)-1)*100;



egyreport2("egycons",fe,g,rs,"bmk")$province(rs)=evd(fe,g,rs);
egyreport2("egycons",fe,g,"CHN","bmk")=sum(rs$province(rs),egyreport2("egycons",fe,g,rs,"bmk"));
egyreport2("egycons",fe,g,rs,"pol")$province(rs)=evd(fe,g,rs)*AT.l(fe,g,rs);
egyreport2("egycons",fe,g,"CHN","pol")=sum(rs$province(rs),egyreport2("egycons",fe,g,rs,"pol"));
egyreport2("egycons",fe,g,rs,"pol%")$(province(rs) and egyreport2("egycons",fe,g,rs,"bmk"))=100*(egyreport2("egycons",fe,g,rs,"pol")/egyreport2("egycons",fe,g,rs,"bmk")-1);
egyreport2("egycons",fe,g,"CHN","pol%")$(egyreport2("egycons",fe,g,"CHN","bmk"))=100*(egyreport2("egycons",fe,g,"CHN","pol")/egyreport2("egycons",fe,g,"CHN","bmk")-1);



execute_unload 'egyint.gdx',%fuel%_intd,%fuel%_inti,%fuel%_totinti,%fuel%_dcons,%fuel%_icons,expshare,optshare,%fuel%_chninti,%fuel%_worldinti;
*execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_intd rng=%fuel%_intd!a2 cdim=0';

$offtext