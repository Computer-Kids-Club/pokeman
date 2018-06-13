
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
HashMap<String, PImage> weather_image = new HashMap<String, PImage>();

String[] weatherNames = {"clear", "harsh", "rain", "sandstorm", "hail"};
String[] weatherPictureNames = {"battlescreen", "sun", "rain", "darude", "hail"};

String [] str_entry_hazards = {"spikes", "toxic-spikes", "stealth-rock", "sticky-web"};

boolean getImages = true;

boolean cleared = true;

PImage[] clientPokemonImg = new PImage[6];
PImage[] otherPokemonImg = new PImage[6];

PImage battleScreenBackground;

PImage clientTrainer;
PImage otherTrainer;

String filename;
String tempPokeName;

ArrayList<ArrayList<Integer>> turnSignals = new ArrayList<ArrayList<Integer>>();
int turn = 0;

void init_battle_screen() {
  chatting = true;
  img_flag_bite = loadImage("MoveAnimations/bite.png");
  img_flag_ballistics = loadImage("MoveAnimations/bullistics.png");
  img_flag_dance = loadImage("MoveAnimations/dance.png");
  img_flag_powder = loadImage("MoveAnimations/powder.png");
  img_flag_pulse = loadImage("MoveAnimations/pulse.png");
  img_flag_punch = loadImage("MoveAnimations/punch.png");
  img_flag_sound = loadImage("MoveAnimations/sound.png");

  //img_flag_bite.resize(150, 0);
  //img_flag_ballistics.resize(150, 0);
  //img_flag_dance.resize(150, 0);
  //img_flag_powder.resize(150, 0);
  //img_flag_pulse.resize(150, 0);
  //img_flag_punch.resize(150, 0);
  //img_flag_sound.resize(150, 0);

  for (int i = 0; i < 5; i++) {
    tempImage = loadImage(weatherPictureNames[i] + ".png");
    tempImage.resize(TEXT_CHAT_DIVIDE, height*13/18);
    weather_image.put(weatherNames[i], tempImage);
  }

  for (String str_type : TYPE_COLOURS.keySet()) {
    // ...
    PImage new_img = loadImage("MoveAnimations/"+str_type+".png");
    //new_img.resize(150, 0);
    TYPE_MOVE_IMG.put(str_type, new_img);
  }

  for (int i=0; i<str_entry_hazards.length; i++) {
    PImage new_img = loadImage(str_entry_hazards[i]+".png");
    new_img.resize(50, 0);
    ENTRY_HAZARD_IMG.put(str_entry_hazards[i], new_img);
  }

  for (int i = 0; i < pokemons.size(); i++) {
    pokemons.get(i).cur_hp = pokemons.get(i).HP;
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
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-(height*7/90), HEALTH_BAR_WIDTH, height*7/900);
  fill(50, 150, 200);
  noStroke();
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-(height*7/90), round(HEALTH_BAR_WIDTH*op), height*7/900);
  fill(interpolate(0, 100, int(p*1000), 1000), 255, 255);
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-(height*7/90), round(HEALTH_BAR_WIDTH*p), height*7/900); // round(pokemons.get(c_my_display_poke).cur_hp)/pokemons.get(c_my_display_poke).HP, 7);
  stroke(0);
  noFill();
  draw_rect(x-HEALTH_BAR_WIDTH/2, y-(height*7/90), HEALTH_BAR_WIDTH, height*7/900);

  textAlign(CENTER, CENTER);
  fill(0);
  draw_text(round(100*p)+"%", x-HEALTH_BAR_WIDTH/2-width/70, y-(height*133/1800));
}

