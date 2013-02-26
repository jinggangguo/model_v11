$title	GTAP8DATA.GMS	Read a GTAP 8 dataset


abort$(nd<>round(nd)) "Number of decimals must be an integer";

$if not set ds $ set ds "data"
$if not set datadir $set datadir "..\data\"
$setglobal datadir %datadir%

set	g(*)	Goods plus C and G and I;

$if exist %ds%.gdx $gdxin '%ds%.gdx'
$if not exist %ds%.gdx $gdxin '%datadir%%ds%.gdx'     
$load g



set	i(g)	Goods
	f(*)	Factors
	c(g)
	h(g);

set	yr;

$load f i c h yr
$if not defined rs__	set rs__(*)	Regions;
$if not defined rs__	$load rs__=rs

alias	(rs__,sr__);

set	rs/
JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW,
BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

alias	(rs,sr);

set	maprs_(rs__,rs)
/
JPN.JPN
KOR.KOR
IDN.IDN
IND.IND
CAN.CAN
USA.USA
MEX.MEX
ARG.ARG
BRA.BRA
FRA.FRA
DEU.DEU
ITA.ITA
GBR.GBR
RUS.RUS
TUR.TUR
ZAF.ZAF
ANZ.ANZ
REU.REU
TSG.TSG
SSA.SSA
MEN.MEN
LAM.LAM
FSU.FSU
ASI.ASI
ROW.ROW

BEJ.BEJ
TAJ.TAJ
HEB.HEB
SHX.SHX
NMG.NMG
LIA.LIA
JIL.JIL
HLJ.HLJ
SHH.SHH
JSU.JSU
ZHJ.ZHJ
ANH.ANH
FUJ.FUJ
JXI.JXI
SHD.SHD
HEN.HEN
HUB.HUB
HNA.HNA
GUD.GUD
GXI.GXI
HAI.HAI
CHQ.CHQ
SIC.SIC
GZH.GZH
YUN.YUN
SHA.SHA
GAN.GAN
NXA.NXA
QIH.QIH
XIN.XIN
/;


set	mapsr_(sr__,sr)
/
JPN.JPN
KOR.KOR
IDN.IDN
IND.IND
CAN.CAN
USA.USA
MEX.MEX
ARG.ARG
BRA.BRA
FRA.FRA
DEU.DEU
ITA.ITA
GBR.GBR
RUS.RUS
TUR.TUR
ZAF.ZAF
ANZ.ANZ
REU.REU
TSG.TSG
SSA.SSA
MEN.MEN
LAM.LAM
FSU.FSU
ASI.ASI
ROW.ROW

BEJ.BEJ
TAJ.TAJ
HEB.HEB
SHX.SHX
NMG.NMG
LIA.LIA
JIL.JIL
HLJ.HLJ
SHH.SHH
JSU.JSU
ZHJ.ZHJ
ANH.ANH
FUJ.FUJ
JXI.JXI
SHD.SHD
HEN.HEN
HUB.HUB
HNA.HNA
GUD.GUD
GXI.GXI
HAI.HAI
CHQ.CHQ
SIC.SIC
GZH.GZH
YUN.YUN
SHA.SHA
GAN.GAN
NXA.NXA
QIH.QIH
XIN.XIN
/;


$if not defined r	set r(rs)	Regions;
$if not defined r	$load r

$if not defined s__	set s__(rs__)	Regions;
$if not defined s__	$load s__=s


set	s(rs)/
JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW
/;


set	maps(s__,s)/
JPN.JPN
KOR.KOR
IDN.IDN
IND.IND
CAN.CAN
USA.USA
MEX.MEX
ARG.ARG
BRA.BRA
FRA.FRA
DEU.DEU
ITA.ITA
GBR.GBR
RUS.RUS
TUR.TUR
ZAF.ZAF
ANZ.ANZ
REU.REU
TSG.TSG
SSA.SSA
MEN.MEN
LAM.LAM
FSU.FSU
ASI.ASI
ROW.ROW
/;

