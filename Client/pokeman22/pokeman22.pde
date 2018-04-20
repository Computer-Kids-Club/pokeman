/* ron is bad
 * Demonstrates the use of the GifAnimation library.
 * the left animation is looping, the one in the middle 
 * plays once on mouse click and the one in the right
 * is a PImage array. 
 * the first two pause if you hit the spacebar.
 */

import gifAnimation.*;
import java.net.URL;
import java.net.HttpURLConnection;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.Channels;
import java.io.FileOutputStream;
import java.util.Map;

// Note the HashMap's "key" is a String and "value" is an Integer

HashMap<String, Integer> names_num = new HashMap<String, Integer>();
HashMap<Integer, String> num_names = new HashMap<Integer, String>();
HashMap<String, Integer[]> names_stats = new HashMap<String, Integer[]>();

HashMap<String, String[]> names_types = new HashMap<String, String[]>();
HashMap<String, String> names_species = new HashMap<String, String>();
HashMap<String, String[]> names_height_weight = new HashMap<String, String[]>();
HashMap<String, String[]> names_abilities = new HashMap<String, String[]>();

HashMap<String, String[][]> names_moves = new HashMap<String, String[][]>();


HashMap<String, String[]> moves_data = new HashMap<String, String[]>();

JSONObject[] pokemon = new JSONObject[6];
PImage[][] pokemonAnimation = {{}, {}, {}, {}, {}, {}};

ArrayList<Pokemon> pokemons;

Gif loopingGif;
Gif nonLoopingGif;
boolean pause = false;

int idx = 1;

JSONObject curr_json;
JSONObject pokemonLocation;

Boolean mousePressValid = true;
Boolean keyPressValid = true;

PImage[] pokemonImages = new PImage[807];

int offset = 0;
int offsetMoves = 0;

boolean transitionStart = false; 

boolean sliderFollow = false;
boolean moveSliderFollow = false;

int pokemonChangeNumber;
boolean pokemonSelectScreen = false;

float mouseWheelChange = 0;

String pokemonSearch = "";
String alphabet_lower = "abcdefghijklmnopqrstuvwxyz";
String alphabet_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String punctuation = " -:";

boolean pokemonSearchBool = false;

StringList validPokemonSearch;
StringList allPokeMoves;

PImage infoButton;
PImage pokeBall;
PImage settingsButton;
PImage backgroundImg;
PImage startButton;
PImage pokedex;

int i_battle_state = 0;

PImage[][] tempAnimations;
boolean tempAnimationLoad = true;
boolean moveSelect = false;
boolean moveScreenReset = true;
boolean moveSelectScreen = true;

int moveSlot;
int textRestrain;
int moveScreenNamePos = 0;

String[] selectedMoves;

int[] IV = {0, 0, 0, 0, 0, 0};
int[] EV = {0, 0, 0, 0, 0, 0};
int[] stats = {0, 0, 0, 0, 0, 0};
int[] nature = {0, 0, 0, 0, 0, 0};

int level;

//int[] settingsButton = {width - 60, 60, 100, 100};

PImage[][] loadPokemon(JSONObject file, boolean shiny) {
  PImage[][] animations = new PImage[2][];

  if (shiny) {
    animations[0] = Gif.getPImages(this, file.getString("gifs"));
    animations[1] = Gif.getPImages(this, file.getString("gifbs"));
  } else {
    animations[0] = Gif.getPImages(this, file.getString("gif"));
    animations[1] = Gif.getPImages(this, file.getString("gifb"));
  }

  return animations;
}

PImage[][] loadPokemonAll(JSONObject file) {
  PImage[][] animations = new PImage[4][];
  animations[0] = Gif.getPImages(this, file.getString("gif"));
  animations[1] = Gif.getPImages(this, file.getString("gifb"));
  animations[2] = Gif.getPImages(this, file.getString("gifs"));
  animations[3] = Gif.getPImages(this, file.getString("gifbs"));

  return animations;
}

String[] getMoveData(String move_name) {
  JSONObject move_json = loadJSONObject(POKEINFO_PATH+"move/"+move_name+".txt");
  String[] data = {move_json.getString("type"), move_json.getString("cat"), move_json.getString("power"), move_json.getString("acc"), move_json.getString("pp"), move_json.getString("prob"), move_json.getString("effect")};
  return data;
}

