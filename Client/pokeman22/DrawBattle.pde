
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

void draw_health_bar(int x, int y, float p) {
  rectMode(CORNER);
  fill(150);
  rect(x-HEALTH_BAR_WIDTH/2, y-70, HEALTH_BAR_WIDTH, 7);
  fill(100, 255, 255);
  noStroke();
  rect(x-HEALTH_BAR_WIDTH/2, y-70, HEALTH_BAR_WIDTH*p, 7); // round(pokemons.get(c_my_display_poke).cur_hp)/pokemons.get(c_my_display_poke).HP, 7);
  stroke(0);
  fill(0, 0);
  rect(x-HEALTH_BAR_WIDTH/2, y-70, HEALTH_BAR_WIDTH, 7);
}

void draw_battling_poke(Pokemon poke, int me_or_other) {

  if (me_or_other==ME) {
    drawPokemon(poke.animationBack, 0, 0);
  } else {
    drawPokemon(poke.animation, 0, 0);
  }

  draw_health_bar(0, 0, (float)poke.cur_hp/poke.HP);

  textAlign(CENTER, CENTER);
  fill(0);
  text(poke.name, 0, -80);
}

void draw_battle() {

  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);

  if (c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < pokemons.size(); i++) {
      drawPokemon(pokemons.get(i).animationBack, (i+1)*100, 400+i*40);
    }
    for (int i = 0; i < other_pokemons.size(); i++) {
      drawPokemon(other_pokemons.get(i).animation, TEXT_CHAT_DIVIDE-(i+1)*100, 250-i*40);
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
    translate(POKE_ME_RECT.i_x, POKE_ME_RECT.i_y);
    draw_battling_poke(pokemons.get(c_my_display_poke), ME);
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
    translate(POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
    draw_battling_poke(other_pokemons.get(c_other_display_poke), OTHER);
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

  textAlign(LEFT);
  text(i_cur_animation_frames_left, 50, 50);
  
  stroke(0);
  fill(255);
  rect(TEXT_CHAT_DIVIDE,0,width-TEXT_CHAT_DIVIDE,height);
  
  textAlign(LEFT, CENTER);
  fill(0);
  for (int i=0; i<text_chat.size() && height - i*30 > 30; i++) {
    text(text_chat.get(i), TEXT_CHAT_DIVIDE+10, height - i*30 - 30);
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