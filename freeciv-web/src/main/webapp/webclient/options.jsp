  
<div style="overflow: auto; height: 92%;">

<div style="text-align: center;">
<center>

<h2>Game Options</h2>

<div class="main_menu_buttons">
<b>Music:</b><br>
  <audio preload="none"></audio>
</div>

<div class="main_menu_buttons">
<table>
<tr>
  <td>
    <button id="switch_renderer_button" type="button" class="button setting_button" onClick="switch_renderer();"></button>
  </td>
  <td>
    <div id="renderer_help" style="font-size: 85%; max-width: 450px;"></div>
  </td>
</tr>
<tr>
  <td>
    <button id="replay_button" type="button" class="button setting_button" onClick="show_replay();">Show game replay</button>
  </td>
  <td>
    Show game replay
  </td>
</tr>
</table>

</div>


<div class="main_menu_buttons" id="timeout_setting_div">
  <b>Timeout (seconds per turn):</b> <input type='number' name='timeout_setting' id='timeout_setting' size='6' length='3' max='3600' step='1'>
  <span id="timeout_info"></span>
</div>


<table>
<tr>
<td>
  <div class="main_menu_buttons">
    <input type='checkbox' name='play_sounds_setting' id='play_sounds_setting' checked><b>Play sounds</b>
  </div>
</td>
<td>
  <div class="main_menu_buttons">
    <input type='checkbox' name='speech_enabled_setting' id='speech_enabled_setting'><b>Speech messages</b>
  </div>
</td>
</tr>

<tr>
<td>
<div class="main_menu_buttons">
  <button id="save_button" type="button" class="button setting_button" onClick="save_game();" title="Saves your current game so you can continue later. Press Ctrl+S to quick save the game.">Save Game (Ctrl+S)</button>
</div>
</td>
<td>
<div class="main_menu_buttons">
  <button id="fullscreen_button" type="button" class="button setting_button" onClick="show_fullscreen_window();" title="Enables fullscreen window mode" >Fullscreen</button>
</div>
</td>
</tr>
<tr>
<td>
<div class="main_menu_buttons">
  <button id="surrender_button" type="button" class="button setting_button" onClick="surrender_game();" title="Surrenders in multiplayer games and thus ends the game for you.">Surrender Game</button>
</div>
</td>
<td>
<div class="main_menu_buttons">
  <button id="end_button" type="button" class="button setting_button" onClick="window.location='/';" title="Ends the game, and returns to the main page of Freeciv-web." >End Game</button>
</div>
</td>
</tr>
<tr>
<td>
<div class="main_menu_buttons">
  <button id="update_model_button" type="button" class="button setting_button" onClick="update_webgl_model();" title="Update a webgl model" >Update 3D model</button>
</div>
</td>
<td>
</td>
</tr>
</table>


<div class="main_menu_buttons" id="title_setting_div">
  <b>Game title:</b> <input type='text' name='metamessage_setting' id='metamessage_setting' size='28' maxlength='42'>
</div>

<div class="main_menu_buttons">
  <h3>Experimental</h3>
  <table>
    <tr>
      <td><input type='checkbox' name='username_in_nations_tab_setting' id='username_in_nations_tab_setting'>Show user instead of leader in Nations tab.</td>
    </tr><tr>
      <td>Show timestamps for <select name='msg_ts_setting' id='msg_ts_setting'>
          <option value='old'>only old messages</option>
          <option value='all'>all messages</option>
          <option value='no'>no messages</option>
        </select></td>
      <td>Show timestamps in <select name='msg_ts_tz_setting' id='msg_ts_tz_setting'>
          <option value='local'>local time</option>
          <option value='server'>server time</option>
          <option value='UTC'>UTC</option>
        </select></td>
    </tr><tr>
      <td colspan="2">* The message settings only apply to new messages</td>
    </tr><tr>
      <td colspan="2">* Note that due to limitations in freeciv protocol, the times may be off near DST changes</td>
    </tr>
  </table>
</div>

</center>
</div>

</div>

