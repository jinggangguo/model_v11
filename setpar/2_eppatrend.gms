* This file contains definitions for exogenous trends: population, labor
* productivity and AEEI, etc.


*-----------------------------------------------------------------------------
*	C-REM
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*	POPULATION GROWTH RATES based on China Census projections to 2030:

parameter population_(*,*,*),popgrowth_(*,*,*);
$gdxin '%setpar_dir%pop%slash%merged.gdx'
$load popgrowth_
$gdxin


parameter popgrowth	5-year population growth rate
	  popgrowth_a	Annual population growth rate;

popgrowth_a(r,t) = popgrowth_("chnpop2",r,"annual")-1;
popgrowth(r,t)=(1+popgrowth_a(r,t))**5;
* Adjustment for 2007
popgrowth(r,"2007")=(1+popgrowth_a(r,"2007"))**3;

display popgrowth;

*-----------------------------------------------------------------------------
*	LABOR PRODUCTIVITY GROWTH:

TABLE 
	rates_(*,*) Base year ANNUAL productivity and population growth rates (%)

	    PRD-start	PRD-end	POP-end	AEEI
CHN         8		2	0.0	1.0;

*	NB: Initial productivity growth rates comes from: http://www.economist.com/node/17966988
*	Inititalize rates for regions:
*	ASSUME HERE uniform labor productivity growth rates across all regions:
*	Uniform rates (with initial rate of 10% and 2.0% in 2100):

rates_(r,"prd-start") = rates_("CHN","prd-start");

*	INITIAL LABOR PRODUCTIVITY GROWTH:
*	Adjust initial labor productivity growth rates to match approx.
*	forecasted GDP growth rates:

parameter corr Initial regional correction factor for labor productivity growth rates to match GDP (per capita) growth from 2007 to 2010;
corr("BEJ")=1.04678875/1.1;
corr("TAJ")=1.113997307/1.1;
corr("HEB")=1.097316266/1.1;
corr("SHX")=1.079693715/1.1;
corr("NMG")=1.158945506/1.1;
corr("LIA")=1.128993805/1.1;
corr("JIL")=1.14228616/1.1;
corr("HLJ")=1.118988401/1.1;
corr("SHH")=1.053639417/1.1;
corr("JSU")=1.118999702/1.1;
corr("ZHJ")=1.085975138/1.1;
corr("ANH")=1.146297338/1.1;
corr("FUJ")=1.123647593/1.1;
corr("JXI")=1.126326144/1.1;
corr("SHD")=1.114332636/1.1;
corr("HEN")=1.115621025/1.1;
corr("HUB")=1.137312777/1.1;
corr("HUN")=1.132329704/1.1;
corr("GUD")=1.081620753/1.1;
corr("GXI")=1.128297467/1.1;
corr("HAI")=1.115055585/1.1;
corr("CHQ")=1.147286365/1.1;
corr("SIC")=1.136181375/1.1;
corr("GZH")=1.134633198/1.1;
corr("YUN")=1.10930399/1.1;
corr("SHA")=1.145942214/1.1;
corr("GAN")=1.106312203/1.1;
corr("QIH")=1.123147154/1.1;
corr("NXA")=1.113647422/1.1;
corr("XIN")=1.081932189/1.1;

