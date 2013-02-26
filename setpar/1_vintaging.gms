$TITLE Capital vintaging 

*	This file declares parameters for capital vintaging and contains
*	the flag for activating the vintaging model.

*--------------------------------------------------------------------------
*       Declare and initialize putty-clay input coefficients, assuming
*       that extant capital has identical characteristics to new 
*       vintage in the base year:
*--------------------------------------------------------------------------

*       High proportion of fixed capital?
$if not set kapflag $set kapflag low


SET     
*	V			"Vintage"	/V5/
	V			"Vintages identified by age" /V5,V10,V15,V20/

*	2-year vintages:
*	V			"Vintages identified by age" /V5,V52,V54,V56,V58,V510,V512,V514,V516,V518,V520/
*	V			"Vintages identified by age" /V5,V54,V56,V58,V510,V512,V514/

*	4-year vintages:
*	V			"Vintages identified by age" /V5,V54,V510,V514,V518/

        V5(V)			"Youngest vintage with rigid coefficients" /V5/
        VINTG(i,rs)		"Pointer to operating vintages (production sectors excl. backstops)"
*        VINTGBS(bt,rs)		"Pointer to operating vintages (backstops)";

SET PCGOODS(i);
PCGOODS(i)=yes;


PARAMETERS
	v_de(rs,i,g,v) 
	v_dcarb(rs,*,g,v)  
	v_mf(rs,g,*,v) 
	v_dk(rs,g,v) 
	v_df(rs,g,*,v) 
        v_kh(i,g,v,rs)		"Vintage capital endowment by household"
        v_k(i,v,rs)		"Vintage capital endowment"
	v_snhw(nhw,v,rs)


$ontext
        VB_DA(BT,I,V,RS)	"Energy input(armington) coefficient for vintaged backstop production"
        VB_DFF(BT,V,RS)		"Fixed-factor input coefficient for vintaged backstop production"
        VB_DK(BT,V,RS)		"Capital input coefficient for vintaged backstop production"
        VB_DL(BT,V,RS)		"Labor input coefficient for vintaged backstop production"
        VB_DC(BT,V,RS)		"Carbon permit input coefficient for vintaged backstop production"
        VB_K(BT,V,RS)		"Vintage backstop capital endowment fixed"
        VB_KM(BT,V,RS)		"Vintage backstop capital endowment malleable"
        VB_Kh(BT,V,h,RS)		"Vintage backstop capital endowment fixed by household"
        VB_KMh(BT,V,h,RS)	"Vintage backstop capital endowment malleable by household"
        BIN(BT,RS)		"Total backstop inputs"
        VBIN(BT,V,RS)		"Total vintaged backstop inputs"
	VB_EM(BT,V,RS)		"Fraction of carbon emitted by vintage"
        VB_EM0(BT,RS)		"Initial fraction of backstop emissions"

*	Vintaged backstop capital output prices by backstop and region:

        PPVBK(BT,V,rs,T)         "Price of vintaged backstop capital - fixed"
        VVBK(BT,V,rs,T)          "Vintaged backstop capital - fixed"
        PPVBKM(BT,V,rs,T)        "Price of vintaged backstop capital - malleable"
        VVBKM(BT,V,rs,T)         "Vintaged backstop capital - malleable"
        TVBK(BT,rs,T)            "Total vintaged backstop capital"
        VBBOUT(I,VBT,V,rs,T)     "Vintaged production"
        TVBBOUT(I,VBT,rs,T)      "Total vintaged production"
$offtext


*	Vintaging defaults (fraction of capital stock fixed):

	THETA(I,T)		"Share of new vintage which is frozen each period"
	THETA0(I,RS)		"Benchmark share of new vintage"
*	THETAB(BT,T)		"Share of backstop capital which is vintaged in each period"
*	VBMALSHR		"Share of vintaged backstop capital that is malleable"
;

$if %kapflag%==low theta0(i,rs) = 0.3;
$if %kapflag%==low theta0("ele",rs) = 0.6;
$if %kapflag%==low theta(i,t) = 0.3;
$if %kapflag%==low theta("ele",t) = 0.6;

$if %kapflag%==high theta0(i,rs) = 0.45;
$if %kapflag%==high theta0("ele",rs) = 0.9;
$if %kapflag%==high theta(i,t) = 0.45;
$if %kapflag%==high theta("ele",t) = 0.9;


*--------------------------------------------------------------------------
*       Check the benchmark with the putty-putty model:
*--------------------------------------------------------------------------
vintg(i,rs) = no;
v_de(rs,i,g,v) = 0;
v_dcarb(rs,i,g,v)  = 0;
v_mf(rs,g,mf,v) = 0;
v_dk(rs,g,v) = 0;
v_df(rs,g,sf,v) = 0;
v_kh(i,g,v,rs)		= 0;
v_k(i,v,rs)	= 0;
v_snhw(nhw,v,rs)=0;


*--------------------------------------------------------------------------
*       VINTAGING:

*       Specify the benchmark conditions:

PARAMETER CLAY_SHR(i,rs)  Benchmark fraction of capital stock which is old
	  VINT_SHR	  Share of benchmark production by vintage
	  idkd		  Identifier for benchmark sectoral capital demand;

parameter
	depr(rs)         Benchmark depreciation rate
	srvshr(rs)       "Single period survival share = (1-delta)**5"
	ror(rs)		Benchmark rate of return


	hshkapital(rs,g)	Capital income by household as fraction of aggregate capital income
	scale(rs)		Scale parameter to calibrate kapital-output ratio
	schet			Iteration count /0/

	bbres			Backstop resource supply
	bbresh			Backstop resource supply by household

	ffact(rs,*)		Total regional fixed factor supply
	d_ffact			Change in national fixed factor supply
	ffact_p			Fixed factor supply from previous period;

