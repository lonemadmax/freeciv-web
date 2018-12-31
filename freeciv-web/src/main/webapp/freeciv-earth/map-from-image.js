/**********************************************************************
    Freeciv-web - the web version of Freeciv.
    Copyright (C) 2009-2018  The Freeciv-web project

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


/**************************************************************************
 This is mostly a copy of freeciv-web/src/main/webapp/javascript/map-from-image.js
**************************************************************************/
const maxWidth = 180;
const maxHeight = 100;
const minTiles = 15;

const terrain = [
   ['Inaccessible', 0, 0, 0, 'i']
  ,['Lake', 0, 80, 200, '+']
  ,['Plains', 100, 120, 30, 'p']
  ,['Swamp', 20, 150, 80, 's']
  ,['Ocean', 8, 20, 36, ' ']
  ,['Deep Ocean', 4, 10, 20, ':']
  ,['Hills', 61, 79, 31, 'h']
  ,['Mountains', 67, 72, 31, 'm']
  ,['Jungle', 37, 64, 27, 'j']
  ,['Forest', 44, 52, 28, 'f']
  ,['Desert', 240, 220, 155, 'd']
  ,['Tundra', 84, 73, 38, 't']
  ,['Grassland', 64, 124, 38, 'g']
  ,['Glacier', 255, 255, 255, 'a']
];

var mapdata = [];

/**************************************************************************
...
**************************************************************************/
function initPage()
{
  if (!(window.FileReader)) {
    $("#content").html("Your browser doesn't support the <a href=\"https://developer.mozilla.org/docs/Web/API/FileReader\">FileReader interface</a> needed for this functionality");
    return;
  }

  var t = [];
  var i;
  for (i = terrain.length - 1; i >= 0 ; i--) {
    t.push("<tr><td>"
         + terrain[i][0]
         + "</td><td><input type='text' id='terrain_" + i
         + "' /></td></tr>");
  }
  $('#terrains').html(t.join(''));
  for (i = terrain.length - 1; i >= 0 ; i--) {
    $('#terrain_' + i).change(updateMap)
                      .spectrum({color: 'rgb('
                                      + terrain[i][1] + ','
                                      + terrain[i][2] + ','
                                      + terrain[i][3] + ')'});
  }
}


/**************************************************************************
...
**************************************************************************/
function handleMapImageUpload(files)
{
  const file = files[0];
  const xsize = $('#xsize');
  const ysize = $('#ysize');
  const oxsize = $('#oxsize');
  const oysize = $('#oysize');

  xsize.text('');
  ysize.text('');
  oxsize.text('');
  oysize.text('');

  if (file == null) {
    return;
  }
  if (!file.type.startsWith('image/')) {
    return;
  }

  const reader = new FileReader();
  reader.onload = function(e) {
    const img = document.getElementById('uploadedImg');
    img.onload = doImage;
    img.src = reader.result;
  }
  reader.readAsDataURL(file);
}

/**************************************************************************
...
**************************************************************************/
function doImage()
{
  const xsize = $('#xsize');
  const ysize = $('#ysize');
  const oxsize = $('#oxsize');
  const oysize = $('#oysize');

  const img = document.getElementById('uploadedImg');

  var w = img.naturalWidth || img.width;
  var h = img.naturalHeight || img.height;

  if (w <= 0 || h <= 0) {
    return;
  }

  var scale = 1;
  if (w > maxWidth || h > maxHeight || w < minTiles || h < minTiles) {
    if ((w/h) > (maxWidth/maxHeight)) {
      scale = maxWidth/w;
    } else {
      scale = maxHeight/h;
    }
    if (scale < 1) {
      scale = 1/(1+Math.trunc(1/scale));
    } else {
      scale = Math.trunc(scale);
    }
  }

  wnew = Math.round(w*scale);
  hnew = Math.round(h*scale);

  if (wnew < minTiles) {
    wnew *= Math.ceil(minTiles/wnew);
  }
  if (hnew < minTiles) {
    hnew *= Math.ceil(minTiles/hnew);
  }

  xsize.text(wnew);
  ysize.text(hnew);
  oxsize.text(w);
  oysize.text(h);

  const omap = document.getElementById('omap');
  omap.width = wnew;
  omap.height = hnew;
  const ctx = omap.getContext('2d');
  ctx.drawImage(img, 0, 0, w, h, 0, 0, wnew, hnew);
  updateMap();
}