rates_("BEJ","prd-start")=corr("BEJ")*rates_("chn","prd-start");
rates_("TAJ","prd-start")=corr("TAJ")*rates_("chn","prd-start");
rates_("HEB","prd-start")=corr("HEB")*rates_("chn","prd-start");
rates_("SHX","prd-start")=corr("SHX")*rates_("chn","prd-start");
rates_("NMG","prd-start")=corr("NMG")*rates_("chn","prd-start");
rates_("LIA","prd-start")=corr("LIA")*rates_("chn","prd-start");
rates_("JIL","prd-start")=corr("JIL")*rates_("chn","prd-start");
rates_("HLJ","prd-start")=corr("HLJ")*rates_("chn","prd-start");
rates_("SHH","prd-start")=corr("SHH")*rates_("chn","prd-start");
rates_("JSU","prd-start")=corr("JSU")*rates_("chn","prd-start");
rates_("ZHJ","prd-start")=corr("ZHJ")*rates_("chn","prd-start");
rates_("ANH","prd-start")=corr("ANH")*rates_("chn","prd-start");
rates_("FUJ","prd-start")=corr("FUJ")*rates_("chn","prd-start");
rates_("JXI","prd-start")=corr("JXI")*rates_("chn","prd-start");
rates_("SHD","prd-start")=corr("SHD")*rates_("chn","prd-start");
rates_("HEN","prd-start")=corr("HEN")*rates_("chn","prd-start");
rates_("HUB","prd-start")=corr("HUB")*rates_("chn","prd-start");
rates_("HUN","prd-start")=corr("HUN")*rates_("chn","prd-start");
rates_("GUD","prd-start")=corr("GUD")*rates_("chn","prd-start");
rates_("GXI","prd-start")=corr("GXI")*rates_("chn","prd-start");
rates_("HAI","prd-start")=corr("HAI")*rates_("chn","prd-start");
rates_("CHQ","prd-start")=corr("CHQ")*rates_("chn","prd-start");
rates_("SIC","prd-start")=corr("SIC")*rates_("chn","prd-start");
rates_("GZH","prd-start")=corr("GZH")*rates_("chn","prd-start");
rates_("YUN","prd-start")=corr("YUN")*rates_("chn","prd-start");
rates_("SHA","prd-start")=corr("SHA")*rates_("chn","prd-start");
rates_("GAN","prd-start")=corr("GAN")*rates_("chn","prd-start");
rates_("QIH","prd-start")=corr("QIH")*rates_("chn","prd-start");
rates_("NXA","prd-start")=corr("NXA")*rates_("chn","prd-start");
rates_("XIN","prd-start")=corr("XIN")*rates_("chn","prd-start");


* Assume that labor productivity growth rates for all regions converge in 2100:
rates_(s,"prd-end") = rates_("chn","prd-end");



* Define productivity growth trend.
	
PARAMETERS        

        FPROD(*,T)             Fixed factor productivity;

FPROD(rs,T) = (1 + 0.01)**(5*(ORD(T) - 1));
FPROD(r,T) = (1 + 0.02)**(5*(ORD(T) - 1));
*$ontext
FPROD("asi",T) = (1 + 0.025)**(5*(ORD(T) - 1));
FPROD("nam",T) = (1 + 0.015)**(5*(ORD(T) - 1));
FPROD("row",T) = (1 + 0.015)**(5*(ORD(T) - 1));
*$offtext.


* Labor productivity


TABLE RATES(*,*) Base year growth and savings rates (%)

	    PRD-start	POP-start	PRD-end	POP-end	AEEI
CHN	    5.0		1.0		2.0	0.0	1.0	
EUR         3.0		0.1		2.0	0.0	1.0
APD         2.5		0.5		2.0	0.0	1.0
ASI         4.4		1.6		2.0	0.1	1.0
CAA         2.0		2.5		2.0	0.1	1.0
NAM         2.3		1.1		2.0	0.0	1.0
ROW         3.0		1.6		2.0	0.1	1.0

BEJ			0.34 
TAJ			0.205
HEB			0.655
SHX			0.533
NMG			0.448
LIA			0.153
JIL			0.25 
HLJ			0.249
SHH			-0.01
JSU			0.23 
ZHJ			0.481
ANH			0.635
FUJ			0.61 
JXI			0.787
SHD			0.5  
HEN			0.494
HUB			0.323
HUN			0.525
GUD			0.73 
GXI			0.82 
HAI			0.891
CHQ			0.38 
SIC			0.292
GZH			0.668
YUN			0.686
SHA			0.405
GAN			0.649
QIH			0.88 
NXA			0.976
XIN			1
;

rates(r,"pop-end") = 0;
rates(r,"aeei") = 1;
rates(r,"prd-start") = rates_(r,"prd-start");
rates(r,"prd-end") = 2;

