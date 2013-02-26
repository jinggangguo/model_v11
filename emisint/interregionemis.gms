$title  Read GTAP8 Basedata and Replicate the Benchmark in MPSGE
* This version without model block is to generate some data outputs, e.g. energy intensity by sector by region.

$setlocal inputfolder '..\data'


*       Da Zhang, Sebastian Rausch 6/6/2011

*       --------------------------------------------------------------------

*       Command line options

*       Which dataset do we use?

$if not set ds $set ds allprov

*       Impose a national or regional intensity target?

$if not set intflag $set intflag no

*       Definition of vintaged capital:

$if not set lic_exempt $set lic_exempt no

*       Definition of vintaged capital:

$if not set lic_exempt $set lic_exempt no

*       Definition of fixed electricity 1:
$if not set eleflag1 $set eleflag1 no

*       Definition of fixed electricity 2:
$if not set eleflag2 $set eleflag2 no

set     inputs  Input assumptions for this run /
        ds              %ds%,
        coalition       %coalition%,
        cutback         %cutback%,
        co2trd          %co2trd%,
        lic_exempt      %lic_exempt%,
        metric          %metric%,
        verbca          %verbca%/;

*       --------------------------------------------------------------------
set
        t      "Time periods" /2004,2006,2008,2010,2012,2014,2016,2018,2020,2022,2024,2026,2028,
                2030,2032,2034,2036,2038,  2040,2042,2044,2046,2048, 2050,2052,2054,2056,2058,  2060,2062,2064,2066,2068,
                2070,2072,2074,2076,2078, 2080,2082,2084,2086,2088,  2090,2092,2094,2096,2098, 2100/;
alias (t,ts);


set     g(*)    Goods plus C and G;
set     i(g)    Goods
        f(*)    Factors;
alias   (i,j) , (g,gg);

set
        sf(f)   Sluggish primary factors (sector-specific),
        mf(f)   Mobile primary factors;

set     trade(*)    Trade type;
set     ctrade(trade);
set     otrade(trade);

set     rs;
alias   (rs,sr);

set     r(rs)   ;
set     s(rs)   ;

alias   (r,rr);

alias   (rs,sr);
set     province(rs);
set     GTAPregions(rs);

set     nhw;


set     rnum(rs)        Numeraire region;



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

        eco2(i,g,rs)    "Volume of carbon emissions (Gg)"
	evd(i,g,rs)	"Volume of energy use (Mtce)"
	evt(i,rs,sr)	"Volume of energy trade"
;

$gdxin '%inputfolder%/%ds%.gdx'
$load g,i,f,trade,nhw
$load rs,r,s
$load rtxs,rtms
$load vxmd,vtwr,vst
$load rtf,rtfnhw,rtfd,rtfdnhw,rtfi
$load vfm,vdfm,vifm,vdtrm,vdst,vom,vomnhw,vdfmnhw,vfmnhw
$load rto,rtonhw
$load esubd,esubva,esubm,eta
$load eco2
$load evd,evt
$gdxin

*$exit

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


parameter
        rtda(i,rs)     Benchmark domestic value-added tax rate
        rtia(i,rs,trade) Benchmark imports value-added tax rate;
rtda(i,rs)$sum(g,vdfm(i,g,rs)) = (sum(g,vdfm(i,g,rs)*rtfd(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs)*rtfdnhw(i,nhw,rs)))/(sum(g,vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs)));
rtia(i,rs,trade)$sum(g,vifm(i,g,rs,trade)) = sum(g,vifm(i,g,rs,trade)*rtfi(i,g,rs))/sum(g,vifm(i,g,rs,trade));

parameter       esub(g,rs)      Top-level elasticity (energy versus non-energy),
                esubn(g,rs)     Top-level elasticity (among non-energy goods),
                esubkl(g,rs)    Capital-labor elasticity;

esub(g,rs) = 0.5;
esubn("C",rs) = 1;
esubkl(g,rs) = esubva(g);
esubkl("ele",rs) = 0.5;

parameter       vdm(g,rs)       Aggregate demand for domestic output;

