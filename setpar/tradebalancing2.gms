$ontext

        Production activities   A (30) (1-30)
        Commodities             C (30) (31-60)
        Primary Factors         F (2)  (61-62: 61:labor, 62: capital)
        Households              H (1)  (63)
        Central Government      G1(1)  (64)
        Provincial Government   G2(1)  (65)
        Types of taxes          T (4)  (66-69: 66: production tax, 67: commodity tax, 68: factor tax, 69: income tax)
        Rest of country         DX(1)  (70: domestic inflow and outflow)
        Rest of world           X (1)  (71: import and export)
        Investment-savings      I (2)  (72: Capital formation, 73: Inventory change)
        Trade margin            M (1)  (74)

Here is a "MAP" of the SAM with the names of the submatrices which
contain data.  All cells with no labels are empty:



           A       C        F       H      G1      G2       T       DX      X      I1      I2      M
        ------------------------------------------------------------------------------------------------
A       |       |   ac  |       |       |       |       |   sa  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
C       |   ca  |       |       |   ch  |       |  g2d  |       |   der |   er  |  cs1  |  cs2  |  trn  |
        ------------------------------------------------------------------------------------------------
F       |   fa  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
H       |       |       |   hf  |       |       |  hg2  |       |   dhr |   hr  |       |       |       |
        ------------------------------------------------------------------------------------------------
G1      |       |       |       |       |       |  g1g2 |       |       |       |  cg1s |       |       |
        ------------------------------------------------------------------------------------------------
G2      |       |       |       |       | g2g1  |       |   tr  |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
T       |   ta  |       |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
DX      |       |  drc  |       |  drh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
X       |       |   rc  |       |   rh  |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I1      |       |       |   dp  |  psv1 | g1sv  |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
I2      |       |   ic  |       |  psv2 |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
M       |       |   mrg |       |       |       |       |       |       |       |       |       |       |
        ------------------------------------------------------------------------------------------------
$offtext

$setlocal inputfolder '../rawdata'


*SAM table
set     i_   SAM rows and colums indices   /
        1*30    Industries,
        31*60   Commodities,
        61      Labor,
        62      Capital,
        63      Household,
        64      Central Government,
        65      Local Government,
        66      Production tax,
        67      Commodity tax,
        68      Factor tax,
        69      Income tax,
        70      Domestic trade,
        71      Foreign trade,
        72      Investment,
        73      Inventory,
        74      Domestic trade margin/;
alias (i_,j_);

set     rs     All regions (intra- and international)/
	CHN,JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW,BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
alias (rs,sr,rsrsrs);

set     r_  China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
set     r(rs)   China provinces       /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
alias	(r,rr,rrr);

*       Map r_ set to new r:
*       Hunan has the same abrev. with Hungary, so its abbrev. has been changed to HNA...
set     mapr(r_,rs) /
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
        HUN.HNA
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

parameter sam4__(r_,i_,j_)           SAM v4;
$gdxin '%inputfolder%/sam4.gdx'
$load sam4__=sam4
$gdxin


parameter sam4_(rs,i_,j_) SAM data;
sam4_(rs,i_,j_)=sum(mapr(r_,rs),sam4__(r_,i_,j_));

display sam4_;

parameter temp;
temp(rs,i_)=sam4_(rs,i_,"63");
display temp;
$exit

set
        s(rs)   Inter-national regions (GTAP);
$gdxin '%inputfolder%/chinamodel2.gdx'
$load s=r
$gdxin
alias(s,ss);


set     province(rs);
set     GTAPregions(rs);

province(r)=yes;
GTAPregions(s)=yes;



*----------------------------------------------------------------------------------
*        BACKCHANGE RMB TO 2007 US DOLLAR
*----------------------------------------------------------------------------------
* The exchange rate from RMB to US dollar is 7.5215
* China's GDP is 26,581 billion yuan in 2007 and 15,988 billion yuan in 2007. The ratio is 1.6626.
sam4_(rs,i_,j_)=sam4_(rs,i_,j_)/7.5215;
sam4_(rs,i_,j_)$(sam4_(rs,i_,j_)<0.01)=0;