* Growth = Productivity Growth + Population growth

rates(rs,"prd") = rates(rs,"prd-start") + rates(rs,"pop-start");
rates(rs,"prd100") = rates(rs,"prd-end") + rates(rs,"pop-end");


PARAMETER
	 PRDGR0(*)      Base year productivity growth rate (%)
	 PRDGR100(*)    Productivity growth rate at the end of horizon
	 GPROD(*,T)     Productivity index;

PRDGR0(rs)   = RATES(rs,"PRD")/100;
PRDGR100(rs) = RATES(rs,"PRD100")/100;

prdgr0(rs) = 1.15*prdgr0(rs);



* Simulate productivity and compute the growth index relative to 2007


parameter glr(*,t),alpha,beta;
alpha=0.1;
beta=0.12;
* 2007, 2010
glr(rs,"2007")=prdgr0(rs);
glr(rs,"2010")=prdgr0(rs);

glr(rs,t)$(ord(t)>2) = (1+alpha)*(prdgr0(rs)-prdgr100(rs))/(1+alpha*exp(5*beta*(ord(t)-2)))+prdgr100(rs);

gprod(rs,"2007") =1;
gprod(rs,"2010") = gprod(rs,"2007")*(1+glr(rs,"2007"))**3; 

loop(t,
if(ord(t) ge 2,
gprod(rs,t+1) = gprod(rs,t)*(1+glr(rs,t))**5; 
);
);


* Population and effective labor supply.

*Parameters

*	POPULATION(RS,T)        POPULATION OF REGION R IN YEAR T;
 
* EPPA4 updated (table 17).

*$include ..\data\popa_eppa_e5.dat
*population(r,t) = popa_eppa5(r,t);



* Define AEEI trends.

PARAMETERS
	LAMDAE(I,*,T)          AEEI FACTORS FOR SECTORS
	LAMDACE(*,T)           AEEI FACTOR FOR CONSUMPTION
	LAMDAGE(*,T)           AEEI FACTOR FOR GOVERNMENT
	LAMDAIE(*,T)           AEEI FACTOR FOR INVESTMENT;
 
PARAMETER       GAMAEG(*)    INITIAL AEEI GROWTH RATE FOR GOVERNMENT
*$ontext
	/
	 EUR		   0.01
	 APD		   0.01
	 ASI               0.01
	 NAM		   0.01
	 CAA               0.01
	 ROW               0.01/
*$offtext
;
GAMAEG(rs) = 0.01;
GAMAEG(r) = 0.01;

PARAMETER       GAMAEI(*)    INITIAL AEEI GROWTH RATE FOR INVESTMENT
*$ontext
	/
	 EUR        	   0.01
	 APD        	   0.01
	 ASI               0.01
	 NAM        	   0.01
	 CAA               0.01
	 ROW               0.01/
*$offtext
;

GAMAEI(rs) = 0.01;	
GAMAEI(r) = 0.01;

* Notes 0s in energy sectors.

TABLE GAMAES(*,I)       INITIAL AEEI GROWTH RATES FOR SECTORS
	
	 COL	CRU	GAS	OIL	ELE	AGR	OMN	LID	EID	OID	GDT	WTR	TRD	TRP	OTH
EUR	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01
APD	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01
ASI	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01
NAM	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01
CAA	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01
ROW	 0.0	0.0	0.0	0.0	0.0	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01	0.01

;
		   
GAMAES(r,I) = GAMAES("asi",I);

parameter GAMAEC(RS)       INITIAL AEEI GROWTH RATES FOR CONSUMER GOODS; 
gamaec(rs)=0.01;