$if not defined rs1	set rs1(rs)	Regions;
$if not defined rs1	$load rs1

$if not defined s1	set s1(s)	Regions;
$if not defined s1	$load s1



set	e(i)	/COL,CRU,GAS,OIL,ELE,GDT/,
	pe(e)	/COL,CRU,GAS/;

set
	rnum(rs)	Numeraire region,
	ghg	Greenhouse gases /co2/;

alias  (i,j),(r,rr),(s,ss);

set	trade	/
	CNTRD,OTHTRD/;

set	nhw/
	hyd,nuc,wind/;

parameters
	vfm__(f,g,rs__)		Endowments - Firms' purchases at market prices,
	vdfm__(i,g,rs__)		Intermediates - firms' domestic purchases at market prices,
	vifm__(i,g,rs__,trade)	Intermediates - firms' imports at market prices,
	vxmd__(i,rs__,sr__)	Trade - bilateral exports at market prices,
	vst__(i,rs__)		Trade - exports for international transportation,
	vtwr__(i,rs__,sr__)	Trade - Margins for international transportation at world prices,
	vdtrm__(i,rs__)		domestic trade margin,
	vdst__(i,rs__)		domestic transport service for trade margin,
	vomnhw__(nhw,rs__)	Hydro, nuclear and wind data output,
	vdfmnhw__(i,nhw,rs__)	Intermediates,
	vfmnhw__(f,nhw,rs__)	Factor inputs,
	vom__(g,rs__)		Total supply at market prices;

$load vfm__=vfm vdfm__=vdfm vifm__=vifm vxmd__=vxmd vst__=vst vtwr__=vtwr vdtrm__=vdtrm vdst__=vdst vomnhw__=vomnhw vdfmnhw__=vdfmnhw vfmnhw__=vfmnhw vom__=vom

parameter 
vfm(f,g,rs)		
vdfm(i,g,rs)		
vifm(i,g,rs,trade)	
vxmd(i,rs,sr)	
vst(i,rs)		
vtwr(i,rs,sr)	
vdtrm(i,rs)		
vdst(i,rs)		
vomnhw(nhw,rs)	
vdfmnhw(i,nhw,rs)	
vfmnhw(f,nhw,rs)	
vom(g,rs);		

vfm(f,g,rs)=sum(maprs_(rs__,rs),vfm__(f,g,rs__));		
vdfm(i,g,rs)=sum(maprs_(rs__,rs),vdfm__(i,g,rs__));
vifm(i,g,rs,trade)=sum(maprs_(rs__,rs),vifm__(i,g,rs__,trade));
vxmd(i,rs,sr)=sum((maprs_(rs__,rs),mapsr_(sr__,sr)),vxmd__(i,rs__,sr__));
vst(i,rs)=sum(maprs_(rs__,rs),vst__(i,rs__));
vtwr(i,rs,sr)=sum((maprs_(rs__,rs),mapsr_(sr__,sr)),vtwr__(i,rs__,sr__));
vdtrm(i,rs)=sum(maprs_(rs__,rs),vdtrm__(i,rs__));
vdst(i,rs)=sum(maprs_(rs__,rs),vdst__(i,rs__));
vomnhw(nhw,rs)=sum(maprs_(rs__,rs),vomnhw__(nhw,rs__));
vdfmnhw(i,nhw,rs)=sum(maprs_(rs__,rs),vdfmnhw__(i,nhw,rs__));
vfmnhw(f,nhw,rs)=sum(maprs_(rs__,rs),vfmnhw__(f,nhw,rs__));
vom(g,rs)=sum(maprs_(rs__,rs),vom__(g,rs__));


