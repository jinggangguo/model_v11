$title China model version 4 (gtap data integrated)

$if not set ind   $set ind 28

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
alias (i_,j_);

set     r China provinces      /BEJ,TAJ,HEB,SHX,NMG,LIA,JIL,HLJ,SHH,JSU,ZHJ,ANH,FUJ,JXI,SHD,HEN,HUB,HNA,GUD,GXI,HAI,CHQ,SIC,GZH,YUN,SHA,GAN,NXA,QIH,XIN/;

parameter sam(r,i_,j_) SAM data;

$gdxin '%inputfolder%/sam52.gdx'
$load sam=sam5
sam(r,i_,j_)$(abs(sam(r,i_,j_))<1e-6)=0;

*-------------------------------------------------------------------
*       RELABEL SETS:
*-------------------------------------------------------------------
set
   i       "Goods and sectors" /
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
   TRD     "Wholesale and retail trade, Hotels and restraunts"
   TRP     "Transportation and warehousing, Post"
   OTH     "Other service industry"
   /
   ;

alias (i,j) , (r,rr,rrr);


parameter
   vxm(r)   "Domestic and foreign exports "
   vim(r)   "Aggregate imports";

*       Domestic exports and immports:
vxm(r)  = sam(r,'%ind%',"62");
vim(r)  = sam(r,"62",'%ind%');
*+sam(r,"66",'%ind%');

parameter 
	trdmgnshr(r);
trdmgnshr(r)$vim(r)=sam(r,"66",'%ind%')/sam(r,"62",'%ind%');
display trdmgnshr;

parameter totvxm,totvim;
totvxm=sum(r,vxm(r));
totvim=sum(r,vim(r));
display vxm,vim,totvxm,totvim;

positive variables vxmd (r,rr)

*positive variables vtwr (r,rr)

variable jj

Equations
   rsum
   csum
*   totvtwr
   obj
   ;

rsum(r)..
  sum(rr,vxmd(r,rr))=e=vxm(r);

csum(r)..
   sum(rr,vxmd(rr,r))=e=vim(r);

*totvtwr(r)..
*   sum(rr,vtwr(rr,r))=e=sam(r,"66",'%ind%');

obj..
   jj=e=sum((r,rr)$(not sameas(r,rr)),
sqr((vxmd(rr,r)/vim(r))$(vim(r))-(vim(rr)/(sum(rrr,vim(rrr))-vim(rr)))$((sum(rrr,vim(rr))-vim(rr)))));
*+100*sum((r,rr),sqr(((vtwr(r,rr)/vxmd(r,rr))$vxmd(r,rr)-trdmgnshr(rr))));

vxmd.fx(r,rr)$(sameas(r,rr))=0;
*vtwr.fx(r,rr)$(sameas(r,rr))=0;
      
Model gua /all/;

gua.iterlim=100000;
gua.reslim=100000000000;
Solve gua minimizing jj using nlp;


parameter vxmd_(r,rr),vtwr_(r,rr);
vtwr_(r,rr)=vxmd.l(r,rr)*trdmgnshr(rr);
vxmd_(r,rr)=vxmd.l(r,rr);

*parameter totvtwr;


display vtwr_,vxmd_;