*** Healthcalc2.gms

PARAMETER year(yr);
year(yr)= ord(yr);

SET     age       age group /
   1       0-4
   2       5-14
   3       15-29
   4       30-44
   5       45-59
   6       60-69
   7       70-79
   8       80+ /;

PARAMETER avg_age(age)
/
1       2
2       10
3       22
4       37
5       52
6       65
7       75
8       85
/;

PARAMETERS
pop(R,yr) regional population,
dist(R,yr,age) age cohort distribution,
Erfct(R) E-R factor for total population,
Prd(R,yr) overall population mortality rate (deaths per 10^5),
Prcpl(R,yr) overall cardio-pulmonary mortality rate,
Prdn(R,yr,age) age cohort mortality rate,
Prcpln(R,yr, age) age cohort carido-pulmonary mortality rate,
prodt(R,yr) productivity growth by region,
urbans(R,yr) urban share;

PARAMETER life(R);
life(R)=75;

* China's total population data is from China Data Online (China's national statistics)
* display population;
pop(R,yr)=population(R,yr);

** UPDATE: POPULATION DATA BY PROVINCE BY YEAR (THIS IS AVAILABLE AT CHINA DATA ONLINE)
pop(R,yr)$((ord(yr) ge 78) and (ord(yr) lt 107))=pop(R,"107")*power(0.995,107-ord(yr));


Table distribution07 (R,age)               2007 age cohort distribution (avg from 2005 and 2010 China census)
        1		2		3		4		5		6		7		8
BEJ	0.032211356	0.063895528	0.278919607	0.273159577	0.213983226	0.073115028	0.050154511	0.014570007
TAJ	0.035678331	0.079510302	0.26394825	0.249179529	0.237950055	0.073283191	0.045795676	0.014654666
HEB	0.060085895	0.113280788	0.249292732	0.243364815	0.211124	0.070693799	0.040088648	0.012069322
SHX	0.050233258	0.145930678	0.231337669	0.26441106	0.196111365	0.063410276	0.038202965	0.010361377
NMG	0.044816233	0.113816873	0.222545089	0.296449173	0.207989307	0.067924145	0.03777415	0.00868693
LIA	0.037324184	0.093803377	0.199895	0.273585063	0.249994396	0.081335628	0.048313208	0.015751293
JIL	0.03997463	0.094910407	0.219783554	0.291626601	0.23286718	0.072261008	0.037829666	0.010751961
HLJ	0.038371504	0.098233644	0.21186487	0.302103865	0.22925391	0.073375516	0.037540164	0.009260086
SHH	0.030937183	0.05751706	0.263236666	0.25154493	0.242079175	0.073131947	0.056641689	0.024903702
JSU	0.04435108	0.100903024	0.217513818	0.266729241	0.21410048	0.084920171	0.051806791	0.019674789
ZHJ	0.046929703	0.10130497	0.220532015	0.283420486	0.207112336	0.071249403	0.050729101	0.018722913
ANH	0.058816793	0.15083462	0.199874527	0.265339162	0.177646152	0.082030195	0.048568827	0.016889725
FUJ	0.053937753	0.11882158	0.251786933	0.276117155	0.18174059	0.061149214	0.040847692	0.015597803
JXI	0.077244282	0.160959317	0.206248878	0.254341277	0.183247162	0.066392304	0.038704026	0.012862754
SHD	0.053854858	0.104629662	0.215491413	0.266998643	0.216132305	0.077056593	0.048262266	0.01757524
HEN	0.066845503	0.143951706	0.229732178	0.249647743	0.187067546	0.069111328	0.039844997	0.013798032
HUB	0.047700285	0.121262097	0.212603173	0.26452786	0.216862463	0.079487806	0.043922685	0.013632836
HUN	0.060736372	0.122019914	0.213076274	0.262084442	0.198885205	0.079004131	0.048669088	0.015523857
GUD	0.050385761	0.145496274	0.297395346	0.257565369	0.149375395	0.051638715	0.034535669	0.013607469
GXI	0.072886348	0.156413611	0.221934512	0.241875076	0.17297722	0.072490186	0.044717785	0.01670526
HAI	0.065342205	0.15592087	0.258681779	0.249484786	0.157701517	0.056482697	0.040669595	0.015716551
CHQ	0.050899615	0.141107354	0.169256558	0.258693247	0.212171234	0.097573974	0.052763365	0.017533033
SIC	0.054076915	0.144906923	0.177691502	0.256124206	0.204363164	0.09457189	0.050832945	0.01743356
GZH	0.071524395	0.199541431	0.196937485	0.244725457	0.16245289	0.074343724	0.039925742	0.01054766
YUN	0.06840611	0.159190797	0.236731826	0.270675023	0.155254656	0.062099127	0.03662052	0.011021941
SHA	0.045860272	0.130307734	0.229356268	0.258870104	0.206985576	0.076898892	0.040422177	0.011301415
GAN	0.054935107	0.15812734	0.223138471	0.275323038	0.171075828	0.073914763	0.035585866	0.007903083
QIH	0.067132479	0.160966769	0.241469999	0.288824403	0.14746812	0.059132201	0.029076312	0.005929716
NXA	0.070263808	0.170744875	0.243063182	0.269275713	0.152083715	0.058505434	0.029159904	0.006903369
XIN	0.068838391	0.154226324	0.255224915	0.277406021	0.146092768	0.060865815	0.029061189	0.008280063
;

dist(R,"107",age)= distribution07(R,age);

Table distribution10 (R,age)               2010 age cohort distribution (2010 China census)
        1		2		3		4		5		6		7		8
BEJ	0.03497181	0.051067622	0.310167543	0.265204844	0.213151619	0.064633705	0.045398852	0.015404004
TAJ	0.035621295	0.062345942	0.295463846	0.243396454	0.232967271	0.073668646	0.040760377	0.015776168
HEB	0.066494169	0.101805475	0.261854719	0.227644309	0.212184366	0.076708143	0.039590165	0.013718653
SHX	0.05104183	0.119937077	0.259717119	0.251751276	0.202246096	0.065805873	0.03795229	0.011548438
NMG	0.045285065	0.095425291	0.235102387	0.284020009	0.225361953	0.066063417	0.038971977	0.0097699
LIA	0.035179208	0.079047009	0.210751107	0.254989294	0.26571751	0.086499361	0.049510287	0.018306224
JIL	0.039304385	0.080592792	0.223738185	0.277646245	0.246617259	0.078751888	0.040425763	0.012923483
HLJ	0.036011466	0.083382021	0.219227227	0.286900313	0.244171091	0.077623863	0.04096668	0.011717338
SHH	0.034462324	0.051677044	0.274237337	0.257487229	0.2314073	0.078356125	0.046837257	0.025535384
JSU	0.048400819	0.081695311	0.242281897	0.253003965	0.214759292	0.087645316	0.050888763	0.021324637
ZHJ	0.044723462	0.087363359	0.239019366	0.277582896	0.212434107	0.073449262	0.045712532	0.019715016
ANH	0.062072318	0.115676468	0.22313727	0.26198757	0.187017756	0.084954391	0.047093747	0.01806048
FUJ	0.05765844	0.096991759	0.272000704	0.273181702	0.185992645	0.059931262	0.037913015	0.016330473
JXI	0.077696773	0.141345533	0.235231708	0.255866966	0.175443269	0.064053559	0.037246019	0.013116174
SHD	0.055690423	0.101672362	0.228458157	0.247829608	0.218838647	0.081919034	0.046576024	0.019015746
HEN	0.075583044	0.134427919	0.246256791	0.23081539	0.185636013	0.07350729	0.03897297	0.014800584
HUB	0.052064436	0.087071207	0.251772175	0.251448437	0.21833077	0.082033621	0.043186044	0.014093309
HUN	0.063710692	0.112489928	0.229408237	0.250091102	0.198854954	0.079771069	0.04849478	0.017179238
GUD	0.053917861	0.114831684	0.315243207	0.262009075	0.156678902	0.050172709	0.032636436	0.014510126
GXI	0.07649264	0.140586989	0.237707931	0.238800106	0.175257602	0.069301246	0.044123426	0.017730059
HAI	0.069715856	0.128098359	0.272460599	0.24339153	0.173060554	0.054889099	0.040743886	0.017640116
CHQ	0.054311924	0.115671127	0.206626426	0.243855701	0.205355928	0.100883584	0.053414647	0.019880664
SIC	0.053185607	0.116517732	0.212482744	0.25828976	0.196501128	0.094502196	0.049705358	0.018815475
GZH	0.070195694	0.182426084	0.210484746	0.243779454	0.164726759	0.073859472	0.042337874	0.012189917
YUN	0.063478253	0.143775657	0.246905884	0.269323189	0.165886502	0.061202261	0.036946258	0.012481996
SHA	0.048388825	0.098671996	0.270572895	0.247161045	0.20669852	0.075889925	0.041333869	0.011282925
GAN	0.054335473	0.127251516	0.251812347	0.259924013	0.182304205	0.075503466	0.04035153	0.008517449
QIH	0.065547566	0.143651642	0.249364328	0.28741294	0.159492657	0.057104108	0.030759289	0.006667469
NXA	0.066180739	0.147746435	0.254656383	0.271019226	0.163704444	0.058155792	0.031032398	0.007504582
XIN	0.071700966	0.132820479	0.260984245	0.281501058	0.15638366	0.057542338	0.030945394	0.00812186
;

