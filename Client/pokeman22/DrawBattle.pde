
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

int i_healthing_original = 0;
int i_total_healthing = 30;
int i_healthing = 0;
int i_healthing_direction = 1;

int i_dmg_text_effecting = 0;
int i_heal_text_effecting = 0;

String str_cur_move_type = "";
String str_cur_move_cat = "";
String str_cur_move_anime_style = "";

PImage img_flag_bite;
PImage img_flag_ballistics;
PImage img_flag_dance;
PImage img_flag_powder;
PImage img_flag_pulse;
PImage img_flag_punch;
PImage img_flag_sound;

int i_weather = 0;
int i_terrain = 0;

ArrayList<String> l_me_hazards = new ArrayList<String> ();
ArrayList<String> l_other_hazards = new ArrayList<String> ();

HashMap<String, PImage> TYPE_MOVE_IMG = new HashMap<String, PImage>();

void init_battle_screen() {
  img_flag_bite = loadImage("MoveAnimations/bite.png");
  img_flag_ballistics = loadImage("MoveAnimations/bullistics.png");
  img_flag_dance = loadImage("MoveAnimations/dance.png");
  img_flag_powder = loadImage("MoveAnimations/powder.png");
  img_flag_pulse = loadImage("MoveAnimations/pulse.png");
  img_flag_punch = loadImage("MoveAnimations/punch.png");
  img_flag_sound = loadImage("MoveAnimations/sound.png");

  img_flag_bite.resize(150, 0);
  img_flag_ballistics.resize(150, 0);
  img_flag_dance.resize(150, 0);
  img_flag_powder.resize(150, 0);
  img_flag_pulse.resize(150, 0);
  img_flag_punch.resize(150, 0);
  img_flag_sound.resize(150, 0);

  for (String str_type : TYPE_COLOURS.keySet()) {
    // ...
    PImage new_img = loadImage("MoveAnimations/"+str_type+".png");
    new_img.resize(150, 0);
    TYPE_MOVE_IMG.put(str_type, new_img);
  }
}

void stop_battle() {
  i_battle_state = NOT_READY;

  c_display_state = DISPLAY_NONE;

  c_my_display_poke = DISPLAY_NONE;
  c_other_display_poke = DISPLAY_NONE;
}

void draw_health_bar(int x, int y, float p, float op) {
  draw_rectMode(CORNER);
  fill(150);
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-70, HEALTH_BAR_WIDTH, 7);
  fill(50, 150, 200);
  noStroke();
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-70, round(HEALTH_BAR_WIDTH*op), 7);
  fill(interpolate(0, 100, int(p*1000), 1000), 255, 255);
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-70, round(HEALTH_BAR_WIDTH*p), 7); // round(pokemons.get(c_my_display_poke).cur_hp)/pokemons.get(c_my_display_poke).HP, 7);
  stroke(0);
  noFill();
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-70, HEALTH_BAR_WIDTH, 7);

  textAlign(CENTER, CENTER);
  fill(0);
  draw_text(round(100*p)+"%", x-HEALTH_BAR_WIDTH/2-20, y-70+7/2);
}

