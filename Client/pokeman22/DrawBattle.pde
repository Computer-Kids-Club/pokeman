
ArrayList<String> text_chat = new ArrayList<String>();

char c_display_state = DISPLAY_NONE;

int c_my_display_poke = DISPLAY_NONE;
int c_other_display_poke = DISPLAY_NONE;

int c_my_display_poke_tmp_new = DISPLAY_NONE;
int c_other_display_poke_tmp_new = DISPLAY_NONE;

JSONObject json_my_display_poke_tmp_new = null;
JSONObject json_other_display_poke_tmp_new = null;

boolean chatting=false;
String chat_msg="";

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
HashMap<String, PImage> ENTRY_HAZARD_IMG = new HashMap<String, PImage>();

String [] str_entry_hazards = {"spikes", "toxic-spikes", "stealth-rock", "sticky-web"};

boolean getImages = true;

PImage[] clientPokemonImg = new PImage[6];
PImage[] otherPokemonImg = new PImage[6];

PImage battleScreenBackground;

PImage clientTrainer;
PImage otherTrainer;

String filename;
String tempPokeName;

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

  for (int i=0; i<str_entry_hazards.length; i++) {
    PImage new_img = loadImage(str_entry_hazards[i]+".png");
    new_img.resize(50, 0);
    ENTRY_HAZARD_IMG.put(str_entry_hazards[i], new_img);
  }



  filename = "https://play.pokemonshowdown.com/sprites/trainers-ordered/" + nf(int(random(1, 295)), 3) + ".png";
  if (filename.indexOf(":/") > 0) {
    filename = filename.trim().toLowerCase();
    try {
      URL url = new URL(filename);
      HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
      httpcon.addRequestProperty("User-Agent", "Mozilla/4.0");
      ReadableByteChannel rbc = Channels.newChannel(httpcon.getInputStream());
      FileOutputStream fos = new FileOutputStream(dataPath("")+"/tmp"+"7"+".png");
      fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
    } 
    catch (IOException e) {
      // System.out.println("help");
    }
    clientTrainer = loadImage(dataPath("")+"/tmp"+"7"+".png");
    clientTrainer.resize(int(clientTrainer.width * 1.5), int(clientTrainer.height * 1.5));
    new File(dataPath("")+"/tmp"+"7"+".png").delete();
  }

  filename = "https://play.pokemonshowdown.com/sprites/trainers-ordered/" + nf(int(random(1, 295)), 3) + ".png";
  if (filename.indexOf(":/") > 0) {
    filename = filename.trim().toLowerCase();
    try {
      URL url = new URL(filename);
      HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
      httpcon.addRequestProperty("User-Agent", "Mozilla/4.0");
      ReadableByteChannel rbc = Channels.newChannel(httpcon.getInputStream());
      FileOutputStream fos = new FileOutputStream(dataPath("")+"/tmp"+"7"+".png");
      fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
    } 
    catch (IOException e) {
      // System.out.println("help");
    }
    otherTrainer = loadImage(dataPath("")+"/tmp"+"7"+".png");
    otherTrainer.resize(int(otherTrainer.width * 1.5), int(otherTrainer.height * 1.5));
    new File(dataPath("")+"/tmp"+"7"+".png").delete();
  }

  battleScreenBackground = loadImage("battlescreen.png");
  battleScreenBackground.resize(TEXT_CHAT_DIVIDE, height*13/18);
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
    //drawPokemon(poke.animationBack, 0, 0);
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
    //drawPokemon(poke.animation, 0, 0);
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

  // protect

  draw_rectMode(CENTER);
  if (poke.protect) {
    stroke(225, 100, 255, 150);
    fill(225, 100, 255, 100);
    draw_rect(0, 0, 150, 100);
  }

  // hazards

  draw_imageMode(CENTER);
  tint(255, 150);
  pushMatrix();
  if (me_or_other==ME) {
    translate(-(l_me_hazards.size()-1)*20, 70);
    for (int i=0; i<l_me_hazards.size(); i++) {
      draw_image(ENTRY_HAZARD_IMG.get(l_me_hazards.get(i)), 0, 0);
      translate(40, -(((i%2)*2)-1)*20);
    }
  } else {
    translate(-(l_other_hazards.size()-1)*20, 70);
    for (int i=0; i<l_other_hazards.size(); i++) {
      draw_image(ENTRY_HAZARD_IMG.get(l_other_hazards.get(i)), 0, 0);
      translate(40, -(((i%2)*2)-1)*20);
    }
  }
  popMatrix();
  noTint();

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
  if (getImages == true && c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < 6; i++) {
      tempPokeName = pokemons.get(i).name;
      if (tempPokeName.indexOf("-") > 0) {
        if (tempPokeName.substring(tempPokeName.indexOf("-") + 1, tempPokeName.indexOf("-") + 2) != "f."
          && tempPokeName.substring(tempPokeName.indexOf("-") + 1, tempPokeName.indexOf("-") + 2) != "m.") {
          tempPokeName = tempPokeName.replace("-", "");
        }
      }
      if (pokemons.get(i).shiny == true) {
        filename = "https://play.pokemonshowdown.com/sprites/bw-shiny/" + tempPokeName + ".png";
      } else {
        filename = "https://play.pokemonshowdown.com/sprites/bw/" + tempPokeName + ".png";
      }
      if (filename.indexOf(":/") > 0) {

        filename = filename.trim().toLowerCase();
        try {
          URL url = new URL(filename);
          HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
          httpcon.addRequestProperty("User-Agent", "Mozilla/4.0");
          ReadableByteChannel rbc = Channels.newChannel(httpcon.getInputStream());
          FileOutputStream fos = new FileOutputStream(dataPath("")+"/tmp"+"7"+".png");
          fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
        } 
        catch (IOException e) {
          // System.out.println("help");
        }
        clientPokemonImg[i] = loadImage(dataPath("")+"/tmp"+"7"+".png");
        clientPokemonImg[i].resize(50, 50);
        new File(dataPath("")+"/tmp"+"7"+".png").delete();
      }
      tempPokeName = other_pokemons.get(i).name;
      if (tempPokeName.indexOf("-") > 0) {
        if (tempPokeName.substring(tempPokeName.indexOf("-") + 1, tempPokeName.indexOf("-") + 2) != "f."
          && tempPokeName.substring(tempPokeName.indexOf("-") + 1, tempPokeName.indexOf("-") + 2) != "m.") {
          tempPokeName = tempPokeName.replace("-", "");
        }
      }
      if (other_pokemons.get(i).shiny == true) {
        filename = "https://play.pokemonshowdown.com/sprites/bw-shiny/" + tempPokeName + ".png";
      } else {
        filename = "https://play.pokemonshowdown.com/sprites/bw/" + tempPokeName + ".png";
      }
      if (filename.indexOf(":/") > 0) {

        filename = filename.trim().toLowerCase();
        try {
          URL url = new URL(filename);
          HttpURLConnection httpcon = (HttpURLConnection) url.openConnection();
          httpcon.addRequestProperty("User-Agent", "Mozilla/4.0");
          ReadableByteChannel rbc = Channels.newChannel(httpcon.getInputStream());
          FileOutputStream fos = new FileOutputStream(dataPath("")+"/tmp"+"7"+".png");
          fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
        } 
        catch (IOException e) {
          // System.out.println("help");
        }
        otherPokemonImg[i] = loadImage(dataPath("")+"/tmp"+"7"+".png");
        otherPokemonImg[i].resize(50, 50);
        new File(dataPath("")+"/tmp"+"7"+".png").delete();
      }
    }
    getImages = false;
  }

  background(0);
  imageMode(CORNER);
  draw_image(backgroundImg, 0, 0);
  draw_image(battleScreenBackground, 0, 0);
  fill(0, 0, 255, 100);
  noStroke();
  draw_triangle(0, 0, 250, 0, 0, 400);
  draw_triangle(TEXT_CHAT_DIVIDE, 650, TEXT_CHAT_DIVIDE - 250, 650, TEXT_CHAT_DIVIDE, 250);
  stroke(0);
  //draw_rect(0, 0, 150, height*13/18);
  //draw_rect(TEXT_CHAT_DIVIDE-150, 0, 150, height*13/18);
  draw_image(clientTrainer, 75 - clientTrainer.width/2, 80 + 30);
  draw_image(otherTrainer, 925 - otherTrainer.width/2, 570 - 30 - otherTrainer.height);
  imageMode(CENTER);
  fill(200);
  noStroke();
  draw_rectMode(CORNER);
  //draw_rect(0, 0, TEXT_CHAT_DIVIDE, height*13/18);
  fill(0, 0, 0, 150);
  draw_rect(0, height*13/18, TEXT_CHAT_DIVIDE, height - height*13/18);

  draw_rectMode(CENTER);
  draw_imageMode(CENTER);
  if (c_display_state == DISPLAY_TEAMS) {
    textAlign(CORNER, CENTER);
    fill(100);
    draw_text("How will you start the battle?", 20, height*13/18 + 10);
    fill(#3973ED);
    draw_text("Choose Lead", 20, height*13/18 + 30);
    textAlign(CENTER);
  }

  if (c_display_state == DISPLAY_TEAMS || c_display_state == DISPLAY_POKES) {
    for (int i = 0; i < 6; i++) {
      if (pokemons.get(i).cur_hp <= 0) {
        tint(255, 0, 100);
      }
      if (i > 2) {
        draw_image(clientPokemonImg[i], 25 + (i-3)*50, 80);
      } else {
        draw_image(clientPokemonImg[i], 25 + i*50, 30);
      }
      noTint();


      if (other_pokemons.get(i).cur_hp <= 0) {
        tint(255, 0, 100);
      }
      if (i > 2) {
        draw_image(otherPokemonImg[i], TEXT_CHAT_DIVIDE - 125 + (i-3)*50, 620);
      } else {
        draw_image(otherPokemonImg[i], TEXT_CHAT_DIVIDE - 125 + i*50, 570);
      }
      noTint();
    }
  }

  if (c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < pokemons.size(); i++) {
      drawPokemon(pokemons.get(i).animationBack, 100 + i*80, 370 + i*30);
    }
    for (int i = 0; i < other_pokemons.size(); i++) {
      drawPokemon(other_pokemons.get(i).animation, TEXT_CHAT_DIVIDE - 80 - i*80, 280 - i*30);
    }
  }

  if (i_switching>0 && i_switching_direction == ME) { // switching anime
    i_switching--;
    if (i_switching==i_total_switching/2) {
      c_my_display_poke = c_my_display_poke_tmp_new;
    }
  }
  if (i_switching>0 && i_switching_direction == OTHER) { // switching anime
    i_switching--;
    if (i_switching==i_total_switching/2) {
      c_other_display_poke = c_other_display_poke_tmp_new;
    }
  }

  // ME poke
  pushMatrix();
  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size()) {
    translate(POKE_ME_RECT.i_x, POKE_ME_RECT.i_y);
    pushMatrix();

    if (i_switching>0 && i_switching_direction == ME) {
      if (i_switching>i_total_switching/2) {
        translate(interpolate(0, -300, (i_total_switching-i_switching), i_total_switching/2), 0);
      } else {
        translate(interpolate(-300, 0, (i_total_switching-i_switching)-i_total_switching/2, i_total_switching/2), 0);
      }
    }

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
    //tint(frameCount%255,255,255);
    drawPokemon(pokemons.get(c_my_display_poke).animationBack, 0, 0);
    noTint();

    popMatrix();

    draw_battling_poke(pokemons.get(c_my_display_poke), ME);
  }
  popMatrix();

  // OTHER poke
  pushMatrix();
  if (c_display_state==DISPLAY_POKES && c_other_display_poke<other_pokemons.size()) {
    translate(POKE_OTHER_RECT.i_x, POKE_OTHER_RECT.i_y);
    pushMatrix();

    if (i_switching>0 && i_switching_direction == OTHER) {
      if (i_switching>i_total_switching/2) {
        translate(interpolate(0, 300, (i_total_switching-i_switching), i_total_switching/2), 0);
      } else {
        translate(interpolate(300, 0, (i_total_switching-i_switching)-i_total_switching/2, i_total_switching/2), 0);
      }
    }

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
    //tint(frameCount%255,255,255);
    drawPokemon(other_pokemons.get(c_other_display_poke).animation, 0, 0);
    noTint();

    popMatrix();

    draw_battling_poke(other_pokemons.get(c_other_display_poke), OTHER);
  }
  popMatrix();

  draw_rectMode(CENTER);

  if (i_moving>0) {
    i_moving--;

    /*if(i_moving == 0) {
     add_effect_text_effect("WOW", width/2, height/2, TYPE_COLOURS.get(str_cur_move_type));
     }*/

    int tmp_move = i_moving;

    pushMatrix();

    if (i_moving_direction==-1) {
      tmp_move = i_total_moving-i_moving;
      //rotate(180);
    }

    translate_interpolation(POKE_ME_RECT, POKE_OTHER_RECT, tmp_move, i_total_moving);

    //rotate((frameCount*20.0)%360);

    rotate(atan2(POKE_OTHER_RECT.i_y-POKE_ME_RECT.i_y, POKE_OTHER_RECT.i_x-POKE_ME_RECT.i_x));
    scale(1, -1*i_moving_direction);
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

      //draw_rect(0, 0, 50, 50);

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
    } else if (str_cur_move_anime_style.equals("spikes") || str_cur_move_anime_style.equals("stealth-rock")
      || str_cur_move_anime_style.equals("toxic-spikes") || str_cur_move_anime_style.equals("sticky-web")) { // --------------------------------------------------------- entry hazards

      draw_image(ENTRY_HAZARD_IMG.get(str_cur_move_anime_style), 0, 0);
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
  draw_rectMode(CORNER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size() && (i_selection_stage == SELECT_MOVE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    for (int i=0; i<json_avail_moves_array.size(); i++) {
      stroke(50);
      fill(TYPE_COLOURS.get(json_avail_moves_array.getJSONObject(i).getString("type")));
      draw_rect(4 + 250*i, 694, 242, 72, 10);
      fill(255);
      draw_text(json_avail_moves_array.getJSONObject(i).getString("name"), 4 + 250*i + 121, 730);
      if (mouseX >= 4 + 250*i && mouseX <= 4 + 250*i + 242 && mouseY >= 694 && mouseY <= 694 + 72) {
        drawPokeMove(i, json_avail_moves_array.getJSONObject(i), 694);
      }
    }
  }

  // team pokes
  if (c_display_state == DISPLAY_TEAMS) {
    for (int i=0; i<6; i++) {
      stroke(50);
      fill(255);
      draw_rect(4 + i*167, height*13/18 + 50, 159, 52, 10);
      draw_image(clientPokemonImg[i], 4 + i*167 + 159/2 - 55, height*13/18 + 76);
      //height*13/18 + 10      660     26
      fill(0);
      draw_text(pokemons.get(i).name, 4 + i*167 + 159/2, height*13/18 + 76);
      if (mouseX >= 4 + i*167 && mouseX <= 4 + i*167 + 159 && mouseY >= height*13/18 + 50 && mouseY <= height*13/18 + 102) {
        drawPokeInfo(i, height*13/18 + 50);
        //textAlign(LEFT, CENTER);
        //pushMatrix();
        //if (i == 0) {
        //  translate(85, 0);
        //} else if (i == 5) {
        //  translate(-85, 0);
        //}
        //fill(0, 0, 255, 200);
        //draw_rect(4 + i*167 + 159/2 - 160, height*13/18 + 50 - 190, 320, 180, 10);
        //fill(0);
        //draw_text(pokemons.get(i).name, 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 180);
        //draw_line(4 + i*167 + 159/2 - 160, height*13/18 + 50 - 150, 4 + i*167 + 159/2 + 160, height*13/18 + 50 - 150);
        //draw_text("HP: " + (pokemons.get(i).cur_hp*100/pokemons.get(i).HP) + "% (" + pokemons.get(i).cur_hp + "/" + pokemons.get(i).HP + ")", 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 140);
        //draw_text("Ability: " + pokemons.get(i).ability, 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 120);
        //draw_text(pokemons.get(i).ATK + " Atk / " + pokemons.get(i).DEF + " Def / " + pokemons.get(i).SPA + " SpA / "
        //  + pokemons.get(i).SPD + " SpD / " + pokemons.get(i).SPE + " Spe", 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 100);
        //draw_line(4 + i*167 + 159/2 - 160, height*13/18 + 50 - 90, 4 + i*167 + 159/2 + 160, height*13/18 + 50 - 90);
        //draw_text("- " + pokemons.get(i).moves[0], 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 80);
        //draw_text("- " + pokemons.get(i).moves[1], 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 62);
        //draw_text("- " + pokemons.get(i).moves[2], 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 44);
        //draw_text("- " + pokemons.get(i).moves[3], 4 + i*167 + 159/2 - 155, height*13/18 + 50 - 26);

        //textAlign(CENTER);
        //fill(255);
        //draw_image(type_image.get(names_types.get(pokemons.get(i).name)[0]), 4 + i*167 + 159/2 - 155 + 25, height*13/18 + 50 - 162);
        //draw_text(names_types.get(pokemons.get(i).name)[0], 4 + i*167 + 159/2 - 155 + 25, height*13/18 + 50 - 162 + height/200);
        //if (names_types.get(pokemons.get(i).name)[1] != null) {
        //  draw_image(type_image.get(names_types.get(pokemons.get(i).name)[1]), 4 + i*167 + 159/2 - 155 + 30 + width*9/224, height*13/18 + 50 - 162);
        //  draw_text(names_types.get(pokemons.get(i).name)[1], 4 + i*167 + 159/2 - 155 + 30 + width*9/224, height*13/18 + 50 - 162 + height/200);
        //}

        //popMatrix();
        //textAlign(CENTER, CENTER);
      }
    }
  } else if ((i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    for (int i=0; i<json_avail_pokes_array.size(); i++) {
      stroke(50);
      fill(255);
      draw_rect(4 + json_avail_pokes_array.getInt(i)*167, 794, 159, 52, 10);
      draw_image(clientPokemonImg[json_avail_pokes_array.getInt(i)], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 55, 820);
      fill(0);
      draw_text(pokemons.get(json_avail_pokes_array.getInt(i)).name, 4 + json_avail_pokes_array.getInt(i)*167 + 159/2, 820);
      if (mouseX >= 4 + json_avail_pokes_array.getInt(i)*167 && mouseX <= 4 + json_avail_pokes_array.getInt(i)*167 + 159 && mouseY >= 794 && mouseY <= 794 + 52) {
        drawPokeInfo(json_avail_pokes_array.getInt(i), 794);
        //textAlign(LEFT, CENTER);
        //pushMatrix();
        //if (json_avail_pokes_array.getInt(i) == 0) {
        //  translate(85, 0);
        //} else if (json_avail_pokes_array.getInt(i) == 5) {
        //  translate(-85, 0);
        //}
        //fill(0, 0, 255, 200);
        //draw_rect(4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 160, 794 - 190, 320, 180, 10);
        //fill(0);
        //draw_text(pokemons.get(json_avail_pokes_array.getInt(i)).name, 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 180);
        //draw_line(4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 160, 794 - 150, 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 + 160, 794 - 150);
        //draw_text("HP: " + (pokemons.get(json_avail_pokes_array.getInt(i)).cur_hp*100/pokemons.get(json_avail_pokes_array.getInt(i)).HP) + "% (" + 
        //  pokemons.get(json_avail_pokes_array.getInt(i)).cur_hp + "/" + pokemons.get(json_avail_pokes_array.getInt(i)).HP + ")", 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 
        //  794 - 140);
        //draw_text("Ability: " + pokemons.get(json_avail_pokes_array.getInt(i)).ability, 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 120);
        //draw_text(pokemons.get(json_avail_pokes_array.getInt(i)).ATK + " Atk / " + pokemons.get(json_avail_pokes_array.getInt(i)).DEF + " Def / " + 
        //  pokemons.get(json_avail_pokes_array.getInt(i)).SPA + " SpA / " + pokemons.get(json_avail_pokes_array.getInt(i)).SPD + " SpD / " + pokemons.get(json_avail_pokes_array.getInt(i)).SPE + 
        //  " Spe", 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 100);
        //draw_line(4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 160, 794 - 90, 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 + 160, 794 - 90);
        //draw_text("- " + pokemons.get(json_avail_pokes_array.getInt(i)).moves[0], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 80);
        //draw_text("- " + pokemons.get(json_avail_pokes_array.getInt(i)).moves[1], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 62);
        //draw_text("- " + pokemons.get(json_avail_pokes_array.getInt(i)).moves[2], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 44);
        //draw_text("- " + pokemons.get(json_avail_pokes_array.getInt(i)).moves[3], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155, 794 - 26);

        //textAlign(CENTER);
        //fill(255);
        //draw_image(type_image.get(names_types.get(pokemons.get(json_avail_pokes_array.getInt(i)).name)[0]), 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155 + 25, 794 - 162);
        //draw_text(names_types.get(pokemons.get(json_avail_pokes_array.getInt(i)).name)[0], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155 + 25, 794 - 162 + height/200);
        //if (names_types.get(pokemons.get(json_avail_pokes_array.getInt(i)).name)[1] != null) {
        //  draw_image(type_image.get(names_types.get(pokemons.get(json_avail_pokes_array.getInt(i)).name)[1]), 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155 + 30 + width*9/224, 794 - 162);
        //  draw_text(names_types.get(pokemons.get(json_avail_pokes_array.getInt(i)).name)[1], 4 + json_avail_pokes_array.getInt(i)*167 + 159/2 - 155 + 30 + width*9/224, 794 - 162 + height/200);
        //}

        //popMatrix();
        //textAlign(CENTER, CENTER);
      }
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

  if (mousePressed && mousePressValid == true) {
    if (c_display_state == DISPLAY_TEAMS) {
      for (int i = 0; i < 6; i++) {
        if (mouseX <= 4 + i*167 + 159 && mouseX >= 4 + i*167 && mouseY <= height*13/18 + 50 + 52 && mouseY >= height*13/18 + 50) {
          select_poke(i);
          i_selection_stage = 77;
          mousePressValid = false;
        }
      }
    } else if (i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE) {
      for (int i = 0; i < json_avail_pokes_array.size(); i++) {
        if (mouseX <= 4 + json_avail_pokes_array.getInt(i)*167 + 159 && mouseX >= 4 + json_avail_pokes_array.getInt(i)*167 && mouseY <= 794 + 52 && mouseY >= 794) {
          select_poke(json_avail_pokes_array.getInt(i));
          i_selection_stage = 77;
          mousePressValid = false;
        }
      }
      if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size()) {
        for (int i = 0; i < json_avail_moves_array.size(); i++) {
          if (mouseX <= 4 + 250*i + 242 && mouseX >= 4 + 250*i && mouseY <= 694 + 72 && mouseY >= 694) {
            select_move(i);
            i_selection_stage = 77;
            mousePressValid = false;
          }
        }
      }
    }
    if (mouseX>=TEXT_CHAT_DIVIDE&&mouseX<=text_chat.size()) {
      if (mouseY<=height - 30 && mouseY>=height - 30-60) {
        chatting=true;
      }
      else{
        chatting=false;}
    }else{chatting=false;}
  }
}

void drawPokeMove(int val, JSONObject move, int y) {
  int lineCount = 0;
  int subIndex = 0;
  String description = moves_data.get(move.getString("name"))[6];
  String[] descList = split(description, ' ');
  String tempString = "";
  int tempStringIndex = 0;

  if (subIndex < 0){
    subIndex = 0;
  }

  while (textWidth(description.substring(subIndex)) > 320) {
    while (textWidth(tempString) < 320) {
      tempString += descList[tempStringIndex] + " ";
      subIndex += descList[tempStringIndex].length() + 1;
      tempStringIndex++;
    }
    tempString = "";
    lineCount += 1;
    descList = splice(descList, "\n", tempStringIndex-1);
  }
  description = "";
  for (int i = 0; i < descList.length; i++) {
    description += descList[i];
    if (descList[i] != "\n") {
      description += " ";
    }
  }

  if (description.length() > 0) {
    lineCount++;
  }

  textAlign(LEFT, CENTER);
  pushMatrix();
  if (val == 0) {
    translate(85, 0);
  } else if (val == 3) {
    translate(-85, 0);
  }

  y = y - 88 - lineCount*30;

  fill(0, 0, 255, 200);
  if (lineCount == 0) {
    draw_rect(4 + val*167 + 159/2 - 160, y, 320, 78, 10);
  } else {
    draw_rect(4 + val*167 + 159/2 - 160, y, 320, 82 + lineCount*30, 10);
  }
  fill(0);
  draw_text(move.getString("name"), 4 + val*167 + 159/2 - 155, y + 10);
  draw_line(4 + val*167 + 159/2 - 160, y + 44, 4 + val*167 + 159/2 + 160, y + 44);
  draw_text("Base power: " + moves_data.get(move.getString("name"))[2], 4 + val*167 + 159/2 - 155, y + 54);
  draw_text("Accuracy: " + moves_data.get(move.getString("name"))[3], 4 + val*167 + 159/2 - 155, y + 74);

  if (lineCount > 0) {
    draw_line(4 + val*167 + 159/2 - 160, y + 88, 4 + val*167 + 159/2 + 160, y + 88);
  }

  textAlign(LEFT, TOP);
  draw_text(description, 4 + val*167 + 159/2 - 155, y + 92);

  textAlign(CENTER);
  fill(255);
  draw_image(type_image.get(moves_data.get(move.getString("name"))[0]), 4 + val*167 + 159/2 - 155 + 25, y + 32);
  draw_text(moves_data.get(move.getString("name"))[0], 4 + val*167 + 159/2 - 155 + 25, y + 32 + height/200);

  popMatrix();
  textAlign(CENTER, CENTER);
}

void drawPokeInfo(int val, int y) {
  textAlign(LEFT, CENTER);
  pushMatrix();

  if (val == 0) {
    translate(85, 0);
  } else if (val == 5) {
    translate(-85, 0);
  }
  fill(0, 0, 255, 200);
  draw_rect(4 + val*167 + 159/2 - 160, y - 190, 320, 180, 10);
  fill(0);
  draw_text(pokemons.get(val).name, 4 + val*167 + 159/2 - 155, y - 180);
  draw_line(4 + val*167 + 159/2 - 160, y - 150, 4 + val*167 + 159/2 + 160, y - 150);
  draw_text("HP: " + (pokemons.get(val).cur_hp*100/pokemons.get(val).HP) + "% (" + 
    pokemons.get(val).cur_hp + "/" + pokemons.get(val).HP + ")", 4 + val*167 + 159/2 - 155, 
    y - 140);
  draw_text("Ability: " + pokemons.get(val).ability, 4 + val*167 + 159/2 - 155, y - 120);
  draw_text(pokemons.get(val).ATK + " Atk / " + pokemons.get(val).DEF + " Def / " + 
    pokemons.get(val).SPA + " SpA / " + pokemons.get(val).SPD + " SpD / " + pokemons.get(val).SPE + 
    " Spe", 4 + val*167 + 159/2 - 155, y - 100);
  draw_line(4 + val*167 + 159/2 - 160, y - 90, 4 + val*167 + 159/2 + 160, y - 90);
  draw_text("- " + pokemons.get(val).moves[0], 4 + val*167 + 159/2 - 155, y - 80);
  draw_text("- " + pokemons.get(val).moves[1], 4 + val*167 + 159/2 - 155, y - 62);
  draw_text("- " + pokemons.get(val).moves[2], 4 + val*167 + 159/2 - 155, y - 44);
  draw_text("- " + pokemons.get(val).moves[3], 4 + val*167 + 159/2 - 155, y - 26);

  textAlign(CENTER);
  fill(255);
  draw_image(type_image.get(names_types.get(pokemons.get(val).name)[0]), 4 + val*167 + 159/2 - 155 + 25, y - 162);
  draw_text(names_types.get(pokemons.get(val).name)[0], 4 + val*167 + 159/2 - 155 + 25, y - 162 + height/200);
  if (names_types.get(pokemons.get(val).name)[1] != null) {
    draw_image(type_image.get(names_types.get(pokemons.get(val).name)[1]), 4 + val*167 + 159/2 - 155 + 30 + width*9/224, y - 162);
    draw_text(names_types.get(pokemons.get(val).name)[1], 4 + val*167 + 159/2 - 155 + 30 + width*9/224, y - 162 + height/200);
  }

  popMatrix();
  textAlign(CENTER, CENTER);
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