vdm(i,rs) = sum(g, vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs));



parameter
        pvxmd(i,rs,sr)   "Import price (power of benchmark tariff)"
        pvtwr(i,rs,sr)   "Import price for transport services"

        vtw(i)           "Aggregate international transportation services"
        vim(i,rs,trade)  "Aggregate imports"
        evom(f,rs)       "Aggregate factor endowment at market prices"
        evomsnhw(nhw,rs) "Resource endowment for nhw"
        vb(*)            "Current account balance";

pvxmd(i,rs,sr) = (1+rtms(i,rs,sr)) * (1-rtxs(i,rs,sr));
pvtwr(i,rs,sr) = 1+rtms(i,rs,sr);

vtw(i) = sum(rs,vst(i,rs));


vdm("c",rs) = vom("c",rs);
vdm("g",rs) = vom("g",rs);


vim(i,rs,trade) =  sum(g, vifm(i,g,rs,trade));
evom(f,rs) = sum(g, vfm(f,g,rs));
evom(f,rs)$(not sameas(f,"res"))=evom(f,rs)+sum(nhw,vfmnhw(f,nhw,rs));
evomsnhw(nhw,rs)=vfmnhw("res",nhw,rs);



vafm(i,g,rs) = vdfm(i,g,rs)*(1+rtfd(i,g,rs)) + sum(trade,vifm(i,g,rs,trade))*(1+rtfi(i,g,rs));
vafm(i,"ele",rs)=vdfm(i,"ele",rs)*(1+rtfd(i,"ele",rs)) + sum(trade,vifm(i,"ele",rs,trade))*(1+rtfi(i,"ele",rs))+sum(nhw,vdfmnhw(i,nhw,rs)*(1+rtfdnhw(i,nhw,rs)));
vam(i,rs) = sum(g,vafm(i,g,rs));



vb(s) = vom("c",s) + vom("g",s) + vom("i",s)
        - sum(f,  evom(f,s)) - sum(nhw,evomsnhw(nhw,s))
        - sum(j,  vom(j,s)*rto(j,s))-sum(nhw,vomnhw(nhw,s)*rtonhw(nhw,s))
        - sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))-sum(nhw,sum(i,vdfmnhw(i,nhw,s)*rtfdnhw(i,nhw,s)))
        - sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))-sum(f,sum(nhw,vfmnhw(f,nhw,s)*rtfnhw(f,nhw,s)))
        - sum((i,rs), rtms(i,rs,s) *  (vxmd(i,rs,s) * (1-rtxs(i,rs,s)) + vtwr(i,rs,s)))
        + sum((i,rs), rtxs(i,s,rs) * vxmd(i,s,rs));

vb(r) = vom("c",r) + vom("g",r) + vom("i",r)
        - sum(f, evom(f,r)) - sum(nhw,evomsnhw(nhw,r))
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


*       Accommodate leisure time in labor endowment:
parameter thetals /0.2/;

*---------------------------------------------------------------------------------------*
*          Set up logical arrays which drive the MPSGE production blocks                *
*---------------------------------------------------------------------------------------*
set     trn(g),cru(g),ele(g),fgs(g),gas(g),col(g),oil(g);
set     fe(i)   Fossil fuels                    /col, oil, gas, gdt/
        e(i)    Energy inputs                   /col,oil,gas,gdt,ele/
        en(i)   Energy goods                    /col,oil,cru,gas,gdt/
        x(g)    Resource sectors                /col,gas,cru,agr,omn/

        yy(g,rs)       Sectors which are in the model
        con(g,rs)      Consumption
        oth(g,rs)       Other sectors;


trn("trp")=yes;
cru("cru")=yes;
ele("ele")=yes;
oil("oil")=yes;
gas("gas")=yes;
col("col")=yes;
fgs("gdt")=yes;

yy(g,rs) = yes$(vom(g,rs)>0);
oth(yy(g,rs)) = yes$(not (oil(g)+cru(g)+ele(g)+col(g)+gas(g)+fgs(g)));
oth("c",rs) = no;
con("c",rs) = yes;

