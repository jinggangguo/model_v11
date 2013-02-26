$setlocal inputfolder '..%slash%data'
$setlocal inputfolder2 '..%slash%rawdata'


set
        t      "Time periods" /2007,2010,2015,2020,2025,2030,2035,2040,2045,2050,2055/;
alias (t,ts);

SET yr /1*200/;
alias (yr,l,ll);

set     g(*)    Goods plus C and G;
set     i(g)    Goods
        f(*)    Factors,
	c(g),h(g);
alias   (i,j) , (g,gg);

set     nhw;
alias	(nhw,nhwnhw);

set
        sf(f)   Sluggish primary factors (sector-specific),
        mf(f)   Mobile primary factors;

set     trade(*)        Trade type;
set     ctrade(trade);
set     otrade(trade);

set     rs;
alias   (rs,sr);

set     r(rs)   ;
set     s(rs)   ;
set     rs1(rs) ;

alias   (r,rr);
alias   (s,ss);

set     province(rs);
set     GTAPregions(rs);

set     rnum(rs)        Numeraire region;
set	isc(g);


parameter
        rtxs(i,rs,sr)   "Export subsidy rate"
        rtms(i,rs,sr)   "Import subsidy rate"

        vxmd(i,rs,sr) "Trade - bilateral exports at market prices"
        vtwr(i,rs,sr) "Trade - Margins for international transportation at world prices"
        vst(i,rs),
        vdst(i,rs),
        vtrdm(g,rs)     "Trade margins"

        rtf(f,g,rs)     "Primary factor and commodity rates taxes"
        rtfnhw(f,nhw,rs)
        rtfd(i,g,rs)    "Firms domestic tax rates"
        rtfdnhw(i,nhw,rs)
        rtfi(i,g,rs)    "Firms' import tax rates"

        vfm(f,g,rs)     "Endowments - Firms' purchases at market prices"
        vdfm(i,g,rs)    "Intermediates - firms' domestic purchases at market prices"
        vifm(i,g,rs,trade)      "Intermediates - firms' imports at market prices"
        vdtrm(i,r)      "domestic trade margin"

        vafm(i,g,rs)    "Armington intermediate demand"
        vam(i,rs)       "Total demand for Armington good i"
        vomnhw(nhw,rs)          "Hydro, nuclear and wind data output"
        vdfmnhw(i,nhw,rs)       "Intermediates"
        vfmnhw(f,nhw,rs)        "Factor inputs"
        vom(g,rs)               "Total supply at market prices"

        rto(g,rs)       "Output tax rate"
        rtonhw(nhw,rs)

        esubd(i)        "Elasticity of substitution (M versus D)"
        esubva(g)       "Elasticity of substitution between factors"
        esubm(i)        "Intra-import elasticity of substitution"
        etrae(f)        "Elasticity of transformation"
        eta(i,rs)       "Income elasticity of demand"

        evd(i,g,rs)     "Volume of energy demand (mtoe)"
        evt(i,rs,sr)	"Volume of energy trade (mtoe)"
        eco2(i,g,rs)    "Volume of carbon emissions (Gg)"
	epslon(i)	"Emission factor"

	rescons(rs,g,i)	"Household consumption in China"
	population(rs,yr) "Population"
;


$gdxin '%inputfolder%%slash%%ds%.gdx'
$load g,i,f,c,h,trade,nhw
$load rs,r,s
$load rtxs,rtms
$load vxmd,vtwr,vst
$load rtf,rtfnhw,rtfd,rtfdnhw,rtfi
$load vfm,vdfm,vifm,vdtrm,vdst,vom,vomnhw,vdfmnhw,vfmnhw
$load rto,rtonhw
$load esubd,esubva,esubm,eta,epslon
$load eco2,evd,evt
$load rescons
$load population
$gdxin


display population;


ctrade(trade)=no;
otrade(trade)=no;
ctrade("CNTRD")=yes;
otrade("OTHTRD")=yes;
province(r)=yes;
GTAPregions(s)=yes;
mf(f)=no;
sf(f)=no;
mf("cap")=yes;
mf("lab")=yes;
sf("res")=yes;
isc(g)=no;
isc(c)=yes;


parameter
        rtda(i,rs)     Benchmark domestic value-added tax rate
        rtia(i,rs,trade) Benchmark imports value-added tax rate;
