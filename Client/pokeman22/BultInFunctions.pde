
int i_rect_mode = CORNER;
int i_image_mode = CORNER;

void mousePressed() {
  mouse_pressed_console();
  if (b_console)
    return;

  /*print(mouseX);
   print(" ");
   println(mouseY);*/
  if (START_BUTTON.i_x-START_BUTTON.i_w/2<=mouseX && mouseX<=START_BUTTON.i_x+START_BUTTON.i_w/2 &&
    START_BUTTON.i_y-START_BUTTON.i_h/2<=mouseY && mouseY<=START_BUTTON.i_y+START_BUTTON.i_h/2 && i_battle_state == NOT_READY && !pokemonSelectScreen && !moveSelectScreen) {
    send_pokes();
    i_battle_state = SEARCHING;
    println("pressed");
  }
}

void mouseReleased() {
  mouse_released_console();
  if (b_console)
    return;

  mousePressValid = true;
}

void mouseClicked() {
}
void mouseWheel(MouseEvent event) {
  mouse_wheel_console();
  if (b_console)
    return;

  if (pokemonSelectScreen == true && moveSelect == false) {
    if (SLIDER.i_y >= height/9 && SLIDER.i_y + SLIDER.i_h <= height) {
      int count = (event.getCount())*5;
      if (count > 0) {
        if (SLIDER.i_y + SLIDER.i_h < height - SELECTSCREENSHIFT_Y) {
          SLIDER.i_y += (event.getCount())*5;
        }
      } else {
        if (SLIDER.i_y > sliderStartY) {
          SLIDER.i_y += (event.getCount())*5;
        }
      }
    }
    if (SLIDER.i_y + SLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
      SLIDER.i_y = height - SLIDER.i_h - SELECTSCREENSHIFT_Y;
    } else if (SLIDER.i_y < height/9 + SELECTSCREENSHIFT_Y) {
      SLIDER.i_y = height/9 + SELECTSCREENSHIFT_Y;
    }
  } else if (moveSelect == true) {
    if (MOVESLIDER.i_y >= SELECTSCREENSHIFT_Y + height/4 + 291 && MOVESLIDER.i_y + MOVESLIDER.i_h <= height) {
      int count = (event.getCount())*5;
      if (count > 0) {
        if (MOVESLIDER.i_y + MOVESLIDER.i_h < height - SELECTSCREENSHIFT_Y) {
          MOVESLIDER.i_y += (event.getCount())*5;
        }
      } else {
        if (MOVESLIDER.i_y > moveSliderStartY) {
          MOVESLIDER.i_y += (event.getCount())*5;
        }
      }
    }
    if (MOVESLIDER.i_y + MOVESLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
      MOVESLIDER.i_y = height - MOVESLIDER.i_h - SELECTSCREENSHIFT_Y;
    } else if (MOVESLIDER.i_y < SELECTSCREENSHIFT_Y + height/4 + 291) {
      MOVESLIDER.i_y = SELECTSCREENSHIFT_Y + height/4 + 291;
    }
  } else if (statSelect == true) {
    if (NATURESLIDER.i_y >= natureSliderStartY && NATURESLIDER.i_y + MOVESLIDER.i_h <= height) {
      int count = (event.getCount())*5;
      if (count > 0) {
        if (NATURESLIDER.i_y + NATURESLIDER.i_h < height - SELECTSCREENSHIFT_Y) {
          NATURESLIDER.i_y += (event.getCount())*5;
        }
      } else {
        if (NATURESLIDER.i_y > natureSliderStartY) {
          NATURESLIDER.i_y += (event.getCount())*5;
        }
      }
    }
    if (NATURESLIDER.i_y + NATURESLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
      NATURESLIDER.i_y = height - NATURESLIDER.i_h - SELECTSCREENSHIFT_Y;
    } else if (NATURESLIDER.i_y < 598) {
      NATURESLIDER.i_y = 598;
    }
  }
}