set fkl(f),fres(f);
fkl("lab")=yes;
fkl("cap")=yes;
fres("res")=yes;


*---------------------------------------------------------------------------------------*
*                                  Definition of emissions                              *
*---------------------------------------------------------------------------------------*

parameter cscale Scale factor for emissions and price;
cscale=1;

parameter       bmkco2(i,g,rs)  Benchmark carbon emissions;
bmkco2(i,g,rs) = eco2(i,g,rs)/cscale;

*       Carbon emission reduction
parameter       co2lim(rs),co2lim0(rs);
co2lim0(rs)=sum((i,g)$(vafm(i,g,rs)>1e-8),bmkco2(i,g,rs));

*------------------------------------------------------*
*          Capital mobility                            *
*------------------------------------------------------*

* Flag for mobile capital across China regions:
$if not set mobcapchn $set mobcapchn yes

set mk(f,rs)    "Flag for mobile capital across China regions --default yes";

mk("cap",r)=%mobcapchn%;

*------------------------------------------------------*
*          Capital vintaging                           *
*------------------------------------------------------*
*$include 1_vintaging.gms



*------------------------------------------------------*
*          Definition of resources                     *
*------------------------------------------------------*
parameter vfmres "Resource rents by household by sector";
vfmres(j,rs)$sum(j.local,vfm("res",j,rs)) = evom("res",rs)*vfm("res",j,rs)/sum(j.local,vfm("res",j,rs));


*       Supply elasticity:
parameter esubx(g,rs)   "EOS btw resource factor and other inputs";
esubx(x,rs)$(vom(x,rs)) = (vfm("res",x,rs)/vom(x,rs)) / (1 - vfm("res",x,rs)/vom(x,rs)) * 0.5;

parameter sigmanhw(nhw,rs);
sigmanhw(nhw,rs) =1;


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


*------------------------------------------------------*
*          Definition of Different CINT Scenarios      *
*------------------------------------------------------*

set carbc(rs) Set for carbon constrained regions;
carbc(rs) = no;
$if %intflag%==nint      carbc(rs)$province(rs) = yes;
$if %intflag%==rint      carbc(rs)$province(rs) = yes;
display carbc;


co2lim(rs) = 0;
co2lim(carbc) = co2lim0(carbc);
display co2lim, co2lim0;

*       Carbon tax
parameter       pcarbb;
pcarbb=1e-6;


*       Define allocation of CO2 permits (distribution of revenue) across provinces:
parameter crevshare(rs)        Share of carbon revenue from national policy;
crevshare(carbc)$(card(carbc) eq card(r)) = co2lim(carbc)/sum(carbc.local,co2lim(carbc));
crevshare(carbc)$(not (card(carbc) eq card(r))) = 1;
display crevshare;


*       Endogenous carbon price to target intensity;
parameter cintf(rs) Flag to determined carbon price to meet intensity target at regional level;
cintf(rs)=no;
$if %intflag%==rint      cintf(r)=yes;

parameter cintfn   Flag to determined carbon price to meet intensity target at national level;
cintfn=no;
$if %intflag%==nint      cintfn=yes;

*       Carbon trade price
set        cbtrade(rs)      Regions involved in carbon trade;
cbtrade(rs) = no ;
$if %intflag%==nint      cbtrade(r) =yes;


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

inttarg("CHN") = 0.82642;


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

*       BENCHMARK GDP CALCULATIONS
*       Income approach
*parameter GDP(*,rs);
*GDP("inc",rs)=sum(mf,evom(mf,rs))+sum(j,vfmres(j,rs))+sum(nhw,evomsnhw(nhw,rs))+sum((i,v),v_k(i,v,rs))
*+taxrevbench(rs);
*       Expenditure approach
*GDP("exp",rs)=vom("c",rs) + vom("g",rs) + vom("i",rs)-vb(rs);

*display GDP;

*parameter chngdp;
*chngdp= sum(rs$province(rs),gdp("exp",rs));
*display chngdp;

*$exit


*------------------------------------------------------*
*       Calculation of indirect emission intensity     *
*------------------------------------------------------*
*$ontext

