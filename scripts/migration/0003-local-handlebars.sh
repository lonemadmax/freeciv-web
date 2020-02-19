#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/../.. >/dev/null && pwd)"

rm -f "${BASEDIR}"/freeciv-web/{target/freeciv-web,src/main/webapp}/javascript/libs/handlebars.runtime*
cd "${BASEDIR}"/freeciv-web
npm ci
