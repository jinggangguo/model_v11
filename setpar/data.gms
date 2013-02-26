$title China model (GTAP data incorporated)

$setlocal inputfolder '..\rawdata'

*-------------------------------------------------------------------
*       Read SAM data:
*-------------------------------------------------------------------

set     i_   SAM rows and colums indices   /
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
alias  (i_,j_);
set	g_/
	1*66
	c
	g
	i/;

set     rs     All regions (intra- and international)/
	CHN,JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW,BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

alias   (rs,sr);
set     rs1(rs)     All regions (intra- and international) excluding China/
	JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW,BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
alias	(rs1,sr1);

set     r_ China provinces      /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HUN,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
set     r(rs) China provinces      /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;
set     mapr(r_,r) /
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
set	rnum(rs)	Numeraire region;



parameter sam(r,i_,j_) SAM data;
$gdxin '%inputfolder%/sam52.gdx'
$load sam=sam5
sam(r,i_,j_)$(abs(sam(r,i_,j_))<1e-6)=0;

*-------------------------------------------------------------------
*       RELABEL SETS:
*-------------------------------------------------------------------

SET     f    Factors /cap,lab,res/
        g    Goods and final demands/
        AGR     "Crop cultivation,Forestry,Livestock and livestock products and Fishery"
        COL     "Coal mining and processing"
        CRU     "Crude petroleum products"
        GAS     "natural gas products"
        OMN     "Metal minerals mining & Non-metal minerals and other mining"   
        FBT     "Food, baverage and tobacco"
        TEX     "Textiles"   
        CLO     "Wearing apparel, leather, furs, down and related products"
        LUM     "Logging and transport of timber and furniture"
        PPP     "Paper, printing, record medium reproduction, cultural goods, toys, sporting and recreation products"
        OIL     "Petroleum refining, coking and nuclear fuels"
        CRP     "Chemical engineering"
        NMM     "Non-metallic mineral products"   
        MSP     "Metal smelting and processing"
        FMP     "Metal product"
        OME     "General and special industrial machinery and equipment & Electric machinery and equipment & Instruments, meters ,other measuring equipment and cultural and office equipment"   
        TME     "Transport machinery and equipment"
        ELQ     "Communicatoin, computer and other electronic machinery and equipment"
        OMF     "Arts and crafts products and other manufacturing  product & Scrap and waste"
        ELE     "Electricity production and supply, and steam and hot water production and supply"
        GDT     "Gas production and supply"
        WTR     "Water production and supply"
        CON     "Construction"
        TRD     "Wholesale and retail trade, Hotels and restraunts"   
        TRP     "Transportation and warehousing, Post"   
        OTH     "Other service industry"
        c       "Private consumption"
	hh1
	hh2
        g       "Government"
        i       "Investment"
        /

        i(g)    "Goods and sectors" /
        AGR     "Crop cultivation,Forestry,Livestock and livestock products and Fishery"
        COL     "Coal mining and processing"
        CRU     "Crude petroleum products"
        GAS     "natural gas products"
        OMN     "Metal minerals mining & Non-metal minerals and other mining"
        FBT     "Food, baverage and tobacco"
        TEX     "Textiles"
        CLO     "Wearing apparel, leather, furs, down and related products"
        LUM     "Logging and transport of timber and furniture"
        PPP     "Paper, printing, record medium reproduction, cultural goods, toys, sporting and recreation products"
        OIL     "Petroleum refining, coking and nuclear fuels"
        CRP     "Chemical engineering"
        NMM     "Non-metallic mineral products"
        MSP     "Metal smelting and processing"
        FMP     "Metal product"
        OME     "General and special industrial machinery and equipment & Electric machinery and equipment & Instruments, meters ,other measuring equipment and cultural and office equipment"
        TME     "Transport machinery and equipment"
        ELQ     "Communicatoin, computer and other electronic machinery and equipment"
        OMF     "Arts and crafts products and other manufacturing  product & Scrap and waste"
        ELE     "Electricity production and supply, and steam and hot water production and supply"
        GDT     "Gas production and supply"
        WTR     "Water production and supply"
        CON     "Construction"
        TRD     "Wholesale and retail trade, Hotels and restraunts"
        TRP     "Transportation and warehousing, Post"
        OTH     "Other service industry"
        /
        ;

set	ires(i);
ires("agr")=yes;
ires("col")=yes;
ires("cru")=yes;
ires("gas")=yes;
ires("omn")=yes;

alias (i,j) , (g,gg) , (r,rr,rrr);


set     
        h(g)            Households,
        c(g)            consumption end use ("c" for gtap + h for China);

c("c") = yes;
h("hh1")=yes;
h("hh2")=yes;
c(h) = yes;


alias(h,hh);

display c;

set	e(i)	/COL,CRU,GAS,OIL,ELE,GDT/,
	pe(e)	/COL,CRU,GAS/;

*       Map i set to new subsets:

set     mapf(i_,f) /
        53.lab
        54.cap/,

        mapic(i_,i) /
	1.AGR
	2.COL
	3.CRU
	4.GAS
	5.OMN
	6.FBT
	7.TEX
	8.CLO
	9.LUM
	10.PPP
	11.OIL
	12.CRP
	13.NMM
	14.MSP
	15.FMP
	16.OME
	17.TME
	18.ELQ
	19.OMF
	20.ELE
	21.GDT
	22.WTR
	23.CON
	24.TRD
	25.TRP
	26.OTH
        /

        mapjc(j_,j) /
	27.AGR
	28.COL
	29.CRU
	30.GAS
	31.OMN
	32.FBT
	33.TEX
	34.CLO
	35.LUM
	36.PPP
	37.OIL
	38.CRP
	39.NMM
	40.MSP
	41.FMP
	42.OME
	43.TME
	44.ELQ
	45.OMF
	46.ELE
	47.GDT
	48.WTR
	49.CON
	50.TRD
	51.TRP
	52.OTH
        /
        mapgc(g_,g) /
	1.AGR
	2.COL
	3.CRU
	4.GAS
	5.OMN
	6.FBT
	7.TEX
	8.CLO
	9.LUM
	10.PPP
	11.OIL
	12.CRP
	13.NMM
	14.MSP
	15.FMP
	16.OME
	17.TME
	18.ELQ
	19.OMF
	20.ELE
	21.GDT
	22.WTR
	23.CON
	24.TRD
	25.TRP
	26.OTH
	c.c
	i.i
	g.g
        /
        gov(g) Government agents /
        g 
        /
        maph(i_,g) /55.c/
        mapg(i_,gov) /56.g,57.g/
        mapinv(i_,g) /64.i/;

alias (gov,govv);
set     trd Domestic and foreign markets /dtrd,ftrd/
        tb  Trade surplus or deficit /s,d/;


*-------------------------------------------------------------------
*       Read GTAP and china data:
*-------------------------------------------------------------------
set
        s(rs)   Inter-national regions (GTAP)   /
	CHN,JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW
        /

	s1(rs)   Inter-national regions (GTAP)   /
	JPN,KOR,IDN,IND,CAN,USA,MEX,ARG,BRA,FRA,DEU,ITA,GBR,RUS,TUR,ZAF,ANZ,REU,TSG,SSA,MEN,LAM,FSU,ASI,ROW
        /;
alias(s,ss);
set	china(rs)/
	CHN/;