dist(R,"110",age)= distribution10(R,age);

** UPDATE: AGE DISTRIBUTION DATA BY PROVINCE BY YEAR (SHOULD BE EXTROPOLATED FROM CENSUS DATA)
dist(R,yr,age)$(ord(yr) lt 107)=dist(R,"107",age);
dist(R,yr,age)$(ord(yr) ge 107)=dist(R,"110",age);

* display dist;


** POPULATION DISTRIBUTION BY COHORT FOR 2015 AND AFTER NEEDS ESTIMATION...

** ER for chronic mortalities
Erfct(R)=0.25;
*This ER factor is calculated from Pope et. al 2002, and is for PM10
*This ER factor is in % per ug*m^3
*PM 10 levels for USA obtained by taking observed measurements and fitting lines to replicate the data

PARAMETER pm10(R,yr);
pm10(R, yr)$(ord(yr) lt 81) = 317.10;
pm10(R, "81")= 317.10;
pm10(R, "82")= 315.58;
pm10(R, "83")= 291.61;
pm10(R, "84")= 300.07;
pm10(R, "85")= 295.93;
pm10(R, "86")= 285.42;
pm10(R, "87")= 265.38;
pm10(R, "88")= 217.41;
pm10(R, "89")= 199.90;
pm10(R, "90")= 188.88;
pm10(R, "91")= 172.59;
pm10(R, "92")= 168.28;
pm10(R, "93")= 167.64;
pm10(R, "94")= 170.11;
pm10(R, "95")= 164.38;
pm10(R, "96")= 188.50;
pm10(R, "97")= 150.16;
pm10(R, "98")= 149.56;
pm10(R, "99")= 135.45;
pm10(R, "100")= 124.32;
pm10(R, "101")= 131.44;
pm10(R, "102")= 124.80;
pm10(R, "103")= 121.92;
pm10(R, "104")= 118.09;
pm10(R, yr)$(ord(yr) ge 105) = 108.52;

$ontext
* For WHO Scenario (PM10 = 20 ug/m3; O3 = 70 ug/m3)
pm10("CHN", y) = 20;
$offtext

** UPDATE???
** all mortality rates for China for 1999 (UN database)
parameter population_mort(R,yr);
population_mort(R,yr)= 0.00551;

parameter cardio_mort(R,yr);
cardio_mort(R,yr) = 1.71E-3;

* Cohort-specific cardio-pulmonary mortality rates for CHN are for 2003 (Ministry of Health).
Table cohort_mortCHN(*,age)
        1               2               3               4               5               6               7               8
CHN     0.0019388       0.0002151       0.0003803       0.0014278       0.0050392       0.0163878       0.0490315       0.1265668
;
parameter cohort_mort(R,age);
cohort_mort(R,age)=cohort_mortCHN("CHN",age);


* Cohort-specific cardio-pulmonary mortality rates for CHN are for 2003 (Ministry of Health).
Table cohort_cardioCHN(*,age)
          1         2        3        4          5          6          7          8
CHN       1.976E-4  1.64E-5  2.97E-5  1.668E-4   9.143E-4   4.842E-3   1.905E-2   5.822E-2
;
parameter cohort_cardio(R,age);
cohort_cardio(R,age)=cohort_cardioCHN("CHN",age);

* display cohort_cardio;

prd(R,yr)=population_mort(R,yr);
prcpl(R,yr)= cardio_mort(R,yr);
prdn(R,yr,age)=cohort_mort(R,age);
prcpln(R,yr,age)= cohort_cardio(R,age);


** UPDATE
Table productivity_growthCHN(*,yr)
             78            79           80           81           82           83           84           85           86           87           88           89           90            91           92           93           94           95           96           97           98           99           100           101           102           103*200
CHN          1.095439      1.053131     1.043976     1.019183     1.053182     1.081753     1.109909     1.096856     1.058180     1.084265     1.081229     1.022278     0.886988      1.079627     1.130588     1.128807     1.120152     1.09906      1.085881     1.079381     1.065533     1.06459      1.073608      1.069056      1.080426      1.097746
;
*$offtext

* China data from 1971-1998 from James H Gapinski "The Panda that grew" China Economic Review 12(2001) 263-279, Table 1 (old numbers)
* 2000+ data for China is the average prod. growth rate from 1971-1998 (old productivity numbers)
* New numbers for China's productivity growth were computed by dividing World Bank's GDP numbers by total employment.

prodt(R,yr)= productivity_growthCHN("CHN",yr);

* China's actual urbanization ratio data (computed by Da Zhang from CSY)
urbans("BEJ","107")=84.50/100;
urbans("TAJ","107")=76.31/100;
urbans("HEB","107")=40.25/100;
urbans("SHX","107")=44.03/100;
urbans("NMG","107")=50.15/100;
urbans("LIA","107")=59.20/100;
urbans("JIL","107")=53.16/100;
urbans("HLJ","107")=53.90/100;
urbans("SHH","107")=88.70/100;
urbans("JSU","107")=53.20/100;
urbans("ZHJ","107")=57.20/100;
urbans("ANH","107")=38.70/100;
urbans("FUJ","107")=48.70/100;
urbans("JXI","107")=39.80/100;
urbans("SHD","107")=46.75/100;
urbans("HEN","107")=34.34/100;
urbans("HUB","107")=44.30/100;
urbans("HUN","107")=40.45/100;
urbans("GUD","107")=63.14/100;
urbans("GXI","107")=36.24/100;
urbans("HAI","107")=47.20/100;
urbans("CHQ","107")=48.34/100;
urbans("SIC","107")=35.60/100;
urbans("GZH","107")=28.24/100;
urbans("YUN","107")=31.60/100;
urbans("SHA","107")=40.62/100;
urbans("GAN","107")=31.59/100;
urbans("QIH","107")=44.02/100;
urbans("NXA","107")=40.07/100;
urbans("XIN","107")=39.15/100;

urbans("BEJ","110")=0.85;
urbans("TAJ","110")=0.7801;
urbans("HEB","110")=0.43;
urbans("SHX","110")=0.4599;
urbans("NMG","110")=0.534;
urbans("LIA","110")=0.6035;
urbans("JIL","110")=0.5332;
urbans("HLJ","110")=0.555;
urbans("SHH","110")=0.886;
urbans("JSU","110")=0.556;
urbans("ZHJ","110")=0.579;
urbans("ANH","110")=0.421;
urbans("FUJ","110")=0.514;
urbans("JXI","110")=0.4318;
urbans("SHD","110")=0.4832;
urbans("HEN","110")=0.377;
urbans("HUB","110")=0.46;
urbans("HUN","110")=0.432;
urbans("GUD","110")=0.634;
urbans("GXI","110")=0.392;
urbans("HAI","110")=0.4913;
urbans("CHQ","110")=0.5159;
urbans("SIC","110")=0.387;
urbans("GZH","110")=0.2989;
urbans("YUN","110")=0.34;
urbans("SHA","110")=0.435;
urbans("GAN","110")=0.3265;
urbans("QIH","110")=0.419;
urbans("NXA","110")=0.461;
urbans("XIN","110")=0.3985;

** UPDATE
urbans(R,yr)$(ord(yr) lt 107)=urbans(R,"107");
urbans(R,yr)$(ord(yr) ge 107)=urbans(R,"110");

* DISPLAY urbans;

PARAMETER cum_exposure(R,yr,age)   cum exposure by age group for region;
PARAMETER birth_year(yr,age);
PARAMETER Erfctn(R,yr,age) age conditioned E-R factor;
PARAMETER mort_inc(R,yr,age) mortality rate increase from PM exposure;
PARAMETER chr_mort(R,yr,age);
PARAMETER cum_mort(R,yr) total deaths per year;
PARAMETER inc_mort(R,yr) deaths + past deaths per cohort;
PARAMETER tot_mort(R,yr) total deaths + past deaths;
PARAMETER laborloss(R,yr) total labor units lost;
PARAMETER leisloss(R,yr) total leisure units lost;
PARAMETER perc_loss(R,yr) percentage of pop lost;
PARAMETER laborpop(R,yr) total working population;
PARAMETER perc_labloss(R,yr) percentage of labor pop lost;