rtda(i,rs)$(sum(g,vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs))) = 
(sum(g,vdfm(i,g,rs)*rtfd(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs)*rtfdnhw(i,nhw,rs)))/(sum(g,vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs)));
rtia(i,rs,trade)$sum(g,vifm(i,g,rs,trade)) = sum(g,vifm(i,g,rs,trade)*rtfi(i,g,rs))/sum(g,vifm(i,g,rs,trade));

parameter       esub(g,rs)      Top-level elasticity (energy versus non-energy),
                esubn(g,rs)     Top-level elasticity (among non-energy goods),
                esubkl(g,rs)    Capital-labor elasticity;

esub(g,rs) = 0.5;
esubn(c,rs) = 1;
esubkl(g,rs) = esubva(g);
esubkl("ele",rs) = 0.5;

parameter       vdm(g,rs)       Aggregate demand for domestic output;

vdm(i,rs) = sum(g, vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs));

parameter 
	shrnhw(nhw,*,rs);
shrnhw(nhw,"output",rs)=vomnhw(nhw,rs)/(vom("ele",rs)+sum(nhw.local,vomnhw(nhw,rs)));


parameter
        pvxmd(i,rs,sr)   "Import price (power of benchmark tariff)"
        pvtwr(i,rs,sr)   "Import price for transport services"
        vtw(i)           "Aggregate international transportation services"
        vim(i,rs,trade)  "Aggregate imports"
	vfms(f,g,rs)	 "Factor endownments by household"
        evom(f,rs,*,*)   "Aggregate factor endowment at market prices"
        vfmsnhw(nhw,g,rs) "Resource endowment for nhw"
        vb(*)            "Current account balance";

pvxmd(i,rs,sr) = (1+rtms(i,rs,sr)) * (1-rtxs(i,rs,sr));
pvtwr(i,rs,sr) = 1+rtms(i,rs,sr);

vtw(i) = sum(rs,vst(i,rs));


vdm(c,rs) = vom(c,rs);
vdm("g",rs) = vom("g",rs);
vdm("i",rs) = vom("i",rs);


vim(i,rs,trade) =  sum(g, vifm(i,g,rs,trade));
vfms(f,"c",rs) = sum(g, vfm(f,g,rs));
vfms(f,"c",rs)$(not sameas(f,"res"))=vfms(f,"c",rs)+sum(nhw,vfmnhw(f,nhw,rs));
vfmsnhw(nhw,"c",rs)=vfmnhw("res",nhw,rs);



vafm(i,g,rs) = vdfm(i,g,rs)*(1+rtfd(i,g,rs)) + sum(trade,vifm(i,g,rs,trade))*(1+rtfi(i,g,rs));
vafm(i,"ele",rs)=vdfm(i,"ele",rs)*(1+rtfd(i,"ele",rs)) + sum(trade,vifm(i,"ele",rs,trade))*(1+rtfi(i,"ele",rs))+sum(nhw,vdfmnhw(i,nhw,rs)*(1+rtfdnhw(i,nhw,rs)));
vam(i,rs) = sum(g,vafm(i,g,rs));

parameter vafm0,vfmsnhw0,vom0, vfms0;

vafm0(i,g,rs) = vafm(i,g,rs);

vfmsnhw0(nhw,c,rs) = vfmsnhw(nhw,c,rs);

vom0(g,rs) = vom(g,rs);

vfms0(mf,c,rs) = vfms(mf,c,rs);




vb(s) = vom("c",s) + vom("g",s) + vom("i",s)
        - sum(f,  vfms(f,"c",s)) - sum(nhw,vfmsnhw(nhw,"c",s))
        - sum(j,  vom(j,s)*rto(j,s))-sum(nhw,vomnhw(nhw,s)*rtonhw(nhw,s))
        - sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))-sum(nhw,sum(i,vdfmnhw(i,nhw,s)*rtfdnhw(i,nhw,s)))
        - sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))-sum(f,sum(nhw,vfmnhw(f,nhw,s)*rtfnhw(f,nhw,s)))
        - sum((i,rs), rtms(i,rs,s) *  (vxmd(i,rs,s) * (1-rtxs(i,rs,s)) + vtwr(i,rs,s)))
        + sum((i,rs), rtxs(i,s,rs) * vxmd(i,s,rs));