parameter def(rs,i);
def(rs,i)=0;
def(rs,i)$((vom(i,rs)>1e-8) and (not sameas(i,"ele")))=sum(fe,bmkco2(fe,i,rs))/vom(i,rs);
def(rs,i)$((vom(i,rs)>1e-8) and (sameas(i,"ele")))=sum(fe,bmkco2(fe,i,rs))/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));


parameter impshare(j,sr,rs);
impshare(j,sr,rs)=0;

loop(j,
loop(rs,
if(sum(sr,vxmd(j,sr,rs))>1e-8,
impshare(j,sr,rs)=vxmd(j,sr,rs)/sum(sr.local,vxmd(j,sr,rs));
);
);
);

variables
ief(rs,i)      'Indirect emission factor'
dummy           'dummy objective variable'
;

positive variables      ief;
ief.lo(rs,i)=def(rs,i);
ief.l(rs,i)=def(rs,i);

equations
steadystate(rs,i)
edummy
;

steadystate(rs,i)$(vom(i,rs))..
(vom(i,rs)+(sum(nhw,vomnhw(nhw,rs)))$(sameas(i,"ele")))*ief(rs,i)=e=

(vom(i,rs)+(sum(nhw,vomnhw(nhw,rs)))$(sameas(i,"ele")))*def(rs,i)+
sum(j,ief(rs,j)*(vdfm(j,i,rs)+sum(nhw,vdfmnhw(j,nhw,rs))$(sameas(i,"ele"))))+
sum(j,(sum(sr,sum(trade,vifm(j,i,rs,trade))*impshare(j,sr,rs)*ief(sr,j))));

edummy.. dummy =e= 0;
model m1 /steadystate,edummy/;
option nlp=conopt;
solve m1 minimizing dummy using nlp;



parameter eintd(rs,i),einti(rs,i);
eintd(rs,i)=def(rs,i);
einti(rs,i)=ief.l(rs,i);



parameter impemis;
impemis(r)=sum(i,sum(rr,vxmd(i,rr,r)*einti(rr,i)));


parameter expemis;
expemis(r)=sum(i,sum(rr,vxmd(i,r,rr)*einti(r,i)));

display impemis,expemis;

$exit

execute_unload 'eint.gdx',eintd,einti;
execute 'gdxxrw i=eint.gdx o=eint.xlsx par=eintd rng=eintd!a2 cdim=0';
execute 'gdxxrw i=eint.gdx o=eint.xlsx par=einti rng=einti!a2 cdim=0';

$exit
*$offtext

*------------------------------------------------------*
*       Calculation of indirect energy intensity       *
*------------------------------------------------------*
*$ontext

*       Which fuel do we calculate?

$if not set fuel $set fuel col

parameter vomm(rs),vomc;
vomm(rs)=sum(g,vom(g,rs));
vomc=sum(rs$province(rs),vomm(rs));
display vomm,vomc;
*$exit


parameter dei(rs,i);
dei(rs,i)=0;
dei(rs,i)$((vom(i,rs)>1e-8) and (not sameas(i,"ele")))=
evd("%fuel%",i,rs)/vom(i,rs);
dei(rs,i)$((vom(i,rs)>1e-8) and (sameas(i,"ele")))=
evd("%fuel%",i,rs)/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));

display dei;


*$exit

parameter impshare(j,sr,rs);
impshare(j,sr,rs)=0;

loop(j,
loop(rs,
if(sum(sr,vxmd(j,sr,rs))>1e-8,
impshare(j,sr,rs)=vxmd(j,sr,rs)/sum(sr.local,vxmd(j,sr,rs));
);
);
);

variables
iei(rs,i)      'Indirect energy use'
dummy           'dummy objective variable'
;

positive variables      ief;
iei.lo(rs,i)=dei(rs,i);
iei.l(rs,i)=dei(rs,i);

equations
steadystate(rs,i)
edummy
;

