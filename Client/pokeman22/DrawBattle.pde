
ArrayList<String> text_chat = new ArrayList<String>();

char c_display_state = DISPLAY_NONE;

int c_my_display_poke = DISPLAY_NONE;
int c_other_display_poke = DISPLAY_NONE;

void draw_battle() {

  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);

  if (c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < pokemons.size(); i++) {
      drawPokemon(pokemons.get(i).animationBack, 150+i*150, 400+i*40);
    }
    for (int i = 0; i < other_pokemons.size(); i++) {
      drawPokemon(other_pokemons.get(i).animation, 500+i*150, 50+i*40);
    }
  }

  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size()) {
    drawPokemon(pokemons.get(c_my_display_poke).animationBack, 150+3*150, 400+3*40);
  }
  if (c_display_state==DISPLAY_POKES && c_other_display_poke<other_pokemons.size()) {
    drawPokemon(other_pokemons.get(c_other_display_poke).animation, 500+3*150, 50+3*40);
  }

  imageMode(CORNER);
  textAlign(CORNER);
  rectMode(CORNER);

  textAlign(CENTER, CENTER);
  fill(0);
  for (int i=0; i<text_chat.size() && height - i*30 > 30; i++) {
    text(text_chat.get(i), width/2, height - i*30 - 30);
  }
}

void select_poke(int i_poke_id) {

  JSONObject json = new JSONObject();

  json.setString("battlestate", "selectpoke");
  json.setInt("poke", i_poke_id);

  if (!myClient.active()) {
    return;
  }

  myClient.write(json.toString());

  println(i_poke_id);
}

void select_move(int i_move_id) {

  JSONObject json = new JSONObject();

  json.setString("battlestate", "selectmove");
  json.setInt("move", i_move_id);

  if (!myClient.active()) {
    return;
  }

  myClient.write(json.toString());

  println(i_move_id);
}