vb(r) = vom("c",r) + vom("g",r) + vom("i",r)
        - sum(f, vfms(f,"c",r)) - sum(nhw,vfmsnhw(nhw,"c",r))
        - sum(j,  vom(j,r)*rto(j,r))-sum(nhw,vomnhw(nhw,r)*rtonhw(nhw,r))
        - sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) +(vifm(i,g,r,"CNTRD")+vifm(i,g,r,"OTHTRD"))*rtfi(i,g,r)))-sum(nhw,sum(i,vdfmnhw(i,nhw,r)*rtfdnhw(i,nhw,r)))
        - sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))-sum(f,sum(nhw,vfmnhw(f,nhw,r)*rtfnhw(f,nhw,r)))
        - sum((i,s), rtms(i,s,r) *  (vxmd(i,s,r) * (1-rtxs(i,s,r)) + vtwr(i,s,r)))
        + sum((i,s), rtxs(i,r,s) * vxmd(i,r,s));

vb("chksum") = sum(rs, vb(rs));

display vb;


*$exit

parameter profit;


*profit(g,rs) = vom(g,rs)*(1 - rto(g,rs))
*               - sum(i, vdfm(i,g,rs)*(1+ rtfd(i,g,rs)))
*               - sum(i, sum(trade,vifm(i,g,rs,trade))*(1+rtfi(i,g,rs)))
*               - sum(f, vfm(f,g,rs)*(1+rtf(f,g,rs)));

profit("ele",rs) = vom("ele",rs)*(1 - rto("ele",rs))
                - sum(i, vdfm(i,"ele",rs)*(1+ rtfd(i,"ele",rs)))
                - sum(i, sum(trade,vifm(i,"ele",rs,trade))*(1+rtfi(i,"ele",rs)))
                - sum(f, vfm(f,"ele",rs)*(1+rtf(f,"ele",rs)));


profit(nhw,rs) = vomnhw(nhw,rs)*(1- rtonhw(nhw,rs))
                - sum(i, vdfmnhw(i,nhw,rs) *(1+ rtfdnhw(i,nhw,rs)))
                - sum(f,vfmnhw(f,nhw,rs)*(1+ rtfnhw(f,nhw,rs)));

profit("ele",rs) = round(profit("ele",rs),6);
profit(nhw,rs) = round(profit(nhw,rs),6);
display profit;


*       Define a numeraire region for denominating international
*       transfers:
rnum(rs) = yes$(vom("c",rs)=smax(sr,vom("c",sr)));

display rnum;

$ontext
*       WE FOLLOW BALLARD (2000) TO CALIBRATE COMPENSATED AND UNCOMPENSATED LABOR SUPPLY ELASTICITIES:

*       (NB: Given estimates for the uncompensated and compensated supply elasticities, we calibrate the value
*       of leisure in the benchmark, and the EOS bw consumption and leisure.)

parameter
        elas_uncomp     Uncompensated labor supply elasticity /0.05/
        elas_comp       Compensated labor supply elasticity /0.3/
        diff_elas       Difference bw compensated and uncompensated elasticity
        sigma_leiscons  Calibrated elasticity of substitution bw leisure and consumption in utility function
;

diff_elas = elas_comp - elas_uncomp;

parameter
        b_leis  Benchmark value of leisure
;

b_leis(g,rs) = diff_elas / (1-diff_elas) * (vom(g,rs)+vinvs(g,rs));

*       Calibrate EOS bw leisure and other consumption in utility function:

sigma_leiscons(g,rs)$b_leis(g,rs) = elas_comp / (1-diff_elas) * vfms("lab",g,rs) / b_leis(g,rs);
$offtext


parameter
        govbudg0;

govbudg0(rs) = vom("g",rs);


*       Accommodate leisure time in labor endowment:
parameter thetals(rs);
thetals(rs)=0.2;

*	Parameters about kapital
parameter
        housav(rs,t)             Household saving
        newcap(rs,t)             New capital
        oldcap(rs,i,t)           Old capital
        oldcapg(rs,t)            Old capital employed by government
        totalcap(rs,t)           Total capital;
parameter resdepl  "Cumulative depletion of fossil fuel up to t";
parameter r_kap,r_nhwkap,r_labor,r_nhwlabor;


