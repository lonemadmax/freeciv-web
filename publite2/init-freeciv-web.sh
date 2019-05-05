#! /bin/bash
# starts freeciv-proxy and freeciv-web.
# This script is started by civlauncher.py in publite2.

if [ "$#" -ne 6 ]; then
  echo "init-freeciv-web.sh error: incorrect number of parameters." >&2
  exit 1
fi

declare -a args

addArgs() {
  local i=${#args[*]}
  for v in "$@"; do
    args[i]=${v}
    let i++
  done
}

echo "init-freeciv-web.sh port ${2}"

addArgs --debug 1
addArgs --port "${2}"
addArgs --Announce none
addArgs --exit-on-end
addArgs --meta --keep --Metaserver "http://${4}"
addArgs --read "pubscript_${6}.serv"
addArgs --log "../logs/freeciv-web-log-${2}.log"

gametype=${5}

if [ "${gametype}" = "pbem" ]; then
  addArgs --Ranklog "/var/lib/tomcat8/webapps/data/ranklogs/rank_${2}.log"
fi

savesdir=${1}
if [ "${gametype}" = "longturn" ]; then
  if [ ${6::12} = "longturn_up_" ]; then
    gametype=multiplayer
    upname=${6:12}
    tmpmark=${upname::8}
    upuser=${upname:9}
    savesdir="${1}/up/${upuser}/${tmpmark}"
    addArgs --Ranklog "${savesdir}/rank.log"
  else
    savesdir="${savesdir}/lt/${6}"
  fi

  mkdir -p "${savesdir}"

  grep -q '^#\s*autoreload\s*$' "pubscript_${6}.serv"
  if [ $? -eq 0 ]; then
    lastsave=$(ls -t "${savesdir}"/*.sav* 2>/dev/null | head -n 1)
    if [ -n "${lastsave}" ]; then
      addArgs --file "${lastsave##*/}"
    fi
  fi
else
  addArgs --quitidle 20
fi
addArgs --saves "${savesdir}"
addArgs --type "${gametype}"

export FREECIV_SAVE_PATH=${savesdir};
rm -f "/var/lib/tomcat8/webapps/data/scorelogs/score-${2}.log"

python3 ../freeciv-proxy/freeciv-proxy.py "${3}" > "../logs/freeciv-proxy-${3}.log" 2>&1 &
proxy_pid=$! && 
${HOME}/freeciv/bin/freeciv-web "${args[@]}" > /dev/null 2> "../logs/freeciv-web-stderr-${2}.log"
rc=$?
kill -9 ${proxy_pid}
exit ${rc}
