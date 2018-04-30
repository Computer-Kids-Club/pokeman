import processing.net.*; 

Client myClient; 

char i_selection_stage = AWAITING_SELECTION;

JSONArray json_avail_pokes_array = null;

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
    i_battle_state = BATTLING;
  } else if (dataIn.charAt(0)==NEXT_TURN) {
    println("NEXT TURN");
    i_battle_state = NOT_READY;
  } else if (dataIn.charAt(0)==SELECT_POKE) {
    i_selection_stage = SELECT_POKE;
    if (dataIn.length()>1) {
      JSONObject json = parseJSONObject(dataIn.substring(1));
      json_avail_pokes_array = json.getJSONArray("availpoke");
      text_chat.add(0, "Select a pokemon with keys: "+json_array_to_string(json_avail_pokes_array, ' '));
    }
  } else if (dataIn.charAt(0)==SELECT_POKE_OR_MOVE) {
    i_selection_stage = SELECT_POKE_OR_MOVE;
    if (dataIn.length()>1) {
      JSONObject json = parseJSONObject(dataIn.substring(1));
      json_avail_pokes_array = json.getJSONArray("availpoke");
      text_chat.add(0, "Select a pokemon with keys: "+json_array_to_string(json_avail_pokes_array, ' ')+"OR Select a move with keys: q,w,e,r");
    }
  } else if (dataIn.charAt(0)==SELECT_MOVE) {
    i_selection_stage = SELECT_MOVE;
    text_chat.add(0, "Select a move with keys: q,w,e,r");
  } else if (dataIn.charAt(0)==AWAITING_SELECTION) {
    i_selection_stage = AWAITING_SELECTION;
    text_chat.add(0, "FOUND BATTLE");
  } else if (dataIn.charAt(0)==DISPLAY_TEXT) {
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
      if(i_healthing_original != new_poke.cur_hp && i_cur_animation_frames_left == 0) {
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
    JSONObject json_move = new JSONObject();
    if (i_display_player==ME) {
      json_move = json.getJSONObject("move");
      //text_chat.add(0, "You used "+json_move.getString("name"));
      i_moving_direction = -1;
    } else/* if (i_display_player==OTHER)*/ {
      json_move = json.getJSONObject("move");
      //text_chat.add(0, "Your opponent used "+json_move.getString("name"));
      i_moving_direction = 1;
    }
    i_moving = i_total_moving;
    str_cur_move_type = json_move.getString("type");
    //println(json_move+" "+json_move.getString("cat"));
    str_cur_move_cat = json_move.getString("cat");
    str_cur_move_anime_style = json_move.getString("anime");
  } else if (dataIn.charAt(0)==DISPLAY_DELAY) {
    i_cur_animation_frames_left = 30;
  } else if (dataIn.charAt(0)==DISPLAY_FIELD) {
    JSONObject json = parseJSONObject(dataIn.substring(1));
    i_weather = json.getInt("weather");
    i_terrain = json.getInt("terrain");
    JSONArray json_arr_me_hazards = json.getJSONArray("mehazards");
    JSONArray json_arr_other_hazards = json.getJSONArray("otherhazards");
    for(int i=0;i<json_arr_me_hazards.size();i++) {
      l_me_hazards.add(json_arr_me_hazards.getString(i));
    }
    for(int i=0;i<json_arr_other_hazards.size();i++) {
      l_other_hazards.add(json_arr_other_hazards.getString(i));
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

void send_pokes() {

  JSONObject json = new JSONObject();

  JSONArray json_poke_array = new JSONArray();

  json.setString("battlestate", "pokes");
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