void drawMove(String move_name) {

  JSONObject move_json = loadJSONObject(POKEINFO_PATH+"move/"+move_name+".txt");
  //JSONObject move_json = loadJSONObject("https://raw.githubusercontent.com/Komputer-Kids-Klub/pokeman/master/pokeinfo/move/"+move_name+".txt");

  //println(move_json.getString("type"));
  fill(TYPE_COLOURS.get(move_json.getString("type")));
  rect(300, 700, 600, 100);

  fill(255); 
  text(move_json.getString("name"), 400, 720);

  //fill(TYPE_COLOURS.get(move_json.getString("type")));
  //rect(300-2, 735 - 11, textWidth(move_json.getString("type"))+4, 14);
  fill(255);
  text(move_json.getString("type"), 400, 735);

  text(move_json.getString("cat"), 400, 750);
  text(move_json.getString("prob"), 400, 765);

  text(move_json.getString("power"), 700, 735);
  text(move_json.getString("acc"), 700, 750);
  text(move_json.getString("pp"), 700, 765);

  text(move_json.getString("effect"), 400, 785);

  textAlign(RIGHT);

  text("Type", 390, 735);

  text("Category", 390, 750);
  text("Probability", 390, 765);

  text("Power", 690, 735);
  text("Accuracy", 690, 750);
  text("PP", 690, 765);

  textAlign(LEFT);
}

void drawStartScreen() {
  //backgroundImg.resize(width, height);

  image(backgroundImg, 0, 0);

  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  rect(START_BUTTON.i_x, START_BUTTON.i_y, START_BUTTON.i_w, START_BUTTON.i_h);
  for (int i = 0; i < 6; i++) {

    fill(0, 0, 100, 100);
    rect(POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y, POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_h);
    drawPokemon(pokemons.get(i).animation, POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y);
    fill(0);
    text(pokemons.get(i).name, POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y + POKEMON_BUTTON.i_h/2 - height/90);
    fill(255);
    image(infoButton, INFO_BUTTON.i_x + i*POKEMON_BUTTON.i_w, INFO_BUTTON.i_y);
    image(pokeBall, POKEBALL.i_x + i*POKEMON_BUTTON.i_w, POKEBALL.i_y);
  }
  image(settingsButton, (width/140)*137, height/30);
  //rect(settingsButton[0], settingsButton[1], settingsButton[2], settingsButton[3]);
  imageMode(CORNER);
  textAlign(CORNER);
  rectMode(CORNER);

  textAlign(CENTER);
  fill(0);
  if (i_battle_state==NOT_READY)
    text("Find Match", START_BUTTON.i_x, START_BUTTON.i_y);
  else if (i_battle_state==SEARCHING)
    text("Searching for Match", START_BUTTON.i_x, START_BUTTON.i_y);
  //text("Find Match", startButton[0], startButton[1]);
  //text("Settings", settingsButton[0], settingsButton[1]);
  fill(255);
  textAlign(CORNER);

  if (mousePressed && mousePressValid == true && pokemonSelectScreen == false && i_battle_state==NOT_READY && moveSelectScreen == false) {
    for (int i = 0; i < 6; i++) {
      if (dist(mouseX, mouseY, POKEBALL.i_x + i*POKEMON_BUTTON.i_w, POKEBALL.i_y) <= height/60) {
        pokemonChangeNumber = i;
        pokemonSelectScreen = true;
        //pokemons.set(i, new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
        mousePressValid = false;
      }
      if (dist(mouseX, mouseY, INFO_BUTTON.i_x + i*POKEMON_BUTTON.i_w, INFO_BUTTON.i_y) <= height/60) {
        mousePressValid = false;
      }
    }
  }
  image(startButton, START_BUTTON.i_x - START_BUTTON.i_w/2, START_BUTTON.i_y - START_BUTTON.i_h/2);
  // line(width/2, 0, width/2, height);
  //line(0, height/2, width, height/2);
}