*Step 1: Cumulative PM10 exposure for each cohort

birth_year(yr,age)= year(yr)-avg_age(age);
cum_exposure(R,yr,age)=0.0;
cum_exposure(R,yr,age)= SUM(l$((ord(l) gt birth_year(yr,age)) and (ord(l) le ord(yr))), pm10(R,l));
cum_exposure(R,yr,age)= cum_exposure(R,yr,age)/avg_age(age);

*DISPLAY cum_exposure;


*Step 2: Calculate the cohort conditioned E-R factors (See Yang & Reilly paper)

* for conditioned ER
Erfctn(R,yr,age)= Erfct(R)*(Prcpln(R,yr,age)*((Prd(R,yr))/(Prcpl(R,yr)*Prdn(R,yr,age))));

*display Erfctn;


*Step 3: Calculate the increase in mortality rate
mort_inc(R,yr,age)= Erfctn(R,yr,age)*cum_exposure(R,yr,age);


*note- this value is still in %
mort_inc(R,yr,age)= mort_inc(R,yr,age)/100;


*Step 4: Calculate extra mortalities for each cohort

chr_mort(R,yr,age) = pop(R,yr)*dist(R,yr,age)*urbans(R,yr)*prdn(R,yr,age)*mort_inc(R,yr,age);


*Step 5: Total mortalities (assuming that each loss only effects one year)
cum_mort(R,yr)= SUM(age $(ord(age) gt 3 and ord(age) le 8), chr_mort(R,yr,age)) ;

*DISPLAY cum_mort;

*Step 6: calculate mortalities, with assumption that years lost have effects in the future (in order to get total labor losses)

PARAMETER cohort_loss(R,yr,age), cohort_leis_loss(R,yr,age);

** first calculate the lost labor,  then add lost elderly leisure   ???
cohort_loss(R,yr, '4') = chr_mort(R,yr,'4')+SUM(ll $(ord(ll) ge (ord(yr)-28) and (ord(ll) lt ord(yr))), (chr_mort(R,ll,'4')
                                *(prod(l $(ord(l) ge ord(ll)and (ord(l) le ord(yr))), prodt(R,l+1)))));
cohort_leis_loss(R,yr,'4')= chr_mort(R,yr, '4')+(2/3*SUM(ll $((ord(ll) ge (ord(yr)-38)) and (ord(ll) lt (ord(yr)))), (chr_mort(R,ll,'4')
                                *(prod(l $(ord(l) ge ord(ll)and (ord(l) le ord(yr))), prodt(R,l+1))))));



cohort_loss(R,yr, '5') = SUM(ll $(ord(ll) ge (ord(yr)-18) and (ord(ll) le ord(yr))), (chr_mort(R,ll,'5')
                                *(prod(l $(ord(l) ge ord(ll)and (ord(l) le ord(yr))), prodt(R,l+1)))));
cohort_leis_loss(R,yr,'5')= cohort_loss(R,yr, '5')+ (
                                2/3*SUM(ll $((ord(ll) ge (ord(yr)-28)) and (ord(ll) lt (ord(yr)))), (
                                        chr_mort(R,ll,'5')*(prod(l $(ord(l) ge ord(ll)and (ord(l) le ord(yr))), prodt(R,l+1))))));

cohort_loss(R,yr, '6') = chr_mort(R,yr,'6');

* No wage loss for age groups 65+ (KM Nam)
cohort_loss(R,yr, '6') = 0.5*cohort_loss(R,yr, '6');

cohort_leis_loss(R,yr,'6')= cohort_loss(R,yr,'6') +
                                (2/3*(SUM(ll $(ord(ll) ge (ord(yr)-10) and (ord(ll) le ord(yr))),
                                        (chr_mort(R,ll,'6')*(prod(l $((ord(l) ge ord(ll))and (ord(l) le ord(yr))), prodt(R,l+1)))))));

*cohorts 7 and 8 only lose leisure

cohort_leis_loss(R,yr,'7')= (2/3)*chr_mort(R,yr,'7');

* No leisure loss for age groups 75+
cohort_leis_loss(R,yr,'7')= 0.5*cohort_leis_loss(R,yr,'7');

*cohort_leis_loss(R,yr,'8')= (2/3)*chr_mort(R,yr,'8');
cohort_leis_loss(R,yr,'8')=0;

inc_mort(R,yr)= SUM(age, cohort_loss(R,yr,age))+ SUM(age, cohort_leis_loss(R,yr,age));

PARAMETER u_pop_index(R,yr);

*display pop,urbans;

** UPDATE
u_pop_index(R,yr)= (pop(R, yr)*urbans(R,yr))/(pop(R,'107')*urbans(R,'107'));

*DISPLAY u_pop_index;
*DISPLAY chr_mort;
*DISPLAY cohort_loss;
*DISPLAY cohort_leis_loss;
*DISPLAY inc_mort;

laborloss(R,yr)$(pop(R,yr) ne 0)= inc_mort(R,yr)/pop(R,yr);

*Display laborloss;






*** EPPATREND

PARAMETER CHRONIC_MORT_LOSS(R,T)  fractional loss of each region's population;
CHRONIC_MORT_LOSS(R,T) = 0;


CHRONIC_MORT_LOSS(R, "2007") = laborloss(R, '80');
CHRONIC_MORT_LOSS(R, "2010") = laborloss(R, '85');
CHRONIC_MORT_LOSS(R, "2015") = laborloss(R, '90');
CHRONIC_MORT_LOSS(R, "2020") = laborloss(R, '95');
CHRONIC_MORT_LOSS(R, "2025") = laborloss(R, '100');
chronic_mort_loss(R, "2030") = laborloss(R, '105');

* DISPLAY Chronic_mort_loss;


*  added pollution growth/decline index - yr one is set to reference value of 1.
PARAMETER Pop_index(R,T)		index of population growth with reference value of 1;
PARAMETER P_INDEX(R, PLT, T)         index of pollution growth with reference value of 1;

P_INDEX(R,PLT,T) = 1.0;
Pop_index(R,T) =1.0;

**
Pop_index(R,'2007')= u_pop_index(R, '80');
Pop_index(R,'2010')= u_pop_index(R, '85');
Pop_index(R,'2015')= u_pop_index(R, '90');
Pop_index(R,'2020')= u_pop_index(R, '95');
Pop_index(R,'2025')= u_pop_index(R, '100');
Pop_index(R,'2030')= u_pop_index(R, '105');


*$ontext
* set rest of years to 0 pollution so we can compare results from control & no control down the line
P_INDEX(R, PLT, "2007") = 1;


$ontext
*WHO levels levels for China scenarios
P_INDEX(R, "1", T) =1.0;
P_INDEX(R, "2", T)=1;
P_INDEX(R, "3", T)=0.279283;
P_INDEX(R, "4", T)=3.10;
P_INDEX(R, "6", T)=0.185362;
$offtext


*Historical PM levels for China scenarios

* for historical, Consider O3 and PM10 only.
* PM10 data is actual, and is from China's Environmental Statistical Yearbooks.
* O3 data is a modeled one, and is from Lok Lamsal at Dalhousie (a 1x1 degree global simulation of afternoon O3 for the globe for the present days.)

*$ontext
P_INDEX(R, "1", "2007")=1.1133;
P_INDEX(R, "1", "2010")=1.1291;
P_INDEX(R, "1", "2015")=1.1315;
P_INDEX(R, "1", "2020")=1.1340;
P_INDEX(R, "1", "2025")=1.1644;
*P_INDEX(R, "1", "2030")=1.1815;
P_INDEX(R, "1", "2030")=0.2436;

P_INDEX(R, "2", T)=1;
P_INDEX(R, "3", T)=1;
P_INDEX(R, "4", T)=1;


P_INDEX(R, "6", "2007")=0.9653;
P_INDEX(R, "6", "2010")=0.7972;
P_INDEX(R, "6", "2015")=0.5472;
P_INDEX(R, "6", "2020")=0.4970;
P_INDEX(R, "6", "2025")=0.3914;
*P_INDEX(R, "6", "2030")=0.3422;
P_INDEX(R, "6", "2030")=3.154E-6;
P_INDEX(R, "6", "2030")=0.17;