*---------------------------------------------------------------------------------------*
*          Set up logical arrays which drive the MPSGE production blocks                *
*---------------------------------------------------------------------------------------*
set     trn(g),cru(g),ele(g),fgs(g),gas(g),col(g),oil(g);
set     e(i)		Energy inputs                   /col,cru,oil,gas,gdt,ele/
	pe(i)		Primary fossil fuels            /col, cru, gas/ 
	fe(i)		Fossil fuels                    /col,oil,cru,gas,gdt/
	ne(i)		Energy without cru		/col,oil,gas,gdt,ele/
	elec(i)		Electricity			/ele/
        x(g)		Resource sectors                /col,gas,cru,agr,omn/
	econv(i,j)	Energy conversion process	/col.oil,col.gdt,cru.oil,cru.gdt,gas.oil,gas.gdt/

        yy(g,rs)       Sectors which are in the model
        con(g,rs)      Consumption
        oth(g,rs)      Other sectors
	inv(g,rs)	Investment
	gov(g,rs)	Government;



trn("trp")=yes;
cru("cru")=yes;
ele("ele")=yes;
oil("oil")=yes;
gas("gas")=yes;
col("col")=yes;
fgs("gdt")=yes;

yy(g,rs) = yes$(vom(g,rs)>0);
oth(yy(g,rs)) = yes$(not (oil(g)+cru(g)+ele(g)+col(g)+gas(g)+fgs(g)));
oth(c,rs) = no;
oth("i",rs) = no;
oth("g",rs) = no;
con(c,rs) = yes;
inv("i",rs) = yes;
gov("g",rs) = yes;

set fkl(f),fres(f);
fkl("lab")=yes;
fkl("cap")=yes;
fres("res")=yes;

*---------------------------------------------------------------------------------------*
*                                    RESOURCE		                                *
*---------------------------------------------------------------------------------------*

parameter vfmresh "Resource rents by household by sector";
vfmresh(j,c,rs)$sum(j.local,vfm("res",j,rs)) = vfms("res",c,rs)*vfm("res",j,rs)/sum(j.local,vfm("res",j,rs));


*       Supply elasticity:
parameter esubx(g,rs)   "EOS btw resource factor and other inputs";
parameter supelas(x)	"Supply elasticity of resource based technology";
supelas(x)=0.5;


$if %gasflag%==high      supelas(x)=0.5;
$if %gasflag%==high      supelas("gas")=2;
esubx(x,rs)$(vom(x,rs)) = (vfm("res",x,rs)/vom(x,rs)) / (1 - vfm("res",x,rs)/vom(x,rs)) * supelas(x);

parameter sigmanhw(nhw,rs);
sigmanhw(nhw,rs) =1;
*(vfmnhw("res",nhw,rs)/vomnhw(nhw,rs))/(1-vfmnhw("res",nhw,rs)/vomnhw(nhw,rs));

parameter resdepl  "Cumulative depletion of fossil fuel up to t";

*---------------------------------------------------------------------------------------*
*                               GDP Accounting		                                *
*---------------------------------------------------------------------------------------*

*       BENCHMARK TAX REVENUE CALCULATIONS
parameter taxrevbench;
taxrevbench(s) =
sum(j,  vom(j,s)*rto(j,s))+sum(nhw,vomnhw(nhw,s)*rtonhw(nhw,s))
+sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))+sum(nhw,sum(i,vdfmnhw(i,nhw,s)*rtfdnhw(i,nhw,s)))
+sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))+sum(f,sum(nhw,vfmnhw(f,nhw,s)*rtfnhw(f,nhw,s)))
+sum((i,rs), rtms(i,rs,s) *  (vxmd(i,rs,s) * (1-rtxs(i,rs,s)) + vtwr(i,rs,s)))
-sum((i,rs), rtxs(i,s,rs) * vxmd(i,s,rs));
taxrevbench(r)=
sum(j,  vom(j,r)*rto(j,r))+sum(nhw,vomnhw(nhw,r)*rtonhw(nhw,r))
+sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) +(vifm(i,g,r,"CNTRD")+vifm(i,g,r,"OTHTRD"))*rtfi(i,g,r)))+sum(nhw,sum(i,vdfmnhw(i,nhw,r)*rtfdnhw(i,nhw,r)))
+sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))+sum(f,sum(nhw,vfmnhw(f,nhw,r)*rtfnhw(f,nhw,r)))
+sum((i,s), rtms(i,s,r) *  (vxmd(i,s,r) * (1-rtxs(i,s,r)) + vtwr(i,s,r)))
-sum((i,s), rtxs(i,r,s) * vxmd(i,r,s));
display taxrevbench;