set     province(rs);
set     GTAPregions(rs);
province(r)=yes;
GTAPregions(s)=yes;
*------------------
*      rtms,rtxs
*------------------
parameter

	rtxs_(i_,rs,sr)	"Export subsidy rate"
	rtms_(i_,rs,sr)	"Import subsidy rate"
	rtxs__(i_,rs,sr)	"Export subsidy rate"
	rtms__(i_,rs,sr)	"Import subsidy rate"

	rtxs(i,rs,sr)	"Export subsidy rate"
	rtms(i,rs,sr)	"Import subsidy rate";
$gdxin '%inputfolder%/chinamodel2.gdx'
$load rtms_=rtms
$load rtxs_=rtxs
$gdxin
rtxs(i,rs,sr)$((gtapregions(rs)) and (gtapregions(sr)))=sum(mapic(i_,i),rtxs_(i_,rs,sr));
rtms(i,rs,sr)$((gtapregions(rs)) and (gtapregions(sr)))=sum(mapic(i_,i),rtms_(i_,rs,sr));


rtxs(i,r,s)=rtxs(i,"CHN",s);
rtxs(i,s,r)=rtxs(i,s,"CHN");
rtms(i,r,s)=rtms(i,"CHN",s);
rtms(i,s,r)=rtms(i,s,"CHN");



*------------------
*    vxmd,vtwr,vst
*------------------
parameter
       vxmd_(i_,rs,sr) Trade - bilateral exports at market prices,
       vtwr_(i_,rs,sr) Trade - Margins for international transportation at world prices
       vxmd(i,rs,sr) Trade - bilateral exports at market prices,
       vtwr(i,rs,sr) Trade - Margins for international transportation at world prices
       vst(i,rs),
       vst_(rs);
$gdxin '%inputfolder%/sam52.gdx'
$load vxmd_=vxmd
$load vtwr_=vtwr
$load vst_=vst
$gdxin
vst("trp",rs)=vst_(rs);
*vst("trp",rs)$(vst("trp",rs)<1e-8)=0;

$ontext
parameter vst__;
vst__=sum(r,vst("trp",r));
display vst__;
$offtext


vxmd(i,rs,sr)=sum(mapic(i_,i),vxmd_(i_,rs,sr));
*vxmd(i,rs,sr)$(vxmd(i,rs,sr)<1e-8)=0;

parameter vxmdchn(i,s);
vxmdchn(i,s)=sum(r,vxmd(i,r,s));
display vxmdchn;


parameter
       vxmd__(i_,rs,sr) Trade - domestic trade
       vtwr__(i_,rs,sr);
$gdxin '%inputfolder%/dtrd.gdx'
$load vxmd__=vxmd_
$load vtwr__=vtwr_
$gdxin
vxmd(i,r,rr)=sum(mapjc(i_,i),vxmd__(i_,r,rr));


vtwr(i,rs,sr)=sum(mapic(i_,i),vtwr_(i_,rs,sr));
vtwr(i,r,rr)=sum(mapjc(i_,i),vtwr__(i_,r,rr));


*vtwr(i,rs,sr)$(vtwr(i,rs,sr)<1e-8)=0;

$ontext
parameter vtwrchn(i,s);
vtwrchn(i,s)=sum(r,vtwr(i,r,s));
display vtwrchn;
$offtext


*parameter
*        vtrdm(g,rs)     "Trade margins"
*        vtrnm(i,rs)     "Transportation margins";
*       Trade margins:
*vtrdm(i,r) = sum(mapjc(i_,i),sam(r,"66",i_));
*       Transport margins:
*vtrnm(i,r) = sum(mapjc(i_,i),sam(r,i_,"66"));
*vtwr(i,rr,r)$(sum(rrr,vxmd(i,rrr,r)))=vtrdm(i,r)*vxmd(i,rr,r)/sum(rrr,vxmd(i,rrr,r));
*vtwr(i,rr,r)$(vtwr(i,rr,r)<1e-8)=0;

*vxmd(i,rs,sr)$(vxmd(i,rs,sr)<1e-8)=0;
*vtwr(i,rs,sr)$(vtwr(i,rs,sr)<1e-8)=0;



*-----------------------
*    rtf,rtfd,rtfi
*-----------------------
parameter
	rtf(f,g,rs)	Primary factor and commodity rates taxes 
	rtfd(i,g,rs)	Firms domestic tax rates
	rtfi(i,g,rs)	Firms' import tax rates
	rtf_(f,g_,s)	Primary factor and commodity rates taxes 
	rtfd_(i_,g_,s)	Firms domestic tax rates
	rtfi_(i_,g_,s)	Firms' import tax rates;

$gdxin '%inputfolder%/chinamodel2.gdx'
$load rtf_=rtf 
$load rtfd_=rtfd
$load rtfi_=rtfi 
rtf(f,g,s)=sum(mapgc(g_,g),rtf_(f,g_,s));
rtfd(i,g,s)=sum((mapic(i_,i),mapgc(g_,g)),rtfd_(i_,g_,s)); 
rtfi(i,g,s)=sum((mapic(i_,i),mapgc(g_,g)),rtfi_(i_,g_,s)); 

*--------------------------
*    vfm,vdfm,vifm,vdm,vom
*--------------------------
parameters
	vfm_(f,g_,s)	Endowments - Firms' purchases at market prices,
	vfm(f,g,rs)	Endowments - Firms' purchases at market prices;
$gdxin '%inputfolder%/chinamodel2.gdx'
$load vfm_=vfm
$gdxin
vfm(f,g,s)=sum(mapgc(g_,g),vfm_(f,g_,s));
vfm(f,i,r)=sum(mapf(j_,f),sum(mapic(i_,i),sam(r,j_,i_)));
* Add resource input in China region
vfm("res",i,r)$(ires(i))=vfm("cap",i,r)*vfm("res",i,"chn")/(vfm("res",i,"chn")+vfm("cap",i,"chn"));
vfm("cap",i,r)$(ires(i))=vfm("cap",i,r)-vfm("res",i,r);
*vfm(f,g,rs)$(vfm(f,g,rs)<1e-8)=0;
display vfm;

parameters
	vdfm_(i_,g_,s)	Intermediates - firms' domestic purchases at market prices,
	vifm_(i_,g_,s)	Intermediates - firms' imports at market prices,
	vdfm(i,g,rs)	Intermediates - firms' domestic purchases at market prices,
	vifm__(i,g,rs)	Intermediates - firms' imports at market prices,
	vafm(i,g,rs)	Intermediates armington - China;
$gdxin '%inputfolder%/chinamodel2.gdx'
$load vdfm_=vdfm
$load vifm_=vifm
$gdxin
vdfm(i,g,s)=sum((mapic(i_,i),mapgc(g_,g)),vdfm_(i_,g_,s));

vifm__(i,g,s)=sum((mapic(i_,i),mapgc(g_,g)),vifm_(i_,g_,s));


set	trade	/
	CNTRD,OTHTRD/;