if (nd>0,
	vfm(f,g,rs) = vfm(f,g,rs)$round(vfm(f,g,rs),nd);
	vdfm(i,g,rs) = vdfm(i,g,rs)$round(vdfm(i,g,rs),nd);
	vifm(i,g,rs,trade) = vifm(i,g,rs,trade)$round(vifm(i,g,rs,trade),nd);
	vxmd(i,rs,sr) = vxmd(i,rs,sr)$round(vxmd(i,rs,sr),nd);
	vst(i,rs) = vst(i,rs)$round(vst(i,rs),nd);
	vtwr(i,rs,sr) = vtwr(i,rs,sr)$round(vtwr(i,rs,sr),nd);
	vdtrm(i,rs)=vdtrm(i,rs)$round(vdtrm(i,rs),nd);
	vdst(i,rs)=vdst(i,rs)$round(vdst(i,rs),nd);
	vomnhw(nhw,rs)=vomnhw(nhw,rs)$round(vomnhw(nhw,rs),nd);
	vdfmnhw(i,nhw,rs)=vdfmnhw(i,nhw,rs)$round(vdfmnhw(i,nhw,rs),nd);
	vfmnhw(f,nhw,rs)=vfmnhw(f,nhw,rs)$round(vfmnhw(f,nhw,rs),nd);
	vom(g,rs)=vom(g,rs)$round(vom(g,rs),nd);
);

display vfm,vdfm,vifm,vxmd,vst,vtwr,vdtrm,vdst;

parameter
	eco2__(i,g,rs__)		Volume of carbon emissions (Mt);
$loaddc eco2__=eco2
parameter eco2(i,g,rs);

eco2(i,g,rs)=sum(maprs_(rs__,rs),eco2__(i,g,rs__));

if (nd>0,
	eco2(i,g,rs) = eco2(i,g,rs)$round(eco2(i,g,rs),nd);
);


parameter
	evd__(i,g,rs__)
	evt__(i,rs__,sr__);
parameter
	evd(i,g,rs) 
	evt(i,rs,sr);

$load evd__=evd
$load evt__=evt

evd(i,g,rs) = sum(maprs_(rs__,rs),evd__(i,g,rs__));
evt(i,rs,sr)= sum((maprs_(rs__,rs),mapsr_(sr__,sr)),evt__(i,rs__,sr__));


parameter
	rto__(g,rs__)	Output (or income) subsidy rates
	rtf__(f,g,rs__)	Primary factor and commodity rates taxes 
	rtfd__(i,g,rs__)	Firms domestic tax rates
	rtfi__(i,g,rs__)	Firms' import tax rates
	rtxs__(i,rs__,sr__)	Export subsidy rates
	rtms__(i,rs__,sr__)	Import taxes rates;

parameter
	rto(g,rs)	Output (or income) subsidy rates
	rtf(f,g,rs)	Primary factor and commodity rates taxes 
	rtfd(i,g,rs)	Firms domestic tax rates
	rtfi(i,g,rs)	Firms' import tax rates
	rtxs(i,rs,sr)	Export subsidy rates
	rtms(i,rs,sr)	Import taxes rates;

$load rto__=rto rtf__=rtf rtfd__=rtfd rtfi__=rtfi rtxs__=rtxs rtms__=rtms

rto(g,rs)	= sum(maprs_(rs__,rs),rto__(g,rs__));
rtf(f,g,rs)	= sum(maprs_(rs__,rs),rtf__(f,g,rs__));	
rtfd(i,g,rs)	= sum(maprs_(rs__,rs),rtfd__(i,g,rs__));	
rtfi(i,g,rs)	= sum(maprs_(rs__,rs),rtfi__(i,g,rs__));	
rtxs(i,rs,sr)	= sum((maprs_(rs__,rs),mapsr_(sr__,sr)),rtxs__(i,rs__,sr__));
rtms(i,rs,sr)	= sum((maprs_(rs__,rs),mapsr_(sr__,sr)),rtms__(i,rs__,sr__));


