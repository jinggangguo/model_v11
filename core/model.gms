$title  Read GTAP8 Basedata and Replicate the Benchmark in MPSGE

*       Da Zhang, Sebastian Rausch 6/6/2011

*       --------------------------------------------------------------------

*       Command line options

*       Which dataset do we use?

$if not set ds $set ds allprov

*       Impose a national or regional intensity target?

$if not set intflag $set intflag no

*       Definition of vintaged capital:

$if not set lic_exempt $set lic_exempt no


*       Definition of fixed electricity policy 1:
$if not set eleflag1 $set eleflag1 no

*       Definition of fixed electricity policy 2:
$if not set eleflag2 $set eleflag2 no

*       Settings for gas supply elasticity:
$if not set gasflag $set gasflag2 low


*------------------------------------------------------*
*          SETS AND PARAMETERS                         *
*------------------------------------------------------*
$include ..\setpar\0_setpar.gms
*$exit

*------------------------------------------------------*
*          CAPITAL VINTAGING                           *
*------------------------------------------------------*
$include ..\setpar\1_vintaging.gms
*$exit


*------------------------------------------------------*
*          FOR DEBUGGING                               *
*------------------------------------------------------*
*display cintf;
*$exit
$ontext
inttarg("ANH")  =       0.817137        ;
inttarg("BEJ")  =       0.500918        ;
inttarg("CHQ")  =       0.724946        ;
inttarg("FUJ")  =       0.664868        ;
inttarg("GAN")  =       0.972275        ;
inttarg("GUD")  =       0.820038        ;
inttarg("GXI")  =       0.908238        ;
inttarg("GZH")  =       1       ;
inttarg("HAI")  =       0.548812        ;
inttarg("HEB")  =       1       ;
inttarg("HEN")  =       0.901402        ;
inttarg("HLJ")  =       0.838051        ;
inttarg("HUB")  =       0.961638        ;
inttarg("HUN")  =       0.821583        ;
inttarg("JIL")  =       0.853024        ;
inttarg("JSU")  =       0.685007        ;
inttarg("JXI")  =       0.801226        ;
inttarg("LIA")  =       0.885486        ;
inttarg("NMG")  =       1       ;
inttarg("NXA")  =       0.827311        ;
inttarg("QIH")  =       1       ;
inttarg("SHA")  =       0.858598        ;
inttarg("SHD")  =       0.819374        ;
inttarg("SHH")  =       0.773759        ;
inttarg("SHX")  =       1       ;
inttarg("SIC")  =       0.792625        ;
inttarg("TAJ")  =       0.753083        ;
inttarg("XIN")  =       0.908481        ;
inttarg("YUN")  =       1       ;
inttarg("ZHJ")  =       0.464958        ;
$offtext

parameter chinagdp;
chinagdp=sum(r,gdp("inc",r));
display chinagdp;

parameter chinaco2;
chinaco2=sum((r,i,g),eco2(i,g,r));
display chinaco2;

*$exit

*------------------------------------------------------*
*                       Model                          *
*------------------------------------------------------*

$ontext
$model:gtap8
$sectors:
   Y(g,rs)$(vom(g,rs)>1e-8)                                     ! Supply
   A(i,rs)$(vam(i,rs)>1e-8)                                     ! Armington
   AT(i,g,rs)$(vafm(i,g,rs)>1e-8)                               ! Armington inclusive of carbon tax or intensity target tax
   M(i,rs,trade)$(vim(i,rs,trade)>1e-8)                         ! Imports
   YT(i)$(vtw(i)>1e-8)                                          ! Transportation services
   CE(rs)$cbtrade(rs)                                           ! Carbon permit trading
   CEE(rs)$cbtrade(rs)                                          ! Carbon permit trading
   W(c,rs)$(rshrcons(c,rs)>1e-8)                                ! Consumers welfare
   YNHW(nhw,rs)$(vomnhw(nhw,rs)>1e-8)                           ! Nuclear, hydro and wind
   FSUP(f,c,rs)$(flagvfms(f,c,rs)$mf(f))                        ! Factor supply
   KSUPV(i,c,v,rs)$(v_kh(i,c,v,rs)>1e-8)                        ! Vintaged capital supply
   DV(i,v,rs)$(sum(c,v_kh(i,c,v,rs))>1e-8)                      ! Vintaged sectoral production

   PH(RS,PLT)$(Q_ph(RS,PLT)>1e-8)                               ! pollution health
   PH_TOT(RS)$Q_PH_TOT(RS)                                    ! total pollution health from all pollutants


$commodities:
   P(g,rs)$(vom(g,rs)>1e-8)                                     ! Domestic output price
   PA(i,rs)$(vam(i,rs)>1e-8)                                    ! Armington
   PAT(i,g,rs)$(vafm(i,g,rs)>1e-8)                              ! Price of Armington inclusive of carbon tax or intensity target tax
   PM(i,rs,trade)$(vim(i,rs,trade)>1e-8)                        ! Import price
   PT(i)$(vtw(i)>1e-8)                                          ! Transportation services
   PSNHW(nhw,rs)$(vfmnhw("res",nhw,rs)>1e-8)                    ! Resource price for nhw
   PCARB(rs)$co2lim(rs)                                         ! Shadow price of carbon
   PTCARB$cintfn                                                ! Traded carbon prices
   PTAX(rs)                                                     ! Tax revenue market
   PW(c,rs)$(rshrcons(c,rs)>1e-8)                               ! Welfare index
   PF(f,rs)$(sum(c,vfms(f,c,rs)$(not mk(f,rs))$mf(f)))          ! Primary factors rent
   PFS(f,c,rs)$(flagvfms(f,c,rs)$mf(f))                         ! Household-specific factor rents
   PMK$(sum((f,rs),mk(f,rs)))                                   ! Price for mobile capital across China regions
   PS(f,g,rs)$(vfm(f,g,rs)$sf(f))                               ! Price for sector-specific resource
   PKSUPV(i,v,rs)$(sum(c,v_kh(i,c,v,rs)))                       ! Vintaged capital supply
   PKSUPVS(i,c,v,rs)$(v_kh(i,c,v,rs)>1e-8)

   P_PH(RS,PLT)$(Q_ph(RS,PLT)>1e-8)                             ! Price of pollution health sectors
   P_PH_TOT(RS)$(Q_PH_TOT(RS))                                  ! Price of total pollution health