*       BENCHMARK GDP CALCULATIONS
*       Income approach
parameter GDP(*,rs);
GDP("inc",rs)=sum(mf,vfms(mf,"c",rs))+sum((j,c),vfmresh(j,c,rs))+sum(nhw,vfmsnhw(nhw,"c",rs))+taxrevbench(rs); 
*+sum((i,v),v_k(i,v,rs))

*       Expenditure approach
GDP("exp",rs)=sum(c,vom(c,rs)) + vom("g",rs) + vom("i",rs)-vb(rs);

display GDP;

parameter chngdp;
chngdp= sum(rs$province(rs),gdp("exp",rs));
display chngdp;
*$exit

*-----------------------------------------------------------------*
*	SPLIT URBAN AND RURAL					  *
*-----------------------------------------------------------------*

parameter rshrcons(g,rs);
parameter rshrinc(g,rs);
rshrcons("c",rs)=1;
rshrinc("c",rs)=1;


parameter pop2007(rs,g),hhshr2007(rs,g);

$if not set onehh $set onehh yes
$if "%onehh%"=="yes" $goto nohhsplit 


* HH consumption share by sector by province
parameter rshrconsi(i,g,rs);
rshrconsi(i,h,r)$(sum(h.local,rescons(r,h,i)))
=rescons(r,h,i)/(sum(h.local,rescons(r,h,i)));

* HH consumption share in total consumption by region
rshrcons(h,r)=sum(i.local,rescons(r,h,i))/sum((i.local,h.local),rescons(r,h,i));
rshrcons("c",r)=0;
rshrcons("c",s)=1;
display rshrcons;

vafm(i,h,r)$(vafm(i,"c",r)>1e-8)=vafm(i,"c",r)*rshrconsi(i,h,r);
* Some sectors have positive consumption, but in the raw data which is used to calculate cons shares, there is no cons...
vafm(i,h,r)$((vafm(i,"c",r)>1e-8) and (sum(h.local,rshrconsi(i,h,r)=0)))=vafm(i,"c",r)*rshrcons(h,r);
vafm(i,c,r)$(vafm(i,c,r)<1e-8)=0;
vafm(i,"c",r)=0;

eco2(i,h,r)$(eco2(i,"c",r))=eco2(i,"c",r)*rshrconsi(i,h,r);
eco2(i,h,r)$((eco2(i,"c",r)>1e-8) and (sum(h.local,rshrconsi(i,h,r)=0)))=eco2(i,"c",r)*rshrcons(h,r);
eco2(i,"c",r)=0;

vom(h,r)=sum(i,vafm(i,h,r));
rshrcons(h,r)=vom(h,r)/(sum(h.local,vom(h,r)));
vom("c",r)=0;


* HH income share in total income by region
parameter savingrate(g,rs);
savingrate(h,r)=0.4;
rshrinc(h,r)=(rshrcons(h,r)/(1-savingrate(h,r)))/sum(h.local,(rshrcons(h,r)/(1-savingrate(h,r))));
rshrinc("c",r)=0;
rshrinc("c",s)=1;


vfms(mf,c,rs)=vfms(mf,"c",rs)*rshrinc(c,rs);
vfms(mf,"c",r)=0;
vfms(f,c,rs)$(not mf(f))=0;

vfmsnhw(nhw,h,r)=vfmsnhw(nhw,"c",r)*rshrinc(h,r);
vfmsnhw(nhw,"c",r)=0;

vfmresh(j,h,r)=vfmresh(j,"c",r)*rshrinc(h,r);
vfmresh(j,"c",r)=0;

display vfms,vfmsnhw,vfmresh;


*-----------------------------------------------------------------------------
*	POPULATION DATA FROM China YB and World Bank in 2007:



*population("EUR","2007")=; 
*population("APD","2007")=; 
*population("ASI","2007")=; 
*population("CAA","2007")=; 
*population("NAM","2007")=33453; 
*population("ROW","2007")=; 


