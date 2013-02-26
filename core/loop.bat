

:--------------------------------------------------------------------------------------------
TITLE RUNNING STATIC MODEL 
:--------------------------------------------------------------------------------------------

call gams model  --ds=allprov o=model.lst s=model

:--------------------------------------------------------------------------------------------
TITLE RUNNING DYNAMIC USREP FOR CASE: %1 %2 %3 %4 %5 %6 %7 %8 %9 
:--------------------------------------------------------------------------------------------

:call gams loop r=model o=loop.lst gdx=gdx\result.gdx

cd gdx
call gdxxrw i=result.gdx o=result.xlsx @dumppar.rpt
:--year=2007 --loadyear=2007 

pause
:end

TITLE DONE