void draw_mini_health_bar(int x, int y, int w, int h, int health) {
  draw_rectMode(CORNER);
  fill(150);
  draw_rect(x, y, w, h);
  noStroke();
  fill(interpolate(0, 100, int(health*10), 1000), 255, 255);
  draw_rect(x, y, round(w*health/100), h);
  stroke(0);
  noFill();
  draw_rect(x, y, w, h);
  fill(0);
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
    draw_rect(0, 0, width*3/28, height/9);
  }

  // hazards

  draw_imageMode(CENTER);
  tint(255, 150);
  pushMatrix();
  if (me_or_other==ME) {
    translate(-(l_me_hazards.size()-1)*(width/70), height*7/90);
    for (int i=0; i<l_me_hazards.size(); i++) {
      draw_image(ENTRY_HAZARD_IMG.get(l_me_hazards.get(i)), 0, 0);
      translate(width/35, -(((i%2)*2)-1)*(width/70));
    }
  } else {
    translate(-(l_other_hazards.size()-1)*(width/70), width*7/90);
    for (int i=0; i<l_other_hazards.size(); i++) {
      draw_image(ENTRY_HAZARD_IMG.get(l_other_hazards.get(i)), 0, 0);
      translate(width/35, -(((i%2)*2)-1)*(width/70));
    }
  }
  popMatrix();
  noTint();

  textAlign(LEFT);
  fill(0);

  pushMatrix();
  translate(-HEALTH_BAR_WIDTH/2, 0);
  for (int i=0; i<poke.text_status_effects.size(); i++) {
    draw_text(poke.text_status_effects.get(i), 0, -(height/18));
    translate(textWidth(poke.text_status_effects.get(i))+(width/280), 0);
  }
  popMatrix();

  textAlign(CENTER, CENTER);
  draw_text(poke.name, 0, -(height*4/45));
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
        clientPokemonImg[i].resize(width/28, height/18);
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
        otherPokemonImg[i].resize(width/28, height/18);
        new File(dataPath("")+"/tmp"+"7"+".png").delete();
      }
    }
    getImages = false;
  }

  background(0);
  imageMode(CORNER);
  draw_image(backgroundImg, 0, 0);
  draw_image(weather_image.get(weatherNames[i_weather]), 0, 0);
  //println(weatherNames[i_weather], i_weather);
  fill(0, 0, 255, 100);
  noStroke();
  draw_triangle(0, 0, width*3/14, 0, 0, height*4/9);
  draw_triangle(TEXT_CHAT_DIVIDE, height*13/18, TEXT_CHAT_DIVIDE - width*3/14, height*13/18, TEXT_CHAT_DIVIDE, height*5/18);
  stroke(0);
  //draw_rect(0, 0, 150, height*13/18);
  //draw_rect(TEXT_CHAT_DIVIDE-150, 0, 150, height*13/18);
  draw_image(clientTrainer, width*3/56 - clientTrainer.width/2, height*11/90);
  draw_image(otherTrainer, width*37/56 - otherTrainer.width/2, height*3/5 - otherTrainer.height);
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
    draw_text("How will you start the battle?", width/70, height*11/15);
    fill(#3973ED);
    draw_text("Choose Lead", width/70, height*34/45);
    textAlign(CENTER);
  }

  if (c_display_state == DISPLAY_TEAMS || c_display_state == DISPLAY_POKES) {
    for (int i = 0; i < 6; i++) {
      if (pokemons.get(i).cur_hp <= 0) {
        tint(255, 0, 100);
      }
      if (i > 2) {
        draw_image(clientPokemonImg[i], width/56 + (i-3)*(width/28), height*4/45);
      } else {
        draw_image(clientPokemonImg[i], width/56 + i*(width/28), height/30);
      }
      noTint();


      if (other_pokemons.get(i).cur_hp <= 0) {
        tint(255, 0, 100);
      }
      if (i > 2) {
        draw_image(otherPokemonImg[i], TEXT_CHAT_DIVIDE - width*5/56 + (i-3)*(width/28), height*31/45);
      } else {
        draw_image(otherPokemonImg[i], TEXT_CHAT_DIVIDE - width*5/56 + i*(width/28), height*19/30);
      }
      noTint();
    }
  }

  if (c_display_state==DISPLAY_TEAMS) {
    for (int i = 0; i < pokemons.size(); i++) {
      drawPokemon(pokemons.get(i).animationBack, width/14 + i*(width*2/35), height*37/90 + i*(height/30));
    }
    for (int i = 0; i < other_pokemons.size(); i++) {
      drawPokemon(other_pokemons.get(i).animation, TEXT_CHAT_DIVIDE - width*2/35 - i*(width*2/35), height*14/45 - i*(height/30));
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

    //translate_interpolation(POKE_ME_RECT, POKE_OTHER_RECT, 0*tmp_move, i_total_moving);

    //rotate((frameCount*20.0)%360);
    translate(TEXT_CHAT_DIVIDE/2, height*13/36);
    //rotate(atan2(POKE_OTHER_RECT.i_y-POKE_ME_RECT.i_y, POKE_OTHER_RECT.i_x-POKE_ME_RECT.i_x));
    if (i_moving_direction==1) {
      translate(0, height*2/30);
      scale(-1, -1);
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

      println(str_cur_move_type);
      if (str_cur_move_type.equals("normal") || str_cur_move_type.equals("fire") || str_cur_move_type.equals("electric")
        || str_cur_move_type.equals("dragon") || str_cur_move_type.equals("ground") || str_cur_move_type.equals("flying")
        || str_cur_move_type.equals("ghost") || str_cur_move_type.equals("water") || str_cur_move_type.equals("fighting")
        || str_cur_move_type.equals("grass") || str_cur_move_type.equals("ice") || str_cur_move_type.equals("psychic")
        || str_cur_move_type.equals("rock") || str_cur_move_type.equals("steel")) {
        draw_image(move_animations.get(str_cur_move_type)[(30-i_moving)*move_animations_num.get(str_cur_move_type)/31], 0, 0);
      } else {
        draw_image(TYPE_MOVE_IMG.get(str_cur_move_type), 0, 0);
      }
      //} else if (str_cur_move_anime_style.equals("flag_bite")) { // --------------------------------------------------------- bite

      //  draw_image(img_flag_bite, 0, 0);
      //} else if (str_cur_move_anime_style.equals("flag_ballistics")) { // --------------------------------------------------------- ballistics

      //  draw_image(img_flag_ballistics, 0, 0);
      //} else if (str_cur_move_anime_style.equals("flag_dance")) { // --------------------------------------------------------- dance

      //  draw_image(img_flag_dance, 0, 0);
      //} else if (str_cur_move_anime_style.equals("flag_powder")) { // --------------------------------------------------------- powder

      //  draw_image(img_flag_powder, 0, 0);
      //} else if (str_cur_move_anime_style.equals("flag_pulse")) { // --------------------------------------------------------- pulse

      //  draw_image(img_flag_pulse, 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_punch")) { // --------------------------------------------------------- punch
      draw_image(move_animations.get("punch")[(30-i_moving)*move_animations_num.get("punch")/31], 0, 0);
    } else if (str_cur_move_anime_style.equals("flag_sound")) { // --------------------------------------------------------- sound
      draw_image(move_animations.get("sound")[(30-i_moving)*move_animations_num.get("sound")/31], 0, 0);
      //draw_image(img_flag_sound, 0, 0);
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
  draw_text(i_cur_animation_frames_left, width/28, height/18);

  // moves
  draw_rectMode(CORNER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size() && (i_selection_stage == SELECT_MOVE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    textAlign(LEFT, CENTER);
    textFont(font_plain_middle);
    fill(#FF2C3A);
    text("Attack", width/140, height*56/75);
    fill(0);
    textFont(font_plain);
    textAlign(CENTER, CENTER);
    for (int i=0; i<json_avail_moves_array.size(); i++) {
      textAlign(CENTER, CENTER);
      stroke(50);
      fill(TYPE_COLOURS.get(json_avail_moves_array.getJSONObject(i).getString("type")));
      draw_rect(width/350 + (width*5/28)*i, height*347/450, width*121/700, height*2/25, height/90);
      fill(255);
      draw_text(json_avail_moves_array.getJSONObject(i).getString("name"), width/350 + (width*5/28)*i + width*121/1400, height*73/90);
      textAlign(RIGHT, BASELINE);
      draw_text(json_avail_moves_array.getJSONObject(i).getInt("pp") + "/" + json_avail_moves_array.getJSONObject(i).getInt("maxpp"), width*6/35 + (width*5/28)*i, height*38/45);
      textAlign(LEFT, BASELINE);
      draw_text(json_avail_moves_array.getJSONObject(i).getString("type"), width/140 + (width*5/28)*i, height*38/45);
      if (mouseX >= width/350 + (width*5/28)*i && mouseX <= width/350 + (width*5/28)*i + width*121/700 && mouseY >= height*347/450 && mouseY <= height*383/450) {
        drawPokeMove(i, json_avail_moves_array.getJSONObject(i), height*347/450);
      }
    }
  }

  // team pokes
  textAlign(CENTER, CENTER);
  if (c_display_state == DISPLAY_TEAMS) {
    for (int i=0; i<6; i++) {
      stroke(50);
      fill(255);
      draw_rect(width/350 + i*(width*167/1400), height*13/18 + height/18, width*159/1400, height*13/225, height/90);
      draw_image(clientPokemonImg[i], width/350 + i*(width*167/1400) + width*7/400, height*121/150);
      fill(0);
      draw_text(pokemons.get(i).name, width/350 + i*(width*167/1400) + width*159/2800, height*13/18 + height*2/25);
      draw_mini_health_bar(width/350 + i*(width*167/1400) + width*191/5600, height*13/18 + height*22/225, width*417/5600, height/150, pokemons.get(i).cur_hp*100/pokemons.get(i).HP);
      if (mouseX >= width/350 + i*(width*167/1400) && mouseX <= width/350 + i*(width*167/1400) + width*159/1400 && mouseY >= height*13/18 + height/18 && mouseY <= height*13/18 + height*17/150) {
        drawPokeInfo(i, height*7/9);
      }
    }
  } else if ((i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
    textAlign(LEFT, CENTER);
    textFont(font_plain_middle);
    fill(#322CFF);
    text("Switch", width/140, height*194/225);
    fill(0);
    textFont(font_plain);
    textAlign(CENTER, CENTER);
    for (int i=0; i<6; i++) {
      cleared = false;
      for (int j = 0; j < json_avail_pokes_array.size(); j++) {
        if (i == json_avail_pokes_array.getInt(j)) {
          cleared = true;
          break;
        }
      }
      if (cleared) {
        stroke(50);
        fill(255);
        draw_rect(width/350 + i*(width*167/1400), height*397/450, width*159/1400, height*13/225, height/90);
        draw_image(clientPokemonImg[i], width/350 + i*(width*167/1400) + width*7/400, height*41/45);
        fill(0);
        draw_text(pokemons.get(i).name, width/350 + i*(width*167/1400) + width*159/2800, height*68/75);
        draw_mini_health_bar(width/350 + i*(width*167/1400) + width*191/5600, height*208/225, width*417/5600, height/150, pokemons.get(i).cur_hp*100/pokemons.get(i).HP);
        if (mouseX >= width/350 + i*(width*167/1400) && mouseX <= width/350 + i*(width*167/1400) + width*159/1400 && mouseY >= height*397/450 && mouseY <= height*47/50) {
          drawPokeInfo(i, height*397/450);
        }
      } else {
        if (i == c_my_display_poke) {
          stroke(50);
          fill(255);
          draw_rect(width/350 + i*(width*167/1400), height*397/450, width*159/1400, height*13/225, height/90);
          draw_image(clientPokemonImg[i], width/350 + i*(width*167/1400) + width*7/400, height*41/45);
          fill(0);
          draw_text(pokemons.get(i).name, width/350 + i*(width*167/1400) + width*159/2800, height*68/75);
          draw_mini_health_bar(width/350 + i*(width*167/1400) + width*191/5600, height*208/225, width*417/5600, height/150, pokemons.get(i).cur_hp*100/pokemons.get(i).HP);
          if (mouseX >= width/350 + i*(width*167/1400) && mouseX <= width/350 + i*(width*167/1400) + width*159/1400 && mouseY >= height*397/450 && mouseY <= height*47/50) {
            drawPokeInfo(i, height*397/450);
          }
        } else {
          stroke(50);
          fill(255);
          draw_rect(width/350 + i*(width*167/1400), height*397/450, width*159/1400, height*13/225, height/90);
          tint(255, 0, 100);
          draw_image(clientPokemonImg[i], width/350 + i*(width*167/1400) + width*7/400, height*41/45);
          noTint();
          fill(150);
          draw_text(pokemons.get(i).name, width/350 + i*(width*167/1400) + width*159/2800, height*68/75);
        }
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
  int turnCounter = turn;
  boolean emptyTrigger = false;
  draw_rectMode(CENTER);
  pushMatrix();
  int text_offset = 0;
  for (int i=0; i<text_chat.size() && height - i*(height/30) > height*2/30; i++) {
    if (text_chat.get(i).equals("") && emptyTrigger == false) {
      fill(150);
      //noFill();
      draw_rect(TEXT_CHAT_DIVIDE + (width - TEXT_CHAT_DIVIDE)/2, height - i*(height/30) - text_offset*(height/30) - height*3/60 - height/30, width - TEXT_CHAT_DIVIDE, height/18);
      fill(0);
      textFont(font_plain_mid);
      draw_text("Turn " + turnCounter, TEXT_CHAT_DIVIDE+(height/90), height - i*(height/30) - text_offset*(height/30) - height*3/60 - height/30);
      turnCounter -= 1;
      emptyTrigger = true;
    } else if (emptyTrigger) {
      emptyTrigger = false;
    } else {
      fill(0);
      textFont(font_plain);
      if (textWidth(text_chat.get(i)) <= width-TEXT_CHAT_DIVIDE) {
        draw_text(text_chat.get(i), TEXT_CHAT_DIVIDE+(height/90), height - i*(height/30) - text_offset*(height/30) - height*2/30);
      } else {
        String printable = "";
        String chatRn = text_chat.get(i);
        ArrayList<String> printable_list = new ArrayList<String>();
        while (chatRn.length()>0) {
          printable = printable + chatRn.charAt(0);
          //println(printable);
          chatRn = chatRn.substring(1);
          if (textWidth(printable) > width-TEXT_CHAT_DIVIDE - 15) {
            printable_list.add(printable);
            //text_offset++;
            printable = "";
          }
        }
        printable_list.add(printable);
        for (int k=0; k<printable_list.size(); k++) {
          if (printable_list.get(printable_list.size()-k-1).length()>0) {
            draw_text(printable_list.get(printable_list.size()-k-1), TEXT_CHAT_DIVIDE+(height/90), height - i*(height/30) - text_offset*(height/30) - height*2/30);
            text_offset++;
          }
        }
        text_offset-=1;
      }
      emptyTrigger = false;
    }
  }
  popMatrix();
  rectMode(CORNER);
  fill(255);
  draw_rect(TEXT_CHAT_DIVIDE, height - height/30, width - TEXT_CHAT_DIVIDE, height/30);     //336.9375 337/1400    364.28125   width*13/50
  fill(200);
  draw_rect(TEXT_CHAT_DIVIDE + width/350, height - height/30 + height/180, width*333/1400, height/45);
  draw_rect(width - width*27/640, height - height/30 + height/180, width*5/128, height/45);
  fill(0);
  textFont(font_plain);
  textAlign(CENTER, CENTER);
  draw_text("Send", width - width*27/640 + width*5/256, height - height/30 + height/180 + height/90);
  textAlign(LEFT, CENTER);
  if (chat_msg == "") {
    draw_text("Send a message", TEXT_CHAT_DIVIDE + width*3/640, height - height/30 + height/180 + height/90);
  } else {
    draw_text(chat_msg, TEXT_CHAT_DIVIDE + width*3/640, height - height/30 + height/180 + height/90);
  }

  //println((width - width*27/640) - (TEXT_CHAT_DIVIDE + width/350) - width/350);
  textFont(font_plain);
  if (mousePressed && mousePressValid == true) {
    if (c_display_state == DISPLAY_TEAMS) {
      for (int i = 0; i < 6; i++) {
        if (mouseX >= width/350 + i*(width*167/1400) && mouseX <= width/350 + i*(width*167/1400) + width*159/1400 && mouseY >= height*13/18 + height/18 && mouseY <= height*13/18 + height*17/150) {
          select_poke(i);
          i_selection_stage = 77;
          mousePressValid = false;
        }
      }
    } else if (i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE) {
      for (int i = 0; i < json_avail_pokes_array.size(); i++) {
        if (mouseX >= width/350 + json_avail_pokes_array.getInt(i)*(width*167/1400) && mouseX <= width/350 + json_avail_pokes_array.getInt(i)*(width*167/1400) + width*159/1400 && mouseY >= height*397/450 && mouseY <= height*47/50) {
          select_poke(json_avail_pokes_array.getInt(i));
          i_selection_stage = 77;
          mousePressValid = false;
        }
      }
      if (c_display_state==DISPLAY_POKES && c_my_display_poke<pokemons.size()) {
        for (int i = 0; i < json_avail_moves_array.size(); i++) {
          if (mouseX >= width/350 + (width*5/28)*i && mouseX <= width/350 + (width*5/28)*i + width*121/700 && mouseY >= height*347/450 && mouseY <= height*383/450) {
            select_move(i);
            i_selection_stage = 77;
            mousePressValid = false;
          }
        }
      }
    }
    if (mouseX >= width - width*27/640 && mouseX <= width - width*27/640 + width*5/128 && mouseY >= height - height/30 + height/180 && mouseY <= height - height/30 + height/180 + height/45) {
      JSONObject json = new JSONObject();
      json.setString("battlestate", "chat");
      json.setString("chat", chat_msg);
      myClient.write(json.toString());
      chat_msg="";
      mousePressValid = false;
    }
  }
}

void drawPokeMove(int val, JSONObject move, int y) {
  int lineCount = 0;
  int subIndex = 0;
  //println(move);
  String description = moves_data.get(move.getString("name"))[6];
  String[] descList = split(description, ' ');
  String tempString = "";
  int tempStringIndex = 0;


  while (textWidth(description.substring(subIndex)) > 310) {
    while (textWidth(tempString) < 310) {
      tempString += descList[tempStringIndex] + " ";
      subIndex += descList[tempStringIndex].length() + 1;
      tempStringIndex++;
    }
    tempString = "";
    lineCount += 1;
    subIndex--;
    descList = splice(descList, "\n", tempStringIndex-1);

    //println(subIndex + " " + description.length() + " ");
    //print(description.substring(subIndex));
  }
  description = "";
  for (int i = 0; i < descList.length; i++) {
    description += descList[i];
    if (descList[i] != "\n") {
      description += " ";
    }
  }

  if (description.length() > 1) {
    lineCount++;
  }


  textAlign(LEFT, CENTER);
  pushMatrix();

  if (val == 0) {
    translate(width*3/100, 0);
  } else if (val == 3) {
    translate(-(width*3/100), 0);
  }

  y = y - height/9 - lineCount*22;

  fill(0, 0, 255, 200);
  if (lineCount == 0) {
    draw_rect(width/350 + (width*5/28)*val - width*39/1400, y, width*8/35, height*43/450, height/90);
  } else {
    draw_rect(width/350 + (width*5/28)*val - width*39/1400, y, width*8/35, height*11/90 + (lineCount-1)*(height*11/450), height/90);
  }
  fill(0);
  draw_text(move.getString("name"), width/350 + (width*5/28)*val - width*34/1400, y + height/90);
  draw_line(width/350 + (width*5/28)*val - width*39/1400, y + height*11/225, width/350 + (width*5/28)*val + width*281/1400, y + height*11/225);
  draw_text("Base power: " + moves_data.get(move.getString("name"))[2], width/350 + (width*5/28)*val - width*34/1400, y + height*3/50);
  draw_text("Accuracy: " + moves_data.get(move.getString("name"))[3], width/350 + (width*5/28)*val - width*34/1400, y + height*37/450);

  if (lineCount > 0) {
    draw_line(width/350 + (width*5/28)*val - width*39/1400, y + height*22/225, width/350 + (width*5/28)*val + width*281/1400, y + height*22/225);
  }

  textAlign(LEFT, TOP);
  draw_text(description, width/350 + (width*5/28)*val - width*34/1400, y + height*23/225);

  textAlign(CENTER);
  fill(255);
  draw_image(type_image.get(moves_data.get(move.getString("name"))[0]), width/350 + (width*5/28)*val - width*9/1400, y + height*8/225);
  draw_text(moves_data.get(move.getString("name"))[0], width/350 + (width*5/28)*val - width*9/1400, y + height*8/225 + height/200);

  popMatrix();
  textAlign(CENTER, CENTER);
}

void drawPokeInfo(int val, int y) {
  textAlign(LEFT, CENTER);
  pushMatrix();

  if (val == 0) {
    translate(width*17/280, 0);
  } else if (val == 5) {
    translate(-(width*17/280), 0);
  }
  fill(0, 0, 255, 200);
  draw_rect(width/350 + val*(width*167/1400) + width*159/2800 - width*4/35, y - height*19/90, width*8/35, height/5, height/90);
  fill(0);
  draw_text(pokemons.get(val).name, width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height/5);
  draw_line(width/350 + val*(width*167/1400) + width*159/2800 - width*4/35, y - height/6, width/350 + val*(width*167/1400) + width*159/2800 + width*4/35, y - height/6);
  draw_text("HP: " + (pokemons.get(val).cur_hp*100/pokemons.get(val).HP) + "% (" + 
    pokemons.get(val).cur_hp + "/" + pokemons.get(val).HP + ")", width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, 
    y - height*7/45);
  draw_text("Ability: " + pokemons.get(val).ability, width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height*2/15);
  draw_text(pokemons.get(val).ATK + " Atk / " + pokemons.get(val).DEF + " Def / " + 
    pokemons.get(val).SPA + " SpA / " + pokemons.get(val).SPD + " SpD / " + pokemons.get(val).SPE + 
    " Spe", width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height/9);
  draw_line(width/350 + val*(width*167/1400) + width*159/2800 - width*4/35, y - height/10, width/350 + val*(width*167/1400) + width*159/2800 + width*4/35, y - height/10);
  draw_text("- " + pokemons.get(val).moves[0], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height*4/45);
  draw_text("- " + pokemons.get(val).moves[1], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height*31/450);
  draw_text("- " + pokemons.get(val).moves[2], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height*11/225);
  draw_text("- " + pokemons.get(val).moves[3], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280, y - height*13/450);

  textAlign(CENTER);
  fill(255);
  draw_image(type_image.get(names_types.get(pokemons.get(val).name)[0]), width/350 + val*(width*167/1400) + width*159/2800 - width*31/280 + width/56, y - height*9/50);
  draw_text(names_types.get(pokemons.get(val).name)[0], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280 + width/56, y - height*9/50 + height/200);
  if (names_types.get(pokemons.get(val).name)[1] != null) {
    draw_image(type_image.get(names_types.get(pokemons.get(val).name)[1]), width/350 + val*(width*167/1400) + width*159/2800 - width*31/280 + width*3/140 + width*9/224, y - height*9/50);
    draw_text(names_types.get(pokemons.get(val).name)[1], width/350 + val*(width*167/1400) + width*159/2800 - width*31/280 + width*3/140 + width*9/224, y - height*9/50 + height/200);
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