hhshr2007("BEJ","hh2")=84.50/100;
hhshr2007("TAJ","hh2")=76.31/100;
hhshr2007("HEB","hh2")=40.25/100;
hhshr2007("SHX","hh2")=44.03/100;
hhshr2007("NMG","hh2")=50.15/100;
hhshr2007("LIA","hh2")=59.20/100;
hhshr2007("JIL","hh2")=53.16/100;
hhshr2007("HLJ","hh2")=53.90/100;
hhshr2007("SHH","hh2")=88.70/100;
hhshr2007("JSU","hh2")=53.20/100;
hhshr2007("ZHJ","hh2")=57.20/100;
hhshr2007("ANH","hh2")=38.70/100;
hhshr2007("FUJ","hh2")=48.70/100;
hhshr2007("JXI","hh2")=39.80/100;
hhshr2007("SHD","hh2")=46.75/100;
hhshr2007("HEN","hh2")=34.34/100;
hhshr2007("HUB","hh2")=44.30/100;
hhshr2007("HUN","hh2")=40.45/100;
hhshr2007("GUD","hh2")=63.14/100;
hhshr2007("GXI","hh2")=36.24/100;
hhshr2007("HAI","hh2")=47.20/100;
hhshr2007("CHQ","hh2")=48.34/100;
hhshr2007("SIC","hh2")=35.60/100;
hhshr2007("GZH","hh2")=28.24/100;
hhshr2007("YUN","hh2")=31.60/100;
hhshr2007("SHA","hh2")=40.62/100;
hhshr2007("GAN","hh2")=31.59/100;
hhshr2007("NXA","hh2")=40.07/100;
hhshr2007("QIH","hh2")=44.02/100;
hhshr2007("XIN","hh2")=39.15/100;
hhshr2007(r,"hh1")=1-hhshr2007(r,"hh2");
hhshr2007(s,"c")=1;

pop2007(r,"c")=population(r,"107");
pop2007(r,h)=population(r,"107")*hhshr2007(r,h);

$label nohhsplit
pop2007(r,"c")=population(r,"107");

set flagvfms;
flagvfms(f,c,rs)=no;
flagvfms(f,c,rs)$(vfms(f,c,rs)>1e-8)=yes
display vafm;


*-----------------------------------------------------------------------------
*	CHECK INCOME BALANCE FOR EACH HOUSEHOLD
parameter incbalance(rs,c);
incbalance(rs,c)=vom(c,rs)
+vom("g",rs)*rshrinc(c,rs)+vom("i",rs)*rshrinc(c,rs)-vb(rs)*rshrinc(c,rs)
+thetals(rs)*vfms("lab",c,rs)
-sum(mf,vfms(mf,c,rs)*(1+thetals(rs)$sameas(mf,"lab")))
-sum(j,vfmresh(j,c,rs))
-sum(nhw,vfmsnhw(nhw,c,rs))
-taxrevbench(rs)*rshrinc(c,rs);

display incbalance;



*------------------------------------------------------*
*          Capital mobility                            *
*------------------------------------------------------*

* Flag for mobile capital across China regions:
$if not set mobcapchn $set mobcapchn yes

set mk(f,rs)    "Flag for mobile capital across China regions --default yes";
mk("cap",r)=%mobcapchn%;



*---------------------------------------------------------------------------------------*
*                                    EMISSIONS		                                *
*---------------------------------------------------------------------------------------*

parameter cscale Scale factor for emissions and price;
cscale=1;

parameter       bmkco2(i,g,rs)  Benchmark carbon emissions;
bmkco2(i,g,rs) = eco2(i,g,rs)/cscale;


*       Carbon emission reduction
parameter       co2lim(rs),co2lim0(rs),refco2(rs);
co2lim0(rs)=sum((i,g),bmkco2(i,g,rs));
refco2(rs)=co2lim0(rs);

set cc(rs) Set for carbon constrained regions;
cc(rs) = no;

$if %intflag%==nint      cc(rs)$province(rs) = yes;
$if %intflag%==rint      cc(rs)$province(rs) = yes;

co2lim(rs) = 0;
co2lim(cc) = co2lim0(cc);
display co2lim, co2lim0;

*       Carbon tax
parameter       pcarbb;
pcarbb=1e-6*cscale;