** PM10 Projection (Historical)
P_INDEX(R, PLT, t)$(ord(t) gt 6) = P_INDEX(R, PLT, "2030");
*$offtext



$ontext
*Green levels for China scenario	

P_INDEX(R, "1", "2007") = 0.2436;
P_INDEX(R, "1", "2010") = 0.2436;
P_INDEX(R, "1", "2015") = 0.2436;
P_INDEX(R, "1", "2020") = 0.2436;
P_INDEX(R, "1", "2025") = 0.2436;
P_INDEX(R, "1", "2030") = 1.1815;
*P_INDEX(R, "1", "2030") = 0.2436;

P_INDEX(R, "2", T) = 1;
P_INDEX(R, "3", T) = 1;
P_INDEX(R, "4", T) = 1;

P_INDEX(R, "6", "2007") = 3.154E-6;
P_INDEX(R, "6", "2010") = 3.154E-6;
P_INDEX(R, "6", "2015") = 3.154E-6;
P_INDEX(R, "6", "2020") = 3.154E-6;
P_INDEX(R, "6", "2025") = 3.154E-6;
P_INDEX(R, "6", "2030") = 0.3422;
*P_INDEX(R, "6", "2030") = 3.154E-6;

$offtext


$ontext
*POLICY (WHO) levels for China scenario	
P_INDEX(R, "1", "2007") = 0.063072;
P_INDEX(R, "1", "2010") = 0.063072;
P_INDEX(R, "1", "2015") = 0.063072;
P_INDEX(R, "1", "2020") = 0.063072;
P_INDEX(R, "1", "2025") = 0.063072;
P_INDEX(R, "1", "2030") = 0.063072;

P_INDEX(R, "2", T) = 1;
P_INDEX(R, "3", T) = 1;
P_INDEX(R, "4", T) = 1;

P_INDEX(R, "6", "2007") = 0.220751;
P_INDEX(R, "6", "2010") = 0.220751;
P_INDEX(R, "6", "2015") = 0.220751;
P_INDEX(R, "6", "2020") = 0.220751;
P_INDEX(R, "6", "2025") = 0.220751;
P_INDEX(R, "6", "2030") = 0.220751;
$offtext

*CHRONIC_MORT_LOSS(R, T)$(ord(T) gt 1) = 0;

* Adjust pollution index so that it also reflects increase in urban population
* In China's case, O3's P_Index is already averaged by using population as weight (1x1 grid cell), and PM10's P_index is #s for large urban areas.
* Thus, no reason to consider Pop_index again for China's P_index.

*DISPLAY P_INDEX;
*DISPLAY CHRONIC_MORT_LOSS;



*** Healthends
*** this program calculates the costs of urban air-pollution related health
*** endpoints
*all data comes from Yang & Reilly 2004

SET OUTCOME
/
RHA      respiratory hospital admissions
CHA      cerebrovascular hospital admissions
SD       symptom days
AM       acute mortality
CBA      chronic bronchitis (adults)
CBC      chronic bronchitis (children)
CC       chronic cough (child only)
RAD      restricted activity day (adults)
MRD      minor restricted day (adults)
CHF      congestive heart failure (elderly)
AA       asthma attack (all asthma)
BDA      bronchodilator (asthma adult)
BDC      bronchodilator (asthma child)
CGA      cough (asthma adult)
CGC      cough (asthma child)
WHA      wheeze (asthma adult)
WHC      wheeze (asthma child)
IHD      ischaemic heart disease (sensitivity)
COP      ER visit for chron. obs. pulm. disease (sensitivity)
ERA      ER visit for asthma (sensitivity)
CDHA	 cardiovascular hospital admissions
SDA	 symptom days (adults)
SDC	 symptom days (children)
WLD	 work loss days (adults)
LRSA	 lower respiratory symptoms (adults)
LRSC	 lower respiratory symptoms (children)	
/;
* LRSA = CGA + WHA
* LRSC = CGS + WHC


PARAMETERS       

Erfct_P(R,PLT,outcome)              E-R function for endpoint,
serv_cost(R,PLT,yr, outcome)         total service demand ($),
lab_cost(R,PLT,yr, outcome)          total labor lost ($),
leis_cost(R,PLT,yr, outcome)         total leisure lost ($),
cases(R,PLT,yr, outcome)             #cases of endpoint,
healthcost(R,outcome)             dollar cost of outcome
;


PARAMETER
poll_yr1(R,PLT)    in ppm except 6 in ug per m^3 ;
*$ontext
**CHN's 1970 historical concentration levels of the five air pollutants, all in ug/m^3 (Consider O3 and PM10 only)
* Updated by KM Nam
poll_yr1(R, "1")= 82.1;
poll_yr1(R, "2")= 0.01;
poll_yr1(R, "3")= 0.01;
poll_yr1(R, "4")= 0.01;    
poll_yr1(R, "5")= 0.01;
poll_yr1(R, "6")= 317.1;
*$offtext


PARAMETER poll_level(R,PLT,yr);

** WHAT HAPPEND HERE?
PARAMETER P_index1(R,PLT,yr);

p_index1(R,PLT, "80")= p_index(R,PLT, "2007");
p_index1(R,PLT, "85")= p_index(R,PLT, "2010");
p_index1(R,PLT, "90")= p_index(R,PLT, "2015");
p_index1(R,PLT, "95")= p_index(R,PLT, "2020");
p_index1(R,PLT, "100")= p_index(R,PLT, "2025");
p_index1(R,PLT, "105")= p_index(R,PLT, "2030");
p_index1(R,PLT, "107")= p_index(R,PLT, "2030");
p_index1(R,PLT, "110")= p_index(R,PLT, "2035");
p_index1(R,PLT, "115")= p_index(R,PLT, "2040");
p_index1(R,PLT, "120")= p_index(R,PLT, "2045");
p_index1(R,PLT, "125")= p_index(R,PLT, "2050");
p_index1(R,PLT, "130")= p_index(R,PLT, "2055");

poll_level(R,PLT,yr) = poll_yr1(R,PLT)*P_index1(R,PLT,yr);

*display poll_level;



*for green scenarios
*poll_level(R,PLT,yr)= poll_level(R,PLT, y) * 0.01;


*$ontext
* The following numbers are from ExternE (1997).
* Revised by KM Nam.

TABLE Erfactor(PLT, outcome)   #cases per ug*m^3*year

         RHA       CHA        SD        AM        CBA        CBC        CC
1        7.09E-06  0          3.30E-02  5.90E-04  0          0          0
2        0         0          0         0         0          0          0
3        2.04E-06  0          0         7.20E-04  0          0          0
4        1.40E-06  0          0         0         0          0          0
5        2.07E-06  5.04E-06   0         4.00E-04  4.90E-05   1.61E-03   2.07E-03
6        2.07E-06  5.04E-06   0         0.0004    4.90E-05   1.61E-03   2.07E-03 


+        RAD       MRD        CHF       AA        BDA        BDC        CGA
1        0         9.76E-03   0         4.29E-03  0          0          0
2        0         0          5.55E-7   0         0          0          0
3        0         0          0         0         0          0          0
4        0         0          0         0         0          0          0
5        2.50E-02  0          1.85E-05  0         1.63E-01   7.80E-02   1.68E-01
6        2.50E-02  0          1.85E-05  0         1.63E-01   7.80E-02   1.68E-01


+        CGC       WHA        WHC      IHD        COP        ERA
1        0         0          0        0          0          1.32E-05
2        0         0          0        4.17E-07   0          0
3        0         0          0        0          1.20E-05   1.08E-05
4        0         0          0        0          0          0
5        1.33E-01  6.10E-02   1.03E-01 1.75E-05   7.20E-06   6.45E-06
6        1.33E-01  6.10E-02   1.03E-01 1.75E-05   7.20E-06   6.45E-06
;
*$offtext



* The following numbers are most recent ones. ExternE (1997)-based numbers are revised and updated on the basis of ExternE (2005).
* Added by KM Nam

*$ontext
TABLE Erfactor2(PLT, outcome)   #cases per ug*m^3*year		
							
	RHA	        CHA	        CDHA	        SD	        SDA		SDC		AM