parameter vifm(i,g,rs,trade);
vifm(i,g,s,"CNTRD")$((sum(rs1,(1+rtms(i,rs1,s))*vtwr(i,rs1,s))+sum(rs1,vxmd(i,rs1,s)*(1+rtms(i,rs1,s))*(1-rtxs(i,rs1,s)))))=
vifm__(i,g,s)*(sum(r,(1+rtms(i,r,s))*vtwr(i,r,s))+sum(r,vxmd(i,r,s)*(1+rtms(i,r,s))*(1-rtxs(i,r,s))))/
(sum(rs1,(1+rtms(i,rs1,s))*vtwr(i,rs1,s))+sum(rs1,vxmd(i,rs1,s)*(1+rtms(i,rs1,s))*(1-rtxs(i,rs1,s))));
vifm(i,g,s,"OTHTRD")$((sum(rs1,(1+rtms(i,rs1,s))*vtwr(i,rs1,s))+sum(rs1,vxmd(i,rs1,s)*(1+rtms(i,rs1,s))*(1-rtxs(i,rs1,s)))))=
vifm__(i,g,s)*(sum(s1,(1+rtms(i,s1,s))*vtwr(i,s1,s))+sum(s1,vxmd(i,s1,s)*(1+rtms(i,s1,s))*(1-rtxs(i,s1,s))))/
(sum(rs1,(1+rtms(i,rs1,s))*vtwr(i,rs1,s))+sum(rs1,vxmd(i,rs1,s)*(1+rtms(i,rs1,s))*(1-rtxs(i,rs1,s))));


*vifm(i,g,s,"tot")=vifm(i,g,s,"CHN")+vifm(i,g,s,"OTH")-vifm__(i,g,s);
*display vifm;