$consumers:
   rh(c,rs)$(rshrcons(c,rs)>1e-8)                               ! Representative agent
   eletaxrev(rs)$neletaxnh(rs)                                  ! Electrcity tax revenue agent
   taxrev(rs)                                                   ! Tax revenue agent
   govt(rs)                                                     ! Government

$auxiliary:
        co2cint(rs)$cintf(rs)                                                   ! Rationing multiplier on supply of permits
        co2cintn$cintfn                                                         ! Rationing multiplier of national target
        neletaxw(rs,g)$(neletaxn(rs)$vafm("ele",g,rs))                          ! Endogeneous tax to fix provincial electricity price
        neletaxh(g,rs)$(neletaxnh(rs)$isc(g)$vafm("ele",g,rs)>1e-8)             ! Endogeneous tax on household to fix household electricity price
        neletaxi(rs)$(neletaxni(rs))                                            ! Endogeneous tax on industry to fix household electricity price
        GOVBUDG(rs)                                                             ! Revenue nutural for government
        LSGOVNH(c,rs)$(rshrcons(c,rs)>1e-8)                                     ! Revenue nutural for government

*       ARMGINTON INCLUSIVE OF CARBON OR INTENSITY TARGET TAX:
$prod:AT(i,g,rs)$(vafm(i,g,rs)>1e-8)  s:0
        o:PAT(i,g,rs)  q:vafm(i,g,rs)
* Subsidy on consumer price of electricity for all users:
+                 a:taxrev(rs)$neletaxn(rs)             n:neletaxw(rs,g)$(neletaxn(rs)$vafm(i,g,rs))$sameas(i,"ele")

* Subsidy only on residential electricity price:
+                 a:eletaxrev(rs)$neletaxnh(rs)         n:neletaxh(g,rs)$neletaxnh(rs)$sameas(i,"ele")$isc(g)
+                 a:eletaxrev(rs)$neletaxni(rs)         n:neletaxi(rs)$neletaxni(rs)$sameas(i,"ele")$(not isc(g))
        i:PA(i,rs)                              q:vafm(i,g,rs)
        i:PCARB(rs)$co2lim(rs)$(fe(i))          q:bmkco2(i,g,rs)        p:pcarbb


*       POLLUTION HEALTH PRODUCTION FOR ALL POLLUTANT SECTORS
$PROD:PH(RS,PLT)$(Q_ph(RS,PLT)>1e-8)   S:0.2
        O:P_PH(RS,PLT)                  Q:(Q_PH(RS,PLT)/P_INDEX_CURR(RS,PLT))
        I:PF("lab",RS)                  Q:Q_L_PH(RS,PLT)
        I:PAT("OTH","c", RS)		Q:Q_SERV_PH(RS,PLT)

*       TOTAL POLLUTION COST
$PROD:PH_TOT(RS)$Q_PH_TOT(RS)        S:0
        O:P_PH_TOT(RS)  Q:Q_PH_TOT(RS)
        I:P_PH(RS,PLT)  Q:Q_PH(RS,PLT)


*       CONSUMPTION:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and con(g,rs)) s:1 ntrn:0.25 e(ntrn):0.4 ne(ntrn):0.25
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:vafm(i,g,rs)  e:$e(i) ne:$(not e(i) and (not trn(i)))


*       INVESTMENT AND GOVERNMENT CONSUMPTION:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and (gov(g,rs) or inv(g,rs)))  s:1  m:0 ec:1
        o:P(g,rs)               q:vom(g,rs)             a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)           q:vafm(i,g,rs)          ec:$e(i) m:$(not e(i))


*       OTHER SECTORS:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and oth(g,rs))  s:0 kle:0.5  en(kle):0.5   nele(en):1 va(kle):1
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:vafm(i,g,rs)    nele:$fe(i) en:$ele(i)
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf(mf,g,rs))         va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfm("cap",g,rs)       p:(1+rtf("cap",g,rs))      va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                     q:vfm(sf,g,rs)          p:(1+rtf(sf,g,rs))         va:    a:taxrev(rs) t:rtf(sf,g,rs)


*       ELECTRICITY GENERATION:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and ele(g))  s:0 kle:0.5 va(kle):1 ene(kle):0.5  ele(ene):0 nele(ene):1 co(nele):0.3 gas(nele):10
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:(vafm(i,g,rs)-sum(nhw,vdfmnhw(i,nhw,rs)*(1+rtfdnhw(i,nhw,rs))))   co:$(oil(i) or col(i))  gas:$(gas(i) or fgs(i)) ele:$ele(i)
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf(mf,g,rs))         va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfm("cap",g,rs)       p:(1+rtf("cap",g,rs))      va:    a:taxrev(rs) t:rtf("cap",g,rs)


