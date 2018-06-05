import processing.net.*; 

Client myClient; 

char i_selection_stage = AWAITING_SELECTION;

JSONArray json_avail_pokes_array = null;
JSONArray json_avail_moves_array = null;

ArrayList<String> l_display_queue = new ArrayList<String>();

int i_cur_animation_frames_left = 0;

boolean reconnect() {
  if (!myClient.active()) {
    myClient = new Client(this, IPv4, PORT);
  }
  return myClient.active();
}

String json_array_to_string(JSONArray json_arr, char c_split) {
  String str_ret = "";
  for (int j = 0; j < json_arr.size(); j++) {
    str_ret += json_arr.getInt(j) + "" + c_split;
  }
  return str_ret;
}

void process_data(String dataIn) {

  i_cur_animation_frames_left = 0;

  if (dataIn.charAt(0)==FOUND_BATTLE) {
    println("FOUND BATTLE");
    text_chat = new ArrayList<String>();
    text_chat.add(0, "FOUND BATTLE");
    turn++;
    i_battle_state = BATTLING;
  } else if (dataIn.charAt(0)==NEXT_TURN) {
    println("NEXT TURN");
    i_battle_state = NOT_READY;
  } else if (dataIn.charAt(0)==SELECT_POKE) {
    i_selection_stage = SELECT_POKE;
    if (dataIn.length()>1) {
      JSONObject json = parseJSONObject(dataIn.substring(1));
      json_avail_pokes_array = json.getJSONArray("availpoke");
      //text_chat.add(0, "Select a pokemon with keys: "+json_array_to_string(json_avail_pokes_array, ' '));
      text_chat.add(0, "");
    }
  } else if (dataIn.charAt(0)==SELECT_POKE_OR_MOVE) {
    i_selection_stage = SELECT_POKE_OR_MOVE;
    if (dataIn.length()>1) {
      JSONObject json = parseJSONObject(dataIn.substring(1));
      json_avail_pokes_array = json.getJSONArray("availpoke");
      json_avail_moves_array = json.getJSONArray("availmove");
      //text_chat.add(0, "Select a pokemon with keys: "+json_array_to_string(json_avail_pokes_array, ' ')+"OR Select a move with keys: q,w,e,r");
    }
  } else if (dataIn.charAt(0)==SELECT_MOVE) {
    i_selection_stage = SELECT_MOVE;
    if (dataIn.length()>1) {
      JSONObject json = parseJSONObject(dataIn.substring(1));
      json_avail_moves_array = json.getJSONArray("availmove");
      //text_chat.add(0, "Select a move with keys: q,w,e,r");
    }
  } else if (dataIn.charAt(0)==AWAITING_SELECTION) {
    i_selection_stage = AWAITING_SELECTION;
    text_chat.add(0, "FOUND BATTLE");
  } else if (dataIn.charAt(0)==DISPLAY_TEXT) {
    if (dataIn.substring(1).equals("")) {
      turn++;
      text_chat.add(0, dataIn.substring(1));
    }
    text_chat.add(0, dataIn.substring(1));
  } else if (dataIn.charAt(0)==SENDING_POKE) {
    JSONObject json = parseJSONObject(dataIn.substring(1));
    JSONArray json_pokes_array = json.getJSONArray("pokes");
    other_pokemons = new ArrayList<Pokemon>();
    for (int j = 0; j < json_pokes_array.size(); j++) {
      other_pokemon_jsons[j] = json_pokes_array.getJSONObject(j);
      other_pokemons.add(new Pokemon(other_pokemon_jsons[j]));
    }
    c_display_state = DISPLAY_TEAMS;
  } else if (dataIn.charAt(0)==CHANGING_POKE) {
    /*JSONObject json = parseJSONObject(dataIn.substring(1));
     JSONArray json_pokes_array = json.getJSONArray("pokes");
     other_pokemons = new ArrayList<Pokemon>();
     for (int j = 0; j < json_pokes_array.size(); j++) {
     other_pokemon_jsons[j] = json_pokes_array.getJSONObject(j);
     //other_pokemons.add(new Pokemon(other_pokemon_jsons[j]));
     }*/
  } else if (dataIn.charAt(0)==DISPLAY_POKES) {
    //i_cur_animation_frames_left = 30;
    c_display_state = DISPLAY_POKES;
    JSONObject json = parseJSONObject(dataIn.substring(1));
    int i_display_player = json.getInt("player");
    Pokemon new_poke = null;
    if (i_display_player==ME) {
      int i_tmp_new_display_poke = json.getInt("pokeidx");
      new_poke = pokemons.get(i_tmp_new_display_poke);
      i_healthing_direction = -1;
      if (c_my_display_poke != i_tmp_new_display_poke) {
        text_chat.add(0, "Client swapped pokemon to " + pokemons.get(i_tmp_new_display_poke).name);
        i_cur_animation_frames_left = 30;
        i_switching_direction = ME;
        i_switching = i_total_switching;
        c_my_display_poke_tmp_new = i_tmp_new_display_poke;
      } else {
        c_my_display_poke = i_tmp_new_display_poke;
      }
    } else if (i_display_player==OTHER) {
      int i_tmp_new_display_poke = json.getInt("pokeidx");
      new_poke = other_pokemons.get(i_tmp_new_display_poke);
      i_healthing_direction = 1;
      if (c_other_display_poke != i_tmp_new_display_poke) {
        text_chat.add(0, "Server swapped pokemon to " + other_pokemons.get(i_tmp_new_display_poke).name);
        i_cur_animation_frames_left = 30;
        i_switching_direction = OTHER;
        i_switching = i_total_switching;
        c_other_display_poke_tmp_new = i_tmp_new_display_poke;
      } else {
        c_other_display_poke = i_tmp_new_display_poke;
      }
    }
    if (new_poke!=null) {
      i_healthing_original = new_poke.cur_hp;
      new_poke.old_hp = new_poke.cur_hp;
      new_poke.update_with_json(json.getJSONObject("poke"));
      if (i_healthing_original != new_poke.cur_hp && i_cur_animation_frames_left == 0) {
        i_cur_animation_frames_left = 30;
        i_healthing = i_total_healthing;
        i_dmg_text_effecting = round(float(i_healthing_original-new_poke.cur_hp)*100/new_poke.HP);
        i_heal_text_effecting = round(float(new_poke.cur_hp-i_healthing_original)*100/new_poke.HP);
      }
    }
  } else if (dataIn.charAt(0)==DISPLAY_WIN) {
    text_chat.add(0, "YOU WIN :)");
    stop_battle();
  } else if (dataIn.charAt(0)==DISPLAY_LOSE) {
    text_chat.add(0, "YOU LOSE :(");
    stop_battle();
  } else if (dataIn.charAt(0)==DISPLAY_MOVE) {
    i_cur_animation_frames_left = 30;
    JSONObject json = parseJSONObject(dataIn.substring(1));
    int i_display_player = json.getInt("player");
    JSONObject json_move = json.getJSONObject("move");
    i_moving = i_total_moving;
    str_cur_move_type = json_move.getString("type");
    //println(json_move+" "+json_move.getString("cat"));
    str_cur_move_cat = json_move.getString("cat");
    str_cur_move_anime_style = json_move.getString("anime");
    String str_cur_move_name = json_move.getString("name");
    if (i_display_player==ME) {
      //text_chat.add(0, "You used "+json_move.getString("name"));
      add_effect_text_effect(str_cur_move_name, POKE_ME_RECT.i_x, POKE_ME_RECT.i_y, (int)TYPE_COLOURS.get(str_cur_move_type));
      i_moving_direction = -1;
    } 
     else/* if (i_display_player==OTHER)*/ {
      //text_chat.add(0, "Your opponent used "+json_move.getString("name"));
      add_effect_text_effect(str_cur_move_name, POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y, (int)TYPE_COLOURS.get(str_cur_move_type));
      i_moving_direction = 1;
    }
  } else if (dataIn.charAt(0)==DISPLAY_DELAY) {
    i_cur_animation_frames_left = 30;
  } else if (dataIn.charAt(0)==DISPLAY_FIELD) {
    JSONObject json = parseJSONObject(dataIn.substring(1));
    i_weather = json.getInt("weather");
    i_terrain = json.getInt("terrain");
    JSONArray json_arr_me_hazards = json.getJSONArray("mehazards");
    JSONArray json_arr_other_hazards = json.getJSONArray("otherhazards");
    l_me_hazards = new ArrayList<String> ();
    for (int i=0; i<json_arr_me_hazards.size(); i++) {
      l_me_hazards.add(json_arr_me_hazards.getString(i));
    }
    l_other_hazards = new ArrayList<String> ();
    for (int i=0; i<json_arr_other_hazards.size(); i++) {
      l_other_hazards.add(json_arr_other_hazards.getString(i));
    }
  } else if (dataIn.charAt(0)==DISPLAY_AD_HOC_TEXT) {
    JSONObject json = parseJSONObject(dataIn.substring(1));
    String str_move = json.getString("move");
    int i_display_player = json.getInt("player");
    if (str_move.equals("failed")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#FF0000));
    } else if (str_move.equals("missed")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#FF0000));
    } else if (str_move.equals("frozen")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#98D8D8));
    } else if (str_move.equals("protected")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#FF8BC1));
    } else if (str_move.equals("burn")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#F08030));
    } else if (str_move.equals("poison")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#A040A0));
    } else if (str_move.equals("toxic")) {
      add_ad_hoc_text_effect(str_move, i_display_player, color(#A040A0));
    }
  } else if (dataIn.charAt(0)=='l') {
    if (dataIn.substring(1).equals("true")) {
      JSONObject json = new JSONObject();
      json.setString("username", username);
      json.setString("battlestate", "pokeread");
      myClient.write(json.toString());
      
      print("data received");
      textFont(font_plain);
      player_name=username;
      login=false;
      register=false;
      print("lol");
    } else {
      username="";
      password="";
      current="";
    }
  } else if (dataIn.charAt(0) == 'z') {
    JSONObject json = parseJSONObject(dataIn.substring(1));
    JSONArray json_pokes_array = json.getJSONArray("pokes");
    pokemons = new ArrayList<Pokemon>();
    for (int j = 0; j < json_pokes_array.size(); j++) {
      pokemon_jsons[j] = json_pokes_array.getJSONObject(j);
      pokemons.add(new Pokemon(pokemon_jsons[j]));
    }
  }
}

String dataIn = ""; 
void recieve_data() { 

  //println("cur anime frames left " + i_cur_animation_frames_left);
  if (i_cur_animation_frames_left>0) {

    i_cur_animation_frames_left--;
  } else if (l_display_queue.size()>0) {

    process_data(l_display_queue.get(0));

    l_display_queue.remove(l_display_queue.get(0));
  }

  //reconnect();
  while (myClient.available() > 0) { 
    char newChar = char(myClient.read());
    dataIn += newChar;
    if (newChar == TERMINATING_CHAR) {
      dataIn = dataIn.substring(0, dataIn.length()-1);
      //println("Recieved data: ");
      //println(dataIn);
      if (dataIn.length()>=1) {

        l_display_queue.add(dataIn);
      }
      dataIn = "";
    }
  }
}

void send_hey() {
  if (myClient.active()) {
    myClient.write("hey");
  }
}

void send_saving() {
  send_pokes("pokewrite");
}

void send_pokes() {
  send_pokes("pokes");
}

void send_pokes(String whatthisis) {

  JSONObject json = new JSONObject();

  JSONArray json_poke_array = new JSONArray();

  json.setString("battlestate", whatthisis);
  /*json.setString("species", "Panthera leo");
   json.setString("name", "Lion");*/

  for (int i=0; i<pokemons.size(); i++) {
    JSONObject json_poke = new JSONObject();
    Pokemon poke = pokemons.get(i);

    json_poke.setString("name", poke.name);
    json_poke.setString("ability", poke.ability);

    json_poke.setInt("num", poke.number);
    json_poke.setInt("hp", poke.HP);
    json_poke.setInt("atk", poke.ATK);
    json_poke.setInt("def", poke.DEF);
    json_poke.setInt("spa", poke.SPA);
    json_poke.setInt("spd", poke.SPD);
    json_poke.setInt("spe", poke.SPE);
    json_poke.setInt("hap", poke.happiness);
    json_poke.setInt("lv", poke.level);
    json_poke.setBoolean("shiny", poke.shiny);

    JSONArray json_move_array = new JSONArray();
    for (int j=0; j<poke.moves.length; j++) {
      json_move_array.setString(j, poke.moves[j]);
    }
    json_poke.setJSONArray("moves", json_move_array);

    json_poke_array.setJSONObject(i, json_poke);
  }

  json.setJSONArray("pokes", json_poke_array);

  println(json.toString());

  if (!myClient.active()) {
    return;
  }

  myClient.write(json.toString());
}
