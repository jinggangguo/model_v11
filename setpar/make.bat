:call gams tradebalancing2 gdx=..\rawdata\sam52
:call dtrd


call gams data gdx=..\data\data

call gams gtapaggr --source=data  --target=aggregated --nd=5
call gams gtapaggr o=gtapaggr.lst --source=data  --target=allprov





pause