*       NUCLEAR, HYDRO AND WIND ELECTRICITY GENERATION:
$prod:YNHW(nhw,rs)$(vomnhw(nhw,rs)>1e-8)      s:sigmanhw(nhw,rs)        a:0 va(a):1
        o:P("ele",rs)                  q:vomnhw(nhw,rs)    a:taxrev(rs)  t:rtonhw(nhw,rs)
        i:PAT(i,"ele",rs)              q:(vdfmnhw(i,nhw,rs)*(1+rtfdnhw(i,nhw,rs)))       a:
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfmnhw(mf,nhw,rs)          p:(1+rtfnhw(mf,nhw,rs))         va:    a:taxrev(rs) t:rtfnhw(mf,nhw,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfmnhw("cap",nhw,rs)       p:(1+rtfnhw("cap",nhw,rs))      va:    a:taxrev(rs) t:rtfnhw("cap",nhw,rs)
        i:PSNHW(nhw,rs)$(vfmnhw("res",nhw,rs)>1e-8) q:vfmnhw("res",nhw,rs)   p:(1+rtfnhw("res",nhw,rs))      a:taxrev(rs) t:rtfnhw("res",nhw,rs)


*       OIL REFINING:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and oil(g)) s:0 kle:0.5  en(kle):0.5   nele(en):1 va(kle):1
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:vafm(i,g,rs)   nele:$(fe(i) and (not cru(i))) en:$ele(i)
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf(mf,g,rs))         va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfm("cap",g,rs)       p:(1+rtf("cap",g,rs))      va:    a:taxrev(rs) t:rtf("cap",g,rs)


*       FUEL GAS:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and fgs(g)) s:0 kle:0.5  en(kle):0.5   nele(en):1 va(kle):1
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:vafm(i,g,rs)   nele:$(fe(i) and (not cru(i)) and (not col(i)) and (not gas(i))) en:$ele(i)
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf(mf,g,rs))         va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfm("cap",g,rs)       p:(1+rtf("cap",g,rs))      va:    a:taxrev(rs) t:rtf("cap",g,rs)


*       COAL, CRUDE OIL, NATURAL GAS PRODUCTION:
$prod:Y(g,rs)$((vom(g,rs)>1e-8) and (col(g) or gas(g) or cru(g))) s:esubx(g,rs) m:0 va(m):1
        o:P(g,rs)      q:vom(g,rs)    a:taxrev(rs)  t:rto(g,rs)
        i:PAT(i,g,rs)  q:vafm(i,g,rs)   va:$e(i)  m:$(not e(i))
        i:PF(mf,rs)$(not mk(mf,rs))     q:vfm(mf,g,rs)          p:(1+rtf(mf,g,rs))         va:    a:taxrev(rs) t:rtf(mf,g,rs)
        i:PMK$(sum(mf,mk(mf,rs)))        q:vfm("cap",g,rs)       p:(1+rtf("cap",g,rs))      va:    a:taxrev(rs) t:rtf("cap",g,rs)
        i:PS(sf,g,rs)                     q:vfm(sf,g,rs)          p:(1+rtf(sf,g,rs))        a:taxrev(rs) t:rtf(sf,g,rs)


*       ARMINGTON AGGREGATION FOR CHINA PROVINCES:
$prod:A(i,r)$(vam(i,r)>1e-8)    s:esubd(i)      m:esubm(i)
        o:PA(i,r)               q:vam(i,r)
        i:P(i,r)                q:vdm(i,r)              p:(1+rtda(i,r)) m: a:taxrev(r) t:rtda(i,r)
        i:PM(i,r,ctrade)        q:vim(i,r,ctrade)       p:(1+rtia(i,r,ctrade)) m: a:taxrev(r) t:rtia(i,r,ctrade)
        i:PM(i,r,otrade)        q:vim(i,r,otrade)       p:(1+rtia(i,r,otrade)) a:taxrev(r) t:rtia(i,r,otrade)

$prod:m(i,r,ctrade)$vim(i,r,ctrade)     s:esubm(i)      rr.tl:0
        o:pm(i,r,ctrade)                        q:vim(i,r,ctrade)
        i:p(i,rr)                               q:vxmd(i,rr,r)  rr.tl:
        i:p("trp",r)#(rr)                       q:vtwr(i,rr,r)  rr.tl:

$prod:m(i,r,otrade)$vim(i,r,otrade)     s:esubm(i)  ss.tl:0
        o:pm(i,r,otrade)                        q:vim(i,r,otrade)
        i:p(i,ss)                       q:vxmd(i,ss,r)  p:pvxmd(i,ss,r) ss.tl: a:taxrev(ss) t:(-rtxs(i,ss,r)) a:taxrev(r) t:(rtms(i,ss,r)*(1-rtxs(i,ss,r)))
        i:pt("trp")#(ss)                q:vtwr(i,ss,r)  p:pvtwr(i,ss,r) ss.tl: a:taxrev(r) t:rtms(i,ss,r)


*       ARMINGTON AGGREGATION FOR INTERNATIONAL REGIONS:
$prod:A(i,s)$(vam(i,s)>1e-8)  s:esubd(i)      m:esubm(i)
        o:PA(i,s)      q:vam(i,s)
        i:P(i,s)       q:vdm(i,s)     p:(1+rtda(i,s)) a:taxrev(s) t:rtda(i,s)
        i:PM(i,s,ctrade)       q:vim(i,s,ctrade)      p:(1+rtia(i,s,ctrade)) m: a:taxrev(s) t:rtia(i,s,ctrade)
        i:PM(i,s,otrade)       q:vim(i,s,otrade)      p:(1+rtia(i,s,otrade)) m: a:taxrev(s) t:rtia(i,s,otrade)