*----------------------------------------------------------------------------------
*        SECTOR AGGREGATION TO BE COMSISTENT WITH GTAP
*----------------------------------------------------------------------------------
set     i   SAM rows and colums indices   /
        1*26    Industries,
        27*52   Commodities,
        53      Labor,
        54      Capital,
        55      Household,
        56      Central Government,
        57      Local Government,
        58      Production tax,
        59      Commodity tax,
        60      Factor tax,
        61      Income tax,
        62      Domestic trade,
        63      Foreign trade,
        64      Investment,
        65      Inventory,
        66      Domestic trade margin/;
alias (i,j);


$ONTEXT
	1	AGR
	2	COL
	3	CRU
	4	GAS
	5	OMN
	6	FBT
	7	TEX
	8	CLO
	9	LUM
	10	PPP
	11	OIL
	12	CRP
	13	NMM
	14	MSP
	15	FMP
	16	OME
	17	TME
	18	ELQ
	19	OMF
	20	ELE
	21	GDT
	22	WTR
	23	CON
	24	TRD
	25	TRP
	26	OTH

$OFFTEXT

set     mapi(i_,i)/
        1.1
        2.2
        3.3
        4.5
        5.5
        6.6
        7.7
        8.8
        9.9
        10.10
        11.11
        12.12
        13.13
        14.14
        15.15
        16.16
        17.17
        18.16
        19.18
        20.16
        21.19
        22.19
        23.20
        24.21
        25.22
        26.23
        27.25
        28.24
        29.26
        30.4
        31.27
        32.28
        33.29
        34.31
        35.31
        36.32
        37.33
        38.34
        39.35
        40.36
        41.37
        42.38
        43.39
        44.40
        45.41
        46.42
        47.43
        48.42
        49.44
        50.42
        51.45
        52.45
        53.46
        54.47
        55.48
        56.49
        57.51
        58.50
        59.52
        60.30
        61.53
        62.54
        63.55
        64.56
        65.57
        66.58
        67.59
        68.60
        69.61
        70.62
        71.63
        72.64
        73.65
        74.66
/;
set     mapj(j_,j)/
        1.1
        2.2
        3.3
        4.5
        5.5
        6.6
        7.7
        8.8
        9.9
        10.10
        11.11
        12.12
        13.13
        14.14
        15.15
        16.16
        17.17
        18.16
        19.18
        20.16
        21.19
        22.19
        23.20
        24.21
        25.22
        26.23
        27.25
        28.24
        29.26
        30.4
        31.27
        32.28
        33.29
        34.31
        35.31
        36.32
        37.33
        38.34
        39.35
        40.36
        41.37
        42.38
        43.39
        44.40
        45.41
        46.42
        47.43
        48.42
        49.44
        50.42
        51.45
        52.45
        53.46
        54.47
        55.48
        56.49
        57.51
        58.50
        59.52
        60.30
        61.53
        62.54
        63.55
        64.56
        65.57
        66.58
        67.59
        68.60
        69.61
        70.62
        71.63
        72.64
        73.65
        74.66
/;
parameter sam4(rs,i,j) AGGREGATED SAM DATA;
sam4(rs,i,j)=sum(mapi(i_,i),sum(mapj(j_,j),sam4_(rs,i_,j_)));


set mapij(i,j)/
        1.27
        2.28
        3.29
        4.30
        5.31
        6.32
        7.33
        8.34
        9.35
        10.36
        11.37
        12.38
        13.39
        14.40
        15.41
        16.42
        17.43
        18.44
        19.45
        20.46
        21.47
        22.48
        23.49
        24.50
        25.51
        26.52
/;



*-------------------------------------------------------------------
*       CHECK ENERGY TRADE DATA
*-------------------------------------------------------------------

parameter 
	pricemargin_(r_,i_),
	pricemargin(r,i_);

