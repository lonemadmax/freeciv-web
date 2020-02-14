#!/bin/bash
# You should run this script if you update your copy of handlebars.

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. >/dev/null && pwd)"

rm -f "${BASEDIR}"/freeciv-web/{target/freeciv-web,src/main/webapp}/javascript/libs/handlebars.runtime*
cp "$(sudo -H npm config get prefix -g)/lib/node_modules/handlebars/dist/handlebars.runtime.js" "${BASEDIR}"/freeciv-web/src/main/webapp/javascript/libs/
