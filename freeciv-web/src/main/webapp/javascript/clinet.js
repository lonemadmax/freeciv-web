/**********************************************************************
    Freeciv-web - the web version of Freeciv. http://play.freeciv.org/
    Copyright (C) 2009-2015  The Freeciv-web project

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


var error_shown = false;
var syncTimerId = -1;

var clinet_last_send = 0;
var debug_client_speed_list = [];

var ws = null;
var ws_errors = new Ring(5);
var civserverport = null;

var ping_last = new Date().getTime();
var pingtime_check = 240000;
var ping_timer = null;

/**************************************************************************
  Initialize the network communication with the server manually.
**************************************************************************/
function network_init_manual_hack(civserverport_manual, username_manual,
                                  savegame)
{
  civserverport = civserverport_manual;
  username = username_manual;

  websocket_init();

  if (savegame != null) {
    wait_for_text("You are logged in as", function () {
      load_game_real(savegame);
    });
  }
}

/****************************************************************************
  Initialized the Network communication, by requesting a valid server port.
****************************************************************************/
function network_init()
{

  if (!("WebSocket" in window)) {
    swal("WebSockets not supported", "", "error");
    return;
  }

  var civclient_request_url = "/civclientlauncher";
  if ($.getUrlVar('action') != null) civclient_request_url += "?action=" + $.getUrlVar('action');
  if ($.getUrlVar('action') == null && $.getUrlVar('civserverport') != null) civclient_request_url += "?";
  if ($.getUrlVar('civserverport') != null) civclient_request_url += "&civserverport=" + $.getUrlVar('civserverport');

  $.ajax({
   type: 'POST',
   url: civclient_request_url,
   success: function(data, textStatus, request){
       civserverport = request.getResponseHeader('port');
       var connect_result = request.getResponseHeader('result');
       if (civserverport != null && connect_result == "success") {
         websocket_init();
         load_game_check();

       } else {
         show_dialog_message("Network error", "Invalid server port. Error: " + connect_result);
       }
   },
   error: function (request, textStatus, errorThrown) {
	show_dialog_message("Network error", "Unable to communicate with civclientlauncher servlet . Error: "
		+ textStatus + " " + errorThrown + " " + request.getResponseHeader('result'));
   }
  });
}

/****************************************************************************
  Initialized the WebSocket connection.
****************************************************************************/
function websocket_init()
{
  $.blockUI({ message: "<h2>Please wait while connecting to the server.</h2>" });
  var ws_protocol = ('https:' == window.location.protocol) ? "wss://" : "ws://";
  var port = window.location.port ? (':' + window.location.port) : '';
  ws = new WebSocket(ws_protocol + window.location.hostname + port + "/civsocket");

  ws.onopen = websocket_ready;

  ws.onmessage = function (event) {
    client_handle_packet(JSON.parse(event.data));
  };

  ws.onclose = function (event) {
   console.info("WebSocket connection closed, code+reason: " + event.code + ", " + event.reason);
   if (websocket_reconnect()) {
      return;
   }
   unrecoverable_error("Network Error"
            , "Connection to server is closed. Please reload the page to restart. Sorry!");
   $("#turn_done_button").button( "option", "disabled", true);
   $("#save_button").button( "option", "disabled", true);
   pbem_phase_ended = true;
  };

  ws.onerror = function (evt) {
   console.error("WebSocket error: Unable to communicate with server using "
                 + document.location.protocol + " WebSockets. Error: " + evt);
   if (websocket_reconnect()) {
      return;
   }
   unrecoverable_error("Network error"
                      , "A problem occured with the "
                        + document.location.protocol
                        + " WebSocket connection to the server: " + ws.url);
  };
}

/****************************************************************************
  When the WebSocket connection is open and ready to communicate, then
  send the first login message to the server.
****************************************************************************/
function websocket_ready()
{
    var sha_password = null;
    var stored_password = simpleStorage.get("password", "");
    if (stored_password != null && stored_password != false) {
      var shaObj = new jsSHA("SHA-512", "TEXT");
      shaObj.update(stored_password);
      sha_password = encodeURIComponent(shaObj.getHash("HEX"));
    }

    if (get_game_auth_method() == "google" && google_user_token == null) {
      unrecoverable_error("Login failed.", "This game requires a Google login");
      return;
    }

    send_request({"pid":4, "username" : username,
    "capability": fc_capabilities.getOurCapabilities().capstring,
    "version_label": "-dev",
    "major_version" : 2, "minor_version" : 5, "patch_version" : 99,
    "port": civserverport,
    "password": google_user_token == null ? sha_password : google_user_token});

    /* Leaving the page without saving can now be an issue. */
    $(window).bind('beforeunload', function(){
      return "Do you really want to leave your nation behind now?";
    });

    /* The connection is now up. Verify that it remains alive. */
    ping_timer = setInterval(ping_check, pingtime_check);

    $.unblockUI();
}

/****************************************************************************
  Tries to restart the WebSocket connection for intermittent errors.
  Returns true for a retry, false for a fold.
****************************************************************************/
function websocket_reconnect()
{
   network_stop();
   const now = new Date().getTime();
   ws_errors.put(now);
   const oldest = ws_errors.get(1);
   if (oldest == null || (now - oldest) > 30000) {
      message_log.update({
        event: E_LOG_ERROR,
        message: "Error: connection to server is closed. Trying to reconnect."
      });
      setTimeout(websocket_init, 1000);
      return true;
   }
   return false;
}

/****************************************************************************
  Stops network sync.
****************************************************************************/
function network_stop()
{
  const cws = ws;

  /* Don't ping a dead connection. */
  clearInterval(ping_timer);

  /* The player can't save the game after the connection is down. */
  $(window).unbind('beforeunload');

  if (cws != null) {
    ws = cws.onopen = cws.onmessage = cws.onclose = cws.onerror = null;
    cws.close();
  }
}

/****************************************************************************
  Sends a request to the server, with a JSON packet.
****************************************************************************/
function send_request(packet_payload)
{
  if (ws != null) {
    ws.send(JSON.stringify(packet_payload));
  }

  if (debug_active) {
    clinet_last_send = new Date().getTime();
  }
}


/****************************************************************************
...
****************************************************************************/
function clinet_debug_collect()
{
  var time_elapsed = new Date().getTime() - clinet_last_send;
  debug_client_speed_list.push(time_elapsed);
  clinet_last_send = new Date().getTime();
}

/****************************************************************************
  Detect server disconnections, by checking the time since the last
  ping packet from the server.
****************************************************************************/
function ping_check()
{
  var time_since_last_ping = new Date().getTime() - ping_last;
  if (time_since_last_ping > pingtime_check) {
    console.log("Error: Missing PING message from server, "
                + "indicates server connection problem.");
  }
}

/****************************************************************************
  send the chat message to the server after a delay.
****************************************************************************/
function send_message_delayed(message, delay)
{
  setTimeout("send_message('" + message + "');", delay);
}

/****************************************************************************
  sends a chat message to the server.
****************************************************************************/
function send_message(message)
{
  if (is_longturn() && message != null) {
    if (message.indexOf(encodeURIComponent("/")) !== 0
      && message.indexOf("/") !== 0
      && message.charAt(0) !== ".") {
      var private_mark_i = message.indexOf(encodeURIComponent(":"));
      if (private_mark_i <= 0) {
        message = username + " : " + message;
      } else {
        var first_space = message.indexOf(encodeURIComponent(" "));
        if (first_space >= 0 && first_space < private_mark_i) {
          message = username + " : " + message;
        }
      }
    }
  }

  send_request({"pid" : packet_chat_msg_req,
                "message" : message});
}