$gdxin '%inputfolder%/pricemargin.gdx'
$load	pricemargin_=pricemargin
$gdxin
pricemargin(r,i_)=sum(mapr(r_,r),pricemargin_(r_,i_));

* Price seen by exporter is different from price seen by importer, the price difference 
* is taken by the transport service provider. 
* This happens when estimating bilateral (domestic) trade flows. 
* For domestic export, value (vxmd, not aggregated export value sam(r,j,"62")) should be divided by expprice.

parameter price(r,i),expprice(r,i);
price(r,"2")=pricemargin(r,"2")+2*pricemargin(r,"4");
price(r,"3")=pricemargin(r,"3")+2*pricemargin(r,"6");
price(r,"4")=pricemargin(r,"30")+2*pricemargin(r,"60");
price(r,"11")=pricemargin(r,"11")+2*pricemargin(r,"22");
price(r,"20")=pricemargin(r,"23")+2*pricemargin(r,"46");
price(r,"21")=pricemargin(r,"24")+2*pricemargin(r,"48");

expprice(r,"2")=pricemargin(r,"2");
expprice(r,"3")=pricemargin(r,"3");
expprice(r,"4")=pricemargin(r,"30");
expprice(r,"11")=pricemargin(r,"11");
expprice(r,"20")=pricemargin(r,"23");
expprice(r,"21")=pricemargin(r,"24");

parameter evx,evi;

evx(i,r)$(price(r,i))=sum(mapij(i,j),sam4(r,j,"63"))*7.5215*10/expprice(r,i);
evi(i,r)$(price(r,i))=sum(mapij(i,j),sam4(r,"63",j))*7.5215*10/expprice(r,i);

parameter totimpc,totimpg,totexpc,totexpg;

totimpc(i)=sum(r,evi(i,r));

totexpc(i)=sum(r,evx(i,r));

display totimpc,totexpc;


*coal use in ele
parameter coalele;
coalele=sum(r,sam4(r,"28","20")*7.5215*10/price(r,"2"));
*coalele(R)=sam4(r,"28","20");
display coalele;

*ele output
parameter eleopt;
eleopt=sum(r,sam4(r,"20","46"));
display eleopt;

*ele int
parameter eleint;
eleint=coalele*2.66/eleopt;
display eleint;


parameter evd,eco2;
evd("2",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"28",j)*7.5215/(price(r,"2"))*10;
evd("3",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"29",j)*7.5215/(price(r,"3"))*10;
evd("4",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"30",j)*7.5215/(price(r,"4"))*10;
evd("11",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"37",j)*7.5215/(price(r,"11"))*10;
evd("21",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"47",j)*7.5215/(price(r,"21"))*10;
evd("20",j,r)$((ord(j)<>62) and (ord(j)<>63))=sam4(r,"46",j)*7.5215/(price(r,"20"))*10;
eco2("2",j,r)=evd("2",j,r)*2.66;
eco2("3",j,r)=evd("3",j,r)*2.02;
eco2("4",j,r)=evd("4",j,r)*1.47;
eco2("11",j,r)=evd("11",j,r)*2.02;
eco2("21",j,r)=evd("21",j,r)*1.47;
eco2("2","11",r)=0;
eco2("2","21",r)=0;
eco2("3","11",r)=0;
eco2("3","21",r)=0;
eco2("4","11",r)=0;
eco2("4","21",r)=0;
parameter 
	totco2(i),
	totco2chnc;
totco2(i)=sum((j,r),eco2(i,j,r));
totco2chnc=sum(i,totco2(i));
display totco2chnc;

*$exit

*-------------------------------------------------------------------
*       Read GTAP data:
*-------------------------------------------------------------------
set tp_(i)/25/;

parameter       vxmd(i,rs,sr)              Trade - bilateral exports at market prices;
parameter       vst_(tp_,rs)		     Exported transportation service;
parameter       vtwr_(tp_,i,rs,sr)	     Trade margin;
parameter       rtms(i,rs,sr)              Import tax rate;
parameter       rtxs(i,rs,sr)              Export tax rate;