depr(rs) = 0.05;
srvshr(rs) = (1-depr(rs))**2;
hshkapital(rs,g)$sum(g.local,vfms("cap",g,rs)) = vfms("cap",g,rs)/sum(g.local,vfms("cap",g,rs));



idkd(rs,i) = vfm("cap",i,rs);


CLAY_SHR(i,rs) = 0;

*	Extant capital only for sectors which have positive 
*	benchmark capital demand:
CLAY_SHR(i,rs)$idkd(rs,i) = THETA0(i,rs); 
alias(V,VV);
VINT_SHR(V,rs) = SRVSHR(rs)**ORD(V) / SUM(VV,SRVSHR(rs)**ORD(VV));
display vint_shr;

*       Adopt the putty clay assumption for the following sectors:

*SET PCGOODS(i) / EIS, MAN, TRN, AGR, ELE, CRP,NMM, I_s,NFM, ppp/;
*VINTG(PCGOODS,rs) = yes;
*VINTGBS(VBT,rs) = YES;

*	Initialize coefficients for vintaged production:

v_de(rs,j,i,v)$(vom(i,rs) and vintg(i,rs) and (vafm(j,i,rs)>1e-8)) = vafm(j,i,rs)/vom(i,rs);
v_de(rs,j,i,v)$(vom(i,rs) and vintg(i,rs) and (vafm(j,i,rs)>1e-8) and sameas(i,"ele")) = 
(vafm(j,i,rs)-sum(nhw,vdfmnhw(j,nhw,rs)*(1+rtfdnhw(j,nhw,rs))))/vom(i,rs);


v_dcarb(rs,fe,i,v)$(vom(i,rs) and vintg(i,rs))  = bmkco2(fe,i,rs)/vom(i,rs);
*v_dcarb(r,"cru","ele",v)$(vom("ele",r) and vintg("ele",r))  = euse("cru","ele",r)*epslonele("cru")/vom("ele",r);

v_mf(rs,i,mf,v)$(vom(i,rs) and vintg(i,rs) and (vfm(mf,i,rs)>1e-8)) = vfm(mf,i,rs)/vom(i,rs);
v_dk(rs,i,v)$(vom(i,rs) and vintg(i,rs) and (vfm("cap",i,rs)>1e-8)) = vfm("cap",i,rs)/vom(i,rs);
v_mf(s,i,"cap",v) = v_dk(s,i,v);
v_df(rs,i,sf,v)$(vom(i,rs) and vintg(i,rs)) = vfm(sf,i,rs)/vom(i,rs);

*v_de(rs,j,i,v)$(vom(i,rs) and vintg(i,rs) and sameas(i,"ele"))= (vafm(j,i,rs)+sum(nhw,vdfmnhw(j,nhw,rs)))/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));
*v_mf(rs,i,mf,v)$(vom(i,rs) and vintg(i,rs) and sameas(i,"ele")) = (vfm(mf,i,rs)+sum(nhw,vfmnhw(mf,nhw,rs)))/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));
*v_dk(rs,i,v)$(vom(i,rs) and vintg(i,rs) and sameas(i,"ele")) = (vfm("cap",i,rs)+sum(nhw,vfmnhw("cap",nhw,rs)))/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));
*v_df(rs,i,sf,v)$(vom(i,rs) and vintg(i,rs) and sameas(i,"ele"))=vfm(sf,i,rs)/(vom(i,rs)+sum(nhw,vomnhw(nhw,rs)));
*v_snhw(nhw,v,rs)$(vomnhw(nhw,rs)>1e-8 and vintg("ele",rs))=vfmnhw("res",nhw,rs)/(vom("ele",rs)+sum(nhwnhw,vomnhw(nhw,rs)));




v_k(i,v,rs)$vintg(i,rs) = CLAY_SHR(i,rs) *vfm("cap",i,rs) * VINT_SHR(V,rs);
v_kh(i,g,v,rs)$vintg(i,rs) = rshrinc(g,rs) * v_k(i,v,rs);

*	Set small coefficients to zero to avoid numerical issues: 
v_kh(i,g,v,rs)$(vintg(i,rs)$(v_kh(i,g,v,rs) lt 1e-5)) = 0;

display v_kh;

parameter vkhid;
vkhid(i,rs) = 1$sum(v,v_k(i,v,rs));
VINTG(PCGOODS,rs)$(not vkhid(pcgoods,rs)) = no;

*       Adjust the new vintage capital stock:

*PARAMETER AKAPITAL   Aggregate capital;

*AKAPITAL(R) = sum(h,kapital(r,h)) - SUM(G$VINTG(G,R), SUM(V,V_K(G,V,R))) 
*	- SUM(VBT$VINTGBS(VBT,R), SUM(V, VB_K(VBT,V,R)))
*	- SUM(VBT$VINTGBS(VBT,R), SUM(V, VB_KM(VBT,V,R)));

vfms("cap",c,r) = vfms("cap",c,r) - sum((i,v), v_kh(i,c,v,r));
vfms("cap","c",s) = vfms("cap","c",s) - sum((i,v), v_k(i,v,s));

*       Recalibrate the new vintage capital:
*y.l(i,rs)$VINTG(i,rs) = 1 - CLAY_SHR(i,rs);
*dv.l(i,V,rs)$VINTG(i,rs) = vom(i,rs) * CLAY_SHR(i,rs) * VINT_SHR(V,rs);