void keyPressed() {
  key_pressed_console();
  if (b_console)
    return;

  //  pokemons = new ArrayList<Pokemon>();
  //  for (int i = 0; i < 6; i ++) {
  //    pokemons.add(new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
  //  }

  if (i_battle_state == BATTLING) {
    if ('1'<=key&&key<='6'&&(i_selection_stage == SELECT_POKE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
      select_poke(int(key-'1'));
      i_selection_stage = AWAITING_SELECTION;
    } else if (KEY_TO_ID.get(key)!=null&&(i_selection_stage == SELECT_MOVE||i_selection_stage == SELECT_POKE_OR_MOVE)) {
      select_move(KEY_TO_ID.get(key));
      i_selection_stage = AWAITING_SELECTION;
    }
  }

  /*if (key=='h') {
   send_hey();
   }
   if (key=='s') {
   send_pokes();
   }*/
  if (key=='`') {
    //reconnect();
  }

  if (pokemonSearchBool == true) {
    for (int i = 0; i < 26; i++) {
      if (key == alphabet_lower.charAt(i) || key == alphabet_upper.charAt(i) || key == punctuation.charAt(i%punctuation.length())) {
        if (pokemonSearch == "") {
          pokemonSearch = str(key);
          break;
        } else {
          pokemonSearch += key;
          break;
        }
      }
    }
    if (key == BACKSPACE) {
      if (pokemonSearch.length() > 1) {
        pokemonSearch = pokemonSearch.substring(0, pokemonSearch.length()-1);
      } else if (pokemonSearch.length() > 0) {
        pokemonSearch = pokemonSearch.substring(0, pokemonSearch.length()-1);
        pokemonSearch = "";
      } else {
        pokemonSearch = "";
      }
    }
    SLIDER.i_y = sliderStartY;
    validPokemonSearch = new StringList();
    for (int i = 1; i <= 807; i++) {
      if (pokemonSearch.length() <= num_names.get(i).length()) {
        if (pokemonSearch.equals(num_names.get(i).substring(0, pokemonSearch.length()))) {
          validPokemonSearch.append(num_names.get(i));
        }
      }
    }
  } else if (moveSearchBool == true) {
    for (int i = 0; i < 26; i++) {
      if (key == alphabet_lower.charAt(i) || key == alphabet_upper.charAt(i) || key == punctuation.charAt(i%punctuation.length())) {
        if (moveSearch == "") {
          moveSearch = str(key);
          break;
        } else {
          moveSearch += key;
          break;
        }
      }
    }
    if (key == BACKSPACE) {
      if (moveSearch.length() > 1) {
        moveSearch = moveSearch.substring(0, moveSearch.length()-1);
      } else if (moveSearch.length() > 0) {
        moveSearch = moveSearch.substring(0, moveSearch.length()-1);
        moveSearch = "";
      } else {
        moveSearch = "";
      }
    }
    MOVESLIDER.i_y = moveSliderStartY;
    validMoveSearch = new StringList();
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < names_moves.get(num_names.get(pokemonNumber))[i].length; j++) {
        if (moveSearch.length() <= names_moves.get(num_names.get(pokemonNumber))[i][j].length()) {
          if (moveSearch.equals(names_moves.get(num_names.get(pokemonNumber))[i][j].substring(0, moveSearch.length()))) {
            validMoveSearch.append(names_moves.get(num_names.get(pokemonNumber))[i][j]);
          }
        }
      }
    }
  } else if (login=true) {
    for (int i = 0; i < 26; i++) {
      if (key == alphabet_lower.charAt(i) || key == alphabet_upper.charAt(i) || key == punctuation.charAt(i%punctuation.length())) {
        if (current=="username") {
          if (username == "") {
            username = str(key);
            break;
          } else if (username.length()<=30) {
            username += key;
            break;
          }
        } else if (current=="password") {
          if (password == "") {
            password = str(key);
            break;
          } else if(password.length()<=30) {
            password += key;
            break;
          }
        }
      }
    }
    if (key == BACKSPACE) {
      if (current=="username") {
        if (username.length() > 1) {
          username = username.substring(0, username.length()-1);
        } else if (username.length() > 0) {
          username = username.substring(0, username.length()-1);
          username = "";
        }
      } else if (current=="password") {
        if (password.length() > 1) {
          password = password.substring(0, password.length()-1);
        } else if (password.length() > 0) {
          password = password.substring(0, password.length()-1);
          password = "";
        }
      }
    }
  }
}

void keyReleased() {
  key_released_console();
  if (b_console)
    return;
}

void draw_rect(int x, int y, int w, int h, int r) {
  if (i_r_drawothermodels==2) {
    noFill();
    strokeWeight(1);
    stroke(#00EDDB);
    if (i_rect_mode==CORNER) {
      line(x, y, x+w, y+h);
      line(x, y+h, x+w, y);
      rect(x, y, w, h, r);
    } else {
      line(x-w/2, y-h/2, x+w/2, y+h/2);
      line(x-w/2, y+h/2, x+w/2, y-h/2);
      rect(x, y, w, h, r);
    }
    return;
  }

  rect(x, y, w, h, r);
}

void draw_text(String str, int x, int y) {
  if (i_r_drawothermodels==2) {
    fill(#00EDDB);
    stroke(#00EDDB);
    strokeWeight(1);
  }

  text(str, x, y);
}

void draw_image(PImage img, int x, int y) {
  if (i_r_drawothermodels==2) {
    int i_tmp_rect_mode = i_rect_mode;
    draw_rectMode(i_image_mode);
    draw_rect(x, y, img.width, img.height);
    draw_rectMode(i_tmp_rect_mode);
    return;
  }

  image(img, x, y);
}

void draw_line(int x1, int y1, int x2, int y2) {
  if (i_r_drawothermodels==2) {
    fill(#00EDDB);
    stroke(#00EDDB);
    strokeWeight(1);
  }

  line(x1, y1, x2, y2);
}

void draw_rect(int x, int y, int w, int h) {
  draw_rect(x, y, w, h, 0);
}

void draw_text(String str, int x, float y) {
  draw_text(str, x, (int)y);
}

void draw_text(String str, float x, float y) {
  draw_text(str, (int)x, y);
}

void draw_text(int str, int x, float y) {
  draw_text(""+str, x, y);
}

void draw_imageMode(int mode) {
  i_image_mode = mode;
  imageMode(mode);
}

void draw_rectMode(int mode) {
  i_rect_mode = mode;
  rectMode(mode);
}