$gdxin '%inputfolder%/chinamodel2.gdx'
$load vxmd
$load vst_=vst
$load vtwr_=vtwr
$load rtms
$load rtxs
$gdxin

parameter       vxmdexp(i)              China's export by sector;
vxmdexp(i)=sum(rs,vxmd(i,"CHN",rs));
parameter       vxmdimp(i)              China's import by sector;
vxmdimp(i)=sum(rs,vxmd(i,rs,"CHN"));
display vxmdexp,vxmdimp;




*----------------------------------------------------------------------------------
*       DISTRIBUTION OF IMPORT AND EXPORT DATA
*----------------------------------------------------------------------------------
* Find the sector which has positive imp/exp in GTAP, but zero in China data
set	simpi(i),sexpi(i);
parameter	chntotexp(i);
parameter	chntotimp(i);
loop(i,
loop(j$(ord(j)=ord(i)+26),
chntotexp(i)=sum(r,sam4(r,j,"63"));
if((chntotexp(i)=0) and (vxmdexp(i)>0),
sexpi(i)=yes;
);
);
);
loop(i,
loop(j$(ord(j)=ord(i)+26),
chntotimp(i)=sum(r,sam4(r,"63",j));
if((chntotimp(i)=0) and (vxmdimp(i)>0),
simpi(i)=yes;
);
);
);

display chntotexp,chntotimp;
display simpi,sexpi;

* Fix the imp/exp problem
parameter isupply(r);
parameter itotsupply;
loop(i$(simpi(i)),
loop(j$(ord(j)=ord(i)+26),
isupply(r)=sam4(r,i,j);
* Should use consumption data... that is more reasonable
itotsupply=sum(r,isupply(r));
sam4(r,"63",j)=vxmdimp(i)/itotsupply*isupply(r);
);
);


loop(i$(sexpi(i)),
loop(j$(ord(j)=ord(i)+26),
isupply(r)=sam4(r,i,j);
itotsupply=sum(r,isupply(r));
sam4(r,j,"63")=vxmdexp(i)/itotsupply*isupply(r);
);
);



$ontext
* There is no export for crude oil in China data, but positive value in GTAP data
parameter       oilsupply(r);
oilsupply(r)=sam4(r,"3","29");
parameter       totoilsupply;
totoilsupply=sum(r,oilsupply(r));
sam4(r,"3","29")=sam4(r,"3","29")+vxmdexp("3")/totoilsupply*oilsupply(r);
sam4(r,"29","63")=vxmdexp("3")/totoilsupply*oilsupply(r);


* There is no import for gas in China data, but positive value in GTAP data 
parameter       gassupply(r);
gassupply(r)=sam4(r,"4","30");
parameter       totgassupply;
totgassupply=sum(r,gassupply(r));
sam4(r,"63","30")=vxmdimp("4")/totgassupply*gassupply(r);
$offtext

* Calculation of China's import and export by sector from China data
parameter vim_(j,rs);
vim_(j,rs)$((ord(j)>=27) and (ord(j)<=52))=sam4(rs,"63",j);
parameter vxm_(i,rs);
vxm_(j,rs)$((ord(j)>=27) and (ord(j)<=52))=sam4(rs,j,"63");
parameter vim(i,rs);
vim(i,rs)=sum(mapij(i,j),vim_(j,rs));
parameter vxm(i,rs);
vxm(i,rs)=sum(mapij(i,j),vxm_(j,rs));

parameter totvim(i),totvxm(i);
totvim(i)=sum(rs,vim(i,rs));
totvxm(i)=sum(rs,vxm(i,rs));

* Distribute national import and export among provinces
vxmd(i,rs,sr)$(province(rs) and gtapregions(sr))=vxmd(i,"CHN",sr)/sum(rsrsrs,(vxm(i,rsrsrs)))*vxm(i,rs);
vxmd(i,rs,sr)$(province(sr) and gtapregions(rs) and (sum(rsrsrs,(vim(i,rsrsrs)))))=vxmd(i,rs,"CHN")/sum(rsrsrs,(vim(i,rsrsrs)))*vim(i,sr);
*display vxmd;