*       Define allocation of CO2 permits (distribution of revenue) across provinces:
parameter carbrevshare(g,rs)        Share of carbon revenue from national policy;
$if "%onehh%"=="yes" carbrevshare("c",cc)$(card(cc) eq card(r)) =co2lim(cc)/sum((cc.local),co2lim(cc));
$if "%onehh%"=="yes" carbrevshare("c",cc)$(not (card(cc) eq card(r))) = 1;
$if "%onehh%"=="no" carbrevshare(h,cc)$(card(cc) eq card(r)) = co2lim(cc)/sum((cc.local),co2lim(cc))*hhshr2007(cc,h);
$if "%onehh%"=="no" carbrevshare(h,cc)$(not (card(cc) eq card(r))) = 1;
*$if "%onehh%"=="yes" carbrevshare("c",cc)$(card(cc) eq card(r)) = pop2007(cc,"c")/sum((cc.local),pop2007(cc,"c"));
*$if "%onehh%"=="yes" carbrevshare("c",cc)$(not (card(cc) eq card(r))) = 1;
*$if "%onehh%"=="no" carbrevshare(h,cc)$(card(cc) eq card(r)) = pop2007(cc,h)/sum((cc.local,h.local),pop2007(cc,h));
*$if "%onehh%"=="no" carbrevshare(h,cc)$(not (card(cc) eq card(r))) = 1;
display carbrevshare;


parameter	emisreduc(rs,t) Emissions reductions as a fraction of BAU emissions;
emisreduc(rs,t) = 0;


parameter
	cbtrade	 Flag for CAT polict 
        ctradet  Flag for CAT policy in dynamic model
        seccarb  Flag to include sector under the carbon policy
        bca      Flag for border adjustment
;

seccarb(g,i,rs) = yes;

parameter cintf(rs) Flag to determined carbon price to meet intensity target at regional level;
cintf(rs)=no;


parameter cintfn   Flag to determined carbon price to meet intensity target at national level;
cintfn=no;

cbtrade(rs) = no ;



parameter
        inttarg(*)      Intensity target by province as fraction of benchmark intensity
        chk_int;

*inttarg(rs)$province(rs)=0.8;
*$ontext
inttarg("ANH") = 0.83;
inttarg("BEJ") = 0.82;
inttarg("CHQ") = 0.83;
inttarg("FUJ") = 0.825;
inttarg("GAN") = 0.84;
inttarg("GUD") = 0.805;
inttarg("GXI") = 0.84;
inttarg("GZH") = 0.84;
inttarg("HAI") = 0.89;
inttarg("HEB") = 0.82;
inttarg("HEN") = 0.83;
inttarg("HLJ") = 0.84;
inttarg("HUB") = 0.83;
inttarg("HUN") = 0.83;
inttarg("JIL") = 0.83;
inttarg("JSU") = 0.81;
inttarg("JXI") = 0.83;
inttarg("LIA") = 0.82;
inttarg("NMG") = 0.84;
inttarg("NXA") = 0.84;
inttarg("QIH") = 0.90;
inttarg("SHA") = 0.83;
inttarg("SHD") = 0.82;
inttarg("SHH") = 0.81;
inttarg("SHX") = 0.83;
inttarg("SIC") = 0.825;
inttarg("TAJ") = 0.81;
inttarg("XIN") = 0.89;
inttarg("YUN") = 0.835;
inttarg("ZHJ") = 0.81;
*$offtext

inttarg("CHN") = 0.82567;
*inttarg("CN2") = 0.82567;


$ontext
*	Energy price in China
parameter 
	price(rs,i);
$gdxin %inputfolder%data.gdx
$load	price=price
$gdxin

$if %ds%==allprov      price("HUN",i)=price("HUB",i);
display price;
$offtext

*       Carbon intensity targets
parameter       bmkint(*);
bmkint(rs)=sum((i,g)$(fe(i)), bmkco2(i,g,rs))  /
gdp("exp",rs);

bmkint("CHN")=sum((r,i,g)$(fe(i)), bmkco2(i,g,r))  /
 sum(rs$province(rs),gdp("exp",rs));


*---------------------------------------------------------------------------------------*
*                                    ENERGY		                                *
*---------------------------------------------------------------------------------------*

parameter efd,eind,eimp(*,*,trade),eexp(*,*,trade);

efd(rs,e) = (evd(e,"c",rs)+evd(e,"g",rs)+evd(e,"i",rs));

eind(rs,e,j) = evd(e,j,rs);

eimp(s,e,"othtrd") = sum(ss,evt(e,ss,s));
eexp(s,e,"othtrd") = sum(ss,evt(e,s,ss));
eimp(r,e,"othtrd") = sum(s,evt(e,s,r));
eexp(r,e,"othtrd") = sum(s,evt(e,r,s));