1	1.25E-05	0	        0	        3.30E-02	0		0		3.00E-04
2	0		0		0	        0	        0		0		0
3	2.04E-06	0	        0	        0		0		0		7.20E-04
4	1.40E-06	0	        0	        0		0		0		0
5	2.07E-06	5.04E-06	4.34E-06	0		1.30E-01	1.86E-01	6.00E-04
6	7.03E-06	5.04E-06	4.34E-06	0		1.30E-01	1.86E-01	6.00E-04
							
							
+	CBA		CBC		CC		RAD		MRD		WLD		CHF
1	0		0		0		0		1.15E-02	0		0
2	0		0		0		0		0		0		5.55E-07
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	2.65E-05	1.61E-03	2.07E-03	5.41E-02	3.46E-02	1.24E-02	1.85E-05
6	2.65E-05	1.61E-03	2.07E-03	5.41E-02	3.46E-02	1.24E-02	1.85E-05
							
							
+	AA		BDA		BDC		CGA		CGC		WHA		WHC
1	4.29E-03	7.30E-02	0		0		9.30E-02	0		1.60E-02
2	0		0		0		0		0		0		0
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	0		9.12E-02	1.80E-02	1.68E-01	1.33E-01	6.10E-02	1.03E-01
6	0		9.12E-02	1.80E-02	1.68E-01	1.33E-01	6.10E-02	1.03E-01
							
+	LRSA		LRSC		IHD		COP		ERA		
1	0		0		0		0		1.32E-05		
2	0		0		4.17E-07	0		0		
3	0		0		0		1.20E-05	1.08E-05		
4	0		0		0		0		0		
5	1.30E-01	1.86E-01	1.75E-05	7.20E-06	6.45E-06		
6	1.30E-01	1.86E-01	1.75E-05	7.20E-06	6.45E-06
;
*$offtext


* For sensitivity only - Upper bound ER (ExternE 2005) values
$ontext
TABLE Erfactor2(PLT, outcome)   #cases per ug*m^3*year		
							
	RHA	        CHA	        CDHA	        SD	        SDA		SDC		AM
1	3.00E-05	0	        0	        6.03E-02	0		0		4.00E-04
2	0		0		0	        0	        0		0		0
3	2.04E-06	0	        0	        0		0		0		7.20E-04
4	1.40E-06	0	        0	        0		0		0		0
5	1.03E-05	9.69E-06	6.51E-06	0		2.43E-01	2.77E-01	8.00E-04
6	1.03E-05	9.69E-06	6.51E-06	0		2.43E-01	2.77E-01	8.00E-04
							
							
+	CBA		CBC		CC		RAD		MRD		WLD		CHF
1	0		0		0		0		1.86E-02	0		0
2	0		0		0		0		0		0		5.55E-07
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	5.41E-05	3.10E-03	3.98E-03	6.08E-02	4.12E-02	1.42E-02	3.56E-05
6	5.41E-05	3.10E-03	3.98E-03	6.08E-02	4.12E-02	1.42E-02	3.56E-05
							
							
+	AA		BDA		BDC		CGA		CGC		WHA		WHC
1	8.25E-03	1.57E-01	0		0		2.22E-01	0		8.10E-02
2	0		0		0		0		0		0		0
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	0		2.77E-01	1.06E-01	3.07E-01	2.43E-01	1.11E-01	1.88E-01
6	0		2.77E-01	1.06E-01	3.07E-01	2.43E-01	1.11E-01	1.88E-01
							
+	LRSA		LRSC		IHD		COP		ERA		
1	0		0		0		0		1.32E-05		
2	0		0		4.17E-07	0		0		
3	0		0		0		1.20E-05	1.08E-05		
4	0		0		0		0		0		
5	2.43E-01	2.77E-01	3.37E-05	7.20E-06	6.45E-06		
6	2.43E-01	2.77E-01	3.37E-05	7.20E-06	6.45E-06
;
$offtext


* For sensitivity only - Lower bound ER (ExternE 2005) values
$ontext
TABLE Erfactor2(PLT, outcome)   #cases per ug*m^3*year		
							
	RHA	        CHA	        CDHA	        SD	        SDA		SDC		AM
1	0		0	        0	        5.71E-03	0		0		1.00E-04
2	0		0		0	        0	        0		0		0
3	2.04E-06	0	        0	        0		0		0		7.20E-04
4	1.40E-06	0	        0	        0		0		0		0
5	2.07E-06	3.88E-07	2.17E-06	0		1.50E-02	9.20E-02	4.00E-04
6	3.83E-06	3.88E-07	2.17E-06	0		1.50E-02	9.20E-02	4.00E-04
							
							
+	CBA		CBC		CC		RAD		MRD		WLD		CHF
1	0		0		0		0		4.40E-03	0		0
2	0		0		0		0		0		0		5.55E-07
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	2.65E-05	1.24E-04	1.59E-04	4.75E-02	2.81E-02	1.06E-02	1.42E-06
6	0		1.24E-04	1.59E-04	4.75E-02	2.81E-02	1.06E-02	1.42E-06
							
							
+	AA		BDA		BDC		CGA		CGC		WHA		WHC
1	3.30E-04	0		0		0		0		0		0
2	0		0		0		0		0		0		0
3	0		0		0		0		0		0		0
4	0		0		0		0		0		0		0
5	0		9.12E-02	1.80E-02	2.91E-02	2.30E-02	1.06E-02	1.78E-02
6	0		0		0		2.91E-02	2.30E-02	1.06E-02	1.78E-02
							
+	LRSA		LRSC		IHD		COP		ERA		
1	0		0		0		0		1.32E-05		
2	0		0		4.17E-07	0		0		
3	0		0		0		1.20E-05	1.08E-05		
4	0		0		0		0		0		
5	1.50E-02	9.20E-02	1.35E-06	7.20E-06	6.45E-06		
6	1.50E-02	9.20E-02	1.35E-06	7.20E-06	6.45E-06
;
$offtext


* Added by KM Nam
Erfct_P(R,PLT,outcome) = Erfactor2(PLT, outcome);

* two lines are added to check
Erfct_P(R,PLT,"sdc")=0;
Erfct_P(R,PLT,"cbc")=0;



* EUR numbers are of the following are updated on the basis of ExternE (2005).
* EUR and CHN numbers are based on 1997 USD.
* Added by KM Nam

TABLE healthcostCHN(*, outcome) dollar values in USD 2000
	RHA	CHA	SD	AM	CBA	CBC	CC	RAD	MRD	CHF	AA	BDA	BDC	CGA	CGC	WHA	WHC	IHD	COP	ERA	CDHA	SDA	SDC	WLD	LRSA	LRSC
CHN	284	284	0.6	662	8000	13	0.6	2.32	0.6	284	4	0	0	0.6	0.6	0.6	0.6	284	23	23	284	0.6	0.6	1.43	0.6	0.6
;		

*(USD 1997 for China and EUR, using World Bank WC estimates)
*CBC is given the cost of Lower Resp Infection for China;
* Numbers for EUR are based on 1997 USD, and are revised on the basis of ExternE (2005), whenever possible.


healthcost(R, outcome)= healthcostCHN("CHN", outcome);
*display healthcost;


SET type
/
serv     service
lab      labor
leis     leisure
/;

$ontext
TABLE resource(type, outcome)
        RHA   CHA   SD    AM       CBA   CBC   CC    RAD   MRD  CHF   AA  BDA  BDC  CGA  CGC  WHA  WHC  IHD   COP  ERA
serv    0.85  0.85  0.5   0        0.85  0.85  0.85  0     0    0.85  1   1    1    1    1    1    1    0.85  0.8  0.8
lab     0.04  0.04  0     0.23077  0     0     0     0.35  0    0     0   0    0    0    0    0    0    0     0    0.02
leis    0.11  0.11  0.5   0.76923  0.15  0.15  0.15  0.65  1    0.15  0   0    0    0    0    0    0    0.15  0.2  0.18
;
$offtext


*table for sensitivity

$ontext
*TABLE resource(type, outcome)
*	RHA	CHA	SD	AM	CBA	CBC	CC	RAD	MRD	CHF	AA	BDA	BDC	CGA	CGC	WHA	WHC	IHD	COP	ERA
*serv	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
*lab	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
*leis	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0

*	RHA	CHA	SD	AM	CBA	CBC	CC	RAD	MRD	CHF	AA	BDA	BDC	CGA	CGC	WHA	WHC	IHD	COP	ERA
*serv	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
*lab	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
*leis	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
*
*	RHA		CHA		SD	AM		CBA	CBC	CC	RAD		MRD	CHF	AA	BDA	BDC	CGA	CGC	WHA	WHC	IHD	COP	ERA
*serv	0.15		0.15		0.5	0		0.85	0.85	0.85	0		0	0.85	1	1	1	1	1	1	1	0.85	0.8	0.8
*lab	0.309090909	0.309090909	0	0.3000013	0	0	0	0.538461538	0	0	0	0	0	0	0	0	0	0	0	0.022222222
*leis	0.540909091	0.540909091	0.5	0.6999987	0.15	0.15	0.15	0.461538462	1	0.15	0	0	0	0	0	0	0	0.15	0.2	0.177777778

        RHA   CHA   SD    AM       CBA   CBC   CC    RAD   MRD  CHF   AA  BDA  BDC  CGA  CGC  WHA  WHC  IHD   COP  ERA