$prod:m(i,s,ctrade)$vim(i,s,ctrade)           s:(4*esubd(i))  r.tl:0
        o:pm(i,s,ctrade)               q:vim(i,s,ctrade)
        i:p(i,r)                        q:vxmd(i,r,s)  p:pvxmd(i,r,s) r.tl: a:taxrev(r) t:(-rtxs(i,r,s)) a:taxrev(s) t:(rtms(i,r,s)*(1-rtxs(i,r,s)))
        i:pt("trp")#(r)                 q:vtwr(i,r,s)  p:pvtwr(i,r,s) r.tl: a:taxrev(s) t:rtms(i,r,s)

$prod:m(i,s,otrade)$vim(i,s,otrade)           s:esubm(i)      ss.tl:0
        o:pm(i,s,otrade)                       q:vim(i,s,otrade)
        i:p(i,ss)                       q:vxmd(i,ss,s) p:pvxmd(i,ss,s) ss.tl: a:taxrev(ss) t:(-rtxs(i,ss,s)) a:taxrev(s) t:(rtms(i,ss,s)*(1-rtxs(i,ss,s)))
        i:pt("trp")#(ss)                q:vtwr(i,ss,s) p:pvtwr(i,ss,s) ss.tl: a:taxrev(s) t:rtms(i,ss,s)


*       INTERNATIONAL TRANSPORTATION SERVICES:
$prod:yt(i)$vtw(i)  s:1
        o:pt(i)         q:vtw(i)
        i:p(i,rs)      q:vst(i,rs)


*       VINTAGED PRODUCTION
$prod:DV(i,v,rs)$v_k(i,v,rs) s:0
        o:P(i,rs)                               q:1                             a:taxrev(rs)  t:rto(i,rs)
        i:PAT(j,i,rs)                           q:v_de(rs,j,i,v)
        i:PF("lab",rs)$(not mk("lab",rs))       q:v_mf(rs,i,"lab",v)    p:(1+rtf("lab",i,rs))       a:taxrev(rs) t:rtf("lab",i,rs)
        i:PKSUPV(i,v,rs)                        q:v_mf(rs,i,"cap",v)    p:(1+rtf("cap",i,rs))                a:taxrev(rs) t:rtf("cap",i,rs)
        i:PS(sf,i,rs)                           q:v_df(rs,i,sf,v)       p:(1+rtf(sf,i,rs))                   a:taxrev(rs) t:rtf(sf,i,rs)


*       FACTOR SUPPLY
$prod:FSUP(f,c,rs)$(flagvfms(f,c,rs)$mf(f))
        o:PF(f,rs)$(not mk(f,rs))        q:vfms(f,c,rs)
        o:PMK$mk(f,rs)                   q:vfms(f,c,rs)
        i:PFS(f,c,rs)                    q:vfms(f,c,rs)

*       VINTAGED CAPITAL
$prod:KSUPV(i,c,v,rs)$v_kh(i,c,v,rs)
        o:PKSUPV(i,v,rs)        q:v_kh(i,c,v,rs)
        i:PKSUPVS(i,c,v,rs)     q:v_kh(i,c,v,rs)


*       CARBON TRADING:
$prod:CE(rs)$cbtrade(rs)
        o:PCARB(rs)$co2lim(rs)          q:1
        i:PTCARB                        q:1

$prod:CEE(rs)$cbtrade(rs)
        i:PCARB(rs)$co2lim(rs)          q:1
        o:PTCARB                        q:1


*       WELFARE:

$prod:W(c,rs)$(rshrcons(c,rs)>1e-8)	s:1	sa:0
        o:PW(c,rs)                      q:(vom(c,rs)+thetals(rs)*vfms("lab",c,rs))
        i:P(c,rs)                       q:(vom(c,rs))		sa:
        i:P_PH_TOT(RS)                  Q:Q_PH_TOT(RS)		sa:
        i:PFS("lab",c,rs)               q:(thetals(rs)*vfms("lab",c,rs))


*       INCOME:

$demand:rh(c,rs)$(rshrcons(c,rs)>1e-8)
d:PW(c,rs)                              q:(vom(c,rs)+thetals(rs)*vfms("lab",c,rs))
e:P("i",rs)                             q:(-vom("i",rs)*rshrinc(c,rs))
e:PFS(mf,c,rs)                          q:(vfms(mf,c,rs)*(1+thetals(rs)$sameas(mf,"lab")))
e:PS("res",j,rs)                        q:vfmresh(j,c,rs)
e:PKSUPVS(i,c,v,rs)                     q:v_kh(i,c,v,rs)
e:PSNHW(nhw,rs)$vfmnhw("res",nhw,rs)    q:vfmsnhw(nhw,c,rs)
e:PCARB(rs)                             q:(carbrevshare(c,rs)*sum(sr,co2lim(sr)))       r:co2cint(rs)$cintf(rs)    r:co2cintn$cintfn
e:PW("c",rnum)                          q:(-1)                                          r:LSGOVNH(c,rs)$(rshrcons(c,rs)>1e-8)


*(1-0.2$(sameas(mf,"cap")))*


*       TAX REVENUE AGENT:
$demand:taxrev(rs)
        d:ptax(rs)                      q:1

*       GOVERNMENT INCOME BY INSTITUTION:
$demand:GOVT(rs)
        d:P("g",rs)                      q:vom("g",rs)
        e:PW("c",rnum)                   q:vb(rs)
        e:ptax(rs)                       q:taxrevbench(rs)
        e:PW("c",rnum)                   q:1                    r:GOVBUDG(rs)

*       BUDGET NEUTRALITY in each region:
$constraint:GOVBUDG(rs)
        GOVT(rs) =e=  vom("g",rs);


