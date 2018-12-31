<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../WEB-INF/jsp/fragments/i18n.jsp" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <c:set var="title" scope="request" value="Freeciv-Web: design your own world map!"/>
    <%@ include file="../WEB-INF/jsp/fragments/head.jsp" %>

<style>
  body { margin:0; padding:0; }

  .btn-primary {
   display: block;
   font-weight: 700;
   text-transform: uppercase;
   background: #be602d;
   text-shadow:
     -0.5px -0.5px 0 #000,
      0.5px -0.5px 0 #000,
     -0.5px  0.5px 0 #000,
      0.5px  0.5px 0 #000;
   width: 100%;
  }

  #uploadedImg {
    max-width: 100%;
  }

  td { padding: 0 0.3em; }
}
</style>
<link href="../css/spectrum.css" rel="stylesheet">

  </head>
  <body>
<%@ include file="../WEB-INF/jsp/fragments/header.jsp" %>

    <div class="row">
    <br><br><br><br>
    </div>

    <!-- Begin page content -->
    <div id="content" class="container">

    <div class="row">
        <div class="col-lg-12">
		<h2>Play Freeciv-web on a real world map!</h2>
		<b>You can now play Freeciv-web with a map designed by you! Just choose an image, be it from a real map to recreate historic nations or from your cat just because, adjust the colour choices if needed, review the result and click the "Play this map" button to play Freeciv-web on your new map.</b>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-3">
            <h3>Pick a file</h3>
            <input type='file' id='mapFileInput' class='hide' accept='image/*' onchange='handleMapImageUpload(this.files)'><button onclick='document.getElementById("mapFileInput").click()' class="btn btn-primary btn-lg" ><i class="fa fa-folder-sopen"></i> Browse...</button><br>
            <table>
            <tr><th>Width</th><td><span id="oxsize"></span></td><td>&gt;</td><td><span id="xsize"></td></tr>
            <tr><th>Height</th><td><span id="oysize"></span></td><td>&gt;</td><td><span id="ysize"></td></tr>
            </table>
            <br>Max 180 x 100 (18 000 tiles)
        </div>
        <div class="col-lg-3">
            <h3>Select tile colors</h3>
            <table id="terrains">
            </table>
        </div>
        <div class="col-lg-3">
            <h3>Review your map</h3>
            <img id="uploadedImg" />
            <br><p>Your map:</p>
            <canvas id="omap" width="0" height="0" class="hide"></canvas>
            <canvas id="map"></canvas>
        </div>
        <div class="col-lg-3">
            <h3>Play this map!</h3>
            <button id="snap" class="btn btn-primary btn-lg" onclick="startGame(false)" disabled><i class="fa fa-flag"></i> 2D Isometric</button>
            <br>
            <button id="snap3d" class="btn btn-primary btn-lg" onclick="startGame(true)" disabled><i class="fa fa-cube"></i> 3D WebGL</button>
        </div>
    </div>

<%@ include file="../WEB-INF/jsp/fragments/footer.jsp" %>

    </div>



    <script src="/javascript/libs/spectrum.js"></script>
    <script type="text/javascript" src="/freeciv-earth/map-from-image.js"></script>
    <script>initPage();</script>

  </body>
</html>