eimp(s,e,"cntrd") = sum(r,evt(e,r,s));
eexp(s,e,"cntrd") = sum(r,evt(e,s,r));
eimp(r,e,"cntrd") = sum(rr,evt(e,rr,r));
eexp(r,e,"cntrd") = sum(rr,evt(e,r,rr)
);

*Energy production
parameter eprod  Energy production by region;

eprod(e,rs) = sum(i, eind(rs,e,i))+efd(rs,e)+sum(trade,eexp(rs,e,trade)-eimp(rs,e,trade));

display eprod;

parameter chneprod;
chneprod(e)=sum(r,eprod(e,r));
display chneprod;

parameter euse  "Energy use (mtce)";

euse(j,i,rs) = eind(rs,j,i);
euse(j,"c",s) = efd(s,j);
euse(j,c,r)$sum(c.local,vafm(j,c,r)) = vafm(j,c,r)/sum(c.local,vafm(j,c,r)) * efd(r,j);

parameter euseele;
euseele(rs)=sum(i,euse(i,"ele",rs));


*------------------------------------------------------*
*          Definition of Healh effect parameters       *
*------------------------------------------------------*

SET  PLT  PHS/
   1    PH1 O3
   2	PH2 he
   3	PH3 SO2
   4	PH4 NO2
   5	PH5 nitrate
   6	PH6 PM2.5 /;


Parameter
   Q_PH_TOT(RS)		total quantity of PH demanded-produced
   Q_PH(RS, PLT)		quantity of PH produced
   Q_L_PERC_SERV_PH_yr1(RS,PLT)	quantity of labor used as a percentage of serv for PH in yr1
   Q_L_PH_yr1(RS, PLT)	Default labor used for PH in year 1
   Q_LEIS_PH_yr1(RS,PLT)	default leisure used for PH in year 1
   Q_SERV_PH_yr1(RS, PLT)	Default service used for PH in year 1
   PH_PERC_SERV(RS,PLT)	Service used for PH as a percentage of total service in year 1
   Q_L_PH(RS, PLT)		labor used for PH
   Q_SERV_PH(RS,PLT)	SERV used for PH
   Q_SERV_PH_TOT(RS)	SERV used for all PH sectors total
   Q_PH_yr1(RS,PLT)	quantity of PH in year1
   Q_SERV_X_PHSERV(RS)	quantity of service demanded thats notused for PH
   Q_WEL_X_PH(RS)	quantity of welfare demanded that doesnot count for PH
   P_index_curr(RS,PLT)	pollution index for current year;

Q_PH_TOT(RS)			=0;
Q_PH(RS, PLT)			=0;
Q_L_PERC_SERV_PH_yr1(RS,PLT)	=0;
Q_L_PH_yr1(RS, PLT)		=0;
Q_LEIS_PH_yr1(RS,PLT)		=0;
Q_SERV_PH_yr1(RS, PLT)		=0;
PH_PERC_SERV(RS,PLT)		=0;
Q_L_PH(RS, PLT)			=0;
Q_SERV_PH(RS,PLT)		=0;
Q_SERV_PH_TOT(RS)		=0;
Q_PH_yr1(RS,PLT)		=0;
Q_SERV_X_PHSERV(RS)		=0;
Q_WEL_X_PH(RS)			=0;
P_index_curr(RS,PLT)		=0;

   
$if %heflag%==yes $include ..\setpar\hepar.gms


*---------------------------------------------------------------------------------------*
*                                   Model run settings                                  *
*---------------------------------------------------------------------------------------*


$if %intflag%==rint      cintf(r)=yes;
$if %intflag%==nint      cintfn=yes;
$if %intflag%==nint      cbtrade(r) =yes;


*------------------------------------------------------*
*          Definition of Different ELE Scenarios       *
*------------------------------------------------------*
parameter neletaxn(rs);
neletaxn(rs)=no;
$if %eleflag1%==yes neletaxn(rs)$province(rs)=yes;

parameter neletaxnh(rs);
neletaxnh(rs)=no;
$if %eleflag2%==yes neletaxnh(rs)$province(rs)=yes;
*neletaxnh("hai")=no;

parameter neletaxni(rs);
neletaxni(rs)=no;
$if %eleflag2%==yes neletaxni(rs)$province(rs)=yes;