serv    0.85  0.85  0.5   0        0.85  0.85  0.85  0.5   0    0.85  1   1    1    1    1    1    1    0.85  0.8  0.8
lab     0.04  0.04  0     0.23077  0     0     0     0.175 0    0     0   0    0    0    0    0    0    0     0    0.02
leis    0.11  0.11  0.5   0.76923  0.15  0.15  0.15  0.325 1    0.15  0   0    0    0    0    0    0    0.15  0.2  0.18	
;
$offtext


$ontext
TABLE resource(type, outcome)
        RHA   CHA   SD    AM       CBA   CBC   CC    RAD   MRD  CHF   AA  BDA  BDC  CGA  CGC  WHA  WHC  IHD   COP  ERA
serv    0.85  0.85  0.5   0        0.85  0.85  0.85  0.5   0    0.85  1   1    1    1    1    1    1    0.85  0.8  0.8
lab     0.04  0.04  0     0.23077  0     0     0     0.175 0    0     0   0    0    0    0    0    0    0     0    0.02
leis    0.11  0.11  0.5   0.76923  0.15  0.15  0.15  0.325 1    0.15  0   0    0    0    0    0    0    0.15  0.2  0.18	
;
$offtext


TABLE resource(type, outcome)
	RHA	CHA	SD	AM	CBA	CBC	CC	RAD	MRD	CHF	AA	BDA	BDC	CGA	CGC	WHA	WHC	IHD	COP	ERA	CDHA	SDA	SDC	WLD	LRSA	LRSC
serv	0.85	0.85	0.5	0	0.85	0.85	0.85	0.5	0	0.85	1	1	1	1	1	1	1	0.85	0.8	0.8	0.85	0.5	0.5	0.5	1	1
lab	0.04	0.04	0	0.23077	0	0	0	0.175	0	0	0	0	0	0	0	0	0	0	0	0.02	0.04	0	0	0.175	0	0
leis	0.11	0.11	0.5	0.76923	0.15	0.15	0.15	0.325	1	0.15	0	0	0	0	0	0	0	0.15	0.2	0.18	0.11	0.5	0.5	0.325	0	0
;


parameter perc(type, outcome);

perc(type,outcome) = resource(type, outcome);


* calculate cases for each health endpoint

* first outcomes for the entire population

cases(R,PLT,yr, "RHA")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,PLT, "RHA")*poll_level(R,PLT,yr);
cases(R,PLT,yr, "CHA")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,PLT, "CHA")*poll_level(R,PLT,yr);
cases(R,PLT,yr, "SD")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,PLT, "SD")*poll_level(R,PLT,yr);
cases(R,PLT,yr, "AM")= urbans(R,yr)*prd(R,yr)*pop(R,yr)*Erfct_P(R,PLT, "AM")*poll_level(R,PLT,yr);
* AM ERfct is in % increase in mort rate, so have to include overall mort rate to get number of cases
* outcomes for adults only


*$ontext
* calculate cases for each health endpoint
* In China's case, O3 concentration (computed from both urban and rural numbers) affects the whole population, but PM concentration (computed from urban numbers) affects urban population only. 


**(I) first outcomes for the entire population

cases(R,"1",yr, "RHA")= pop(R,yr)*Erfct_P(R,"1", "RHA")*poll_level(R,"1",yr);
cases(R,"6",yr, "RHA")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,"6", "RHA")*poll_level(R,"6",yr);

cases(R,"6",yr, "CHA")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,"6", "CHA")*poll_level(R,"6",yr);

cases(R,"6",yr, "CDHA")= urbans(R,yr)*pop(R,yr)*Erfct_P(R,"6", "CDHA")*poll_level(R,"6",yr);

cases(R,"1",yr, "SD")= pop(R,yr)*Erfct_P(R,"1", "SD")*poll_level(R,"1",yr);

* AM ERfct is in % increase in mort rate, so have to include overall mort rate to get number of cases.
cases(R,"1",yr, "AM")= prd(R,yr)*pop(R,yr)*Erfct_P(R,"1", "AM")*poll_level(R,"1",yr);
cases(R,"6",yr, "AM")= urbans(R,yr)*prd(R,yr)*pop(R,yr)*Erfct_P(R,"6", "AM")*poll_level(R,"6",yr);

* ER functions (ExternE 2005) on AA are defined on population with asthma (4% of entire population).
cases(R,"1",yr, "AA")= 0.04*pop(R,yr)*Erfct_P(R,"1", "AA")*poll_level(R,"1",yr);




* (II) outcomes for adults only
* If not defined otherwise, adults are assumed as age groups 15+.

* ER functions (ExternE 2005) on RAD are defined on age groups 15-64.
cases(R,"6",yr, "RAD")= urbans(R,yr)*((SUM(age$(ord(age) ge 3), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "RAD")*poll_level(R,"6",yr)));


* ER functions (ExternE 2005) on MRD (O3) are defined on age groups 18-64.
cases(R,"1",yr, "MRD")= ((SUM(age$(ord(age) ge 4), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"1", "MRD")*poll_level(R,"1",yr))
                         + (0.8*(pop(R,yr)*dist(R,yr,'3')*Erfct_P(R,"1","MRD")
                                 *poll_level(R,"1",yr))));


* ER functions (ExternE 2005) on SDA (PM10) are defined on adult population with chronic respiratory symptoms (30% of adult population).
cases(R,"6",yr, "SDA")= urbans(R,yr)*((SUM(age$(ord(age) ge 3), 0.3*pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "SDA")*poll_level(R,"6",yr)));


* ER functions (ExternE 2005) on CBA (PM10) are defined on age groups 27+.
cases(R,"6",yr, "CBA")= urbans(R,yr)*((SUM(age$(ord(age) ge 4), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "CBA")*poll_level(R,"6",yr))
                         + (2/15*(pop(R,yr)*dist(R,yr,"3")*Erfct_P(R,"6","CBA")
                                 *poll_level(R,"6",yr))));


* ER functions (ExternE 2005) on BDA are defined on age groups 20+ with well-established asthma (4.5% of total adult population).
cases(R,"1",yr, "BDA")= ((SUM(age$(ord(age) ge 3), 0.045*pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"1", "BDA")*poll_level(R,"1",yr)));
cases(R,"6",yr, "BDA")= urbans(R,yr)*((SUM(age$(ord(age) ge 3), 0.045*pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "BDA")*poll_level(R,"6",yr)));


* ER functions (ExternE 2005) on LRSA are defined on adult population with chronic respiratory symptoms (30% of total adult population).
cases(R,"6",yr, "LRSA")= urbans(R,yr)*((SUM(age$(ord(age) ge 3), 0.3*pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "LRSA")*poll_level(R,"6",yr)));


* (III) outcomes for elderly only
cases(R,"6",yr, "CHF")= urbans(R,yr)*((SUM(age$(ord(age) gt 6), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "CHF")*poll_level(R,"6",yr))
                         + (0.5*(pop(R,yr)*dist(R,yr,'6')*Erfct_P(R,"6","CHF")
                                 *poll_level(R,"6",yr))));



* (IV) outcomes for children only
* If not defined otherwise, children are assumed as age groups under 15 (0-14).

* ER functions (ExternE 2005) on LRSC are defined on age groups 5-14.
cases(R,"6",yr, "LRSC")= urbans(R,yr)*((SUM(age$(ord(age) eq 2), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "LRSC")*poll_level(R,"6",yr)));


* ER functions (ExternE 2005) on WHC are defined on age groups 5-14.
cases(R,"1",yr, "WHC")= ((SUM(age$(ord(age) eq 2), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"1", "WHC")*poll_level(R,"1",yr)));

*$ontext
* ER functions (ExternE 2005) on SDC are defined on age groups 5-14.
cases(R,"6",yr, "SDC")= urbans(R,yr)*((SUM(age$(ord(age) eq 2), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "SDC")*poll_level(R,"6",yr)));


* ER functions (ExternE 1997) on CBC are defined on age groups under 18.
cases(R,"6",yr, "CBC")= urbans(R,yr)*(Erfct_P(R,"6", "CBC")*poll_level(R,"6",yr)
                       *(pop(R,yr)*dist(R,yr,"1")+pop(R,yr)*dist(R,yr,"2")+0.2*pop(R,yr)*dist(R,yr,"3")));
                     