LAMDAE(I,RS,T) = EXP(5*Rates(rs,"aeei")*GAMAES(Rs,I)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 

LAMDACE(rs,T) = EXP(5*Rates(rs,"aeei")*GAMAEC(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 
LAMDAGE(rs,T) = EXP(5*Rates(rs,"aeei")*GAMAEG(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 
LAMDAIE(rs,T) = EXP(5*Rates(rs,"aeei")*GAMAEI(rs)*(ORD(T)-1)*(1-(ORD(T)-1)/100)); 

$ontext
LAMDAE(I,"rus",T)$(ord(t) ge 4) = 1.23 * LAMDAE(I,"rus",T);
LAMDAE(I,"roe",T)$(ord(t) ge 4) = 1.2 * LAMDAE(I,"roe",T);
LAMDAE(I,"eur",T)$(ord(t) ge 4) = 1.1 * LAMDAE(I,"eur",T);


LAMDACE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDACE("rus",T);
LAMDACE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDACE("roe",T);
LAMDACE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDACE("eur",T);

LAMDAIE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDAIE("rus",T);
LAMDAIE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDAIE("roe",T);
LAMDAIE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDAIE("eur",T);

LAMDAGE("rus",T)$(ord(t) ge 4) = 1.23 * LAMDAGE("rus",T);
LAMDAGE("roe",T)$(ord(t) ge 4) = 1.2 * LAMDAGE("roe",T);
LAMDAGE("eur",T)$(ord(t) ge 4) = 1.1 * LAMDAGE("eur",T);



LAMDAE(I,"chn", "2004")= 1.2;
LAMDAE(I,"chn", "2006")= 1.2;
LAMDAE(I,"chn", "2010")= 1.2;

LAMDACE("chn", "2004") = 1.2;
LAMDAGE("chn", "2004") = 1.2;
LAMDAIE("chn", "2004") = 1.2;

LAMDACE("chn", "2006") = 1.2;
LAMDAGE("chn", "2006") = 1.2;
LAMDAIE("chn", "2006") = 1.2;

LAMDACE("chn", "2010") = 1;
LAMDAGE("chn", "2010") = 1;
LAMDAIE("chn", "2010") = 1;


lamdae(enoe,rs,t) = 1;
lamdae("ele",rs,t) = 1;
$offtext

display lamdae, lamdace, lamdage, lamdaie;

*$exit              

* EPPA4 Updated (table 20)


table res070(*,pe)	1995 resource base by fuel (EJ)
	cru	gas     col
*$ontext
CHN	4000	2000	40000
EUR	840	1160	12000	
APD	100	500	6000
ASI	450	890	2850
CAA	20000	13000	120000
NAM	4485.8	1290.1	25619.7
ROW	8000	2600	9000
;

res070(rs,"col")=res070(rs,"col")/0.03;
res070(rs,"cru")=res070(rs,"cru")*1.5/0.03;
res070(rs,"gas")=res070(rs,"gas")*1.5/0.03;


$include '%setpar_dir%eppa_ngas.gms'


parameter res07(rs,grt,pe);
res07(rs,grt,pe)=cy_res(rs,grt,pe);

*Convert from EJ to mtce
res07(rs,grt,pe)=res07(rs,grt,pe)/0.03;

display res07;

* Provincial fossil reserves (EJ)
table fossil_reserves(*,i)
	cru	gas	col
BEJ			100
TAJ	600	40	50
HEB	100	30	600
SHX			4000
NMG			13000
LIA	200	20	60
JIL	100	30	30
HLJ	600	60	200
SHH	1	10	
JSU	20	2	50
ZHJ			
ANH			600
FUJ			30
JXI			50
SHD	500	10	400
HEN	100	10	900
HUB	20	5	
HUN			50
GUD	200	160	10
GXI	1	2	20
HAI	2	5	
CHQ		5	100
SIC	2	500	200
GZH	10		2000
YUN			440
SHA	500	500	2000
GAN		1	1400
QIH	40	120	400
NXA		1	1700
XIN	1000	520	18000
;

*Convert from EJ to mtce
fossil_reserves(r,i)=fossil_reserves(r,i)/0.03;
display fossil_reserves;


parameter 
	ffreserves	"Fossil fuel reserves estimates (mtce)";

ffreserves(r,pe) = fossil_reserves(r,pe)/0.03;
ffreserves("CHN",pe) = res070("CHN",pe);
ffreserves(s,pe) = res070(s,pe);

display ffreserves;

display gprod;
