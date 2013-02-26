:start
title	Balancing energy data for %1 -- job started at %time%

call gams dtrdest --ind=%1 o=..\listings\%1.lst gdx=..\rawdata\dtrd\%1
:next

:pause
shift

if not "%1"=="" goto start

:end


