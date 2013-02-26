$title	Read GTAP8 Basedata and Replicate the Benchmark in MPSGE
$setglobal projectfolder '%gams.curdir%'
$setlocal inputfolder '%projectfolder%\data'

  
set	g(*)	Goods plus C and G;
set	i(g)	Goods
	f(*)	Factors;
alias (i,j) , (g,gg);


set	rs;
alias   (rs,rsrs,rsrsrs);
set     rs1(rs);
set     r(rs);
alias	(r,rr,rrr);
set	s(rs);
alias	(s,ss);
set	s1(rs);
set	rnum(rs)	Numeraire region;

set	e(i),pe(e);

$gdxin '%inputfolder%/data.gdx'
$load g,i,f
$load rs,rs1,r,s,s1,rnum
$load e,pe
$gdxin


parameter
	rtxs(i,rs,rsrs)	"Export subsidy rate"
	rtms(i,rs,rsrs)	"Import subsidy rate"
			
	vxmd(i,rs,rsrs) "Trade - bilateral exports at market prices"
	vtwr(i,rs,rsrs) "Trade - Margins for international transportation at world prices"
	vst(i,rs),	
        vtrdm(g,rs)     "Trade margins"
        vtrnm(i,rs)     "Transportation margins"
			
	rtf(f,g,rs)	"Primary factor and commodity rates taxes"
	rtfd(i,g,rs)	"Firms domestic tax rates"
	rtfi(i,g,rs)	"Firms' import tax rates"
			
	vfm(f,g,rs)	"Endowments - Firms' purchases at market prices" 
	vdfm(i,g,rs)	"Intermediates - firms' domestic purchases at market prices"
	vifm(i,g,rs)	"Intermediates - firms' imports at market prices"
	vafm(i,g,r)	"Intermediates armington - China"
	vdtrm(i,r)	"domestic trade margin"

	vdm(g,rs)	"Aggregate demand for domestic output"
	vom(g,rs)	"Total supply at market prices"			
			
	rto(g,rs)       "Output tax rate"
        vtax(g,rs)      "Output tax payments"
        vsub(g,rs)      "Output subsidy payments"
			
	esubd(i)	"Elasticity of substitution (M versus D)"
	esubva(g)	"Elasticity of substitution between factors"
	esubm(i)	"Intra-import elasticity of substitution"
	etrae(f)	"Elasticity of transformation"
	eta(i,rs)	"Income elasticity of demand"

	eco2(i,g,rs)	"Volume of carbon emissions (Gg)";


$gdxin '%inputfolder%/data.gdx'
$load rtxs,rtms
$load vxmd,vtwr,vst,vtrdm,vtrnm
$load rtf,rtfd,rtfi
$load vfm,vdfm,vifm,vafm,vdtrm
$load vdm,vom
$load rto,vtax,vsub
$load esubd,esubva,esubm,etrae,eta
$load eco2
$gdxin


parameter			
   			
	pvxmd(i,rs,rsrs)	"Import price (power of benchmark tariff)"
	pvtwr(i,rs,rsrs)	"Import price for transport services"
			
	vtw(i)		"Aggregate international transportation services"
	vim(i,rs)	"Aggregate imports"
	evom(f,rs)	"Aggregate factor endowment at market prices"
	vb(*)		"Current account balance";


pvxmd(i,rs,rsrs) = (1+rtms(i,rs,rsrs)) * (1-rtxs(i,rs,rsrs));
pvtwr(i,rs,rsrs) = 1+rtms(i,rs,rsrs);


vtw(i) = sum(rs1,vst(i,rs1));
vim(i,rs) =  sum(g, vifm(i,g,rs));
evom(f,rs) = sum(g, vfm(f,g,rs));
vb(s) = vom("c",s) + vom("g",s) + vom("i",s) 
	- sum(f,  evom(f,s))
	- sum(j,  vom(j,s)*rto(j,s))
	- sum(g,  sum(i, vdfm(i,g,s)*rtfd(i,g,s) + vifm(i,g,s)*rtfi(i,g,s)))
	- sum(g,  sum(f, vfm(f,g,s)*rtf(f,g,s)))
	- sum((i,rs1), rtms(i,rs1,s) *  (vxmd(i,rs1,s) * (1-rtxs(i,rs1,s)) + vtwr(i,rs1,s)))
	+ sum((i,rs1), rtxs(i,s,rs1) * vxmd(i,s,rs1));
vb(r) = vom("c",r) + vom("g",r) + vom("i",r) 
	- sum(f, evom(f,r))
	- sum(j,  vom(j,r)*rto(j,r))
	- sum(g,  sum(i, vdfm(i,g,r)*rtfd(i,g,r) + vifm(i,g,r)*rtfi(i,g,r)))
	- sum(g,  sum(f, vfm(f,g,r)*rtf(f,g,r)))
	- sum((i,s1), rtms(i,s1,r) *  (vxmd(i,s1,r) * (1-rtxs(i,s1,r)) + vtwr(i,s1,r)))
	+ sum((i,s1), rtxs(i,r,s1) * vxmd(i,r,s1));

vb("chksum1") = sum(s, vb(s));
vb("chksum2") = sum(rs1, vb(rs1));
vb("chksum3") = sum(rs, vb(rs));
display vb;