vxmd(i,"CHN",r)=0;
vxmd(i,r,"CHN")=0;




* Adjustment of SAM table
sam4(r,j,"63")$((ord(j)>=27) and (ord(j)<=52))=sum(mapij(i,j),sum(s,vxmd(i,r,s)));
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sum(mapij(i,j),sum(s,vxmd(i,s,r)*(1-rtxs(i,s,"CHN"))));


*----------------------------------------------------------------------------------
*       DISTRIBUTION OF TRADE MARGIN
*----------------------------------------------------------------------------------
parameter       vtwr(i,rs,sr)         Trade margin;
vtwr(i,rs,sr)=sum(tp_,vtwr_(tp_,i,rs,sr));


vtwr(i,rs,sr)$(province(rs) and gtapregions(sr) and sum(rsrsrs,vxm(i,rsrsrs)))=vtwr(i,"CHN",sr)/sum(rsrsrs,vxm(i,rsrsrs))*vxm(i,rs);
vtwr(i,rs,sr)$(province(sr) and gtapregions(rs) and (sum(rsrsrs,(vim(i,rsrsrs)))))=vtwr(i,rs,"CHN")/sum(rsrsrs,(vim(i,rsrsrs)))*vim(i,sr);

* Add vtwr("CHN","CHN") to vtwr("USA","CHN")
vtwr(i,"USA",r)=vtwr(i,"USA",r)+vtwr(i,"CHN",r);
vtwr(i,"CHN",r)=0;

*Add import trade margin to the imports
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sam4(r,"63",j)+sum(mapij(i,j),sum(sr,vtwr(i,sr,r)));
sam4(r,"63",j)$((ord(j)>=27) and (ord(j)<=52))=sam4(r,"63",j)+sum((mapij(i,j),s),rtms(i,s,"CHN")*vxmd(i,s,r)*(1-rtxs(i,s,"CHN")))
+sum((mapij(i,j),s),vtwr(i,s,r)*rtms(i,s,"CHN"));
display vtwr;



*----------------------------------------------------------------------------------
*        ADJUSTMENT OF ENERGY PRICE
*----------------------------------------------------------------------------------

$ONTEXT
parameter pricescl,exppricescl;
pricescl(r,i)$(evi(i,r) and price(r,i))=sum(mapij(i,j),sam4(r,"63",j))*7.5215*10/evi(i,r)/price(r,i);
exppricescl(r,i)$(evx(i,r) and price(r,i))=sum(mapij(i,j),sam4(r,j,"63"))*7.5215*10/evx(i,r)/expprice(r,i);

display pricescl,exppricescl;
$OFFTEXT
*----------------------------------------------------------------------------------
*        DISTRIBUTION OF EXPORT TRANSPORTATION SERVICE
*----------------------------------------------------------------------------------
parameter       vst(rs);
vst(rs)=sum(tp_,vst_(tp_,rs));
parameter       trpsupply(rs);
trpsupply(r)=sam4(r,"25","51");
parameter       tottrpsupply;
tottrpsupply=sum(rs,trpsupply(rs));
vst(rs)$(province(rs))=vst("CHN")/tottrpsupply*trpsupply(rs);

sam4(rs,"51","63")$(province(rs))=sam4(rs,"51","63")+vst(rs);
sam4(rs,"25","51")$(province(rs))=sam4(rs,"25","51")+vst(rs);
*display vst;


*----------------------------------------------------------------------------------
*        ADD IMPORT TAX AND EXPORT SUBSIDY TO THE UNBALANCED SAM TABLE
*----------------------------------------------------------------------------------
$ontext
* Calculation of aggregated import tax rate and export subsidy rate
parameter       rtms(i,rs,rsrs)            Import tax rate;
parameter       rtxs(i,rs,rsrs)            Export subsidy rate;