*$offtext

* ER functions (ExternE 1997) on CC are defined on age groups under 18.
cases(R,"6",yr, "CC")= urbans(R,yr)*((SUM(age$(ord(age) lt 3), pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "CC")*poll_level(R,"6",yr))
                         + (0.2*(pop(R,yr)*dist(R,yr,'3')*Erfct_P(R,"6","CC")
                                 *poll_level(R,"6",yr))));


* ER functions (ExternE 2005) on BDC are defined on age groups 5-14 meeting PEACE study criteria (25% of total children population in the case of Western Europe).
cases(R,"6",yr, "BDC")= urbans(R,yr)*((SUM(age$(ord(age) lt 3), 0.25*pop(R,yr)*dist(R,yr,age))
                         *Erfct_P(R,"6", "BDC")*poll_level(R,"6",yr)));


*display cases;

*$offtext
* [Case computation for EUR ends here] **


* Next, calculate the costs

serv_cost(R,PLT,yr, outcome)= cases(R,PLT,yr,outcome)*healthcost(R,outcome)*perc("serv", outcome);
lab_cost(R,PLT,yr, outcome)= cases(R,PLT,yr,outcome)*healthcost(R, outcome)*perc("lab", outcome); 
leis_cost(R,PLT,yr, outcome)= cases(R,PLT,yr,outcome)*healthcost(R, outcome)*perc("leis", outcome);

PARAMETER serv_perc(R,PLT,yr), lab_perc(R,PLT,yr);

serv_perc(R,PLT,yr)$(((SUM(outcome, lab_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, serv_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, leis_cost(R,PLT,yr,outcome)))) ne 0) = (SUM(outcome, serv_cost(R,PLT,yr,outcome)))/((SUM(outcome, lab_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, serv_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, leis_cost(R,PLT,yr,outcome))));

lab_perc(R,PLT,yr)$(((SUM(outcome, lab_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, serv_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, leis_cost(R,PLT,yr,outcome)))) ne 0) = (SUM(outcome, lab_cost(R,PLT,yr,outcome)))/((SUM(outcome, lab_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, serv_cost(R,PLT,yr,outcome)))
			+(SUM(outcome, leis_cost(R,PLT,yr,outcome))));


* Added by KM Nam (lab/serv/leis cost sum except chronic mortality)
PARAMETER lab_cost_sum(R,yr), serv_cost_sum(R,yr), leis_cost_sum(r,yr);

lab_cost_sum(R,yr)= sum(PLT,SUM(outcome, lab_cost(r,PLT,yr,outcome)));
serv_cost_sum(R,yr)= sum(PLT,SUM(outcome, serv_cost(r,PLT,yr,outcome)));
leis_cost_sum(R,yr)= sum(PLT,SUM(outcome, leis_cost(r,PLT,yr,outcome)));

*display lab_cost_sum,serv_cost_sum,leis_cost_sum;


PARAMETER PH_cost_sum(R,T);

PH_cost_sum(R,'2007') = lab_cost_sum(R,'80') + serv_cost_sum(R,'80');
PH_cost_sum(R,'2010') = lab_cost_sum(R,'85') + serv_cost_sum(R,'85');
PH_cost_sum(R,'2015') = lab_cost_sum(R,'90') + serv_cost_sum(R,'90');
PH_cost_sum(R,'2020') = lab_cost_sum(R,'95') + serv_cost_sum(R,'95');
PH_cost_sum(R,'2025') = lab_cost_sum(R,'100') + serv_cost_sum(R,'100');
PH_cost_sum(R,'2030') = lab_cost_sum(R,'105') + serv_cost_sum(R,'105');
PH_cost_sum(R,'2035') = lab_cost_sum(R,'110') + serv_cost_sum(R,'110');
PH_cost_sum(R,'2040') = lab_cost_sum(R,'115') + serv_cost_sum(R,'115');
PH_cost_sum(R,'2045') = lab_cost_sum(R,'120') + serv_cost_sum(R,'120');
PH_cost_sum(R,'2050') = lab_cost_sum(R,'125') + serv_cost_sum(R,'125');
PH_cost_sum(R,'2055') = lab_cost_sum(R,'130') + serv_cost_sum(R,'130');



* Change the monetary unit into US$ billion.
PH_cost_sum(R,T) = PH_cost_sum(R,T)/1E9;

*display ph_cost_sum;

* New ER applied.

file casecalcs_CHN /..\results\casecals_CHN.dat/;

put casecalcs_CHN;
loop(R,
loop (yr $((ord(yr) eq 70 or ord(yr) eq 75 or ord(yr) eq 80 or ord(yr) eq 85 or ord(yr) eq 90 or ord(yr) eq 95 or ord(yr) eq 100 or ord(yr) eq 105)),
put /yr.tl;
put 'Number of cases and costs' ///;
put @23, 'PM10', put @37, 'NO2', put @50, 'SO2', put @64, 'CO', put @77, 'O3'/;
loop (outcome, put @2,outcome.tl, put @15, cases (R,'6',yr,outcome), ' '
, cases (R,'4',yr,outcome), ' ',cases (R,'3',yr,outcome), ' ', cases (R,'2',yr,outcome), ' ',cases (R,'1',yr,outcome)/;)

put // 'Service cost'//;
put @23, 'PM10', put @37, 'NO2', put @50, 'SO2', put @64, 'CO', put @77, 'O3'/;
loop(outcome, put @2, outcome.tl, put @15, serv_cost(R,'6',yr,outcome), ' ',serv_cost(R,'4',yr,outcome), ' ',serv_cost(R,'3',yr,outcome), 
' ',serv_cost(R,'2',yr,outcome), ' ',serv_cost(R,'1',yr,outcome)/);

put // 'Labor cost'//;
put @23, 'PM10', put @37, 'NO2', put @50, 'SO2', put @64, 'CO', put @77, 'O3'/;
loop(outcome, put @2, outcome.tl, put @15, lab_cost(R,'6',yr,outcome),' ',lab_cost(R,'4',yr,outcome),' ',lab_cost(R,'3',yr,outcome),' ',
lab_cost(R,'2',yr,outcome),' ',lab_cost(R,'1',yr,outcome)/);

put // 'Leisure cost'//;
put @23, 'PM10', put @37, 'NO2', put @50, 'SO2', put @64, 'CO', put @77, 'O3'/;
loop(outcome, put @2, outcome.tl, put @15, leis_cost(R,'6',yr,outcome), ' ',leis_cost(R,'4',yr,outcome), ' ',leis_cost(R,'3',yr,outcome), ' ',
leis_cost(R,'2',yr,outcome), ' ',leis_cost(R,'1',yr,outcome)/);

put //'serv_perc'//;
put @23, 'PM10', put @37, 'NO2', put @50, 'SO2', put @64, 'CO', put @77, 'O3'/;
put @15, serv_perc(R,'6',yr), ' ',serv_perc(R,'4',yr), ' ',serv_perc(R,'3',yr), ' ',
serv_perc(R,'2',yr), ' ',serv_perc(R,'1',yr)/;

put //'Age Pop'//;
put @22, '00-04', put @35,'05-14',put @48,'15-29',put @61,'30-44',put @74,'45-59',put @87,'60-69',put @100,'70-79',put @113,'80+'/;
put @15, dist(R,yr,'1'), ' ',dist(R,yr,'2'), ' ',dist(R,yr,'3'), ' ', dist(R,yr,'4'), ' ',dist(R,yr,'5')' ',
dist(R,yr,'6')' ',dist(R,yr,'7')' ',dist(R,yr,'8')/;

put //'chronic mortalities'//;
put @2, 'chronic mortalities, current year only, (persons)'/;
put @22, '00-04', put @35,'05-14',put @48,'15-29',put @61,'30-44',put @74,'45-59',put @87,'60-69',put @100,'70-79',put @113,'80+'/;
put @15, chr_mort(R,yr,'1'), ' ',chr_mort(R,yr,'2'), ' ',chr_mort(R,yr,'3'), ' ', chr_mort(R,yr,'4'), ' ',
chr_mort(R,yr,'5')' ',chr_mort(R,yr,'6')' ',chr_mort(R,yr,'7')' ',chr_mort(R,yr,'8')/;
put @2, 'chronic cohort loss: labor loss only (working persons)'/;
put @22, '00-04', put @35,'05-14',put @48,'15-29',put @61,'30-44',put @74,'45-59',put @87,'60-69',put @100,'70-79',put @113,'80+'/;
put @15, cohort_loss(R,yr,'1'), ' ',cohort_loss(R,yr,'2'), ' ',cohort_loss(R,yr,'3'), ' ', cohort_loss(R,yr,'4'), ' ',
cohort_loss(R,yr,'5')' ',cohort_loss(R,yr,'6')' ',cohort_loss(R,yr,'7')' ',cohort_loss(R,yr,'8')/;
put @2, 'chronic leisure loss: leisure loss only (working persons)'/;
put @22, '00-04', put @35,'05-14',put @48,'15-29',put @61,'30-44',put @74,'45-59',put @87,'60-69',put @100,'70-79',put @113,'80+'/;
put @15, cohort_leis_loss(R,yr,'1'), ' ',cohort_leis_loss(R,yr,'2'), ' ',cohort_leis_loss(R,yr,'3'), ' ', 
cohort_leis_loss(R,yr,'4'), ' ',cohort_leis_loss(R,yr,'5')' ',cohort_leis_loss(R,yr,'6')' ',cohort_leis_loss(R,yr,'7')' ',
cohort_leis_loss(R,yr,'8')/;
put @2, yr.tl, put @15, 'labor loss + leisure loss', put @50, inc_mort(R,yr):8:5/;
put @2, 'Population', put @15 pop(R,yr)/;
put @2, '% Urban', put@15 urbans(R, yr)//;

put @2, 'ER for chronic mortality'/;
put @15, erfctn(R,yr,'1'), ' ',erfctn(R,yr,'2'), ' ',erfctn(R,yr,'3'), ' ', erfctn(R,yr,'4'), ' ',
erfctn(R,yr,'5')' ',erfctn(R,yr,'6')' ',erfctn(R,yr,'7')' ',erfctn(R,yr,'8')/;


);
);