if (nd>0,
	rto(g,rs) = rto(g,rs)$round(rto(g,rs),nd);
	rtf(f,g,rs) = rtf(f,g,rs)$round(rtf(f,g,rs),nd);
	rtfd(i,g,rs) = rtfd(i,g,rs)$round(rtfd(i,g,rs),nd);
	rtfi(i,g,rs) = rtfi(i,g,rs)$round(rtfi(i,g,rs),nd);
	rtxs(i,rs,sr) = rtxs(i,rs,sr)$round(rtxs(i,rs,sr),nd);
	rtms(i,rs,sr) = rtms(i,rs,sr)$round(rtms(i,rs,sr),nd);

);


parameter
	esubd(i)	Elasticity of substitution (M versus D),
	esubva(g)	Elasticity of substitution between factors
	esubm(i)	Intra-import elasticity of substitution,
	etrae(f)	Elasticity of transformation,
	epslon(i)	Emission factor,
	eta__(i,rs__)	Income elasticity of demand,
	epsilon__(i,rs__)	Own-price elasticity of demand;

parameter
	eta(i,rs)	Income elasticity of demand;

$load epslon esubd esubva esubm etrae eta__=eta

eta(i,rs)=sum(maprs_(rs__,rs),eta__(i,rs__));


parameter 
	rescons__(rs__,g,i);
$load rescons__=rescons

display rescons__;


parameter 
	rescons(rs,g,i);

rescons(rs,g,i)=sum(maprs_(rs__,rs),rescons__(rs__,g,i));

if (nd>0,
	rescons(rs,g,i) = rescons(rs,g,i)$round(rescons(rs,g,i),nd);
);


parameter population__(rs__,yr);
$load population__=population

parameter population(rs,yr);
population(rs,yr)=sum(maprs_(rs__,rs),population__(rs__,yr));

if (nd>0,
	population(rs,yr) = population(rs,yr)$round(population(rs,yr),nd);
);



*----------------------------------------------------------------
*	Declare some intermediate arrays which are required to 
*	evaluate tax rates:

parameter	vdm(g,rs)	Aggregate demand for domestic output;
vdm(i,rs) = sum(g, vdfm(i,g,rs))+sum(nhw,vdfmnhw(i,nhw,rs));


parameter
	rtf0(f,g,rs)	Primary factor and commodity rates taxes 
	rtfd0(i,g,rs)	Firms domestic tax rates
	rtfi0(i,g,rs)	Firms' import tax rates
	rtxs0(i,rs,sr)	Export subsidy rates
	rtms0(i,rs,sr)	Import taxes rates;

rtf0(f,g,rs) = rtf(f,g,rs);
rtfd0(i,g,rs) = rtfd(i,g,rs);
rtfi0(i,g,rs) = rtfi(i,g,rs);
rtxs0(i,rs,sr) = rtxs(i,rs,sr);
rtms0(i,rs,sr) = rtms(i,rs,sr);

parameter	pvxmd(i,sr,rs)	Import price (power of benchmark tariff)
		pvtwr(i,sr,rs)	Import price for transport services;

pvxmd(i,sr,rs) = (1+rtms0(i,sr,rs)) * (1-rtxs0(i,sr,rs));
pvtwr(i,sr,rs) = 1+rtms0(i,sr,rs);



parameter	
	vtw(j)		Aggregate international transportation services,
	vim(i,rs,trade)	Aggregate imports,
	evom(f,rs,*,*)	Aggregate factor endowment at market prices,
	vfms(f,g,rs)	Factor endownments by household,
	vb(*)		Current account balance;

vtw(j) = sum(rs, vst(j,rs));

vdm("c",rs) = vom("c",rs);
vdm("g",rs) = vom("g",rs);

vim(i,rs,"CNTRD") =  sum(g, vifm(i,g,rs,"CNTRD"));
vim(i,rs,"OTHTRD") =  sum(g, vifm(i,g,rs,"OTHTRD"));