steadystate(rs,i)$(vom(i,rs))..
(vom(i,rs)+(sum(nhw,vomnhw(nhw,rs)))$(sameas(i,"ele")))*iei(rs,i)=e=
(vom(i,rs)+(sum(nhw,vomnhw(nhw,rs)))$(sameas(i,"ele")))*dei(rs,i)+
sum(j,iei(rs,j)*(vdfm(j,i,rs)+sum(nhw,vdfmnhw(j,nhw,rs))$(sameas(i,"ele"))))+
sum(j,(sum(sr,sum(trade,vifm(j,i,rs,trade))*impshare(j,sr,rs)*iei(sr,j))));

edummy.. dummy =e= 0;
model m1 /steadystate,edummy/;
option lp=conopt;
solve m1 minimizing dummy using lp;

parameter %fuel%_intd(rs,i),%fuel%_inti(rs,i);
%fuel%_intd(rs,i)=dei(rs,i);
%fuel%_inti(rs,i)=iei.l(rs,i);

parameter %fuel%_totinti(rs);
%fuel%_totinti(rs)=sum(i,vom(i,rs)*%fuel%_inti(rs,i))/sum(i,vom(i,rs));

parameter %fuel%_chninti,%fuel%_worldinti;
%fuel%_chninti=sum((rs,i)$province(rs),vom(i,rs)*%fuel%_inti(rs,i))/sum((rs,i)$province(rs),vom(i,rs));
%fuel%_worldinti=sum((rs,i),vom(i,rs)*%fuel%_inti(rs,i))/sum((rs,i),vom(i,rs));

parameter expshare;
expshare(i,rs)=vafm(i,"c",rs)/vom("c",rs);
expshare(i,"CN2")=sum(r,vafm(i,"c",r))/sum(r,vom("c",r));
parameter %fuel%_dcons,%fuel%_icons;

parameter optshare;
optshare(i,rs)=vom(i,rs)/sum(i.local,vom(i,rs));
optshare(i,"CN2")=sum(r,vom(i,r))/sum((i.local,r),vom(i,r));

%fuel%_dcons(rs)=evd("%fuel%","c",rs);
%fuel%_icons(rs)=sum(i,vafm(i,"c",rs)*%fuel%_inti(rs,i));

execute_unload 'egyint.gdx',%fuel%_intd,%fuel%_inti,%fuel%_totinti,%fuel%_dcons,%fuel%_icons,expshare,optshare,%fuel%_chninti,%fuel%_worldinti;
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_intd rng=%fuel%_intd!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_inti rng=%fuel%_inti!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_totinti rng=%fuel%_totinti!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_dcons rng=%fuel%_dcons!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_icons rng=%fuel%_icons!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=expshare rng=expshare!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=optshare rng=optshare!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_chninti rng=%fuel%_china!a2 cdim=0';
execute 'gdxxrw i=egyint.gdx o=egyint.xlsx par=%fuel%_worldinti rng=%fuel%_world!a2 cdim=0';

$exit
*$offtext

*------------------------------------------------------*
*          Output for some trade statistics            *
*------------------------------------------------------*
*$ontext
parameter eintd,einti;
$gdxin '%projectfolder%/eint.gdx'
$load eintd,einti
$gdxin
parameter provtrade,provcons;
provtrade(r,"output",i)=vom(i,r);
provtrade(r,"dimp",i)=sum(rr,vxmd(i,rr,r));
provtrade(r,"imp",i)=sum(s,vxmd(i,s,r));
provtrade(r,"dexp",i)=sum(rr,vxmd(i,r,rr));
provtrade(r,"exp",i)=sum(s,vxmd(i,r,s));
provcons(r,"cemisd")=sum(i,vafm(i,"c",r)*eintd(r,i));
provcons(r,"cemisi")=sum(i,vafm(i,"c",r)*einti(r,i));
provcons(r,"cemistrpd")=vafm("trp","c",r)*eintd(r,"trp")+vafm("oil","c",r)*eintd(r,"oil");
provcons(r,"cemistrpi")=vafm("trp","c",r)*einti(r,"trp")+vafm("oil","c",r)*einti(r,"oil");

execute_unload 'output.gdx',provtrade,provcons;
execute 'gdxxrw i=output.gdx o=trade.xlsx @trade.rpt'
$exit
*$offtext