tms(i,s,ss)=sum(mapii(i__,i),rtms_(i__,s,ss)*(1-rtxs_(i__,s,ss))*vxmd_(i__,s,ss)+vtwr_(i__,s,ss)*rtms_(i__,s,ss));
txs(i,s,ss)=sum(mapii(i__,i),rtxs_(i__,s,ss)*vxmd_(i__,s,ss));

rtxs(i,s,ss)$(vxmd(i,s,ss))=txs(i,s,ss)/vxmd(i,s,ss);
rtms(i,s,ss)$(vxmd(i,s,ss)+vtwr(i,s,ss))=tms(i,s,ss)/(vxmd(i,s,ss)*(1-rtxs(i,s,ss))+vtwr(i,s,ss));


* Calculate rtxs and rtms for each province
parameter       tms(i,s,r)             Total Import tax collected;
parameter       txs(i,r,s)             Total Export subsidy;

* Import tax collected by provinces
tms(i,s,r)=rtms(i,s,"CHN")*vxmd(i,s,r)*(1-rtxs(i,s,"CHN"))+vtwr(i,s,r)*rtms(i,s,"CHN");
sam4(r,"59",j)=sum(mapij(i,j),sum(s,tms(i,s,r)));


txs(i,r,s)=rtxs(i,"CHN",s)*vxmd(i,r,s);
* Subsidy rate is negative, so here we give positive value in sam
sam4(r,i,"59")=-sum(s,txs(i,r,s));


*display tms,txs;

sam4(r,"57","59")=sum(i,sam4(r,"59",i))-sum(i,sam4(r,i,"59"));

$offtext

*----------------------------------------------------------------------------------
*        MOVE THE INVENTORY DELETION TO PRODUCTION
*----------------------------------------------------------------------------------
loop(rs,
loop(j$((ord(j)>=27) and (ord(j)<=52)),
if(sam4(rs,"65",j)>0,
loop(i$(ord(i)=ord(j)-26),
sam4(rs,i,j)=sam4(rs,i,j)+sam4(rs,"65",j);
sam4(rs,"65",j)=0;
);
);
);
);

*----------------------------------------------------------------------------------
*        MOVE THE INVENTORY ADDITION TO INVESTMENT
*----------------------------------------------------------------------------------
loop(rs,
loop(j$((ord(j)>=27) and (ord(j)<=52)),
if(sam4(rs,j,"65")>0,
sam4(rs,j,"64")=sam4(rs,j,"64")+sam4(rs,"65",j);
sam4(rs,j,"65")=0;
);
);
);

sam4(rs,"55","65")=0;
sam4(rs,"65","55")=0;


*----------------------------------------------------------------------------------
*        FINAL BALANCING
*----------------------------------------------------------------------------------
positive variables finalsam (r,i,j)
positive variables rowsum(r,i)
positive variables columnsum(r,i)
positive variables domesticinsum(i)
positive variables domesticoutsum(i)
variable jj

Equations
        rsum
        csum
        sumbalance
        drcsum
        dxsum
        tradebalance
	fixtrdmrgshr
        expleprd
	notbigexp
	notbigimp
        obj
;

rsum(r,i)..
sum(j,finalsam(r,i,j))=e=rowsum(r,i);

csum(r,i)..
sum(j,finalsam(r,j,i))=e=columnsum(r,i);

sumbalance(r,i)..
rowsum(r,i)=e=columnsum(r,i);