*       LUMP-SUM TAX to maintain budget neutrality:
$constraint:LSGOVNH(c,rs)$(rshrcons(c,rs)>1e-8)
        LSGOVNH(c,rs) =e= rshrinc(c,rs) * GOVBUDG(rs);


*       ELECTRICITY TAX REVENUE
$demand:eletaxrev(rs)$neletaxnh(rs)
d:PW("c",rnum)                          q:1


*       CONSTRAINTS FOR FIXED ELECTRICITY
$constraint:neletaxw(rs,g)$(neletaxn(rs)$(vafm("ele",g,rs)>1e-8))
PAT("ele",g,rs) =e= 1;

$constraint:neletaxh(g,rs)$(neletaxnh(rs)$isc(g)$vafm("ele",g,rs)>1e-8)
PAT("ele",g,rs) =e= 1;

$constraint:neletaxi(rs)$neletaxni(rs)
eletaxrev(rs)   =e= 0;


*       CONSTRAINTS FOR CARBON INTENSITY TARGETS:
$constraint:co2cint(rs)$cintf(rs)
*       (Emissions in production and consumption) / GDP:
sum((fe,g)$(vafm(fe,g,rs)>1e-8),AT(fe,g,rs)*bmkco2(fe,g,rs))
* GDP expenditure-based:
/(sum(c$(vom(c,rs)),Y(c,rs)*vom(c,rs)*P(c,rs))
+Y("g",rs)*vom("g",rs)*P("g",rs)
+Y("i",rs)*vom("i",rs)*P("i",rs)
-vb(rs))
=e=
inttarg(rs) * bmkint(rs);


$constraint:co2cintn$cintfn
sum((rs,i,g)$(fe(i)$province(rs)), AT(i,g,rs)*bmkco2(i,g,rs))
/sum(rs$province(rs),
sum(c$(vom(c,rs)),Y(c,rs)*vom(c,rs)*P(c,rs))
+Y("g",rs)*vom("g",rs)*P("g",rs)
+Y("i",rs)*vom("i",rs)*P("i",rs)
-vb(rs))
=e=
inttarg("CHN") * bmkint("CHN");



*       Reporting variables:
$report:
v:dv_out(i,v,rs)$v_k(i,v,rs)                                    o:p(i,rs)               prod:DV(i,v,rs)
v:vv_de(j,i,rs)$(vom(i,rs)>1e-8)                                i:PAT(j,i,rs)           prod:Y(i,rs)
v:vv_mflab(i,rs)$((vom(i,rs)>1e-8)$(not mk("lab",rs)))          i:PF("lab",rs)          prod:Y(i,rs)
v:vv_mfcap(i,rs)$((vom(i,rs)>1e-8)$(not mk("cap",rs)))          i:PF("cap",rs)          prod:Y(i,rs)
v:vv_dk(i,rs)$((vom(i,rs)>1e-8)$sum(mf,mk(mf,rs)))              i:PMK                   prod:Y(i,rs)
v:vv_df(j,i,rs)$(vom(i,rs)>1e-8)                                i:PS(j,i,rs)            prod:Y(i,rs)


* Imports from other regions to China:
v:imports_f(i,rs,sr)$vim(i,rs,"OTHTRD") i:P(i,sr)               prod:M(i,rs,"OTHTRD")
* Imports from China to other regions:
v:imports_c(i,rs,sr)$vim(i,rs,"CNTRD")  i:P(i,sr)               prod:M(i,rs,"CNTRD")


v:r_consh(rs,c)         i:P(c,rs)                prod:W(c,rs)
v:r_leish(rs,c)         i:PFS("lab",c,rs)        prod:W(c,rs)


v:r_enbnele(rs,j,i)$(vom(i,rs)>1e-8)            i:pat(j,i,rs)           prod:y(i,rs)
v:ei_v(rs,j,i,v)$sum(g,v_k(i,v,rs))             i:pat(j,i,rs)           prod:DV(i,v,rs)
v:r_afgc(rs,i,g)                                i:pat(i,g,rs)           prod:y(g,rs)




$offtext



$sysinclude mpsgeset gtap8

*       Fix numeraire
loop(rnum(rs),
PW.fx("c",rs)=1;
);

*       Initiation of auxiliary variables
PCARB.l(rs)$co2lim(rs) = 1;
co2cint.l(rs)$cintf(rs) = 1;
co2cint.lo(rs)$cintf(rs) = -inf;
co2cintn.l$cintfn = 1;
co2cintn.lo$cintfn = -inf;
neletaxw.l(rs,g)$(neletaxn(rs)$province(rs)) = -1;
neletaxw.lo(rs,g)$(neletaxn(rs)$province(rs))= -inf;
neletaxw.up(rs,g)$(neletaxn(rs)$province(rs))=+inf;
neletaxh.l(g,rs)$(neletaxnh(rs)$province(rs)) = 1;
neletaxh.lo(g,rs)$(neletaxnh(rs)$province(rs))= -inf;
neletaxi.l(rs)$(neletaxni(rs)$province(rs)) = 1;
GOVBUDG.lo(rs)= -inf;
GOVBUDG.l(rs) = 1;
LSGOVNH.lo(c,rs)$(rshrcons(c,rs)>1e-8)=-inf;
LSGOVNH.l(c,rs)$(rshrcons(c,rs)>1e-8)=1;


*       Recalibrate the new vintage capital:
y.l(i,rs)$VINTG(i,rs) = 1 - CLAY_SHR(i,rs);
dv.l(i,V,rs)$VINTG(i,rs) = vom(i,rs) * CLAY_SHR(i,rs) * VINT_SHR(V,rs);

