* parameters for calibrating resurce supply curve for gas (EPPA5) based on cost curve data :

* Define a set for gas resource types:
SET grt gas resource types / cnv conventional, shl shale, tgh tight sands, cbm coal bed methane/;

alias (grt,gtr);

parameter cy_res(*,grt,pe) the current updated resource base by type;


table gasres04(*,grt) benchmark total gas reserves by type in TCF based on 2004 gas prices (3$ per mmbtu) 

* Cost_04_M_at5$

*$ontext
	cnv	shl	tgh	cbm
NAM	800	1000	0	0
CHN	200	0	0	0	
EUR	1160	0	0	0	
APD	500	0	0	0
ASI	890	0	0	0
CAA	13000	0	0	0
ROW	2600	0	0	0
;


table gasresb0(*,*) resource supply elasticity for gas based on econmetric fitting of whole curve 

*$ontext
* cost_04
	b0	
CHN	0.6
EUR	0.6
APD	0.5	
ASI	0.5
NAM	0.6
CAA	0.6
ROW	0.6
;

table gasresb11(*,*) resource supply elasticity for gas based on econmetric fitting of relevant curve segment 0 to 10

* cost_04_M_at$5
	cnv	shl	tgh	cbm
CHN	0.3	0	0	0
EUR	0.3	0	0	0
APD	0.2	0	0	0
ASI	0.3	0	0	0
CAA	0.1	0	0	0
NAM	0.6	0.2	0.5	0.5
ROW	0.2	0	0	0
;


table gasresb12(*,*) resource supply elasticity for gas based on econmetric fitting of relevant curve segment 10 plus

* cost_04_M_at$5
	cnv	shl	tgh	cbm
CHN	0.4	0	0	0	
EUR	0.1	0	0	0
APD	0.1	0	0	0
ASI	0.1	0	0	0
CAA	0.05	0	0	0
NAM	0.4	0	0.2	0.1
ROW	0.1	0	0	0
 ;


parameter gas_mod;

gas_mod = 0;


* over-write the resource numbers for gas with the new assessment
res070(s,"gas")$gas_mod=sum(grt, gasres04(s,grt));



* initialize reserve accounting:
cy_res(s,grt,pe)=0;
cy_res(s,"cnv",pe)=res070(s,pe);
cy_res("can",grt,"gas")=gasres04("can",grt);