drcsum(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticinsum(i)=e=sum(r,finalsam(r,"62",i));

* The share of trade margin should be fixed
fixtrdmrgshr(r,i)$((ord(i)>=27) and (ord(i)<=52) and (sam4(r,"62",i)))..
finalsam(r,"66",i)=e=sam4(r,"66",i)/sam4(r,"62",i)*finalsam(r,"62",i);

dxsum(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticoutsum(i)=e=sum(r,finalsam(r,i,"62"));

tradebalance(i)$((ord(i)>=27) and (ord(i)<=52))..
domesticinsum(i)=e=domesticoutsum(i);

*Export is less than or equal to production
expleprd(r,i,j)$(((ord(i)>=27) and (ord(i)<=52)) and (ord(j)=ord(i)-26))..
finalsam(r,j,i)=g=finalsam(r,i,"63")+finalsam(r,i,"62");

notbigexp(r,i)$(ord(i)=44)..
finalsam(r,i,"62")=l=sum(rr$(not sameas(r,rr)),finalsam(rr,"62",i));

notbigimp(r,i)$(ord(i)=44)..
finalsam(r,"62",i)=l=sum(rr$(not sameas(r,rr)),finalsam(rr,i,"62"));

obj..
*jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))));
jj=e=sum(r,sum(i,sum(j,sqr(finalsam(r,i,j)-sam4(r,i,j)))))+
10000*sum(r,sum(i$((ord(i)=28) or (ord(i)=29) or (ord(i)=30) or (ord(i)=37) or (ord(i)=46) or (ord(i)=47) or (ord(i)=62) or (ord(i)=63)),
sum(j$((ord(j)=2) or (ord(j)=3) or (ord(j)=4) or (ord(j)=11) or (ord(j)=20) or (ord(j)=21) or (ord(j)=62) or (ord(j)=63)),
sqr(finalsam(r,i,j)-sam4(r,i,j)))));





Model gua /all/;
loop(r,
loop(i,
loop(j,
finalsam.l(r,i,j)=sam4(r,i,j);
);););
*$ontext
* Make the foreign trade balancing term flexible to change
loop(r,
if(finalsam.l(r,"55","63")=0,finalsam.l(r,"55","63")=1e-6);
if(finalsam.l(r,"63","55")=0,finalsam.l(r,"63","55")=1e-6);
);
*$offtext

loop(r,
loop(i,
loop(j,
if (finalsam.l(r,i,j)=0,
finalsam.fx(r,i,j)=0;
);
);
);
);

* Fix international trade flow and its tax
finalsam.fx(r,i,"63")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"63");
finalsam.fx(r,"63",i)$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,"63",i);
finalsam.fx(r,i,"59")=finalsam.l(r,i,"59");
finalsam.fx(r,"59",i)=finalsam.l(r,"59",i);

* Fix private and government consumption as well as investment
finalsam.fx(r,i,"55")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"55");
finalsam.fx(r,i,"57")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"57");
finalsam.fx(r,i,"64")$((ord(i)>=27) and (ord(i)<=52))=finalsam.l(r,i,"64");

display finalsam.l;

* Fix cap, lab, coal and other input in electricity production
finalsam.fx(r,"53","20")=finalsam.l(r,"53","20");
finalsam.fx(r,"54","20")=finalsam.l(r,"54","20");
finalsam.fx(r,"28","20")=finalsam.l(r,"28","20");
finalsam.fx(r,"52","20")=finalsam.l(r,"52","20");

* Fix private electricity consumption
* finalsam.fx("hai","46","55")=finalsam.l("hai","46","55");


gua.iterlim=100000;
gua.reslim=100000000000;
gua.optfile=1;

option nlp=CONOPT;
Solve gua minimizing jj using nlp;
display finalsam.l;





set     negval5(i,j)     Flag for negative elements;
set     empty5(i,*)      Flag for empty rows and columns;
parameter       chkfinalsam(i,*)       Consistency check of social accounts;
parameter totoutput3(r);
loop(r,
totoutput3(r)=0;
);
loop(r,
loop(i$((ord(i)>=27) and (ord(i)<=52)),
totoutput3(r)=totoutput3(r)+sum(j,finalsam.l(r,i,j));
);
);

parameter totimp(i),totexp(i);
totimp(i)$((ord(i)>=27) and (ord(i)<=52))=sum(r,finalsam.l(r,"63",i));
totexp(i)$((ord(i)>=27) and (ord(i)<=52))=sum(r,finalsam.l(r,i,"63"));

parameter sam5(r,i,j);
loop(r,
loop(i,
loop(j,
sam5(r,i,j)= finalsam.l(r,i,j);
);
);
);


