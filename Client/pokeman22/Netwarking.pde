import processing.net.*; 

Client myClient; 

char i_selection_stage = AWAITING_SELECTION;

boolean reconnect() {
  if (!myClient.active()) {

    myClient = new Client(this, "127.0.0.1", PORT);
  }
  return myClient.active();
}

String dataIn = ""; 
void recieve_data() { 
  //reconnect();
  while (myClient.available() > 0) { 
    char newChar = char(myClient.read());
    dataIn += newChar;
    if (newChar == TERMINATING_CHAR) {
      dataIn = dataIn.substring(0, dataIn.length()-1);
      //println("Recieved data: ");
      //println(dataIn);
      if (dataIn.length()>=1) {
        if (dataIn.charAt(0)==FOUND_BATTLE) {
          println("FOUND BATTLE");
          text_chat.add(0, "FOUND BATTLE");
          i_battle_state = BATTLING;
        } else if (dataIn.charAt(0)==NEXT_TURN) {
          println("NEXT TURN");
          i_battle_state = NOT_READY;
        } else if (dataIn.charAt(0)==SELECT_POKE) {
          i_selection_stage = SELECT_POKE;
          text_chat.add(0, "Select a pokemon with keys: 1,2,3,4,5,6");
        } else if (dataIn.charAt(0)==SELECT_POKE_OR_MOVE) {
          i_selection_stage = SELECT_POKE_OR_MOVE;
          text_chat.add(0, "Select a pokemon with keys: 1,2,3,4,5,6 OR Select a move with keys: q,w,e,r");
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
          JSONObject json = parseJSONObject(dataIn.substring(1));
          JSONArray json_pokes_array = json.getJSONArray("pokes");
          other_pokemons = new ArrayList<Pokemon>();
          for (int j = 0; j < json_pokes_array.size(); j++) {
            other_pokemon_jsons[j] = json_pokes_array.getJSONObject(j);
            //other_pokemons.add(new Pokemon(other_pokemon_jsons[j]));
          }
        } else if (dataIn.charAt(0)==DISPLAY_POKES) {
          c_display_state = DISPLAY_POKES;
          JSONObject json = parseJSONObject(dataIn.substring(1));
          int i_display_player = json.getInt("player");
          if (i_display_player==ME) {
            c_my_display_poke = json.getInt("pokeidx");
          } else if (i_display_player==OTHER) {
            c_other_display_poke = json.getInt("pokeidx");
          }
        }
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

    String name, type1, type2, species, h, weight, ability, move1, move2, move3, move4;
    int number, HP, ATK, DEF, SPA, SPD, SPE, happiness, level;
    Boolean shiny;

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

    json_poke_array.setJSONObject(i, json_poke);
  }

  json.setJSONArray("pokes", json_poke_array);

  println(json.toString());

  if (!myClient.active()) {
    return;
  }

  myClient.write(json.toString());
}