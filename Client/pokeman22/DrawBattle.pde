
ArrayList<String> text_chat = new ArrayList<String>();

char c_display_state = DISPLAY_NONE;

int c_my_display_poke = DISPLAY_NONE;
int c_other_display_poke = DISPLAY_NONE;

int c_my_display_poke_tmp_new = DISPLAY_NONE;
int c_other_display_poke_tmp_new = DISPLAY_NONE;

JSONObject json_my_display_poke_tmp_new = null;
JSONObject json_other_display_poke_tmp_new = null;

int i_total_moving = 30;
int i_moving = 0;
int i_moving_direction = 1;

int i_total_switching = 30;
int i_switching = 0;
int i_switching_direction = 1;

void stop_battle() {
  i_battle_state = NOT_READY;

  c_display_state = DISPLAY_NONE;

  c_my_display_poke = DISPLAY_NONE;
  c_other_display_poke = DISPLAY_NONE;
}

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

  // ME poke
  pushMatrix();
  if (i_switching>0 && i_switching_direction == ME) {
    i_switching--;
    if (i_switching>i_total_switching/2) {
      translate(interpolate(0, -300, (i_total_switching-i_switching), i_total_switching/2), 0);
    } else {
      translate(interpolate(-300, 0, (i_total_switching-i_switching)-i_total_switching/2, i_total_switching/2), 0);
    }
    if (i_switching==i_total_switching/2) {
      c_my_display_poke = c_my_display_poke_tmp_new;
    }
  }
  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size()) {

    drawPokemon(pokemons.get(c_my_display_poke).animationBack, POKE_ME_RECT.i_x, POKE_ME_RECT.i_y);
    rectMode(CORNER);
    fill(150);
    rect(POKE_ME_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_ME_RECT.i_y-100, HEALTH_BAR_WIDTH, 7);
    fill(100, 255, 255);
    noStroke();
    rect(POKE_ME_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_ME_RECT.i_y-100, HEALTH_BAR_WIDTH*round(pokemons.get(c_my_display_poke).cur_hp)/pokemons.get(c_my_display_poke).HP, 7);
    stroke(0);
    fill(0, 0);
    rect(POKE_ME_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_ME_RECT.i_y-100, HEALTH_BAR_WIDTH, 7);
    textAlign(CENTER);
  }
  popMatrix();

  // OTHER poke
  pushMatrix();
  if (i_switching>0 && i_switching_direction == OTHER) {
    i_switching--;
    if (i_switching>i_total_switching/2) {
      translate(interpolate(0, 300, (i_total_switching-i_switching), i_total_switching/2), 0);
    } else {
      translate(interpolate(300, 0, (i_total_switching-i_switching)-i_total_switching/2, i_total_switching/2), 0);
    }
    if (i_switching==i_total_switching/2) {
      c_other_display_poke = c_other_display_poke_tmp_new;
    }
  }
  if (c_display_state==DISPLAY_POKES && c_other_display_poke<other_pokemons.size()) {
    drawPokemon(other_pokemons.get(c_other_display_poke).animation, POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
    rectMode(CORNER);
    fill(150);
    rect(POKE_OTHER_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_OTHER_RECT.i_y-100, HEALTH_BAR_WIDTH, 7);
    fill(100, 255, 255);
    noStroke();
    rect(POKE_OTHER_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_OTHER_RECT.i_y-100, HEALTH_BAR_WIDTH*round(other_pokemons.get(c_other_display_poke).cur_hp)/other_pokemons.get(c_other_display_poke).HP, 7);
    stroke(0);
    fill(0, 0);
    rect(POKE_OTHER_RECT.i_x-HEALTH_BAR_WIDTH/2, POKE_OTHER_RECT.i_y-100, HEALTH_BAR_WIDTH, 7);
    textAlign(CENTER);
  }
  popMatrix();

  rectMode(CENTER);

  if (i_moving>0) {
    i_moving--;

    pushMatrix();

    int tmp_move = i_moving;

    if (i_moving_direction==-1) {
      tmp_move = i_total_moving-i_moving;
    }

    translate_interpolation(POKE_ME_RECT, POKE_OTHER_RECT, tmp_move, i_total_moving);
    rotate((frameCount*20.0)%360);
    fill(0, 255, 255);
    noStroke();
    rect(0, 0, 50, 50);
    popMatrix();
  }

  imageMode(CORNER);
  textAlign(CORNER);
  rectMode(CORNER);

  textAlign(CENTER, CENTER);
  fill(0);
  for (int i=0; i<text_chat.size() && height - i*30 > 30; i++) {
    text(text_chat.get(i), width/2, height - i*30 - 30);
  }

  textAlign(LEFT);
  text(i_cur_animation_frames_left, 50, 50);
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