*	Define a numeraire region for denominating international
*	transfers:

rnum(rs) = yes$(vom("c",rs)=smax(rsrs,vom("c",rsrs)));

parameter	esub(g)		Top-level elasticity indemand /C 1/;


eco2(i,g,rs)=eco2(i,g,rs);
parameter	co2lim(rs);
co2lim(rs)=sum((e,g),eco2(e,g,rs));
parameter	pcarbb;
pcarbb=1e-5;


$ontext
$model:gtap8
$sectors:
   y(g,rs1)$(vom(g,rs1)>1e-8)			! Supply
   m(i,rs1)$vim(i,rs1)				! Imports
   yt(i)$vtw(i)					! Transportation services

$commodities:
   p(g,rs1)$(vom(g,rs1)>1e-8)			! Domestic output price
   pm(i,rs1)$vim(i,rs1)				! Import price
   pt(i)$vtw(i)					! Transportation services
   pf(f,rs1)$evom(f,rs1)			! Primary factors rent
   PCARB(rs1)$co2lim(rs1)                       ! Shadow price of carbon

$consumers:
   ra(rs1)					! Representative agent

$prod:y(g,rs1)$(vom(g,rs1)>1e-8)	s:esub(g)    i.tl:esubd(i)  va:esubva(g)
o:p(g,rs1)	q:vom(g,rs1)	a:ra(rs1)  t:rto(g,rs1)
i:p(i,rs1)	q:vdfm(i,g,rs1)	p:(1+rtfd(i,g,rs1)) i.tl:  a:ra(rs1) t:rtfd(i,g,rs1)
i:PCARB(rs1)#(e)$co2lim(rs1)	q:eco2(e,g,rs1)       p:pcarbb e.tl:
i:pm(i,rs1)	q:vifm(i,g,rs1)	p:(1+rtfi(i,g,rs1)) i.tl:  a:ra(rs1) t:rtfi(i,g,rs1)
i:pf(f,rs1)	q:vfm(f,g,rs1)	p:(1+rtf(f,g,rs1))  va:    a:ra(rs1) t:rtf(f,g,rs1)

$prod:yt(i)$vtw(i)  s:1
o:pt(i)		q:vtw(i)
i:p(i,rs1)	q:vst(i,rs1)

$prod:m(i,r)$vim(i,r)	s:esubm(i)  s1.tl:0.5	rr.tl:0.5
o:pm(i,r)			q:vim(i,r)
i:p(i,s1)			q:vxmd(i,s1,r)	p:pvxmd(i,s1,r) s1.tl: a:ra(s1) t:(-rtxs(i,s1,r)) a:ra(r) t:(rtms(i,s1,r)*(1-rtxs(i,s1,r)))
i:pt("trp")#(s1)		q:vtwr(i,s1,r)	p:pvtwr(i,s1,r) s1.tl: a:ra(r) t:rtms(i,s1,r)
i:p(i,rr)			q:vxmd(i,rr,r)
i:p("trp",r)#(rr)		q:vtwr(i,rr,r)

$prod:m(i,s1)$vim(i,s1)	s:esubm(i)  rs1.tl:0.5	
o:pm(i,s1)		q:vim(i,s1)
i:p(i,rs1)		q:vxmd(i,rs1,s1)	p:pvxmd(i,rs1,s1) rs1.tl: a:ra(rs1) t:(-rtxs(i,rs1,s1)) a:ra(s1) t:(rtms(i,rs1,s1)*(1-rtxs(i,rs1,s1)))
i:pt("trp")#(rs1)	q:vtwr(i,rs1,s1)	p:pvtwr(i,rs1,s1) rs1.tl: a:ra(s1) t:rtms(i,rs1,s1)

$demand:ra(rs1)
d:p("c",rs1)	q:vom("c",rs1)
e:p("c",rnum)	q:vb(rs1)
e:p("g",rs1)	q:(-vom("g",rs1))
e:p("i",rs1)	q:(-vom("i",rs1))
e:pf(f,rs1)	q:evom(f,rs1)
e:PCARB(rs1)	q:co2lim(rs1)

$offtext

$sysinclude mpsgeset gtap8

gtap8.workspace = 128;
gtap8.iterlim =10000;
$include gtap8.gen
solve gtap8 using mcp;

parameter marginals;
parameter marginal2;

marginals("y",g,rs1) = y.m(g,rs1)$(abs(y.m(g,rs1)) gt 5e-5);
marginals("p",g,rs1) = p.m(g,rs1)$(abs(p.m(g,rs1)) gt 5e-5);
marginals("m",i,rs1) = m.m(i,rs1)$(abs(m.m(i,rs1)) gt 5e-5);
marginals("pm",i,rs1) = pm.m(i,rs1)$(abs(pm.m(i,rs1)) gt 5e-5);
marginals("pf",f,rs1) = pf.m(f,rs1)$(abs(pf.m(f,rs1)) gt 5e-5);

marginal2("yt",i) = yt.m(i)$(abs(yt.m(i)) gt 5e-5);
marginal2("pt",i) = pt.m(i)$(abs(pt.m(i)) gt 5e-5);
display marginals,marginal2;