void drawPokemonSelectionScreen(int slotNumber) {
  strokeWeight(0);

  image(backgroundImg, 0, 0);
  float gridSize = (height*8/9 - SELECTSCREENSHIFT_Y*2)*1.0f/POKEMON_PER_PAGE;
  int BST = 0;
  float textHight = height/10 + SELECTSCREENSHIFT_Y;

  rectMode(CORNER);
  fill(0, 0, 0, 150);
  rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y, width*5/7 - SELECTSCREENSHIFT_X*2, height/9);
  //rect(width/7, height/18, width*5/7, height/18);

  fill(255);
  text("#", width*43/280 + SELECTSCREENSHIFT_X, textHight);
  text("Name", width*3/14, textHight);
  text("Types", width*19/56 - SELECTSCREENSHIFT_X, textHight);
  text("Abilities", width*9/20 + (width/14) - SELECTSCREENSHIFT_X*1.5, textHight);
  text("HP", width*13/20 - SELECTSCREENSHIFT_X, textHight);
  text("ATK", width*19/28 - SELECTSCREENSHIFT_X, textHight);
  text("DEF", width*99/140 - SELECTSCREENSHIFT_X, textHight);
  text("SPA", width*103/140 - SELECTSCREENSHIFT_X, textHight);
  text("SPD", width*107/140 - SELECTSCREENSHIFT_X, textHight);
  text("SPE", width*111/140 - SELECTSCREENSHIFT_X, textHight);
  text("BST", width*115/140 - SELECTSCREENSHIFT_X, textHight);


  textHight = height/9 + SELECTSCREENSHIFT_Y- gridSize/2;

  textAlign(LEFT, CENTER);

  if (pokemonSearch == "" && validPokemonSearch.size()!=807) {
    for (int i = 1; i <= 807; i++) {
      validPokemonSearch.append(num_names.get(i));
    }
  }

  offset = int((SLIDER.i_y - sliderStartY)*(807.0-POKEMON_PER_PAGE)/((height - height/9 - SELECTSCREENSHIFT_Y*2)-SLIDER.i_h));
  fill(0, 0, 0, 150);
  rect(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, width*5/7 - SELECTSCREENSHIFT_X*2, (height*38)/45 - SELECTSCREENSHIFT_Y);
  fill(255);
  stroke(255);
  strokeWeight(1);
  line(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, width/7 + SELECTSCREENSHIFT_X + width*5/7 - SELECTSCREENSHIFT_X*2, height/9 + SELECTSCREENSHIFT_Y);
  strokeWeight(0);
  for (int i = 0; i < POKEMON_PER_PAGE && i + 1 + offset <= num_names.size(); i++) {
    //line(width/7 + SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2, (width/7)*6 - SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2);
    //rect(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y + i*gridSize, width*5/7 - SELECTSCREENSHIFT_X*2, gridSize);
    fill(255);
    if (i < validPokemonSearch.size()) {
      if (validPokemonSearch.size() > POKEMON_PER_PAGE) {
        offset = int(((SLIDER.i_y - sliderStartY)*(validPokemonSearch.size() - POKEMON_PER_PAGE)/((height*8/9 - SELECTSCREENSHIFT_Y*2) - SLIDER.i_h)));
      } else {
        offset = 0;
      }
      //println(validPokemonSearch.size(), validPokemonSearch.size()-POKEMON_PER_PAGE, offset, (height/9)*8 - SLIDER.i_h, SLIDER.i_y - sliderStartY);
      text(names_num.get(validPokemonSearch.get(i + offset)), width*43/280 + SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      text(validPokemonSearch.get(i + offset), width*3/14, textHight + (i+1)*gridSize);
      for (int j = 0; j < 2; j++) {
        if (names_types.get(validPokemonSearch.get(i + offset))[j] != null) {
          text(names_types.get(validPokemonSearch.get(i + offset))[j], width*11/35 + j*(width/20) - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
        }
      }
      for (int j = 0; j < 3; j++) {
        if (names_abilities.get(validPokemonSearch.get(i + offset))[j] != null) {
          text(names_abilities.get(validPokemonSearch.get(i + offset))[j].replaceAll("-", " "), width*9/20 + j*(width/14) - SELECTSCREENSHIFT_X*1.5, textHight + (i+1)*gridSize);
        }
      }
      BST = 0;
      for (int j = 0; j < 6; j++) {
        BST += names_stats.get(validPokemonSearch.get(i + offset))[j];
        text(names_stats.get(validPokemonSearch.get(i + offset))[j], width*13/20 + j*(width/35) - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      }
      text(BST, width*115/140 - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      if (mousePressed && mousePressValid == true) {
        if (mouseX < width*6/7 - SLIDER.i_w - SELECTSCREENSHIFT_X && mouseX >= width/7 + SELECTSCREENSHIFT_X && mouseY < height*7/45 + i*gridSize + SELECTSCREENSHIFT_Y && mouseY > height/9 + i*gridSize + SELECTSCREENSHIFT_Y && sliderFollow == false) {
          pokemons.set(pokemonChangeNumber, new Pokemon(names_num.get(validPokemonSearch.get(i + offset)), boolean(int(random(0, 2)))));
          SLIDER.i_y = sliderStartY;
          pokemonSearch = "";
          validPokemonSearch = new StringList();
          pokemonSearchBool = false;
          pokemonSelectScreen = false;
          mousePressValid = false;
        }
      }
    }
  }
  //fill(0);
  //rect((width/7)*6 - SLIDER.i_w - SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, SLIDER.i_w, (height/9)*8 - SELECTSCREENSHIFT_Y*2);
  fill(255);
  rect(SLIDER.i_x, SLIDER.i_y, SLIDER.i_w, SLIDER.i_h);
  fill(0, 0, 0, 60);
  rect(SEARCH_BUTTON.i_x, SEARCH_BUTTON.i_y, SEARCH_BUTTON.i_w, SEARCH_BUTTON.i_h);
  fill(255);
  if (pokemonSearchBool == false) {
    text("Search by Name", width*43/280 + SELECTSCREENSHIFT_X, height/36 + SELECTSCREENSHIFT_Y);
  } else {
    text(pokemonSearch, width*43/280 + SELECTSCREENSHIFT_X, height/36 + SELECTSCREENSHIFT_Y);
  }
  fill(255);
  textAlign(CENTER);

  if (mousePressed && mousePressValid == true) {
    if (mouseX <= SEARCH_BUTTON.i_x + SEARCH_BUTTON.i_w && mouseX >= SEARCH_BUTTON.i_x && mouseY <= SEARCH_BUTTON.i_y + SEARCH_BUTTON.i_h && mouseY >= SEARCH_BUTTON.i_y) {
      pokemonSearchBool = true;
    } else {
      pokemonSearchBool = false;
    }

    if (mouseX >= SLIDER.i_x && mouseX <= SLIDER.i_x + SLIDER.i_w && mouseY >= SLIDER.i_y && mouseY <= SLIDER.i_y + SLIDER.i_h) {
      sliderFollow = true;
    }
    if (sliderFollow == false) {
      if (mouseX < width/7 || mouseX >= (width/7)*6) {
        pokemonSelectScreen = false;
        SLIDER.i_y = sliderStartY;
        pokemonSearch = "";
        validPokemonSearch = new StringList();
        pokemonSearchBool = false;
      }
    }
  } else {
    sliderFollow = false;
  }
  if (sliderFollow == true) {
    if (mouseY >= height/9 + SELECTSCREENSHIFT_Y && mouseY <= height - SLIDER.i_h/2 - SELECTSCREENSHIFT_Y) {
      SLIDER.i_y = mouseY - SLIDER.i_h/2;
    } else if (mouseY <= height/9 + SELECTSCREENSHIFT_Y) {
      SLIDER.i_y = height/9 + SELECTSCREENSHIFT_Y;
    } else if (mouseY >= height - SLIDER.i_h) {
      SLIDER.i_y = height - SELECTSCREENSHIFT_Y - SLIDER.i_h;
    }
  }
  if (SLIDER.i_y + SLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
    SLIDER.i_y = height - SLIDER.i_h - SELECTSCREENSHIFT_Y;
  } else if (SLIDER.i_y < height/9 + SELECTSCREENSHIFT_Y) {
    SLIDER.i_y = height/9 + SELECTSCREENSHIFT_Y;
  }
  image(pokedex, 0, 0);
  strokeWeight(1);
  stroke(0);
}

void drawPokemonInformationScreen(int slotNumber, int pokeNum, float gridsize) {
  if (moveScreenReset == true) {
    level = 100;
    allPokeMoves = new StringList();
    selectedMoves = new String[4];
    for (int i = 0; i < 4; i++) {
      selectedMoves[i] = "";
    }    
    for (int i = 0; i < 6; i++) {
      IV[i] = 0;
      EV[i] = 0;
    }
    for (int i = 0; i < 5; i++){
      nature[i] = 0;
    }
    textRestrain = 525 - MOVESLIDER.i_w;
    for (int i = 0; i < names_moves.get(num_names.get(pokeNum)).length; i++) {
      for (int j = 0; j < names_moves.get(num_names.get(pokeNum))[i].length; j++) {
        allPokeMoves.append(names_moves.get(num_names.get(pokeNum))[i][j]);
        if (textWidth(names_moves.get(num_names.get(pokeNum))[i][j].replaceAll("-", " ")) > moveScreenNamePos) {
          moveScreenNamePos = int(textWidth(names_moves.get(num_names.get(pokeNum))[i][j].replaceAll("-", " ")));
        }
        moves_data.put(names_moves.get(num_names.get(pokeNum))[i][j], getMoveData(names_moves.get(num_names.get(pokeNum))[i][j]));
      }
    }
    stats[0] = ((2*names_stats.get(num_names.get(pokeNum))[0] + IV[0] + (int(EV[0]/4))*level) + level + 10);
    stats[1] = ((2*names_stats.get(num_names.get(pokeNum))[1] + IV[1] + (int(EV[1]/4))*level) + 5);
    stats[2] = ((2*names_stats.get(num_names.get(pokeNum))[2] + IV[2] + (int(EV[1]/4))*level) + 5);
    stats[3] = ((2*names_stats.get(num_names.get(pokeNum))[3] + IV[3] + (int(EV[1]/4))*level) + 5);
    stats[4] = ((2*names_stats.get(num_names.get(pokeNum))[4] + IV[4] + (int(EV[1]/4))*level) + 5);
    stats[5] = ((2*names_stats.get(num_names.get(pokeNum))[5] + IV[5] + (int(EV[1]/4))*level) + 5);
    for (int i = 0; i < 6; i++){
      if (nature[i-1] == 1){
        stats[i] *= 1.1;
      } else if (nature[i-1] == -1){
        stats[i]  = int(stats[i] / 1.1);
      }
      print(stats[i]);
    }
    println();
    println(2*names_stats.get(num_names.get(pokeNum))[0] + IV[0] + (int(EV[0]/4))*level);
    println((2*names_stats.get(num_names.get(pokeNum))[0] + IV[0] + (int(EV[0]/4))*level)/100);
    moveScreenReset = false;
  }
  //image(pokedex, 0, 0);

  offsetMoves = int((MOVESLIDER.i_y - moveSliderStartY)*(allPokeMoves.size()-MOVES_PER_PAGE)/((height - SELECTSCREENSHIFT_Y - moveSliderStartY)-MOVESLIDER.i_h));

  if (tempAnimationLoad) {
    tempAnimations = loadPokemonAll(loadJSONObject(POKEINFO_PATH+"pokemon/"+pokeNum+".txt")); 
    tempAnimationLoad = false;
  }
  rectMode(CORNER);
  //rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y, width*5/7 - SELECTSCREENSHIFT_X*2 + 100, height - SELECTSCREENSHIFT_Y*2);
  for (int i = 0; i < 4; i++) {
    rect(width/7 + SELECTSCREENSHIFT_X + (height/4)*i, SELECTSCREENSHIFT_Y, height/4, height/4);
    imageMode(CENTER);
    drawPokemon(tempAnimations[i], width/7 + SELECTSCREENSHIFT_X + (height/4)*i + height/8, SELECTSCREENSHIFT_Y + height/8);
    imageMode(CORNER);
  }
  rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4, width*5/7 - SELECTSCREENSHIFT_X*2, 60);
  //rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + 900/4 + 60, width*5/7 - SELECTSCREENSHIFT_X*2, 187);
  if (moveSelect) {
    rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 248, width*5/7 - SELECTSCREENSHIFT_X*2, 44);
    rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 291, width*5/7 - SELECTSCREENSHIFT_X*2, 224);
    rect(MOVESLIDER.i_x, MOVESLIDER.i_y, MOVESLIDER.i_w, MOVESLIDER.i_h);
    fill(0);
    for (int i = 0; i < MOVES_PER_PAGE; i++) {
      if (i < allPokeMoves.size()) {
        if (allPokeMoves.size() > MOVES_PER_PAGE) {
          offsetMoves = int((MOVESLIDER.i_y - moveSliderStartY)*(allPokeMoves.size()-MOVES_PER_PAGE)/((height - SELECTSCREENSHIFT_Y - moveSliderStartY)-MOVESLIDER.i_h));
        } else {
          offsetMoves = 0;
        }
      }
      text(allPokeMoves.get(i + offsetMoves).replaceAll("-", " "), width*43/280 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      text(moves_data.get(allPokeMoves.get(i + offsetMoves))[0], width*43/280 + SELECTSCREENSHIFT_X + 120, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      text(moves_data.get(allPokeMoves.get(i + offsetMoves))[1], width*43/280 + SELECTSCREENSHIFT_X + 180, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      text(moves_data.get(allPokeMoves.get(i + offsetMoves))[2], width*43/280 + SELECTSCREENSHIFT_X + 240, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      text(moves_data.get(allPokeMoves.get(i + offsetMoves))[3], width*43/280 + SELECTSCREENSHIFT_X + 280, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      text(moves_data.get(allPokeMoves.get(i + offsetMoves))[4], width*43/280 + SELECTSCREENSHIFT_X + 320, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      if (textWidth(moves_data.get(allPokeMoves.get(i + offsetMoves))[6]) < textRestrain) {
        text(moves_data.get(allPokeMoves.get(i + offsetMoves))[6], width*43/280 + SELECTSCREENSHIFT_X + 360, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
      } else {
        for (int j = moves_data.get(allPokeMoves.get(i + offsetMoves))[6].length(); j > 0; j--) {
          if (textWidth(moves_data.get(allPokeMoves.get(i + offsetMoves))[6].substring(0, j) + "...") < textRestrain) {
            text(moves_data.get(allPokeMoves.get(i + offsetMoves))[6].substring(0, j) + "...", width*43/280 + SELECTSCREENSHIFT_X + 360, SELECTSCREENSHIFT_Y + height/4 + 296 + gridsize/2 + i*gridsize);
            break;
          }
        }
      }
    }
    textAlign(CENTER);
    text("Move Name", width*43/280 + SELECTSCREENSHIFT_X + moveScreenNamePos/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("Type", width*43/280 + SELECTSCREENSHIFT_X + 120 + textWidth("fighting")/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("Category", width*43/280 + SELECTSCREENSHIFT_X + 180 + textWidth("physical")/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("Pow", width*43/280 + SELECTSCREENSHIFT_X + 240 + textWidth("150")/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("Acc", width*43/280 + SELECTSCREENSHIFT_X + 280 + textWidth("100")/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("PP", width*43/280 + SELECTSCREENSHIFT_X + 320 + textWidth("60")/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    text("Description", width*43/280 + SELECTSCREENSHIFT_X + 360 + textRestrain/2, SELECTSCREENSHIFT_Y + height/4 + 274);
    textAlign(LEFT);
    fill(255);
    //println(offsetMoves, allPokeMoves.size(), MOVESLIDER.i_y, offset);
  } else {
    rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 60 + 188, width*5/7 - SELECTSCREENSHIFT_X*2, 268);
  }
  for (int i = 0; i < 3; i++) {
    rect(width/7 + SELECTSCREENSHIFT_X + i*((width*5/7 - SELECTSCREENSHIFT_X*2)/3), SELECTSCREENSHIFT_Y + height/4 + 60, (width*5/7 - SELECTSCREENSHIFT_X*2)/3, 188);
  }
  //rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y,400,400);
  //rect(width/7 + SELECTSCREENSHIFT_X + 400, SELECTSCREENSHIFT_Y,width*5/7 - SELECTSCREENSHIFT_X*2 - 400,60);
  //for (int i = 0; i < 3; i++) {
  //rect(width/7 + SELECTSCREENSHIFT_X + 400, SELECTSCREENSHIFT_Y + 60 + i*50,width*5/7 - SELECTSCREENSHIFT_X*2 - 400,50);
  //}
  //println(width/7 + SELECTSCREENSHIFT_X + 2*((width*5/7 - SELECTSCREENSHIFT_X*2)/3));
  textAlign(LEFT, CENTER);
  for (int i = 0; i < 4; i++) {
    fill(255);
    rect(580, 395 + i*40, 240, height/30);
    fill(0);
    if (selectedMoves[i] == "") {
      text("Select a move", 585, 395 + i*40 + height/60);
    } else {
      text(selectedMoves[i], 585, 395 + i*40 + height/60);
    }
  }
  fill(255);
  textAlign(LEFT);

  rect(310, SELECTSCREENSHIFT_Y + height/4 + 325/2, height/30, height/30);
  rect(350, SELECTSCREENSHIFT_Y + height/4 + 325/2, height/15, height/30);
  rect(420, SELECTSCREENSHIFT_Y + height/4 + 325/2, height/30, height/30);
  rect(310, 515, 220, height/30);
  rect(860, 395, 282, 150, height/90);
  fill(0);
  //rect(896,405, 205,10);
  //println((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5), ((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5)*205)/714, ((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5) / 714)*205);
  for (int i = 0; i < 6; i++){
    if (i == 0){
      rect(895, 405, (stats[i] * 205) / 714, 10);
    } else {
      rect(895, 405 + 23*i, (stats[i] * 205) / 669, 10);
    }
  }
  textAlign(CENTER, CENTER);
  text(level, 350 + height/30, SELECTSCREENSHIFT_Y + height/4 + 325/2 + height/60);
  textAlign(LEFT);
  //text("Name: " + num_names.get(pokeNum), 700,150);
  text("Name : " + num_names.get(pokeNum), width/7 + SELECTSCREENSHIFT_X + 10, 395);
  text("Types :", width/7 + SELECTSCREENSHIFT_X + 10, 442);
  text("Level :", width/7 + SELECTSCREENSHIFT_X + 10, 489);
  text("Ability :", width/7 + SELECTSCREENSHIFT_X + 10, 536);
  text("Moves", 560, 385);
  text("1.", 560, 415);
  text("2.", 560, 455);
  text("3.", 560, 495);
  text("4.", 560, 535);
  text("Stats", 870, 385);
  text("HP", 870, 415);
  text("ATK", 870, 438);
  text("DEF", 870, 461);
  text("SPA", 870, 484);
  text("SPD", 870, 507);
  text("SPE", 870, 530);
  fill(255);

  if (mousePressed && mousePressValid == true) {
    if (mouseY <= SELECTSCREENSHIFT_Y + height/4 + 325/2 + height/30 && mouseY >= SELECTSCREENSHIFT_Y + height/4 + 325/2) {
      if (mouseX <= 310 + height/30 && mouseX >= 310) {
        println("DOWN");
        if (level > 0) {
          level -= 1;
          mousePressValid = false;
        }
      }
      if (mouseX <= 420 + height/30 && mouseX >= 420) {
        println("UP");
        if (level < 100) {
          level += 1;
          mousePressValid = false;
        }
      }
    }
    for (int i = 0; i < 4; i++) {
      if (mouseX <= 820 && mouseX >= 580 && mouseY <= 425 + i*40 && mouseY >= 395 + i*40) {
        moveSelect = true;
        moveSlot = i;
      }
    }
    if (moveSelect == true && moveSliderFollow == false) {
      for (int i = 0; i < MOVES_PER_PAGE; i++) {
        if (mouseX <= width*6/7 - SELECTSCREENSHIFT_X - MOVESLIDER.i_w && mouseX >= width/7 + SELECTSCREENSHIFT_X && mouseY <= SELECTSCREENSHIFT_Y + height/4 + 323 + i*gridsize && mouseY >= SELECTSCREENSHIFT_Y + height/4 + 291 + i*gridsize) {
          selectedMoves[moveSlot] = allPokeMoves.get(i + offsetMoves);
        }
      }
    }
    if (mouseX >= MOVESLIDER.i_x && mouseX <= MOVESLIDER.i_x + MOVESLIDER.i_w && mouseY >= MOVESLIDER.i_y && mouseY <= MOVESLIDER.i_y + MOVESLIDER.i_h) {
      moveSliderFollow = true;
    }
  } else {
    moveSliderFollow = false;
  }

  if (moveSliderFollow == true) {
    if (mouseY >= SELECTSCREENSHIFT_Y + height/4 + 291 && mouseY <= height - MOVESLIDER.i_h/2 - SELECTSCREENSHIFT_Y) {
      MOVESLIDER.i_y = mouseY - MOVESLIDER.i_h/2;
    } else if (mouseY <= SELECTSCREENSHIFT_Y + height/4 + 291) {
      MOVESLIDER.i_y = SELECTSCREENSHIFT_Y + height/4 + 291;
    } else if (mouseY >= height - SELECTSCREENSHIFT_Y - MOVESLIDER.i_h) {
      MOVESLIDER.i_y = height - SELECTSCREENSHIFT_Y - MOVESLIDER.i_h;
    }
  }
  if (MOVESLIDER.i_y + MOVESLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
    MOVESLIDER.i_y = height - MOVESLIDER.i_h - SELECTSCREENSHIFT_Y;
  } else if (MOVESLIDER.i_y < SELECTSCREENSHIFT_Y + height/4 + 291) {
    MOVESLIDER.i_y = SELECTSCREENSHIFT_Y + height/4 + 291;
  }
  //image(pokedex, 0, 0);
}

void drawPokemon(PImage[] pAnimation, int x, int y, float s) {
  if (pAnimation.length>0) {
    pushMatrix();
    translate(x, y);
    scale(s, s);
    image(pAnimation[(int) frameCount%pAnimation.length], 0, 0);
    popMatrix();
  }
}

void drawPokemon(PImage[] pAnimation, int x, int y) {
  drawPokemon(pAnimation, x, y, 1);
}

void setup() {
  size(1400, 900, P2D);
  //fullScreen();
  frameRate(50);
  imageMode(CENTER);
  noSmooth();
  colorMode(HSB);

  myClient = new Client(this, "127.0.0.1", PORT);

  init_constants();

  Gif.tmpPath = dataPath("");

  validPokemonSearch = new StringList();

  infoButton = loadImage("infoButton.png");
  pokeBall = loadImage("Pokeball.png");
  settingsButton = loadImage("Settings.png");
  backgroundImg = loadImage("Background.jpg");
  startButton = loadImage("Button.jpg");
  pokedex = loadImage("pokedex.png");

  settingsButton.resize(width/28, height/18);
  pokeBall.resize((width/140)*3, height/30);
  infoButton.resize((width/140)*3, height/30);
  backgroundImg.resize(width, height);
  startButton.resize(START_BUTTON.i_w, START_BUTTON.i_h);
  pokedex.resize(width, height);

  pokemons = new ArrayList<Pokemon>();
  for (int i = 0; i < 6; i ++) {
    pokemons.add(new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
  }

  for (int i = 1; i <= 807; i++) {
    JSONObject file = loadJSONObject(POKEINFO_PATH+"pokemon/"+i+".txt");
    //JSONObject file = loadJSONObject("https://raw.githubusercontent.com/Komputer-Kids-Klub/pokeman/master/pokeinfo/pokemon/"+i+".txt");
    names_num.put(file.getString("name"), i);
    num_names.put(i, file.getString("name"));
    Integer[] stats = {int(file.getString("HP")), int(file.getString("ATK")), int(file.getString("DEF")), int(file.getString("SPA")), int(file.getString("SPD")), int(file.getString("SPE"))};
    String[] types = {file.getString("type1"), file.getString("type2")};
    String[] height_weight = {file.getString("height"), file.getString("weight")};
    String ab1 = file.getString("ability1");
    String ab2 = file.getString("ability2");
    String ab3 = file.getString("hiddenability");
    String[] abilities = {ab1, ab2, ab3};
    names_stats.put(file.getString("name"), stats);
    names_types.put(file.getString("name"), types);
    names_species.put(file.getString("name"), file.getString("species"));
    names_height_weight.put(file.getString("name"), height_weight);
    names_abilities.put(file.getString("name"), abilities);

    String[] levelMoves = new String[file.getJSONArray("levelmoves").size()];
    for (int j = 0; j < file.getJSONArray("levelmoves").size(); j++) {
      levelMoves[j] = file.getJSONArray("levelmoves").getJSONObject(j).getString("move");
    }
    String[] eggMoves = new String[file.getJSONArray("eggmoves").size()];
    for (int j = 0; j < file.getJSONArray("eggmoves").size(); j++) {
      eggMoves[j] = file.getJSONArray("eggmoves").getJSONObject(j).getString("move");
    }
    String[] tutorMoves = new String[file.getJSONArray("tutormoves").size()];
    for (int j = 0; j < file.getJSONArray("tutormoves").size(); j++) {
      tutorMoves[j] = file.getJSONArray("tutormoves").getJSONObject(j).getString("move");
    }
    String[] tmMoves = new String[file.getJSONArray("tmmoves").size()];
    for (int j = 0; j < file.getJSONArray("tmmoves").size(); j++) {
      tmMoves[j] = file.getJSONArray("tmmoves").getJSONObject(j).getString("move");
    }
    String[][] allMoves = {levelMoves, eggMoves, tutorMoves, tmMoves};
    names_moves.put(file.getString("name"), allMoves);
  }

  println(names_stats.get("bulbasaur"));
  println(names_types.get("bulbasaur"));
  println(names_species.get("bulbasaur"));
  println(names_height_weight.get("bulbasaur"));
  println(names_abilities.get("bulbasaur"));
  println();
  println(names_moves.get("bulbasaur"));
  println(names_moves.get("bulbasaur")[1]);
}

void draw() {

  recieve_data();

  background(200);

  if (i_battle_state == BATTLING) {
    draw_battle();
    return;
  }

  drawStartScreen();
  if (moveSelectScreen == true) {
    drawPokemonInformationScreen(1, 151, 32);
  }
  if (pokemonSelectScreen == true) {
    drawPokemonSelectionScreen(pokemonChangeNumber);
  }
}
