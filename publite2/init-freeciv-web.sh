#! /bin/bash
# starts freeciv-proxy and freeciv-web.
# This script is started by civlauncher.py in publite2.

if [ "$#" -ne 6 ]; then
  echo "init-freeciv-web.sh error: incorrect number of parameters." >&2
  exit 1
fi

echo "init-freeciv-web.sh port ${2}"

if [ $5 = "pbem" ]; then
   pbemcmd="--Ranklog /var/lib/tomcat8/webapps/data/ranklogs/rank_${2}.log "
fi

quitidle=" -q 20"
if [[ $6 == *"longturn"* ]]; then
  quitidle=" "
fi

if [ ${6::12} = "longturn_up_" ]; then
  game_type=multiplayer
  upname=${6:12}
  tmpmark=${upname::8}
  upuser=${upname:9}
  gamedir="${1}/up/${upuser}/${tmpmark}"
  pbemcmd="--Ranklog ${gamedir}/rank.log "
  lastgame=$(ls -t "${gamedir}"/*.sav* 2>/dev/null | head -n 1)
  if [ -n "${lastgame}" ]; then
    pbemcmd="${pbemcmd} --file ${lastgame##*/}"
  fi
else
  game_type=$5
  gamedir=$1
fi

export FREECIV_SAVE_PATH=${gamedir};
rm -f /var/lib/tomcat8/webapps/data/scorelogs/score-${2}.log; 

python3 ../freeciv-proxy/freeciv-proxy.py ${3} > ../logs/freeciv-proxy-${3}.log 2>&1 &
proxy_pid=$! && 
${HOME}/freeciv/bin/freeciv-web --debug=1 --port ${2} --keep ${quitidle} --Announce none -e  -m \
-M http://${4} --type ${game_type} --read pubscript_${6}.serv --log ../logs/freeciv-web-log-${2}.log \
--saves ${gamedir} ${pbemcmd:- } > /dev/null 2> ../logs/freeciv-web-stderr-${2}.log;

rc=$?; 
kill -9 $proxy_pid; 
exit $rc
