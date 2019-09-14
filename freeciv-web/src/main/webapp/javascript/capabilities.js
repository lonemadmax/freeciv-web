/**********************************************************************
    Copyright (C) 2019  The Freeciv-web project

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

***********************************************************************/

/**
 * Freeciv capabilities.
 *
 * Freeciv uses capability strings in several areas as indication of features.
 * In particular, capstrings are exchanged between server and client when
 * joining a game, saying what network protocol version each understand and
 * what features and behaviours they implement.
 *
 * Capstrings are strings composed of a list of words separated by whitespace
 * or commas, each of which is a capability. Mandatory capabilities start with
 * a '+'.
 *
 * @namespace
 * @property {implementation} implementation
 * @property {function(!string): !Capabilities} parse
 * @property {function(): !Capabilities} getOurCapabilities
 * @property {function(): !Capabilities} getTheirCapabilities
 * @property {function((!string|!Capabilities)): boolean} setTheirCapabilities
 */
const fc_capabilities = (function () {
    'use strict';

    /**
     * The way an agent implements a feature.
     *
     * Can be used as boolean.
     *
     * @enum {number}
     */
    const implementation = {
        NONE: 0,
        MANDATORY: 1,
        OPTIONAL: 2,
    };

    /** Words separator in capstrings */
    const tokenSeparator = /[\s,]+/;

    /**
     * @struct
     * @typedef {!Object} fc_capabilities~CapList
     * @property {?string} capstring - The capabilities string representation
     * @property {!Set<!string>} mandatory - The set of mandatory capabilities
     * @property {!Set<!string>} optional - The set of optional capabilities
     */

    /** @type {WeakMap<Capabilities, CapList>} */
    const privateCapabilities = new WeakMap();

    /**
     * Represents the capabilities of an agent.
     * @inner
     */
    class Capabilities {
        /** @param {!string} capstring */
        constructor(capstring) {
            const cap = {
                capstring: null,
                mandatory: new Set(),
                optional: new Set(),
            };
            privateCapabilities.set(this, cap);

            this.add(capstring);
        }

        /**
         * Adds a capstring to the capabilities.
         *
         * New optional capabilities are not included if they are already
         * mandatory. Current optional capabilities are "promoted" if they
         * are added as mandatory.
         *
         * @param {!string} capstring - The capstring to add.
         * @return {undefined}
         */
        add(capstring) {
            const cap = privateCapabilities.get(this);
            let changeCap, checkCap;

            const tokens = capstring.split(tokenSeparator);
            const n = tokens.length;

            for (let i = 0; i < n; i++) {
                let capability = tokens[i];

                if (capability.charAt(0) === '+') {
                    capability = capability.substring(1);
                    changeCap = cap.mandatory;
                    checkCap = cap.optional;
                } else {
                    checkCap = cap.mandatory;
                    if (checkCap.has(capability)) {
                        continue;
                    }
                    changeCap = cap.optional;
                }

                if (capability.length > 0) {
                    checkCap.delete(capability);
                    changeCap.add(capability);
                }
            }
            cap.capstring = null;
        }

        /**
         * Determines whether this system provides a capability.
         *
         * @param {string} capability - The capability to check.
         *                              A single word without '+' prefix.
         * @return {implementation}
         */
        has(capability) {
            const cap = privateCapabilities.get(this);
            if (cap.mandatory.has(capability)) {
                return implementation.MANDATORY;
            } else if (cap.optional.has(capability)) {
                return implementation.OPTIONAL;
            } else {
                return implementation.NONE;
            }
        }

        /**
         * Are the capabilities compatible with the given ones?
         *
         * @param {!Capabilities} cap - The capabilities to check against.
         * @return {boolean}
         */
        isCompatible(cap) {
            /**
             * Checks whether the mandatory capabilities of 'a' are implemented
             * in 'b'.
             *
             * @param {CapList} a - The capabilities to check
             * @param {CapList} b - The capabilities to check against
             * @return {boolean}
             */
            function check(a, b) {
                const man = b.mandatory;
                const opt = b.optional;
                for (const capability of a.mandatory) {
                    if (!(man.has(capability) || opt.has(capability))) {
                        return false;
                    }
                }
                return true;
            }
            const theseCaps = privateCapabilities.get(this);
            const thoseCaps = privateCapabilities.get(cap);
            return check(theseCaps, thoseCaps) && check(thoseCaps, theseCaps);
        }

        /**
         * The capstring corresponding to these capabilities.
         *
         * @return {!string}
         */
        get capstring() {
            const cap = privateCapabilities.get(this);
            if (cap.capstring == null) {
                let s = '';
                let tempArr = Array.from(cap.mandatory);
                if (tempArr.length > 0) {
                    s = '+' + tempArr.join(' +');
                }
                tempArr = Array.from(cap.optional);
                if (tempArr.length > 0) {
                    s = s + ' ' + tempArr.join(' ');
                }
                cap.capstring = s;
            }
            return cap.capstring;
        }
    }

    /** Array of capstrings we can use, in order of preference */
    const ourCaps = [
        new Capabilities('+Freeciv.Devel-3.1-2018.Nov.20 +CityCanBuild +CityTileOutput +HtmlMessages +GotoPF +TileInfo'),
        new Capabilities('+Freeciv.Web.Devel-3.1'),
    ];
    /**
     * Index to our current capabilities from {@link ourCaps}.
     * @type {number}
     */
    let currentCaps = 0;
    /**
     * The other side's capabilities.
     * @type {Capabilities}
     */
    let theirCaps;

    /**
     * Sets the [server capabilities]{@link theirCaps}, and the best
     * compatible [client capabilities]{@link currentCaps}. If no compatible
     * capabilities are found, the first one is chosen.
     *
     * @param {!string|!Capabilities} theirs - The server capabilities
     * @return {boolean} - Whether we have compatible capabilities
     */
    function setTheirCapabilities(theirs) {
        if (theirs instanceof Capabilities) {
            theirCaps = theirs;
        } else {
            theirCaps = new Capabilities(theirs);
        }

        const n = ourCaps.length;
        for (currentCaps = 0; currentCaps < n; currentCaps++) {
            const caps = ourCaps[currentCaps];
            if (caps.isCompatible(theirCaps)) {
                return true;
            }
        }
        currentCaps = 0;
        return false;
    }

    return {
        implementation: implementation,
        parse: capstring => new Capabilities(capstring),
        getOurCapabilities: () => ourCaps[currentCaps],
        getTheirCapabilities: () => theirCaps,
        setTheirCapabilities: setTheirCapabilities,
    };

}());
