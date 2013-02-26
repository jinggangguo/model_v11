@echo off
if not exist listings\nul mkdir listings
if not exist gdx\nul mkdir gdx


gams model   o=rt.lst gdx=gdx\REF.gdx --ds=allprov

gams model   o=int_r.lst gdx=gdx\INT_R.gdx --ds=allprov --intflag=rint 

:gams model   o=int_r2.lst gdx=gdx\INT_R2.gdx --ds=allprov --intflag=rint 


cd ..\gdx2
call gdxmerge *.gdx

call gdxxrw i=merged.gdx o=compare2.xlsx @dumppar.rpt

cd..

pause
