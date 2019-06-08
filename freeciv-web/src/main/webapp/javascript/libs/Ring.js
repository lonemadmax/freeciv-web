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

function Ring(size) {
  if (size == null || size <= 1) throw "Invalid size";
  this.data = [];
  this.size = size;
  this.index = size - 1;
}


// Get the current item or one 'i' distance from it.
Ring.prototype.get = function (i) {
  if (i == null) return this.data[this.index];
  var i_access = (i + this.index) % this.size;
  if (i_access < 0) i_access = i_access + this.size;
  return this.data[i_access];
}

// Add an item to the ring.
Ring.prototype.put = function (v) {
  this.index = (this.index + 1) % this.size;
  this.data[this.index] = v;
}

