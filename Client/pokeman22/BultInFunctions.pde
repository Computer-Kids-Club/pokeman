

void mousePressed() {
  /*print(mouseX);
  print(" ");
  println(mouseY);*/
  if (START_BUTTON.i_x-START_BUTTON.i_w/2<=mouseX && mouseX<=START_BUTTON.i_x+START_BUTTON.i_w/2 &&
    START_BUTTON.i_y-START_BUTTON.i_h/2<=mouseY && mouseY<=START_BUTTON.i_y+START_BUTTON.i_h/2 && i_battle_state == NOT_READY) {
    send_pokes();
    i_battle_state = SEARCHING;
    println("pressed");
  }
}

void mouseReleased() {
  mousePressValid = true;
}

void mouseClicked() {
}
void mouseWheel(MouseEvent event) {
  if (pokemonSelectScreen == true) {
    if (SLIDER.i_y >= height/9 && SLIDER.i_y + SLIDER.i_h <= height) {
      SLIDER.i_y += (event.getCount())*5;
    }
    if (SLIDER.i_y + SLIDER.i_h > height) {
      SLIDER.i_y = height - SLIDER.i_h;
    } else if (SLIDER.i_y < height/9) {
      SLIDER.i_y = height/9;
    }
  }
}
void keyPressed() {
  //  pokemons = new ArrayList<Pokemon>();
  //  for (int i = 0; i < 6; i ++) {
  //    pokemons.add(new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
  //  }
  
  if(i_battle_state == BATTLING) {
  }

  /*if (key=='h') {
    send_hey();
  }
  if (key=='s') {
    send_pokes();
  }*/
  if (key=='`') {
    reconnect();
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
  }
}

void keyReleased() {
}