void draw_battling_poke(Pokemon poke, int me_or_other) {

  boolean b_cur_poke_hp_anime = false;

  if (me_or_other==ME) {
    drawPokemon(poke.animationBack, 0, 0);
    if (i_healthing_direction == -1 && i_healthing>0 ) {
      b_cur_poke_hp_anime = true;
      for (int i=0; i<3; i++) {
        if (i_dmg_text_effecting>0)
          add_dmg_text_effect(POKE_ME_RECT.i_x, POKE_ME_RECT.i_y);
        if (i_heal_text_effecting>0)
          add_heal_text_effect(POKE_ME_RECT.i_x, POKE_ME_RECT.i_y);
        i_dmg_text_effecting = max(i_dmg_text_effecting-1, 0);
        i_heal_text_effecting = max(i_heal_text_effecting-1, 0);
      }
    }
  } else {
    drawPokemon(poke.animation, 0, 0);
    if (i_healthing_direction == 1 && i_healthing>0 ) {
      b_cur_poke_hp_anime = true;
      for (int i=0; i<3; i++) {
        if (i_dmg_text_effecting>0)
          add_dmg_text_effect(POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
        if (i_heal_text_effecting>0)
          add_heal_text_effect(POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
        i_dmg_text_effecting = max(i_dmg_text_effecting-1, 0);
        i_heal_text_effecting = max(i_heal_text_effecting-1, 0);
      }
    }
  }

  if (i_healthing>0 && b_cur_poke_hp_anime) {
    i_healthing--;
    draw_health_bar(0, 0, (float)(interpolate(i_healthing_original, poke.cur_hp, i_total_healthing-i_healthing, i_total_healthing))/poke.HP, (float)poke.old_hp/poke.HP);
  } else {
    draw_health_bar(0, 0, (float)poke.cur_hp/poke.HP, (float)poke.old_hp/poke.HP);
  }

  draw_rectMode(CENTER);
  if (poke.protect) {
    stroke(225, 100, 255, 150);
    fill(225, 100, 255, 100);
    draw_rect(0, 0, 150, 100);
  }

  textAlign(LEFT);
  fill(0);

  pushMatrix();
  translate(-HEALTH_BAR_WIDTH/2, 0);
  for (int i=0; i<poke.text_status_effects.size(); i++) {
    draw_text(poke.text_status_effects.get(i), 0, -50);
    translate(textWidth(poke.text_status_effects.get(i))+5, 0);
  }
  popMatrix();

  textAlign(CENTER, CENTER);
  draw_text(poke.name, 0, -80);
}

void draw_battle() {

  background(0);

  fill(200);
  noStroke();
  draw_rectMode(CORNER);
  draw_rect(0, 0, width, height);

  draw_rectMode(CENTER);
  draw_imageMode(CENTER);
  textAlign(CENTER);

  if (c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < pokemons.size(); i++) {
      drawPokemon(pokemons.get(i).animationBack, (i+1)*100, 350+i*40);
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

    if (i_moving>0 && str_cur_move_anime_style.equals("physical") && i_moving_direction == -1) {

      int tmp_move = i_moving * 2;

      if (tmp_move<i_total_moving) {
        tmp_move = tmp_move;
      } else {
        tmp_move = 2*i_total_moving-tmp_move;
      }
      //println(tmp_move);
      translate_interpolation(POKE_ME_RECT, POKE_OTHER_RECT, tmp_move, i_total_moving);
      translate(-POKE_ME_RECT.i_x, -POKE_ME_RECT.i_y);
    }

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

    if (i_moving>0 && str_cur_move_anime_style.equals("physical") && i_moving_direction == 1) {

      int tmp_move = i_moving * 2;

      if (tmp_move<i_total_moving) {
        tmp_move = tmp_move;
      } else {
        tmp_move = 2*i_total_moving-tmp_move;
      }
      //println(tmp_move);
      translate_interpolation(POKE_OTHER_RECT, POKE_ME_RECT, tmp_move, i_total_moving);
      translate(-POKE_OTHER_RECT.i_x, -POKE_OTHER_RECT.i_y);
    }

    translate(POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
    draw_battling_poke(other_pokemons.get(c_other_display_poke), OTHER);
  }
  popMatrix();

  draw_rectMode(CENTER);

  if (i_moving>0) {
    i_moving--;

    int tmp_move = i_moving;

    pushMatrix();

    if (i_moving_direction==-1) {
      tmp_move = i_total_moving-i_moving;
      //rotate(180);
    }

    translate_interpolation(POKE_ME_RECT, POKE_OTHER_RECT, tmp_move, i_total_moving);

    //rotate((frameCount*20.0)%360);

    rotate(atan2(POKE_OTHER_RECT.i_y-POKE_ME_RECT.i_y, POKE_OTHER_RECT.i_x-POKE_ME_RECT.i_x));
    scale(1,-1*i_moving_direction);
    if (i_moving_direction==1) {
      rotate(PI);
    }

    fill(0, 255, 255);
    if (str_cur_move_type!="") {
      //tint(TYPE_COLOURS.get(str_cur_move_type));
      fill(TYPE_COLOURS.get(str_cur_move_type));
    }

    noStroke();

    draw_imageMode(CENTER);

    //println(str_cur_move_anime_style);
    if (str_cur_move_anime_style.equals("special")) {

      fill(0, 255, 255);
      if (str_cur_move_type!="")
        fill(TYPE_COLOURS.get(str_cur_move_type));

      draw_rect(0, 0, 50, 50);
      
      draw_image(TYPE_MOVE_IMG.get(str_cur_move_type), 0, 0);
      
    } else if (str_cur_move_anime_style.equals("flag_bite")) { // --------------------------------------------------------- bite

      draw_image(img_flag_bite, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_ballistics")) { // --------------------------------------------------------- ballistics

      draw_image(img_flag_ballistics, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_dance")) { // --------------------------------------------------------- dance

      draw_image(img_flag_dance, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_powder")) { // --------------------------------------------------------- powder

      draw_image(img_flag_powder, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_pulse")) { // --------------------------------------------------------- pulse

      draw_image(img_flag_pulse, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_punch")) { // --------------------------------------------------------- punch

      draw_image(img_flag_punch, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_sound")) { // --------------------------------------------------------- sound

      draw_image(img_flag_sound, 0, 0);
    }

    noTint();
    popMatrix();
  }

  draw_imageMode(CORNER);
  textAlign(CORNER);
  draw_rectMode(CORNER);

  textAlign(LEFT);
  draw_text(i_cur_animation_frames_left, 50, 50);

  // moves
  draw_rectMode(CENTER);
  textAlign(CENTER, CENTER);
  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size() && (i_selection_stage == SELECT_MOVE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    for (int i=0; i<4; i++) {
      pushMatrix();
      translate((1+2*i)*TEXT_CHAT_DIVIDE/8, 660);
      stroke(50);
      fill(TYPE_COLOURS.get(pokemons.get(c_my_display_poke).move_types[i]));
      draw_rect(0, 0, TEXT_CHAT_DIVIDE/4-8, 80-8, 10);
      fill(255);
      draw_text(pokemons.get(c_my_display_poke).moves[i], 0, 0);
      //draw_text(pokemons.get(c_my_display_poke).move_types[i], 0, 30);
      popMatrix();
    }
  }

  // team pokes
  if ((i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    for (int i=0; i<6; i++) {
      pushMatrix();
      translate((1+2*i)*TEXT_CHAT_DIVIDE/12, 730);
      stroke(50);
      fill(255);
      draw_rect(0, 0, TEXT_CHAT_DIVIDE/6-8, 60-8, 10);
      fill(0);
      draw_text(pokemons.get(i).name, 0, 0);
      popMatrix();
    }
  }

  // chat
  stroke(0);
  fill(255);
  draw_rectMode(CORNER);
  draw_rect(TEXT_CHAT_DIVIDE, 0, width-TEXT_CHAT_DIVIDE, height);

  textAlign(LEFT, CENTER);
  fill(0);
  for (int i=0; i<text_chat.size() && height - i*30 > 30; i++) {
    draw_text(text_chat.get(i), TEXT_CHAT_DIVIDE+10, height - i*30 - 30);
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