file mortalities_CHN /..\results\mortalities_CHN.dat/;

put mortalities_CHN;
put //'chronic mortalities, current year only, (persons)'//;
put @2, 'year', put @22, '00-04', put @35,'05-14',put @48,'15-29',put @61,'30-44',put @74,'45-59',put @87,'60-69',put @100,'70-79',put @113,'80+'//;
loop(R,
loop (yr $((ord(yr) ge 25) and (ord(yr) le 200)),
put @2, yr.tl, put @15, chr_mort(R,yr,'1'), ' ',chr_mort(R,yr,'2'), ' ',chr_mort(R,yr,'3'), ' ', chr_mort(R,yr,'4'), ' ',chr_mort(R,yr,'5')' ',chr_mort(R,yr,'6')' ',chr_mort(R,yr,'7')' ',chr_mort(R,yr,'8')/;
);
);


*** EPPAPARM
$ONTEXT
PARAMETER LEIS_SUPPLY_yr1(R)            Leisure supply in efficiency units for initial yr;
PARAMETER L_ONLY_SUPPLY(R,T)            labor (no leis) only supply for all yrs and regions;
* leisure is made up of adult leisure + kids leisure + elderly leisure
* adt leisure is valued at the same rate as labor but there are 1x as much leisure time in a day
* kids leisure is valued at 1/3 the adt rate but all they have is leisure (2*8=16hrs)
* elderly leisure is valued at 2/3 the adt rate but all they have is leisure
LEIS_SUPPLY_yr1(R) = 0.000000001;
LEIS_SUPPLY_yr1('usa') = L0('usa') + L0('usa')*1/3*7/5 + L0('usa')*2/3*1/2;
LEIS_SUPPLY_yr1('chn') = L0('chn') + L0('chn')*1/3*7/5 + L0('chn')*2/3*1/2;
LEIS_SUPPLY_yr1('EUR') = L0('EUR') + L0('EUR')*1/3*7/5 + L0('EUR')*2/3*1/2;

PARAMETER  
	Q_L_LEIS(R)	quantity of labor used for leisure;
Q_L_LEIS(R) = LEIS_SUPPLY_YR1(R);
$OFFTEXT


* define data for PH
*year 1 is 1970 (T= 1997, y = 70)
*serv_cost and labor_cost are calculated in healthends.gms

PH_PERC_SERV(R,PLT) = 0.0000001;

PH_PERC_SERV(R, "1") = serv_perc(R, "1", "107");
PH_PERC_SERV(R, "2") = serv_perc(R, "2", "107");
PH_PERC_SERV(R, "3") = serv_perc(R, "3", "107");
PH_PERC_SERV(R, "4") = serv_perc(R, "4", "107");
PH_PERC_SERV(R, "5") = serv_perc(R, "5", "107");
PH_PERC_SERV(R, "6") = serv_perc(R, "6", "107");

*DISPLAY PH_PERC_SERV;

Q_SERV_PH_yr1(R,PLT)= SUM(outcome, serv_cost(R,PLT,"107",outcome));

*need to get costs in units of $ billion
Q_SERV_PH_yr1(R,PLT)= Q_SERV_PH_yr1(R,PLT)/1E9;
*DISPLAY Q_SERV_PH_yr1;


* define labor use
Q_L_PERC_SERV_PH_YR1(R, PLT) = 1;
Q_L_PH_yr1(R,PLT) = Q_L_PERC_SERV_PH_YR1(R,PLT) * Q_SERV_PH_yr1(R,PLT);


* Added by KM Nam.
* For New ER
Q_L_PH_yr1(R,PLT) = 0.5*(lab_cost(R,PLT, "107","RHA" )+lab_cost(R,PLT, "107","cha" )+lab_cost(R,PLT, "107","CDHA")+
lab_cost(R,PLT, "107","AA" )+lab_cost(R,PLT, "107","AM" )) + 0.67*(lab_cost(R,PLT, "107","CBA" )+
lab_cost(R,PLT, "107","RAD" )+lab_cost(R,PLT, "107","MRD" )+lab_cost(R,PLT, "107","SDA" )+lab_cost(R,PLT, "107","BDA" )+
lab_cost(R,PLT, "107","LRSA"))
+SUM(outcome, leis_cost(R, PLT, "107", outcome));


*for cases involving all poPLT, only 50% result in labor losses (since only 50% of pop is working adults)
*cases for child outcomes have zero labor loss
*cases of adult only have 67% labor loss (2/3 of adult population is working, 1/3 is elderly/retired)

*need to get costs in units of $10 billion

Q_L_PH_yr1(R,PLT) = Q_L_PH_yr1(R,PLT)/1E9;
*DISPLAY Q_L_PH_yr1;



* total PH INPUTS
Q_PH_yr1(R,PLT) = Q_L_PH_yr1(R,PLT) + Q_SERV_PH_yr1(R,PLT);
Q_PH(R,PLT) = Q_PH_yr1(R,PLT);
Q_L_PH(R,PLT) = Q_L_PH_yr1(R,PLT);
Q_SERV_PH(R,PLT) = Q_SERV_PH_yr1(R,PLT);
P_INDEX_CURR(R,PLT) = P_INDEX(R,PLT, "2007");
Q_PH_TOT(R) = sum(PLT, Q_PH(R,PLT));
Q_SERV_PH_TOT(R) = sum(PLT, Q_SERV_PH(R,PLT));


*display q_ph, p_index_curr, q_L_ph_yr1, q_serv_ph_yr1;
*DISPLAY Q_PH_TOT;
*DISPLAY Q_SERV_PH_TOT;
*DISPLAY Q_SERV_PH;

* update consumer demand of services
vam("OTH",r) = vam("OTH",r) - Q_SERV_PH_TOT(r);

* update the final consumer demand of services
vafm("OTH","c", R) = vafm("OTH","c", R) - Q_SERV_PH_TOT(R);


*display vam,vafm;


* increase labor and consumption to take into account PH labor
vfms("lab","c",R) = vfms("lab","c",R) + sum(PLT, Q_L_PH_yr1(R,PLT));
vom("c",R) = vom("c",R) + sum(PLT, Q_L_PH_yr1(R,PLT));




*** EPPACORE.gms
display q_L_ph, q_serv_ph, thetals, Q_ph, p_index_curr, q_ph_tot;

** update for pollution health
vom("OTH",R) = vom("OTH",R) - Q_SERV_PH_TOT(R);
vafm(i,"OTH",R)=vafm(i,"OTH",R)*(vom("OTH",R) - Q_SERV_PH_TOT(R))/vom("OTH",R);
vfm("lab","OTH",R)=vfm("lab","OTH",R)*(vom("OTH",R) - Q_SERV_PH_TOT(R))/vom("OTH",R);
vfm("cap","OTH",R)=vfm("cap","OTH",R)*(vom("OTH",R) - Q_SERV_PH_TOT(R))/vom("OTH",R);

$exit