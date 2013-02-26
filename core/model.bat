@echo off
if not exist listings\nul mkdir listings
if not exist gdx\nul mkdir gdx



:goto nt

:gams model   o=rt.lst gdx=gdx\REF.gdx --ds=allprov
:gams model   o=int_r.lst gdx=gdx\INT_R.gdx --ds=allprov --intflag=rint --eleflag1=no --eleflag2=no 
:gams model   o=int_r_eleall.lst gdx=gdx\int_r_eleall.gdx --ds=allprov --intflag=rint --eleflag1=yes --eleflag2=no
:gams model   o=int_r_eleres.lst gdx=gdx\int_r_eleres.gdx --ds=allprov --intflag=rint --eleflag1=no --eleflag2=yes

:goto end




:nt
:gams model  o=int_n.lst gdx=gdx\INT_N.gdx --ds=allprov --intflag=nint --eleflag1=no --eleflag2=no
:gams model  o=int_n_eleall.lst gdx=gdx\INT_N_ELEALL.gdx --ds=allprov --intflag=nint --eleflag1=yes --eleflag2=no
:gams model  o=int_n_eleres.lst gdx=gdx\INT_N_ELERES.gdx --ds=allprov --intflag=nint --eleflag1=no --eleflag2=yes




:gams model  o=int_r_highfxkap.lst gdx=gdx\INT_R_highfxkap.gdx --ds=allprov --intflag=rint --kapflag=high
:gams model  o=int_n_highfxkap.lst gdx=gdx\INT_N_highfxkap.gdx --ds=allprov --intflag=nint --kapflag=high
:gams model  o=int_r_highgas.lst gdx=gdx\INT_R_highgas.gdx --ds=allprov --intflag=rint --gasflag=high
:gams model  o=int_n_highgas.lst gdx=gdx\INT_N_highgas.gdx --ds=allprov --intflag=nint --gasflag=high



pause

:goto end

:end


cd ..\gdx
call gdxmerge *.gdx

call gdxxrw i=merged.gdx o=compare2.xlsx @dumppar.rpt

cd..

pause