gtap8.workspace = 1000;
gtap8.iterlim =100000;
*gtap8.iterlim =0;
gtap8.reslim=100000;
gtap8.optfile=1;
$include gtap8.gen

$include ..\setpar\2_eppatrend.gms

$include ..\setpar\3_reportpar_loop.gms

*display gdp;
*$exit
solve gtap8 using mcp;

display glr,gprod;


*$exit

*------------------------------------------------------*
*                     REPORT                           *
*------------------------------------------------------*
*       MARGINALS
parameter marginals;
parameter marginal2;
parameter marginal3;

marginals("y",g,rs) = y.m(g,rs)$(abs(y.m(g,rs)) gt 1e-4);
marginal3("a",i,g,rs) = a.m(i,rs)$(abs(a.m(i,rs)) gt 1e-4);
marginal3("at",i,g,rs) = at.m(i,g,rs)$(abs(at.m(i,g,rs)) gt 1e-4);
marginal3("m",i,rs,trade) = m.m(i,rs,trade)$(abs(m.m(i,rs,trade)) gt 1e-4);
marginal2("yt",i) = yt.m(i)$(abs(yt.m(i)) gt 5e-5);
marginals("ynhw",nhw,rs) = ynhw.m(nhw,rs)$(abs(ynhw.m(nhw,rs)) gt 1e-4);
marginals("w",c,rs) = w.m(c,rs)$(abs(w.m(c,rs)) gt 1e-4);
marginal3("dv",i,v,rs) = dv.m(i,v,rs)$(abs(dv.m(i,v,rs)) gt 1e-4);
marginals("p",g,rs) = p.m(g,rs)$(abs(p.m(g,rs)) gt 5e-5);
marginals("pa",i,rs) = pa.m(i,rs)$(abs(pa.m(i,rs)) gt 1e-4);
marginal3("pat",i,g,rs) = pat.m(i,g,rs)$(abs(pat.m(i,g,rs)) gt 1e-4);
marginal3("pm",i,rs,trade) = pm.m(i,rs,trade)$(abs(pm.m(i,rs,trade)) gt 1e-4);
marginals("pf",f,rs) = pf.m(f,rs)$(abs(pf.m(f,rs)) gt 5e-5);
marginal2("pt",i) = pt.m(i)$(abs(pt.m(i)) gt 5e-5);
marginals("pw",c,rs) = pw.m(c,rs)$(abs(pw.m(c,rs)) gt 1e-4);

display marginals,marginal2,marginal3;

*$exit


*report

parameter report,report2;
report("CO2emis",rs,"bmk") = sum((fe,g),bmkco2(fe,g,rs));
report("CO2emis","CHN","bmk") = sum(r,report("CO2emis",r,"bmk"));
report("Intensity",rs,"bmk") = bmkint(rs);
report("Intensity","CHN","bmk") = bmkint("CHN");


*       CARBON INTENSITY
report("Intensity",rs,"pol") = sum((fe,g)$(vafm(fe,g,rs)>1e-8),AT.l(fe,g,rs)*bmkco2(fe,g,rs))/
(Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("Intensity","CHN","pol") = sum((rs,i,g)$(fe(i)$province(rs)), AT.l(i,g,rs)*bmkco2(i,g,rs))  /
sum(rs$province(rs),Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("Intensity",rs,"pol%") = 100*(report("Intensity",rs,"pol")/report("Intensity",rs,"bmk")-1);
report("Intensity","CHN","pol%") = 100*(report("Intensity","chn","pol")/report("Intensity","chn","bmk")-1);


*       CO2 EMISSION
report("CO2emis",rs,"pol") = sum((fe,g)$(vafm(fe,g,rs)>1e-8),AT.l(fe,g,rs)*bmkco2(fe,g,rs));
report("CO2emis","CHN","pol") = sum(r,report("CO2emis",r,"pol"));
report("CO2emis",rs,"pol%") = 100*(report("CO2emis",rs,"pol")/report("CO2emis",rs,"bmk")-1);
report("CO2emis","CHN","pol%") = 100*(report("CO2emis","chn","pol")/report("CO2emis","chn","bmk")-1);


*       CO2 EMISSION BY FUEL TYPE BY SECTOR BY REGION
parameter co2rpt;
co2rpt("bmk",fe,g,rs)=bmkco2(fe,g,rs);
co2rpt("pol",fe,g,rs)=at.l(fe,g,rs)*bmkco2(fe,g,rs);
co2rpt("pol%",fe,g,rs)$(co2rpt("bmk",fe,g,rs)>1e-8)=(co2rpt("pol",fe,g,rs)/co2rpt("bmk",fe,g,rs)-1)*100;


*       WELFARE CHANGE
parameter wchange       Equivalent variation in percent of full income;
report2("Wchange",c,rs,"pol%")= 100*(W.l(c,rs)-1);
report2("Wchange",c,"CHN","pol%")$(sum(sr$province(sr),vom(c,sr)+thetals(sr)*(vfms("lab",c,sr))))
=sum(rs$province(rs),
report2("Wchange",c,rs,"pol%")*(vom(c,rs)+thetals(rs)*(vfms("lab",c,rs)))
/sum(sr$province(sr),vom(c,sr)+thetals(rs)*(vfms("lab",c,sr)))
);

*       GDP
report("GDP",rs,"bmk")=vom("c",rs)+vom("g",rs)+vom("i",rs)-vb(rs);
report("GDP",rs,"pol")=Y.l("c",rs)*vom("c",rs)*P.l("c",rs)+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)-vb(rs);
report("GDP",rs,"pol%")=100*(report("GDP",rs,"pol")/report("GDP",rs,"bmk")-1);

*       GDP PER CAPITA
report("PGDP",rs,"bmk")$province(rs)=(vom("c",rs)+vom("g",rs)+vom("i",rs)-vb(rs))/pop2007(rs,"c");
report("PGDP",rs,"pol")$province(rs)=(Y.l("c",rs)*vom("c",rs)*P.l("c",rs)+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)-vb(rs))/pop2007(rs,"c");
report("PGDP",rs,"pol%")$province(rs)=100*(report("PGDP",rs,"pol")/report("PGDP",rs,"bmk")-1);

