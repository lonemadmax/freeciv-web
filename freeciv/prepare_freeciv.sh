#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
cd "${DIR}"

# Fix line endings on Windows
sed -i 's/\r$//' freeciv-web.project

. ./version.txt

# Allow the user to override how Freeciv is downloaded.
if test -f dl_freeciv.sh ; then
  DL_FREECIV=dl_freeciv.sh
else
  DL_FREECIV=dl_freeciv_default.sh
fi

if ! ./$DL_FREECIV "${FCREV}" "${FCREPO}" "${FCBRANCH}"; then
  echo "Git checkout failed" >&2
  exit 1
fi

( cd freeciv
  ./autogen.sh CFLAGS="-O3" --enable-dev-save-compat=yes --enable-mapimg=magickwand --with-project-definition=../freeciv-web.project --enable-fcweb --enable-json --disable-delta-protocol --disable-nls --disable-fcmp --enable-freeciv-manual --disable-ruledit --enable-fcdb=no --enable-ai-static=classic,threaded --prefix=${HOME}/freeciv/ && make -s -j$(nproc)
)