/**************************************************************************
...
**************************************************************************/
function updateMap()
{
  const omap = document.getElementById('omap');
  const w = omap.width;
  const h = omap.height;

  if (w == 0 || h == 0) {
    return;
  }

  for (i = terrain.length - 1; i >= 0 ; i--) {
    const c = $('#terrain_' + i).spectrum('get');
    const t = terrain[i];
    t[5] = c['_r'];
    t[6] = c['_g'];
    t[7] = c['_b'];
  }

  const map = document.getElementById('map');
  map.width = w;
  map.height = h;
  const image = omap.getContext('2d').getImageData(0, 0, w, h);
  const imageData = image.data;
  const processedImageCtx = map.getContext('2d');
  const processedImage = processedImageCtx.createImageData(image);
  const processedData = processedImage.data;
  mapdata = [];

  var i = 0;
  for (var y = 0; y < h; y++) {
    var row = [];
    row.push("t" + zeroFill(y, 4) + '="');
    for (var x = 0; x < w; x++) {
      const t = colorToTerrain(imageData[i], imageData[i+1], imageData[i+2]);
      row.push(t[4]);
      processedData[i++] = t[5];
      processedData[i++] = t[6];
      processedData[i++] = t[7];
      processedData[i++] = 255;
    }
    row.push('"\n');
    mapdata.push(row.join(''));
  }

  processedImageCtx.putImageData(processedImage, 0, 0);

  document.getElementById('snap').disabled = false;
  document.getElementById('snap3d').disabled = false;
}

/**************************************************************************
...
**************************************************************************/
function startGame(webgl)
{
  const h = mapdata.length;
  if (h < minTiles) {
    return;
  }
  const w = mapdata[0].length - 9;

  $.ajax({
    type: "POST",
    url: "/freeciv-earth-mapgen",
    data: mapdata.join('') + ";" + w + ";" + h
  }).done(function(savegame) {
    window.location.href="/webclient/?action=earthload&type=singleplayer&savegame=" + savegame + (webgl ? "&renderer=webgl" : "");
  }).fail(function(response) {
    msg = "Something failed. Please try again later!\n"
        + response.status + ": " + response.statusText;
    console.error(msg);
    alert(msg);
  });
}

/**************************************************************************
...
**************************************************************************/
function zeroFill( number, width )
{
  width -= number.toString().length;
  if ( width > 0 )
  {
    return new Array( width + (/\./.test( number ) ? 2 : 1) ).join( '0' ) + number;
  }
  return number + ""; 
}

/**************************************************************************
...
**************************************************************************/
function colorToTerrain(r, g, b)
{
  var bestTerrain = null;
  var threshold = 10000;
  for (i = terrain.length - 1; i >= 0 ; i--) {
    const t = terrain[i];
    const diff = sqColorDiff(r, g, b, t[5], t[6], t[7]);
    if (diff < threshold) {
      bestTerrain = t;
      threshold = diff;
    }
  }
  if (bestTerrain != null) {
    return bestTerrain;
  }

  const rnd = 10 * Math.random();
  if (rnd < 4) return terrain[2]; //plains
  if (rnd < 6) return terrain[6];  //hills
  if (rnd < 7) return terrain[11];  //tundra 
  return terrain[12];  //grassland 
}

/**************************************************************************
...
**************************************************************************/
function sqColorDiff(r1, g1, b1, r2, g2, b2)
{
  const diffR = (r2 - r1);
  const diffG = (g2 - g1);
  const diffB = (b2 - b1);
  return (diffR*diffR + diffG*diffG + diffB*diffB);
}

