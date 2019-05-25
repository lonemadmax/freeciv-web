/**********************************************************************
    Freeciv-web - the web version of Freeciv. http://play.freeciv.org/
    Copyright (C) 2009-2019  The Freeciv-web project

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


/* Items on the mapview are drawn in layers.  Each entry below represents
 * one layer.  The names are basically arbitrary and just correspond to
 * groups of elements in fill_sprite_array().  Callers of fill_sprite_array
 * must call it once for each layer. */
const LAYER_TERRAIN1 = 0;
const LAYER_TERRAIN2 = 1;
const LAYER_TERRAIN3 = 2;
const LAYER_ROADS = 3;
const LAYER_SPECIAL1 = 4;
const LAYER_CITY1 = 5;
const LAYER_SPECIAL2 = 6;
const LAYER_UNIT = 7;
const LAYER_FOG = 8;
const LAYER_SPECIAL3 = 9;
const LAYER_TILELABEL = 10;
const LAYER_CITYBAR = 11;
const LAYER_GOTO = 12;
const LAYER_COUNT = 13;

// these layers are not used at the moment, for performance reasons.
//const LAYER_BACKGROUND = ; (not in use)
//const LAYER_EDITOR = ; (not in use)
//const LAYER_GRID* = ; (not in use)

/* An edge is the border between two tiles.  This structure represents one
 * edge.  The tiles are given in the same order as the enumeration name. */
const EDGE_NS = 0; /* North and south */
const EDGE_WE = 1; /* West and east */
const EDGE_UD = 2; /* Up and down (nw/se), for hex_width tilesets */
const EDGE_LR = 3; /* Left and right (ne/sw), for hex_height tilesets */
const EDGE_COUNT = 4;

const MATCH_NONE = 0;
const MATCH_SAME = 1;		/* "boolean" match */
const MATCH_PAIR = 2;
const MATCH_FULL = 3;

const CELL_WHOLE = 0;		/* entire tile */
const CELL_CORNER = 1;	/* corner of tile */

/* Darkness style.  Don't reorder this enum since tilesets depend on it. */
/* No darkness sprites are drawn. */
const DARKNESS_NONE = 0;

/* 1 sprite that is split into 4 parts and treated as a darkness4.  Only
 * works in iso-view. */
const DARKNESS_ISORECT = 1;

/* 4 sprites, one per direction.  More than one sprite per tile may be
 * drawn. */
const DARKNESS_CARD_SINGLE = 2;

/* 15=2^4-1 sprites.  A single sprite is drawn, chosen based on whether
 * there's darkness in _each_ of the cardinal directions. */
const DARKNESS_CARD_FULL = 3;

/* Corner darkness & fog.  3^4 = 81 sprites. */
const DARKNESS_CORNER = 4;