vtw(i) = sum(rs,vst(i,rs));

vfms(f,"c",rs) = sum(g, vfm(f,g,rs))+sum(nhw,vfmnhw(f,nhw,rs));


vb(s) = vom("c",s) + vom("g",s) + vom("i",s) 
	- sum(f,  vfms(f,"c",s))
	- sum(j,  vom(j,s)*rto(j,s))-sum(nhw,vomnhw(nhw,s)*rto("ele",s))
	- sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))-sum(nhw,sum(i,vdfmnhw(i,nhw,s)*rtfd(i,"ele",s)))
	- sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))-sum(nhw,vfmnhw("lab",nhw,s)*rtf("lab","ele",s))-sum(nhw,vfmnhw("cap",nhw,s)*rtf("cap","ele",s))-sum(nhw,vfmnhw("res",nhw,s)*rtf("cap","ele",s))
	- sum((i,rs), rtms(i,rs,s) *  (vxmd(i,rs,s) * (1-rtxs(i,rs,s)) + vtwr(i,rs,s)))
	+ sum((i,rs), rtxs(i,s,rs) * vxmd(i,s,rs));

vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, vfms(f,"c",r))
	- sum(j,  vom(j,r)*rto(j,r))-sum(nhw,vomnhw(nhw,r)*rto("ele",r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) +(vifm(i,g,r,"CNTRD")+vifm(i,g,r,"OTHTRD"))*rtfi(i,g,r)))-sum(nhw,sum(i,vdfmnhw(i,nhw,r)*rtfd(i,"ele",r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))-sum(nhw,vfmnhw("lab",nhw,r)*rtf("lab","ele",r))-sum(nhw,vfmnhw("cap",nhw,r)*rtf("cap","ele",r))-sum(nhw,vfmnhw("res",nhw,r)*rtf("cap","ele",r))
	- sum((i,s), rtms(i,s,r) *  (vxmd(i,s,r) * (1-rtxs(i,s,r)) + vtwr(i,s,r)))
	+ sum((i,s), rtxs(i,r,s) * vxmd(i,r,s));

vb("chksum") = sum(rs, vb(rs));

display vb;




parameter       mprofit Zero profit for m,
                yprofit Zero profit for y;

mprofit(i,s) = sum(trade,vim(i,s,trade)) - sum(rs, pvxmd(i,rs,s)*vxmd(i,rs,s)+vtwr(i,rs,s)*pvtwr(i,rs,s));
mprofit(i,r) = sum(trade,vim(i,r,trade)) - sum(s, pvxmd(i,s,r)*vxmd(i,s,r)+vtwr(i,s,r)*pvtwr(i,s,r))-sum(rr,vxmd(i,rr,r)+vtwr(i,rr,r));
mprofit(i,rs) = round(mprofit(i,rs),4);

display mprofit;

yprofit(g,rs)$(not sameas(g,"ele")) = vom(g,rs)*(1-rto(g,rs))-sum(i, vdfm(i,g,rs)*(1+rtfd0(i,g,rs))
        + sum(trade,vifm(i,g,rs,trade))*(1+rtfi0(i,g,rs))) - sum(f, vfm(f,g,rs)*(1+rtf0(f,g,rs)));
yprofit("ele",rs) = vom("ele",rs)*(1-rto("ele",rs))-sum(i, vdfm(i,"ele",rs)*(1+rtfd0(i,"ele",rs))
        + sum(trade,vifm(i,"ele",rs,trade))*(1+rtfi0(i,"ele",rs))) - sum(f, vfm(f,"ele",rs)*(1+rtf0(f,"ele",rs)));

yprofit(i,rs) = round(yprofit(i,rs),4)
display yprofit;



*	Define a numeraire region for denominating international
*	transfers:

rnum(rs) = yes$(vom("c",rs)=smax(sr,vom("c",sr)));
display rnum;