parameter egyreport2;
egyreport2("egycons",fe,g,rs,"bmk")$province(rs)=evd(fe,g,rs);
egyreport2("egycons",fe,g,"CHN","bmk")=sum(rs$province(rs),egyreport2("egycons",fe,g,rs,"bmk"));
egyreport2("egycons",fe,g,rs,"pol")$province(rs)=evd(fe,g,rs)*AT.l(fe,g,rs);
egyreport2("egycons",fe,g,"CHN","pol")=sum(rs$province(rs),egyreport2("egycons",fe,g,rs,"pol"));
egyreport2("egycons",fe,g,rs,"pol%")$(province(rs) and egyreport2("egycons",fe,g,rs,"bmk"))=100*(egyreport2("egycons",fe,g,rs,"pol")/egyreport2("egycons",fe,g,rs,"bmk")-1);
egyreport2("egycons",fe,g,"CHN","pol%")$(egyreport2("egycons",fe,g,"CHN","bmk"))=100*(egyreport2("egycons",fe,g,"CHN","pol")/egyreport2("egycons",fe,g,"CHN","bmk")-1);


*       FINAL FOSSIL ENERGY CONSUMPTION BY TYPE BY REGION
parameter egyreport;
egyreport("egycons",fe,rs,"bmk")$province(rs)=sum(g,evd(fe,g,rs));
egyreport("egycons","COL",rs,"bmk")$province(rs)
=sum(g$(not sameas(g,"OIL") and (not sameas(g,"GDT"))),evd("COL",g,rs));
egyreport("egycons","GAS",rs,"bmk")$province(rs)
=sum(g$((not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("GAS",g,rs));
egyreport("egycons",fe,"CHN","bmk")=sum(rs$province(rs),egyreport("egycons",fe,rs,"bmk"));
egyreport("egycons","CRU",rs,"bmk")$province(rs)
=sum(g$((not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("CRU",g,rs));
egyreport("egycons",fe,"CHN","bmk")=sum(rs$province(rs),egyreport("egycons",fe,rs,"bmk"));


egyreport("egycons",fe,rs,"pol")$province(rs)=sum(g,evd(fe,g,rs)*AT.l(fe,g,rs));
egyreport("egycons","COL",rs,"pol")$province(rs)
=sum(g$((vafm("COL",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("COL",g,rs)*AT.l("COL",g,rs));
egyreport("egycons","GAS",rs,"pol")$province(rs)
=sum(g$((vafm("GAS",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("GAS",g,rs)*AT.l("GAS",g,rs));
egyreport("egycons","CRU",rs,"pol")$province(rs)
=sum(g$((vafm("CRU",g,rs)>1e-8) and (not sameas(g,"OIL")) and (not sameas(g,"GDT"))),evd("CRU",g,rs)*AT.l("CRU",g,rs));

egyreport("egycons",fe,"CHN","pol")=sum(rs$province(rs),egyreport("egycons",fe,rs,"pol"));

egyreport("egycons",fe,rs,"pol%")$(province(rs) and egyreport("egycons",fe,rs,"bmk"))=100*(egyreport("egycons",fe,rs,"pol")/egyreport("egycons",fe,rs,"bmk")-1);
egyreport("egycons",fe,"CHN","pol%")$(egyreport("egycons",fe,"CHN","bmk")>1e-8)=100*(egyreport("egycons",fe,"CHN","pol")/egyreport("egycons",fe,"CHN","bmk")-1);


*       FINAL FOSSIL ENERGY CONSUMPTION BY REGION
report("egycons",rs,"bmk")$province(rs)=sum(fe,egyreport("egycons",fe,rs,"bmk"));
report("egycons","CHN","bmk")=sum(fe,egyreport("egycons",fe,"CHN","bmk"));
report("egycons",rs,"pol")$province(rs)=sum(fe,egyreport("egycons",fe,rs,"pol"));
report("egycons","CHN","pol")=sum(fe,egyreport("egycons",fe,"CHN","pol"));
report("egycons",rs,"pol%")$province(rs)=(report("egycons",rs,"pol")/report("egycons",rs,"bmk")-1)*100;
report("egycons","CHN","pol%")=(report("egycons","CHN","pol")/report("egycons","CHN","bmk")-1)*100;


*       PRIMARY FOSSIL ENERGY SUPPLY BY TYPE BY REGION
egyreport("egysup",pe,rs,"bmk")$province(rs)=sum(g,evd(pe,g,rs));
egyreport("egysup",pe,"CHN","bmk")=sum(rs$province(rs),egyreport("egysup",pe,rs,"bmk"));
egyreport("egysup",pe,rs,"pol")$province(rs)=sum(g,evd(pe,g,rs)*AT.l(pe,g,rs));
egyreport("egysup",pe,"CHN","pol")=sum(rs$province(rs),egyreport("egysup",pe,rs,"pol"));
egyreport("egysup",pe,rs,"pol%")$(province(rs) and egyreport("egysup",pe,rs,"bmk"))=100*(egyreport("egysup",pe,rs,"pol")/egyreport("egysup",pe,rs,"bmk")-1);
egyreport("egysup",pe,"CHN","pol%")$(egyreport("egysup",pe,"CHN","bmk")>1e-8)=100*(egyreport("egysup",pe,"CHN","pol")/egyreport("egysup",pe,"CHN","bmk")-1);

*       PRIMARY FOSSIL ENERGY SUPPLY BY REGION
report("egysup",rs,"bmk")$province(rs)=sum(pe,egyreport("egysup",pe,rs,"bmk"));
report("egysup","CHN","bmk")=sum(pe,egyreport("egysup",pe,"CHN","bmk"));
report("egysup",rs,"pol")$province(rs)=sum(pe,egyreport("egysup",pe,rs,"pol"));
report("egysup","CHN","pol")=sum(pe,egyreport("egysup",pe,"CHN","pol"));
report("egysup",rs,"pol%")$province(rs)=(report("egysup",rs,"pol")/report("egysup",rs,"bmk")-1)*100;
report("egysup","CHN","pol%")=(report("egysup","CHN","pol")/report("egysup","CHN","bmk")-1)*100;


*       NUC, HYDRO AND WIND PRODUCTION BY TYPE BY REGION
*       Electricity generation efficiency is needed (334g/kwh,http://news.163.com/08/0422/10/4A4JV026000120GU.html)
egyreport("nhwprod",nhw,rs,"bmk")$province(rs)=vomnhw(nhw,rs)*334/123;
egyreport("nhwprod",nhw,"CHN","bmk")=sum(rs$province(rs),egyreport("nhwprod",nhw,rs,"bmk"));
egyreport("nhwprod",nhw,rs,"pol")$province(rs)=vomnhw(nhw,rs)*YNHW.L(nhw,rs)/P.l("ele",rs)*334/123;
egyreport("nhwprod",nhw,"CHN","pol")=sum(rs$province(rs),egyreport("nhwprod",nhw,rs,"pol"));
egyreport("nhwprod",nhw,rs,"pol%")$(province(rs) and (egyreport("nhwprod",nhw,rs,"bmk")>1e-8))
=100*(egyreport("nhwprod",nhw,rs,"pol")/egyreport("nhwprod",nhw,rs,"bmk")-1);
egyreport("nhwprod",nhw,"CHN","pol%")=100*(egyreport("nhwprod",nhw,"CHN","pol")/egyreport("nhwprod",nhw,"CHN","bmk")-1);


*       NUC, HYDRO AND WIND PRODUCTION BY REGION
report("nhwprod",rs,"bmk")$province(rs)=sum(nhw,egyreport("nhwprod",nhw,rs,"bmk"));
report("nhwprod","CHN","bmk")=sum(nhw,egyreport("nhwprod",nhw,"CHN","bmk"));
report("nhwprod",rs,"pol")$province(rs)=sum(nhw,egyreport("nhwprod",nhw,rs,"pol"));
report("nhwprod","CHN","pol")=sum(nhw,egyreport("nhwprod",nhw,"CHN","pol"));
report("nhwprod",rs,"pol%")$(province(rs) and (report("nhwprod",rs,"bmk")>1e-8))=(report("nhwprod",rs,"pol")/report("nhwprod",rs,"bmk")-1)*100;
report("nhwprod","CHN","pol%")=(report("nhwprod","CHN","pol")/report("nhwprod","CHN","bmk")-1)*100;


*       ENERGY INTENSITY
report("EGYIntensity","CHN","bmk")=(report("egycons","CHN","bmk")+report("nhwprod","CHN","bmk"))/
sum(rs$province(rs),gdp("exp",rs));
report("EGYIntensity","CHN","pol") = (report("egycons","CHN","pol")+report("nhwprod","CHN","pol"))  /
sum(rs$province(rs),Y.l("c",rs)*vom("c",rs)*P.l("c",rs)
+Y.l("g",rs)*vom("g",rs)*P.l("g",rs)
+Y.l("i",rs)*vom("i",rs)*P.l("i",rs)
-vb(rs));
report("EGYIntensity","CHN","pol%")=(report("EGYIntensity","CHN","pol")/report("EGYIntensity","CHN","bmk")-1)*100;


*       CARBON INTENSITY IN ENERGY
report("CIntinEGY","CHN","bmk")=report("CO2emis","CHN","bmk")/(report("egycons","CHN","bmk")+report("nhwprod","CHN","bmk"));
report("CIntinEGY","CHN","pol")=report("CO2emis","CHN","pol")/(report("egycons","CHN","pol")+report("nhwprod","CHN","pol"));
report("CIntinEGY","CHN","pol%")=(report("CIntinEGY","CHN","pol")/report("CIntinEGY","CHN","bmk")-1)*100;


*       CAPITAL EARNING
*report("Capearning",rs,"bmk")=vfms("cap","c",rs)+sum((i,v),v_k(i,v,rs));
*report("Capearning",rs,"pol")=pfs.l("cap",rs)*vfms("cap","c",rs)+sum((i,v),pksupv.l(i,v,rs)*v_k(i,v,rs));
*report("Capearning",rs,"pol%")=(report("Capearning",rs,"pol")/report("Capearning",rs,"bmk")-1)*100;
*report("Capearning","CHN","bmk")=sum(rs,report("Capearning",rs,"bmk"));
*report("Capearning","CHN","pol")=sum(rs,report("Capearning",rs,"pol"));
*report("Capearning","CHN","pol%")=(report("Capearning","CHN","pol")/report("Capearning","CHN","bmk")-1)*100;

display report,report2;

$exit
$include report.gms