*       Intermediate demands for Armington goods for provinces:
vafm(j,i,r) =  sum((mapic(i_,i),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,"c",r) =  sum((maph(i_,g),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,"i",r) =  sum((mapinv(i_,g),mapjc(j_,j)),sam(r,j_,i_));
vafm(j,"g",r) =  sum((mapg(i_,gov),mapjc(j_,j)),sam(r,j_,i_));

vafm(i,g,s) = max((vdfm(i,g,s)*(1+rtfd(i,g,s))+sum(trade,vifm(i,g,s,trade)*(1+rtfi(i,g,s)))),0);






*Total import by industry by province
parameters
	vim_(i,r,*);
parameters
	vdtrm(i,r)	domestic trade margin,
	vdst(i,rs)	domestic transport service for trade margin;
vdst(i,rs)=0;
vdtrm(i,r)=sum(rr,vtwr(i,rr,r));

vdst("trp",r)=sum(i,vdtrm(i,r));

*vdst("trp",r)$(vdst("trp",r)<1e-8)=0;
display vdtrm,vdst;


vim_(i,r,"OTHTRD")=sum(s1,(1+rtms(i,s1,r))*vtwr(i,s1,r))+sum(s1,vxmd(i,s1,r)*(1+rtms(i,s1,r))*(1-rtxs(i,s1,r)));
vim_(i,r,"CNTRD")=sum(rr,vxmd(i,rr,r)+vtwr(i,rr,r));
display vim_;



parameter totcons(i,r);
totcons(i,r)=sum(g,vafm(i,g,r));

vifm(i,g,r,"CNTRD")=0;
vifm(i,g,r,"OTHTRD")=0;

loop(r,
loop(i,
if((totcons(i,r)>0),
vifm(i,g,r,"CNTRD")=vim_(i,r,"CNTRD")*vafm(i,g,r)/totcons(i,r);
vifm(i,g,r,"OTHTRD")=vim_(i,r,"OTHTRD")*vafm(i,g,r)/totcons(i,r);
);
);
);

display vafm,vifm;


vdfm(i,g,r)=vafm(i,g,r)-vifm(i,g,r,"CNTRD")-vifm(i,g,r,"OTHTRD");
display vdfm;


parameter	vdm(g,rs)	Aggregate demand for domestic output,
		vom(g,rs)	Total supply at market prices,
		vom_(i,j_,rs)   
		vom2(g,rs);
vdm(i,rs) = sum(g, vdfm(i,g,rs));
display vdm,vst,vdst;



vom(i,s) = vdm(i,s)+sum(sr, vxmd(i,s,sr)$(not sameas(sr,"CHN"))) + vst(i,s)+vdst(i,s);

vom(i,r) =sum(s, vxmd(i,r,s))+sum(rr, vxmd(i,r,rr))+vst(i,r)+vdst(i,r)+vdm(i,r);
*-sum((mapic(i_,i),mapjc(j_,i)),sam(r,i_,j_));


vom(i,rs)$(vom(i,rs)<1e-8)=0;
display vom;
*$exit

vom("c",rs) = sum(i, vdfm(i,"c",rs)*(1+rtfd(i,"c",rs)) + (vifm(i,"c",rs,"CNTRD")+vifm(i,"c",rs,"OTHTRD"))*(1+rtfi(i,"c",rs)));
vom("g",rs) = sum(i, vdfm(i,"g",rs)*(1+rtfd(i,"g",rs)) + (vifm(i,"g",rs,"CNTRD")+vifm(i,"g",rs,"OTHTRD"))*(1+rtfi(i,"g",rs)));
vom("i",rs) = sum(i, vdfm(i,"i",rs)*(1+rtfd(i,"i",rs)) + (vifm(i,"i",rs,"CNTRD")+vifm(i,"i",rs,"OTHTRD"))*(1+rtfi(i,"i",rs)));
vdm("c",rs) = vom("c",rs);
vdm("g",rs) = vom("g",rs);

*-----------------------
*    energy parameters
*-----------------------
parameter 
	pricemargin_(r_,i_),
	pricemargin(r,i_);

$gdxin '%inputfolder%/pricemargin.gdx'
$load	pricemargin_=pricemargin
$gdxin
pricemargin(r,i_)=sum(mapr(r_,r),pricemargin_(r_,i_));

* Price seen by exporter is different from price seen by importer, the price difference 
* is taken by the transport service provider.

parameter price(r,i),expprice(r,i);
price(r,"col")=pricemargin(r,"2")+2*pricemargin(r,"4");
price(r,"cru")=pricemargin(r,"3")+2*pricemargin(r,"6");
price(r,"gas")=pricemargin(r,"30")+2*pricemargin(r,"60");
price(r,"oil")=pricemargin(r,"11")+2*pricemargin(r,"22");
price(r,"gdt")=pricemargin(r,"24")+2*pricemargin(r,"48");
price(r,"ele")=pricemargin(r,"23")+2*pricemargin(r,"46");

expprice(r,"col")=pricemargin(r,"2");
expprice(r,"cru")=pricemargin(r,"3");
expprice(r,"gas")=pricemargin(r,"30");
expprice(r,"oil")=pricemargin(r,"11");
expprice(r,"gdt")=pricemargin(r,"24");
expprice(r,"ele")=pricemargin(r,"23");


display price;

parameter
	evd(i,g,rs)
        evd_(i_,g_,rs)    usage of domestic product by firms (mtoe)
	evt(i,rs,sr)
	evt_(i_,rs,sr);
$gdxin '%inputfolder%/chinamodel2.gdx'
$load evd_=evd 
$load evt_=evt


* Mtoe -> Mtce
evd(i,g,rs)=sum((mapic(i_,i),mapgc(g_,g)),evd_(i_,g_,rs)*1.4286);
evt(i,rs,sr)=sum(mapic(i_,i),evt_(i_,rs,sr)*1.4286);
display evd,evt;

parameter eprod;
eprod(rs,i)=sum(g,evd(i,g,rs))+sum(sr,evt(i,rs,sr))-sum(sr,evt(i,sr,rs));
display eprod;

* evd for China
evd("col",g,r)=vafm("col",g,r)*7.5215/(price(r,"col"))*10;
evd("cru",g,r)=vafm("cru",g,r)*7.5215/(price(r,"cru"))*10;
evd("gas",g,r)=vafm("gas",g,r)*7.5215/(price(r,"gas"))*10;
evd("oil",g,r)=vafm("oil",g,r)*7.5215/(price(r,"oil"))*10;
evd("gdt",g,r)=vafm("gdt",g,r)*7.5215/(price(r,"gdt"))*10;
evd("ele",g,r)=vafm("ele",g,r)*7.5215/(price(r,"ele"))*10;


* evd for domestic trade flows and flows related to China

evt(i,r,rr)$expprice(r,i)=vxmd(i,r,rr)*7.5215*10/expprice(r,i);
evt(i,r,s1)$((expprice(r,i)) and (sum(s1.local,vxmd(i,r,s1))))=sum(mapjc(i_,i),sam(r,i_,"63"))*7.5215*10/expprice(r,i)*vxmd(i,r,s1)/sum(s1.local,vxmd(i,r,s1));
evt(i,s1,r)$((price(r,i)) and sum(s1.local,vxmd(i,s1,r)))=sum(mapjc(i_,i),sam(r,"63",i_))*7.5215*10/price(r,i)*vxmd(i,s1,r)/sum(s1.local,vxmd(i,s1,r));


* Compare differences between energy data in GTAP and China data
parameter totimpc,totimpg,totexpc,totexpg;

totimpc(i)=sum(r,sum(s1,evt(i,s1,r)));
totimpg(i)=sum(s1,evt(i,s1,"chn"));

totexpc(i)=sum(r,sum(s1,evt(i,r,s1)));
totexpg(i)=sum(s1,evt(i,"chn",s1));

display totimpc,totimpg,totexpc,totexpg;

*------------------
*      rto
*------------------
parameter
	rto_(g_,rs)        "Output tax rate"
	rto(g,rs)          "Output tax rate";
$gdxin '%inputfolder%/chinamodel2.gdx'
$load rto_=rto
$gdxin
	rto(g,s)=sum(mapgc(g_,g),rto_(g_,s));
parameters
        vtax(g,rs)      "Output tax payments"
        vtax_(g,rs)      "Output tax payments"
        vsub(g,rs)      "Output subsidy payments"
        vsub_(g,rs)      "Output subsidy payments";
	rto(g,r)=0;
*       Output/subsidy taxes:
	vtax_(i,r) = sum(mapic(i_,i),sam(r,"58",i_));
	vsub_(i,r) = sum(mapic(i_,i),sam(r,i_,"58"));


*	After aggregation, some sectors may have both positive tax and subsidy
	vtax(i,r)$(vtax_(i,r)-vsub_(i,r))=vtax_(i,r)-vsub_(i,r);
	vsub(i,r)$(-vtax_(i,r)+vsub_(i,r))=-vtax_(i,r)+vsub_(i,r);
	rto(i,r)$(vom(i,r) and (vtax(i,r)))=vtax(i,r)/vom(i,r);
	rto(i,r)$(vom(i,r) and (vsub(i,r)))=-vsub(i,r)/vom(i,r);
	
display rto;


*----------------------------------------
*      esubd esubva esubm etrae eta
*----------------------------------------

parameter
	esubd_(i_)	Elasticity of substitution (M versus D),
	esubd(i)	Elasticity of substitution (M versus D),
	esubva_(g_)	Elasticity of substitution between factors,
	esubva(g)	Elasticity of substitution between factors,
	esubm_(i_)	Intra-import elasticity of substitution,
	esubm(i)	Intra-import elasticity of substitution,
	etrae(f)	Elasticity of transformation,
	eta_(i_,rs)	Income elasticity of demand,
	eta(i,rs)	Income elasticity of demand;

$gdxin '%inputfolder%/chinamodel2.gdx'
$load esubd_=esubd
$load esubva_=esubva
$load esubm_=esubm
$load etrae
$load eta_=eta
$gdxin

esubd(i)=sum(mapic(i_,i),esubd_(i_));
esubva(g)=sum(mapgc(g_,g),esubva_(g_));
esubm(i)=sum(mapic(i_,i),esubm_(i_));
eta(i,s)=sum(mapic(i_,i),eta_(i_,s));
eta(i,r)=eta(i,"CHN");



*----------------------------------------
*      BALANCE TESTING
*----------------------------------------


$ontext
parameter profit;
profit(j,rs) = vom(j,rs)*(1 - rto(j,rs))
		- sum(i, vdfm(i,j,rs)*(1+ rtfd(i,j,rs)))
		- sum(i, sum(trade,vifm(i,j,rs,trade))*(1+rtfi(i,j,rs)))
		- sum(f, vfm(f,j,rs)*(1+rtf(f,j,rs)));

profit(j,rs)= 0$(abs(profit(j,rs))<1e-8);
display profit;



parameter			
   			
	pvxmd(i,rs,sr)	"Import price (power of benchmark tariff)"
	pvtwr(i,rs,sr)	"Import price for transport services"
			
	vtw(i)		"Aggregate international transportation services"
	vim(i,rs,*)	"Aggregate imports"
	evom(f,rs)	"Aggregate factor endowment at market prices"
	vb(*)		"Current account balance";

pvxmd(i,rs,sr) = (1+rtms(i,rs,sr)) * (1-rtxs(i,rs,sr));
pvtwr(i,rs,sr) = 1+rtms(i,rs,sr);

vim(i,rs,"CNTRD") =  sum(g, vifm(i,g,rs,"CNTRD"));
vim(i,rs,"OTHTRD") =  sum(g, vifm(i,g,rs,"OTHTRD"));

vtw(i) = sum(rs1,vst(i,rs1));



evom(f,rs) = sum(g, vfm(f,g,rs));

vb(s) = vom("c",s) + vom("g",s) + vom("i",s) 
	- sum(f,  evom(f,s))
	- sum(j,  vom(j,s)*rto(j,s))
	- sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))
	- sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))
	- sum((i,rs1), rtms(i,rs1,s) *  (vxmd(i,rs1,s) * (1-rtxs(i,rs1,s)) + vtwr(i,rs1,s)))
	+ sum((i,rs1), rtxs(i,s,rs1) * vxmd(i,s,rs1));


vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, evom(f,r))
	- sum(j,  vom(j,r)*rto(j,r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) +(vifm(i,g,r,"CNTRD")+vifm(i,g,r,"OTHTRD"))*rtfi(i,g,r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
	- sum((i,s1), rtms(i,s1,r) *  (vxmd(i,s1,r) * (1-rtxs(i,s1,r)) + vtwr(i,s1,r)))
	+ sum((i,s1), rtxs(i,r,s1) * vxmd(i,r,s1));

vb("chksum1") = sum(s, vb(s));
vb("chksum2") = sum(rs1, vb(rs1));
vb("chksum3") = sum(rs, vb(rs));
display vb;

$exit
$offtext



*$exit




*-----------------------------------------------------------------*
*	SPLIT HYDRO, NUC AND WIND FROM ELEC			  *
*-----------------------------------------------------------------*

parameter
        vomnhw           Output of nuc, hyd and wind
        vfmnhw           Factor inputs for nuc,hyd and wind
        vdfmnhw          Inputs for nuc, hyd and win;

set nhw /nuc,hyd,wind/;

parameter chkvfm;
chkvfm(f,rs) = 1;

*Iterations to avoid negative imputed vfm after including nuclear,hydro and wind 
set iter /1*100/;


parameter shrnhwoutput,idneg,idneglog,vom4__,vfm__,vafm__,vdfm__;

idneg(rs) = 0;
vom4__(i,rs) = vom(i,rs);
vfm__(f,i,rs) = vfm(f,i,rs);
vafm__(i,g,rs) = vafm(i,g,rs);
vdfm__(i,g,rs) = vdfm(i,g,rs);


*** CODE THAT separates nuc, hyd and wind from total electricity generation:
*$ontext
* Data for 2006 (should be better if 2007 data is available, from USREP/integrated.gdx)
table nhoutput(rs,nhw)
	hyd		nuc
ANZ	3.196765914	
ARG	0.760120557	0.196497657
BRA	25.98051136	0.940344571
CAN	17.11085319	4.537675671
CHN	17.12105865	2.444059888
FRA	3.844252309	28.77914821
IDN	0.688480436	
ITA	6.450417636	
JPN	13.44971453	40.38531912
RUS	10.4196828	8.575675755
ZAF	0.028319341	0.398408407
KOR	0.30950388	9.343371757
TUR	4.165333162	
GBR	0.499705989	8.254383529
USA	19.78705876	59.36008153
REU	30.07585061	34.9950246
DEU	2.908325623	23.05258909
IND	0.688480436		

LAM	14.5213527	0.196497657
TSG	0.200347926	2.464716384
FSU	2.427469073
SSA	4.12229254
MEN	1.64146963
ASI	5.584917109	0.216074658
ROW	12.64227847	13.45014003



;

parameter shrnhw(nhw,*,rs);
shrnhw(nhw,"output",rs)=nhoutput(rs,nhw)/vom4__("ele",rs);

table shrnhw_(r,nhw)
	hyd		nuc		wind  
ANH	0.0230				      
BEJ	0.0176				      
CHQ	0.2104				      
FUJ	0.3003				0.0038
GAN	0.3048				0.0050
GUD	0.0861		0.1121		0.0014
GXI	0.4730		
GZH	0.2592
HAI	0.1053				0.0008
HEB	0.0077				0.0043
HEN	0.0488		
HLJ	0.0117				0.0052
HUB	0.6055		
HNA	0.3513		
JIL	0.1118				0.0128	
JSU	0.0011		0.0354		0.0007
JXI	0.1478		
LIA	0.0091				0.0030
NMG	0.0077				0.0079
NXA	0.0375				0.0011
QIH	0.6788			
SHA	0.0806		
SHD	0.0008				0.0010
SHH					0.0005
SHX	0.0148
SIC	0.6321
TAJ	0.0003
XIN	0.1667				0.0119
YUN	0.4762
ZHJ	0.0625		0.1091		0.0002
;

shrnhw(nhw,"output",r)=shrnhw_(r,nhw);
*Input share of hyd
table shrhyd_(f,rs)
	CHN	JPN	IND	CAN	USA	BRA	RUS	ARG	ROW	TUR	REU	ANZ	GBR	DEU	FRA	ITA	IDN	ZAF	KOR	LAM	TSG	FSU	SSA	MEN	ASI	
cap	0.55	0.6	0.6	0.5	0.6	0.08	0.2	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	
lab	0.1	0.05	0.05	0.15	0.05	0.42	0.09	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	
res	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3	0.3
;



shrnhw("hyd","cap",rs)=shrhyd_("cap",rs);
shrnhw("hyd","cap",r)=0.55;
shrnhw("hyd","lab",rs)=shrhyd_("lab",rs);
shrnhw("hyd","lab",r)=0.1;
shrnhw("hyd","res",rs)=shrhyd_("res",rs);
shrnhw("hyd","res",r)=0.3;

table shrhydi_(i,rs)
	CHN	JPN	IND	CAN	USA	BRA	RUS	ARG	ROW	TUR	REU	ANZ	GBR	DEU	FRA	ITA	IDN	ZAF	KOR	LAM	TSG	FSU	SSA	MEN	ASI	
COL	0.02		0.01		0.01		0.01		0.01	0.01	0.01	0.01	0.01	0.01			0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	
OIL		0.01	0.01	0.01		0.03	0.02																																														
CON		0.01																									
OTH	0.03	0.03	0.03	0.03	0.03	0.11	0.07	0.04	0.03	0.03	0.03	0.03	0.03	0.03	0.04	0.04	0.03	0.03	0.03	0.03	0.03	0.03	0.03	0.03	0.03
TRD				0.005	0.005	0.01	0.20	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005
TRP				0.005	0.005	0.01	0.06	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005			
GAS						0.01	0.05
ELQ						0.03
;

shrnhw("hyd","COL",rs)=shrhydi_("COL",rs);
shrnhw("hyd","COL",r)=0.02;
shrnhw("hyd","OTH",rs)=shrhydi_("OTH",rs);
shrnhw("hyd","OTH",r)=0.03;
shrnhw("hyd","OIL",rs)=shrhydi_("OIL",rs);
shrnhw("hyd","CON",rs)=shrhydi_("CON",rs);
shrnhw("hyd","TRD",rs)=shrhydi_("TRD",rs);
shrnhw("hyd","TRP",rs)=shrhydi_("TRP",rs);
shrnhw("hyd","GAS",rs)=shrhydi_("GAS",rs);
shrnhw("hyd","ELQ",rs)=shrhydi_("ELQ",rs);



*Input share of nuc
table shrnuc_(f,rs)
	CHN	JPN	IND	CAN	USA	BRA	RUS	ARG	ROW	TUR	REU	ANZ	GBR	DEU	FRA	ITA	IDN	ZAF	KOR	LAM	TSG	FSU	SSA	MEN	ASI	
cap	0.55	0.55	0.55	0.55	0.55	0.2	0.2	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	0.55	
lab	0.25	0.25	0.25	0.25	0.25		0.3	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	0.25	
res	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	0.15	
;
shrnhw("nuc","cap",rs)=shrnuc_("cap",rs);
shrnhw("nuc","cap",r)=0.55;
shrnhw("nuc","lab",rs)=shrnuc_("lab",rs);
shrnhw("nuc","lab",r)=0.25;
shrnhw("nuc","res",rs)=shrnuc_("res",rs);
shrnhw("nuc","res",r)=0.15;


table shrnuci_(i,rs)
	CHN	JPN	IND	CAN	USA	BRA	RUS	ARG	ROW	TUR	REU	ANZ	GBR	DEU	FRA	ITA	IDN	ZAF	KOR	LAM	TSG	FSU	SSA	MEN	ASI	
COL	0.02		0.01		0.01				0.01	0.01	0.01	0.01	0.01	0.01			0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	
OIL		0.01	0.01	0.01		0.22																																						
CON		0.01																									
OTH	0.03	0.03	0.03	0.03	0.03	0.20	0.08	0.04	0.03	0.03	0.03	0.03	0.03	0.03	0.04	0.04	0.03	0.03	0.03	0.03	0.03	0.03	0.03	0.03	0.03		
TRD				0.005	0.005	0.05	0.19	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	
TRP				0.005	0.005	0.05	0.05	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005	0.005						
GAS						0.05	0.03
ELQ						0.04
PPP						0.02
CRP						0.02
;

shrnhw("nuc","COL",rs)=shrnuci_("COL",rs);
shrnhw("nuc","COL",r)=0.02;
shrnhw("nuc","OTH",rs)=shrnuci_("OTH",rs);
shrnhw("nuc","OTH",r)=0.03;
shrnhw("nuc","OIL",rs)=shrnuci_("OIL",rs);
shrnhw("nuc","CON",rs)=shrnuci_("CON",rs);
shrnhw("nuc","TRD",rs)=shrnuci_("TRD",rs);
shrnhw("nuc","TRP",rs)=shrnuci_("TRP",rs);
shrnhw("nuc","CRU",rs)=shrnuci_("CRU",rs);
shrnhw("nuc","GAS",rs)=shrnuci_("GAS",rs);
shrnhw("nuc","ELQ",rs)=shrnuci_("ELQ",rs);
shrnhw("nuc","PPP",rs)=shrnuci_("PPP",rs);
shrnhw("nuc","CRP",rs)=shrnuci_("CRP",rs);

*Input share of wind
shrnhw("wind","cap",rs)=0.6;
shrnhw("wind","lab",rs)=0.1;
shrnhw("wind","res",rs)=0.3;


display shrnhw;
*N.B.: The EPPA data has substantially undervalued China's hyd and nuc generation.



*display vdfm;
*$exit
* Set to record negative input
set negf(f,rs),negi(i,rs);

loop(iter,

*       Reduce share of nuclear and hydro if imputed capital demand for non-nuclear+hydro is negative:
shrnhw(nhw,"output",rs)$idneg(rs) = shrnhw(nhw,"output",rs) * (1-0.01*ord(iter));

*       Iteration log:
shrnhwoutput(nhw,rs,iter) = shrnhw(nhw,"output",rs);

*       Nuclear and hydro output:
vomnhw(nhw,rs) =  shrnhw(nhw,"output",rs) * vom4__("ele",rs);

*       Input demands:
vfmnhw("lab",nhw,rs) = shrnhw(nhw,"lab",rs) * vomnhw(nhw,rs) * (1-rto("ele",rs))/(1+rtf("lab","ele",rs));
vfmnhw("cap",nhw,rs)$(1+rtf("cap","ele",rs)) = shrnhw(nhw,"cap",rs) * vomnhw(nhw,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
vfmnhw("res",nhw,rs)$(1+rtf("cap","ele",rs)) = shrnhw(nhw,"res",rs) * vomnhw(nhw,rs) * (1-rto("ele",rs))/(1+rtf("cap","ele",rs));
*vdfmnhw(i,nhw,rs)$vafm__(i,"ele",rs) = vafm__(i,"ele",rs)/sum(i.local,vafm__(i,"ele",rs)) *  
*sum(i.local,shrnhw(rs,i,nhw)) * vomnhw(nhw,rs)* (1-rto("ele",rs))/(1+rtfd(i,"ele",rs));
vdfmnhw(i,nhw,rs)= shrnhw(nhw,i,rs) * vomnhw(nhw,rs)* (1-rto("ele",rs))/(1+rtfd(i,"ele",rs));

*       Recalibrate output, capital, and labor, srv, and oth for electricity generated from fossil fuel:
vom("ele",rs) = vom4__("ele",rs) - sum(nhw,vomnhw(nhw,rs));

vfm("lab","ele",rs) = vfm__("lab","ele",rs) - sum(nhw,vfmnhw("lab",nhw,rs));
vfm("cap","ele",rs) = vfm__("cap","ele",rs) - sum(nhw,vfmnhw("cap",nhw,rs))-sum(nhw,vfmnhw("res",nhw,rs));
vafm(i,"ele",rs) = vafm__(i,"ele",rs) - sum(nhw,vdfmnhw(i,nhw,rs))*(1+rtfd(i,"ele",rs));
vdfm(i,"ele",rs) = vdfm__(i,"ele",rs) - sum(nhw,vdfmnhw(i,nhw,rs));



*       Check sign of imputed values:
chkvfm(f,rs) = vfm(f,"ele",rs)$(vfm(f,"ele",rs) lt -1e-12);
negf(f,rs)$(vfm(f,"ele",rs) lt -1e-12)=yes;
chkvfm(i,rs) = vdfm(i,"ele",rs)$(vdfm(i,"ele",rs) lt -1e-12);
negi(i,rs)$(vdfm(i,"ele",rs) lt -1e-12)=yes;

*       Identify negative values and record log:
idneg(rs) = 1$(chkvfm("cap",rs) lt -1e-12 or chkvfm("lab",rs) lt -1e-12 or sum(i,chkvfm(i,rs)) lt -1e-12);
idneglog(rs,iter) = idneg(rs);

);


shrnhwoutput(nhw,rs,"%dev")$shrnhwoutput(nhw,rs,"1") = 100*(shrnhwoutput(nhw,rs,"100") / shrnhwoutput(nhw,rs,"1")-1);

abort$(smin((rs,f),chkvfm(f,rs)) lt -1e-5) "Imputed vfm is negative (see mergedata.gms)",chkvfm;
abort$(smin((rs,i),chkvfm(i,rs)) lt -1e-5) "Imputed vafm is negative (see mergedata.gms)",chkvfm;

display idneg,idneglog,shrnhwoutput,negf,negi;



*$exit


*       Zero profit for nuclear and hydro electicity generation:

parameter zprf_nhw;
zprf_nhw(rs,nhw) = vomnhw(nhw,rs)*(1-rto("ele",rs))
                                - vfmnhw("cap",nhw,rs)*(1+rtf("cap","ele",rs))
                                - vfmnhw("lab",nhw,rs)*(1+rtf("lab","ele",rs))
                                - vfmnhw("res",nhw,rs)*(1+rtf("cap","ele",rs))
                                - sum(i,vdfmnhw(i,nhw,rs)*(1+rtfd(i,"ele",rs)));
display zprf_nhw;

parameter zprf_ele;
zprf_ele(rs) = vom("ele",rs) * (1-rto("ele",rs))
                - sum(i,vafm(i,"ele",rs))
                - sum(f,vfm(f,"ele",rs)*(1+rtf(f,"ele",rs)));


display zprf_ele;




parameter profit;

profit("ele",rs) = vom("ele",rs)*(1 - rto("ele",rs))
		- sum(i, vdfm(i,"ele",rs)*(1+ rtfd(i,"ele",rs)))
		- sum(i, sum(trade,vifm(i,"ele",rs,trade))*(1+rtfi(i,"ele",rs)))
		- sum(f, vfm(f,"ele",rs)*(1+rtf(f,"ele",rs)));

display profit;





*abort$(abs(smin(rs,sum(nhw,zprf_nhww(rs,nhw))+zprf_ele(rs))) gt 1e-8) "Zero profit conditions for electricity production does not hold (see loaddata.gms)";


*display rtf,rto;


*--------------------------------------------------------------------------
*       Do a CES calibration to a given price supply elasticity for nuclear and hydro:

PARAMETER neta          Price elasticity of supply for nuclear,
          heta          Price elasticity of supply for hydro,
          sharenhw       Cost share of nuclear or hydro
          sigmanhw       Elasticity of substitution between value added and nuclear or hydro resource;

*       Price supply elasticity from EPPA 4 (assumed to be identical across all China provinces):

neta(rs)=0.5;
neta("usa")=0.25;
neta("eur")=0.50;
neta("jpn")=0.60;
neta("can")=0.40;
neta("rus")=0.25;
neta("roe")=0.25;
neta("asi")=0.60;
neta("chn")=0.60;
neta("ind")=0.60;

heta(rs)=0.5;
heta("jpn")=0.25;
heta("anz")=0.25;


*	Treat existing hydro as including renewables, and calculate a pric supply elasticity
*	that is a weigted average of hydro elasticity (=0.5) and elasticity for 
*	for renewable electricity supply (LOW and HIGH).
*heta("ca")=0.52*0.5+0.48*etabs;
*heta("az")=0.99*0.5+0.01*etabs;
*heta("nv")=0.4*0.5+0.6*etabs;
*heta("ut")=0.22*0.5+0.78*etabs;
*heta("paci")=0.04*0.5+0.96*etabs;

sharenhw(nhw,rs)$vomnhw(nhw,rs) = vfmnhw("res",nhw,rs)/vomnhw(nhw,rs);
sigmanhw("nuc",rs)$(1-sharenhw("nuc",rs))= neta(rs)*sharenhw("nuc",rs)/(1-sharenhw("nuc",rs));
sigmanhw("hyd",rs)$(1-sharenhw("hyd",rs))= heta(rs)*sharenhw("hyd",rs)/(1-sharenhw("hyd",rs));
sigmanhw("wind",rs)$(1-sharenhw("wind",rs))= heta(rs)*sharenhw("wind",rs)/(1-sharenhw("wind",rs));


*$offtext



*-----------------------------------------------------------------*
*	OTHER IMPUTED PARAMETER  			          *
*-----------------------------------------------------------------*

parameter			
   			
	pvxmd(i,rs,sr)	"Import price (power of benchmark tariff)"
	pvtwr(i,rs,sr)	"Import price for transport services"
			
	vtw(i)		"Aggregate international transportation services"
	vim(i,rs,*)	"Aggregate imports"
	vfms(f,g,rs)	"Factor endownment by household"
	evom(f,rs,*,*)	"Aggregate factor endowment at market prices"
	vb(*)		"Current account balance";


pvxmd(i,rs,sr) = (1+rtms(i,rs,sr)) * (1-rtxs(i,rs,sr));
pvtwr(i,rs,sr) = 1+rtms(i,rs,sr);

vim(i,rs,"CNTRD") =  sum(g, vifm(i,g,rs,"CNTRD"));
vim(i,rs,"OTHTRD") =  sum(g, vifm(i,g,rs,"OTHTRD"));

vtw(i) = sum(rs1,vst(i,rs1));

vfms(f,"c",rs) = sum(g, vfm(f,g,rs))+sum(nhw,vfmnhw(f,nhw,rs));




vb(s) = vom("c",s) + vom("g",s) + vom("i",s) 
	- sum(f,  vfms(f,"c",s))
	- sum(j,  vom(j,s)*rto(j,s))-sum(nhw,vomnhw(nhw,s)*rto("ele",s))
	- sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + (vifm(i,g,s,"CNTRD")+vifm(i,g,s,"OTHTRD"))*rtfi(i,g,s)))-sum(nhw,sum(i,vdfmnhw(i,nhw,s)*rtfd(i,"ele",s)))
	- sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))-sum(nhw,vfmnhw("lab",nhw,s)*rtf("lab","ele",s))-sum(nhw,vfmnhw("cap",nhw,s)*rtf("cap","ele",s))-sum(nhw,vfmnhw("res",nhw,s)*rtf("cap","ele",s))
	- sum((i,rs1), rtms(i,rs1,s) *  (vxmd(i,rs1,s) * (1-rtxs(i,rs1,s)) + vtwr(i,rs1,s)))
	+ sum((i,rs1), rtxs(i,s,rs1) * vxmd(i,s,rs1));

vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, vfms(f,"c",r))
	- sum(j,  vom(j,r)*rto(j,r))-sum(nhw,vomnhw(nhw,r)*rto("ele",r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) +(vifm(i,g,r,"CNTRD")+vifm(i,g,r,"OTHTRD"))*rtfi(i,g,r)))-sum(nhw,sum(i,vdfmnhw(i,nhw,r)*rtfd(i,"ele",r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))-sum(nhw,vfmnhw("lab",nhw,r)*rtf("lab","ele",r))-sum(nhw,vfmnhw("cap",nhw,r)*rtf("cap","ele",r))-sum(nhw,vfmnhw("res",nhw,r)*rtf("cap","ele",r))
	- sum((i,s1), rtms(i,s1,r) *  (vxmd(i,s1,r) * (1-rtxs(i,s1,r)) + vtwr(i,s1,r)))
	+ sum((i,s1), rtxs(i,r,s1) * vxmd(i,r,s1));

vb("chksum") = sum(rs1, vb(rs1));

display vb;



*$offtext



*----------------------------------------
*      eco2
*----------------------------------------

parameter
	eco2_(i_,g_,rs)	Volume of carbon emissions (Mt),
	eco2(i,g,rs)	Volume of carbon emissions (Mt);
$gdxin '%inputfolder%/chinamodel2.gdx'
$load eco2_=eco2
$gdxin

eco2(i,g,rs)=sum((mapic(i_,i),mapgc(g_,g)),eco2_(i_,g_,rs));


* Emission factor from CAS DING, Zhongli
*eco2("col",g,rs1)=evd("col",g,rs1)*2.66;
*eco2("cru",g,rs1)=evd("cru",g,rs1)*2.02;
*eco2("gas",g,rs1)=evd("gas",g,rs1)*1.47;
*eco2("oil",g,rs1)=evd("oil",g,rs1)*2.02;
*eco2("gdt",g,rs1)=evd("gdt",g,rs1)*1.47;

parameter epslon(i);
epslon("col")=2.77;
epslon("cru")=2.15;
epslon("gas")=1.64;
epslon("oil")=2.15;
epslon("gdt")=1.64;

* Emission factor from IPCC
eco2("col",g,rs)=evd("col",g,rs)*epslon("col");
eco2("cru",g,rs)=evd("cru",g,rs)*epslon("cru");
eco2("gas",g,rs)=evd("gas",g,rs)*epslon("gas");
eco2("oil",g,rs)=evd("oil",g,rs)*epslon("oil");
eco2("gdt",g,rs)=evd("gdt",g,rs)*epslon("gdt");

* Emission factor from IEA (emission factor by toe -> tce)
*3.96=2.77
*2.58=1.80
*2.35=1.64

eco2("col","oil",rs)=0;
eco2("col","gdt",rs)=0;
eco2("cru","oil",rs)=0;
eco2("cru","gdt",rs)=0;
eco2("gas","oil",rs)=0;
eco2("gas","gdt",rs)=0;





*-----------------------------------------------------------------*
*	Accounting of carbon emission of energy use in China      *
*-----------------------------------------------------------------*

parameter 
	totco2(i),
	totco2chnc,
	totco2chng;
totco2(i)=sum((g,r),eco2(i,g,r));
totco2chnc=sum(i,totco2(i));
totco2chng=sum((i,g),eco2(i,g,"CHN"));
display totco2chnc,totco2chng;


* Enery use in quantity from China data
parameter 	totq(r,i),totq2(r,i),totq3(rs,i);
*Primary energy use
totq(r,"col")=sum(g,evd("col",g,r));
totq(r,"cru")=sum(g,evd("cru",g,r));
totq(r,"gas")=sum(g,evd("gas",g,r));


*Secondary energy use
totq2(r,"col")=sum(g$((not sameas(g,"oil")) and (not sameas(g,"gdt")) and (not sameas(g,"gas")) and (not sameas(g,"ele"))),evd("col",g,r));
totq2(r,"cru")=sum(g$((not sameas(g,"oil")) and (not sameas(g,"gdt")) and (not sameas(g,"gas")) and (not sameas(g,"ele"))),evd("cru",g,r));
totq2(r,"gas")=sum(g$((not sameas(g,"oil")) and (not sameas(g,"gdt")) and (not sameas(g,"ele"))),evd("gas",g,r));
totq2(r,"oil")=sum(g,evd("oil",g,r));
totq2(r,"gdt")=sum(g,evd("gdt",g,r));
totq2(r,"ele")=sum(g,evd("ele",g,r));

*Energy production
totq3(rs1,i)=sum(g,evd(i,g,rs1))+sum(sr1,evt(i,rs1,sr1))-sum(sr1,evt(i,sr1,rs1));

display totq,totq2;

parameter eprodchnc;
eprodchnc(i)=sum(r,totq3(r,i));
display eprodchnc;

parameter coalele;
coalele=sum(r,evd("col","ele",r));
display coalele;



*-----------------------------------------------------------------*
*	HOUSEHOLD INFORMATION      			          *
*-----------------------------------------------------------------*
set i__ /1*42/;

parameter rescons_(r_,*,i__),rescons(rs,g,i);
$gdxin '..\rawdata\urbanrural.gdx'
$load rescons_=rescons
$gdxin

set mapic2(i__,i) /
	1.AGR
	2.COL
	3.GAS
	4.OMN
	5.OMN
	6.FBT
	7.TEX
	8.CLO
	9.LUM
	10.PPP
	11.OIL
	12.CRP
	13.NMM
	14.MSP
	15.FMP
	16.OME
	17.TME
	18.OME
	19.ELQ
	20.OME
	21.OMF
	22.OMF
	23.ELE
	24.GDT
	25.WTR
	26.CON
	27.TRP
	28.OTH
	29.OTH
	30.TRD
	31.TRD
	32.OTH
	33.OTH
	34.OTH
	35.OTH
	36.OTH
	37.OTH
	38.OTH
	39.OTH
	40.OTH
	41.OTH
	42.OTH
        /;

rescons(r,g,i)=sum((mapic2(i__,i),mapr(r_,r)),rescons_(r_,g,i__));


display rescons;



*-----------------------------------------------------------------*
*	POPULATOIN		      			          *
*-----------------------------------------------------------------*

set
        yr      "Time periods" /1*200/;



parameter population_(*,r_,*),popgrowth_(*,r,*);
$gdxin '..\setpar\pop\merged.gdx'
$load population_
$gdxin

display population_;


parameter population(rs,yr);

population(r,yr)=sum(mapr(r_,r),population_("chnpop1",r_,yr));


display population;


parameter eindiele(rs);
eindiele("ANH")=4.72; 
*eindiele("APD")=2.00; 
*eindiele("ASI")=2.99; 
eindiele("BEJ")=3.01; 
*eindiele("CAA")=3.12; 
eindiele("CHQ")=3.53; 
*eindiele("EUR")=1.20; 
eindiele("FUJ")=3.50; 
eindiele("GAN")=2.73; 
eindiele("GUD")=2.98; 
eindiele("GXI")=2.63; 
eindiele("GZH")=4.01; 
eindiele("HAI")=3.62; 
eindiele("HEB")=4.32; 
eindiele("HEN")=4.59; 
eindiele("HLJ")=4.72; 
eindiele("HUB")=2.21; 
eindiele("HNA")=3.23; 
eindiele("JIL")=4.88; 
eindiele("JSU")=3.65; 
eindiele("JXI")=4.45; 
eindiele("LIA")=4.09; 
*eindiele("NAM")=2.32; 
eindiele("NMG")=4.51; 
eindiele("NXA")=2.30; 
eindiele("QIH")=4.41; 
*eindiele("ROW")=1.40; 
eindiele("SHA")=3.76; 
eindiele("SHD")=4.16; 
eindiele("SHH")=3.50; 
eindiele("SHX")=4.23; 
eindiele("SIC")=2.53; 
eindiele("TAJ")=3.94; 
eindiele("XIN")=4.01; 
eindiele("YUN")=3.68; 
eindiele("ZHJ")=3.55; 

parameter egyinelec;
egyinelec(r)=eindiele(r)/(7.5215/price(r,"ele")*10);
egyinelec("chn")=sum(r,eindiele(r)*(vom("ele",r)+sum(nhw,vomnhw(nhw,r))))/sum(r,(vom("ele",r)+sum(nhw,vomnhw(nhw,r)))*7.5215/price("BEJ","ele")*10);
display egyinelec;


$exit



*-----------------------------------------------------------------*
*	SIDE ACCOUNTING....      			          *
*-----------------------------------------------------------------*






SET
        ei(i)    "Goods and sectors" /
        COL     "Coal mining and processing"
        CRU     "Crude petroleum products"
        GAS     "natural gas products"
        OMN     "Metal minerals mining & Non-metal minerals and other mining"
        FBT     "Food, baverage and tobacco"
        TEX     "Textiles"
        CLO     "Wearing apparel, leather, furs, down and related products"
        LUM     "Logging and transport of timber and furniture"
        PPP     "Paper, printing, record medium reproduction, cultural goods, toys, sporting and recreation products"
        OIL    "Petroleum refining, coking and nuclear fuels"
        CRP     "Chemical engineering"
        NMM     "Non-metallic mineral products"
        MSP     "Metal smelting and processing"
        FMP     "Metal product"
        OME     "General and special industrial machinery and equipment & Electric machinery and equipment & Instruments, meters ,other measuring equipment and cultural and office equipment"
        TME     "Transport machinery and equipment"
        ELQ     "Communicatoin, computer and other electronic machinery and equipment"
        OMF     "Arts and crafts products and other manufacturing  product & Scrap and waste"
        ELE     "Electricity production and supply, and steam and hot water production and supply"
        GDT     "Gas production and supply"
        WTR      "Water production and supply"
        CON     "Construction"
        TRP     "Transportation and warehousing, Post"
        /
        ;


parameter expshare(r,i);
expshare(r,i)$(vom(i,r)>0)=sum(s1,vxmd(i,r,s1))/vom(i,r);
expshare(r,i)$(vom(i,r)=0)=999;
display expshare;

execute_unload 'graph.gdx',expshare;
execute 'gdxxrw i=graph.gdx o=exp.xlsx par=expshare cdim=0';

$exit

parameter exshare(r);
exshare(r)=sum(i,sum(s1,vxmd(i,r,s1)))/sum(i,vom(i,r));
display exshare;

$exit
execute_unload 'graph.gdx',totq2;
execute 'gdxxrw i=graph.gdx o=segymix.xlsx par=totq2 cdim=0';



$exit

parameter report2(*,r);
report2("totgdp",r)=sum((f,i),vfm(f,i,r));
parameter totemis(r);
report2("totemis",r)=sum((i,g),eco2(i,g,r));
report2("emisint",r)=report2("totemis",r)/report2("totgdp",r);


*       Output results for plotting in Excel:
execute_unload 'graph.gdx',totq2;
execute 'gdxxrw i=graph.gdx o=segymix.xlsx par=totq2 cdim=0';

