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
import java.util.HashSet;
import java.util.Set;

// Note the HashMap's "key" is a String and "value" is an Integer

String[] male = {"braviary", "gallade", "hitmonchan", "hitmonlee", "hitmontop", "landorus", "latios", "mothim", "nidoking", "nidoran-m", "nidorino", "rufflet", "sawk", "tauros", "throh", "thundurus", "tornadus", "tyrogue", "volbeat"};
String[] female = {"blissey", "bounsweet", "chansey", "cresselia", "flabebe", "floette", "florges", "froslass", "happiny", "illumise", "jynx", "kangaskhan", "latias", "lilligant", "mandibuzz", "miltank", "nidoqueen", "nidoran-f", "nidorina", "petilil", "salazzle", "smoochum", "steenee", "tsareena", "vespiquen", "vullaby", "wormadam"};
String[] unspecified = {"arceus", "articuno", "azelf", "baltoy", "beldum", "blacephalon", "bronzong", "bronzor", "buzzwole", "carbink", "celebi", "celesteela", "claydol", "cobalion", "cosmoem", "cosmog", "cryogonal", "darkrai", "deoxys", "dhelmise", "dialga", "diancie", "ditto", "electrode", "entei", "genesect", "giratina", "golett", "golurk", "groudon", "guzzlord", "ho-oh", "hoopa", "jirachi", "kartana", "keldeo", "klang", "klink", "klinklang", "kyogre", "kyurem", "lugia", "lunala", "lunatone", "magearna", "magnemite", "magneton", "magnezone", "manaphy", "marshadow", "meloetta", "mesprit", "metagross", "metang", "mew", "mewtwo", "minior", "moltres", "naganadel", "necrozma", "nihilego", "palkia", "pheromosa", "phione", "poipole", "porygon", "porygon-z", "porygon2", "raikou", "rayquaza", "regice", "regigigas", "regirock", "registeel", "reshiram", "rotom", "shaymin", "shedinja", "silvally", "solgaleo", "solrock", "stakataka", "starmie", "staryu", "suicune", "tapu-bulu", "tapu-fini", "tapu-koko", "tapu-lele", "terrakion", "type-null", "unown", "uxie", "victini", "virizion", "volcanion", "voltorb", "xerneas", "xurkitree", "yveltal", "zapdos", "zekrom", "zeraora", "zygarde"};

boolean maleBool = false;
boolean femaleBool = false;
boolean unspecifiedBool = false;

HashMap<Integer, String> num_male = new HashMap<Integer, String>();
HashMap<Integer, String> num_female = new HashMap<Integer, String>();
HashMap<Integer, String> num_unspecified = new HashMap<Integer, String>();

HashMap<String, Integer> names_num = new HashMap<String, Integer>();
HashMap<Integer, String> num_names = new HashMap<Integer, String>();
HashMap<String, Integer[]> names_stats = new HashMap<String, Integer[]>();

HashMap<String, String[]> names_types = new HashMap<String, String[]>();
HashMap<String, String> names_species = new HashMap<String, String>();
HashMap<String, String[]> names_height_weight = new HashMap<String, String[]>();
HashMap<String, String[]> names_abilities = new HashMap<String, String[]>();

HashMap<String, String[][]> names_moves = new HashMap<String, String[][]>();

HashMap<String, PImage> type_image = new HashMap<String, PImage>();
String[] types = {"bug", "dark", "dragon", "electric", "error", "fairy", "fighting", "fire", "flying", 
  "ghost", "grass", "ground", "ice", "normal", "poison", "psychic", "rock", "steel", "water"};
PImage tempImage;

HashMap<String, String[]> moves_data = new HashMap<String, String[]>();

JSONObject[] pokemon = new JSONObject[6];
PImage[][] pokemonAnimation = {{}, {}, {}, {}, {}, {}};

ArrayList<Pokemon> pokemons;

Gif loopingGif;
Gif nonLoopingGif;
boolean pause = false;
boolean drawSettingScreen=false;
int idx = 1;

JSONObject curr_json;
JSONObject pokemonLocation;

Boolean mousePressValid = true;
Boolean keyPressValid = true;

PImage[] pokemonImages = new PImage[807];

int offset = 0;
int offsetMoves = 0;
int offsetNature = 0;

boolean transitionStart = false; 

boolean sliderFollow = false;
boolean moveSliderFollow = false;
boolean natureSliderFollow = false;

int pokemonChangeNumber;
boolean pokemonSelectScreen = false;

float mouseWheelChange = 0;

String pokemonSearch = "";
String moveSearch = "";
String alphabet_lower = "abcdefghijklmnopqrstuvwxyz";
String alphabet_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String punctuation = " -:";

boolean pokemonSearchBool = false;
boolean moveSearchBool = false;

StringList validPokemonSearch;
StringList allPokeMoves;
StringList validMoveSearch;

PImage infoButton;
PImage pokeBall;
PImage settingsButton;
PImage backgroundImg;
PImage startButton;
PImage pokedex;
PImage back;
PImage confirm;

int i_battle_state = 0;

PImage[][] tempAnimations;
boolean tempAnimationLoad = true;
boolean moveSelect = false;
boolean statSelect = true;
boolean moveScreenReset = true;
boolean moveScreenReload = false;
boolean moveSelectScreen = false;

int moveSlot;
int textRestrain;
int moveScreenNamePos = 0;

String[] selectedMoves;

int[] IV = {31, 31, 31, 31, 31, 31};
int[] EV = {0, 0, 0, 0, 0, 0};
int[] stats = {0, 0, 0, 0, 0, 0};
int[] nature = {0, 0, 0, 0, 0};
int maxEV = 508;
int EVRemaining;
int lastSliderTouched = 0;

int level;
String natureString = "";

boolean[] statSliderFollow = {false, false, false, false, false, false};

String[] natureName = {"Hardy", "Lonely", "Brave", "Adamant", "Naughty", "Bold", "Docile", "Relaxed", "Impish", "Lax", "Timid", "Hasty", "Serious", "Jolly", "Naive", "Modest", "Mild", "Quiet", "Bashful", "Rash", "Calm", "Gentle", "Sassy", "Careful", "Quirky"};
String[][] natureStat = {{}, {"Atk", "Def"}, {"Atk", "Spe"}, {"Atk", "SpA"}, {"Atk", "SpD"}, {"Def", "Atk"}, {}, {"Def", "Spe"}, {"Def", "SpA"}, {"Def", "SpD"}, {"Spe", "Atk"}, {"Spe", "Def"}, {}, {"Spe", "SpA"}, {"Spe", "SpD"}, {"SpA", "Atk"}, {"SpA", "Def"}, {"SpA", "Spe"}, 
  {}, {"SpA", "SpD"}, {"SpD", "Atk"}, {"SpD", "Def"}, {"SpD", "Spe"}, {"SpD", "Spa"}, {}};
String[] natureAbility = {"Atk", "Def", "SpA", "SpD", "Spe"};

String selectedAbility = "";
boolean chooseAbility = false;
String selectedGender = "";
boolean chooseGender = false;

String[] genders = {"Male", "Female", "Unspecified"};
int abilityCount = 0;

boolean shinyBool = false;

int pokemonSlotNumber;
int pokemonNumber;

int selectedNature = 0;

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
  draw_rect(300, 700, 600, 100);

  fill(255); 
  draw_text(move_json.getString("name"), 400, 720);

  //fill(TYPE_COLOURS.get(move_json.getString("type")));
  //draw_rect(300-2, 735 - 11, textWidth(move_json.getString("type"))+4, 14);
  fill(255);
  draw_text(move_json.getString("type"), 400, 735);

  draw_text(move_json.getString("cat"), 400, 750);
  draw_text(move_json.getString("prob"), 400, 765);

  draw_text(move_json.getString("power"), 700, 735);
  draw_text(move_json.getString("acc"), 700, 750);
  draw_text(move_json.getString("pp"), 700, 765);

  draw_text(move_json.getString("effect"), 400, 785);

  textAlign(RIGHT);

  draw_text("Type", 390, 735);

  draw_text("Category", 390, 750);
  draw_text("Probability", 390, 765);

  draw_text("Power", 690, 735);
  draw_text("Accuracy", 690, 750);
  draw_text("PP", 690, 765);

  textAlign(LEFT);
}
void drawSettingScreen() {
  fill(150);
  draw_rect(0, 0, width, height);
  if (mousePressed) {
    drawSettingScreen=false;
  }
}

void drawStartScreen() {
  //backgroundImg.resize(width, height);

  draw_image(backgroundImg, 0, 0);

  draw_rectMode(CENTER);
  draw_imageMode(CENTER);
  textAlign(CENTER);
  draw_rect(START_BUTTON.i_x, START_BUTTON.i_y, START_BUTTON.i_w, START_BUTTON.i_h);
  for (int i = 0; i < 6; i++) {

    fill(0, 0, 100, 100);
    draw_rect(POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y, POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_h);
    drawPokemon(pokemons.get(i).animation, POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y);
    fill(0);
    draw_text(pokemons.get(i).name, POKEMON_BUTTON.i_x + i*POKEMON_BUTTON.i_w, POKEMON_BUTTON.i_y + POKEMON_BUTTON.i_h/2 - height/90);
    fill(255);
    draw_image(infoButton, INFO_BUTTON.i_x + i*POKEMON_BUTTON.i_w, INFO_BUTTON.i_y);
    draw_image(pokeBall, POKEBALL.i_x + i*POKEMON_BUTTON.i_w, POKEBALL.i_y);
  }
  draw_image(settingsButton, (width/140)*137, height/30);
  //draw_rect(settingsButton[0], settingsButton[1], settingsButton[2], settingsButton[3]);
  draw_imageMode(CORNER);
  textAlign(CORNER);
  draw_rectMode(CORNER);

  textAlign(CENTER);
  fill(0);
  if (i_battle_state==NOT_READY)
    draw_text("Find Match", START_BUTTON.i_x, START_BUTTON.i_y);
  else if (i_battle_state==SEARCHING)
    draw_text("Searching for Match", START_BUTTON.i_x, START_BUTTON.i_y);
  //draw_text("Find Match", startButton[0], startButton[1]);
  //draw_text("Settings", settingsButton[0], settingsButton[1]);
  fill(255);
  textAlign(CORNER);

  if (mousePressed && mousePressValid == true && pokemonSelectScreen == false && i_battle_state==NOT_READY && moveSelectScreen == false) {
    for (int i = 0; i < 6; i++) {
      if (dist(mouseX, mouseY, POKEBALL.i_x + i*POKEMON_BUTTON.i_w, POKEBALL.i_y) <= height/60) {
        pokemonChangeNumber = i;
        pokemonSelectScreen = true;
        mousePressValid = false;
      }
      if (dist(mouseX, mouseY, (width/140)*137, height/30)<=dist((width/140)*137-width/56, height/30-height/36, (width/140)*137, height/30)) {
        drawSettingScreen=true;
      }
      if (dist(mouseX, mouseY, INFO_BUTTON.i_x + i*POKEMON_BUTTON.i_w, INFO_BUTTON.i_y) <= height/60) {
        pokemonSlotNumber = i;
        pokemonNumber = pokemons.get(i).number;
        moveSelectScreen = true;
        //moveScreenReset = true;
        moveScreenReload = true;
        tempAnimationLoad = true;
        mousePressValid = false;
      }
    }
  }
  draw_image(startButton, START_BUTTON.i_x - START_BUTTON.i_w/2, START_BUTTON.i_y - START_BUTTON.i_h/2);
  // draw_line(width/2, 0, width/2, height);
  //line(0, height/2, width, height/2);
}

void drawPokemonSelectionScreen(int slotNumber) {
  strokeWeight(0);

  draw_image(backgroundImg, 0, 0);
  int BST = 0;
  float textHight = height/10 + SELECTSCREENSHIFT_Y;

  draw_rectMode(CORNER);
  fill(0, 0, 0, 150);
  draw_rect(0, 0, width, height);
  //draw_rect(width/7, height/18, width*5/7, height/18);

  fill(255);
  draw_text("#", width*43/280 + SELECTSCREENSHIFT_X, textHight);
  draw_text("Name", width*3/14, textHight);
  draw_text("Types", width*19/56 - SELECTSCREENSHIFT_X, textHight);
  draw_text("Abilities", width*9/20 + (width/14) - SELECTSCREENSHIFT_X*1.5, textHight);
  draw_text("HP", width*13/20 - SELECTSCREENSHIFT_X, textHight);
  draw_text("ATK", width*19/28 - SELECTSCREENSHIFT_X, textHight);
  draw_text("DEF", width*99/140 - SELECTSCREENSHIFT_X, textHight);
  draw_text("SPA", width*103/140 - SELECTSCREENSHIFT_X, textHight);
  draw_text("SPD", width*107/140 - SELECTSCREENSHIFT_X, textHight);
  draw_text("SPE", width*111/140 - SELECTSCREENSHIFT_X, textHight);
  draw_text("BST", width*115/140 - SELECTSCREENSHIFT_X, textHight);


  textHight = height/9 + SELECTSCREENSHIFT_Y- gridSize/2;

  textAlign(LEFT, CENTER);

  if (pokemonSearch == "" && validPokemonSearch.size()!=807) {
    for (int i = 1; i <= 807; i++) {
      validPokemonSearch.append(num_names.get(i));
    }
  }

  offset = int((SLIDER.i_y - sliderStartY)*(807.0-POKEMON_PER_PAGE)/((height - height/9 - SELECTSCREENSHIFT_Y*2)-SLIDER.i_h));
  //draw_rect(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, width*5/7 - SELECTSCREENSHIFT_X*2, (height*38)/45 - SELECTSCREENSHIFT_Y);
  fill(255);
  stroke(255);
  strokeWeight(1);
  draw_line(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, width/7 + SELECTSCREENSHIFT_X + width*5/7 - SELECTSCREENSHIFT_X*2, height/9 + SELECTSCREENSHIFT_Y);
  strokeWeight(0);
  for (int i = 0; i < POKEMON_PER_PAGE && i + 1 + offset <= num_names.size(); i++) {
    //line(width/7 + SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2, (width/7)*6 - SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2);
    //draw_rect(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y + i*gridSize, width*5/7 - SELECTSCREENSHIFT_X*2, gridSize);
    fill(255);
    if (i < validPokemonSearch.size()) {
      if (validPokemonSearch.size() > POKEMON_PER_PAGE) {
        offset = int(((SLIDER.i_y - sliderStartY)*(validPokemonSearch.size() - POKEMON_PER_PAGE)/((height*8/9 - SELECTSCREENSHIFT_Y*2) - SLIDER.i_h)));
      } else {
        offset = 0;
      }
      //println(validPokemonSearch.size(), validPokemonSearch.size()-POKEMON_PER_PAGE, offset, (height/9)*8 - SLIDER.i_h, SLIDER.i_y - sliderStartY);
      draw_text(names_num.get(validPokemonSearch.get(i + offset)), width*43/280 + SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      draw_text(validPokemonSearch.get(i + offset), width*3/14, textHight + (i+1)*gridSize);
      for (int j = 0; j < 2; j++) {
        if (names_types.get(validPokemonSearch.get(i + offset))[j] != null) {
          draw_text(names_types.get(validPokemonSearch.get(i + offset))[j], width*11/35 + j*(width/20) - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
        }
      }
      for (int j = 0; j < 3; j++) {
        if (names_abilities.get(validPokemonSearch.get(i + offset))[j] != null) {
          draw_text(names_abilities.get(validPokemonSearch.get(i + offset))[j].replaceAll("-", " "), width*9/20 + j*(width/14) - SELECTSCREENSHIFT_X*1.5, textHight + (i+1)*gridSize);
        }
      }
      BST = 0;
      for (int j = 0; j < 6; j++) {
        BST += names_stats.get(validPokemonSearch.get(i + offset))[j];
        draw_text(names_stats.get(validPokemonSearch.get(i + offset))[j], width*13/20 + j*(width/35) - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      }
      draw_text(BST, width*115/140 - SELECTSCREENSHIFT_X, textHight + (i+1)*gridSize);
      if (mousePressed && mousePressValid == true) {
        if (mouseX < width*6/7 - SLIDER.i_w - SELECTSCREENSHIFT_X && mouseX >= width/7 + SELECTSCREENSHIFT_X && mouseY < height*7/45 + i*gridSize + SELECTSCREENSHIFT_Y && mouseY > height/9 + i*gridSize + SELECTSCREENSHIFT_Y && sliderFollow == false) {
          //pokemons.set(pokemonChangeNumber, new Pokemon(names_num.get(validPokemonSearch.get(i + offset)), boolean(int(random(0, 2)))));
          pokemonSlotNumber = slotNumber;
          pokemonNumber = names_num.get(validPokemonSearch.get(i + offset));
          moveSelectScreen = true;
          moveScreenReset = true;
          tempAnimationLoad = true;

          for (int k = i; k < POKEMON_PER_PAGE && k + 1 + offset <= num_names.size(); k++) {
            //line(width/7 + SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2, (width/7)*6 - SELECTSCREENSHIFT_X, i*gridSize+textHight+gridSize/2);
            //draw_rect(width/7 + SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y + i*gridSize, width*5/7 - SELECTSCREENSHIFT_X*2, gridSize);
            fill(255);
            if (k < validPokemonSearch.size()) {
              if (validPokemonSearch.size() > POKEMON_PER_PAGE) {
                offset = int(((SLIDER.i_y - sliderStartY)*(validPokemonSearch.size() - POKEMON_PER_PAGE)/((height*8/9 - SELECTSCREENSHIFT_Y*2) - SLIDER.i_h)));
              } else {
                offset = 0;
              }
              //println(validPokemonSearch.size(), validPokemonSearch.size()-POKEMON_PER_PAGE, offset, (height/9)*8 - SLIDER.i_h, SLIDER.i_y - sliderStartY);
              draw_text(names_num.get(validPokemonSearch.get(k + offset)), width*43/280 + SELECTSCREENSHIFT_X, textHight + (k+1)*gridSize);
              draw_text(validPokemonSearch.get(k + offset), width*3/14, textHight + (k+1)*gridSize);
              for (int j = 0; j < 2; j++) {
                if (names_types.get(validPokemonSearch.get(k + offset))[j] != null) {
                  draw_text(names_types.get(validPokemonSearch.get(k + offset))[j], width*11/35 + j*(width/20) - SELECTSCREENSHIFT_X, textHight + (k+1)*gridSize);
                }
              }
              for (int j = 0; j < 3; j++) {
                if (names_abilities.get(validPokemonSearch.get(k + offset))[j] != null) {
                  draw_text(names_abilities.get(validPokemonSearch.get(k + offset))[j].replaceAll("-", " "), width*9/20 + j*(width/14) - SELECTSCREENSHIFT_X*1.5, textHight + (k+1)*gridSize);
                }
              }
              BST = 0;
              for (int j = 0; j < 6; j++) {
                BST += names_stats.get(validPokemonSearch.get(k + offset))[j];
                draw_text(names_stats.get(validPokemonSearch.get(k + offset))[j], width*13/20 + j*(width/35) - SELECTSCREENSHIFT_X, textHight + (k+1)*gridSize);
              }
              draw_text(BST, width*115/140 - SELECTSCREENSHIFT_X, textHight + (k+1)*gridSize);
            }
          }

          SLIDER.i_y = sliderStartY;
          pokemonSearch = "";
          validPokemonSearch = new StringList();
          pokemonSearchBool = false;
          pokemonSelectScreen = true;
          mousePressValid = false;
        }
      }
    }
  }
  //fill(0);
  //draw_rect((width/7)*6 - SLIDER.i_w - SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, SLIDER.i_w, (height/9)*8 - SELECTSCREENSHIFT_Y*2);
  fill(255);
  draw_rect(SLIDER.i_x, SLIDER.i_y, SLIDER.i_w, SLIDER.i_h);
  fill(0, 0, 0, 150);
  stroke(255);
  strokeWeight(1);
  draw_rect(SEARCH_BUTTON.i_x, SEARCH_BUTTON.i_y, SEARCH_BUTTON.i_w, SEARCH_BUTTON.i_h);
  fill(255);
  if (pokemonSearchBool == false && pokemonSearch == "") {
    draw_text("Search by Name", width*43/280 + SELECTSCREENSHIFT_X, height/36 + SELECTSCREENSHIFT_Y);
  } else {
    draw_text(pokemonSearch, width*43/280 + SELECTSCREENSHIFT_X, height/36 + SELECTSCREENSHIFT_Y);
  }
  textAlign(CENTER);

  draw_imageMode(CORNER);
  draw_image(back, width*6/7 - SELECTSCREENSHIFT_X - width*23/350 - 10, SEARCH_BUTTON.i_y);
  //rect(1048,90,width*23/350, 50);
  //println(sliderFollow);
  //draw_image(back, 1048, 90);

  if (mousePressed && mousePressValid == true) {   
    if (mouseX <= width*6/7 - SELECTSCREENSHIFT_X - 10 && mouseX >= width*6/7 - SELECTSCREENSHIFT_X - width*23/350 - 10 && mouseY <= SEARCH_BUTTON.i_y + height/18 && mouseY >= SEARCH_BUTTON.i_y) {
      //if (mouseX >= width*6/7 - SELECTSCREENSHIFT_X - width*23/350 - 10 && mouseY >= SEARCH_BUTTON.i_y) {
      //moveSelectScreen = false;
      //mousePressValid = false;
      pokemonSelectScreen = false;
    }
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
  draw_image(pokedex, 0, 0);
  strokeWeight(1);
  stroke(0);
}

void drawPokemonInformationScreen(int slotNumber, int pokeNum, float gridsize) {
  draw_image(backgroundImg, 0, 0);
  if (moveScreenReset == true) {
    level = 100;
    maxEV = 508;
    allPokeMoves = new StringList();
    selectedMoves = new String[4];
    EVRemaining = maxEV;
    selectedAbility = "";
    chooseAbility = false;
    abilityCount = 0;
    shinyBool = false;
    selectedGender = "";
    chooseGender = false;
    maleBool = false;
    femaleBool = false;
    unspecifiedBool = false;
    selectedNature = 0;

    if (num_male.get(pokeNum) != null) {
      selectedGender = genders[0];
      maleBool = true;
    } else if (num_female.get(pokeNum) != null) {
      selectedGender = genders[1];
      femaleBool = true;
    } else if (num_unspecified.get(pokeNum) != null) {
      selectedGender = genders[2];
      unspecifiedBool = true;
    }

    for (int i = 0; i < names_abilities.get(num_names.get(pokeNum)).length; i++) {
      if (names_abilities.get(num_names.get(pokeNum))[i] != null) {
        abilityCount++;
      }
    }
    for (int i = 0; i < 4; i++) {
      selectedMoves[i] = "";
    }    
    for (int i = 0; i < 6; i++) {
      IV[i] = 31;
      EV[i] = 0;
      statSliders.get(i).i_x = statSliderStartX[i];
    }
    for (int i = 0; i < 5; i++) {
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

    moveScreenReset = false;
  } else if (moveScreenReload == true) {
    moveScreenReload = false;
  }
  stats[0] = ((((2*names_stats.get(num_names.get(pokeNum))[0] + IV[0] + int(EV[0]/4))*level))/100 + level + 10);
  stats[1] = (((2*names_stats.get(num_names.get(pokeNum))[1] + IV[1] + int(EV[1]/4))*level)/100 + 5);
  stats[2] = (((2*names_stats.get(num_names.get(pokeNum))[2] + IV[2] + int(EV[2]/4))*level)/100 + 5);
  stats[3] = (((2*names_stats.get(num_names.get(pokeNum))[3] + IV[3] + int(EV[3]/4))*level)/100 + 5);
  stats[4] = (((2*names_stats.get(num_names.get(pokeNum))[4] + IV[4] + int(EV[4]/4))*level)/100 + 5);
  stats[5] = (((2*names_stats.get(num_names.get(pokeNum))[5] + IV[5] + int(EV[5]/4))*level)/100 + 5);
  for (int i = 0; i < 5; i++) {
    if (nature[i] == 1) {
      stats[i+1] *= 1.1;
    } else if (nature[i] == -1) {
      stats[i+1] = int(stats[i+1] / 1.1);
    }
  }
  EVRemaining = maxEV - EV[0] - EV[1] - EV[2] - EV[3] - EV[4] - EV[5];
  //draw_image(pokedex, 0, 0);

  offsetMoves = int((MOVESLIDER.i_y - moveSliderStartY)*(allPokeMoves.size()-MOVES_PER_PAGE)/((height - SELECTSCREENSHIFT_Y - moveSliderStartY)-MOVESLIDER.i_h));
  offsetNature = int((NATURESLIDER.i_y - natureSliderStartY)*(natureName.length-NATURES_PER_PAGE)/((height - SELECTSCREENSHIFT_Y - natureSliderStartY)-NATURESLIDER.i_h));

  if (tempAnimationLoad) {
    tempAnimations = loadPokemonAll(loadJSONObject(POKEINFO_PATH+"pokemon/"+pokeNum+".txt")); 
    tempAnimationLoad = false;
  }
  draw_rectMode(CORNER);
  //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y, width*5/7 - SELECTSCREENSHIFT_X*2 + 100, height - SELECTSCREENSHIFT_Y*2);

  fill(0, 0, 0, 150);
  draw_rect(0, 0, width, height);
  stroke(255);
  for (int i = 0; i < 4; i++) {
    //draw_rect(width/7 + SELECTSCREENSHIFT_X + (height/4)*i, SELECTSCREENSHIFT_Y, height/4, height/4);
    if (i > 0) {
      draw_line(width/7 + SELECTSCREENSHIFT_X + (height/4)*i, SELECTSCREENSHIFT_Y, width/7 + SELECTSCREENSHIFT_X + (height/4)*i, SELECTSCREENSHIFT_Y + height/4);
    }
    draw_imageMode(CENTER);
    drawPokemon(tempAnimations[i], width/7 + SELECTSCREENSHIFT_X + (height/4)*i + height/8, SELECTSCREENSHIFT_Y + height/8);
    draw_imageMode(CORNER);
  }
  draw_line(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4, width*6/7 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4);
  draw_line(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*19/60, width*6/7 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*19/60);
  //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4, width*5/7 - SELECTSCREENSHIFT_X*2, 60);
  draw_image(back, width*3/20 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*23/90);
  draw_image(confirm, width*549/700 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*23/90);

  fill(0, 0, 0, 150);
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  if (shinyBool == false) {
    stroke(100);
    draw_rect(width*16/35, SELECTSCREENSHIFT_Y + height*58/225, width*3/35, height*23/450);
    draw_rect(width*129/280, SELECTSCREENSHIFT_Y + height*79/300, width*3/70, height/25);
    fill(255);
    draw_text("SHINY", width*27/56, SELECTSCREENSHIFT_Y + height*17/60);
  } else {
    stroke(#36FAFF);
    draw_rect(width*16/35, SELECTSCREENSHIFT_Y + height*58/225, width*3/35, height*23/450);
    draw_rect(width*139/280, SELECTSCREENSHIFT_Y + height*79/300, width*3/70, height/25);
    fill(255);
    draw_text("SHINY", width*29/56, SELECTSCREENSHIFT_Y + height*17/60);
  }
  textAlign(LEFT);
  fill(0, 0, 0, 150);
  stroke(0);
  strokeWeight(1);
  //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + 900/4 + 60, width*5/7 - SELECTSCREENSHIFT_X*2, 187);
  if (moveSelect) {
    if (moveSearch == "" && validMoveSearch.size()!= names_moves.get(num_names.get(pokemonNumber))[0].length + names_moves.get(num_names.get(pokemonNumber))[1].length + names_moves.get(num_names.get(pokemonNumber))[2].length + names_moves.get(num_names.get(pokemonNumber))[3].length) {
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < names_moves.get(num_names.get(pokemonNumber))[i].length; j++) {
          validMoveSearch.append(names_moves.get(num_names.get(pokemonNumber))[i][j]);
        }
      }
    }
    //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 248, width*5/7 - SELECTSCREENSHIFT_X*2, 44);
    //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 291, width*5/7 - SELECTSCREENSHIFT_X*2, 224);
    stroke(255);
    draw_line(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*43/75, width*6/7 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*43/75);
    fill(255);
    if (MOVESLIDER.i_y + MOVESLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
      MOVESLIDER.i_y = height - MOVESLIDER.i_h - SELECTSCREENSHIFT_Y;
    } else if (MOVESLIDER.i_y < SELECTSCREENSHIFT_Y + height*43/75) {
      MOVESLIDER.i_y = SELECTSCREENSHIFT_Y + height*43/75;
    }
    draw_rect(MOVESLIDER.i_x, MOVESLIDER.i_y, MOVESLIDER.i_w, MOVESLIDER.i_h);
    for (int i = 0; i < MOVES_PER_PAGE && i + 1 + offsetMoves <= names_moves.get(num_names.get(pokemonNumber))[0].length + names_moves.get(num_names.get(pokemonNumber))[1].length + names_moves.get(num_names.get(pokemonNumber))[2].length + names_moves.get(num_names.get(pokemonNumber))[3].length; i++) {
      if (i < validMoveSearch.size()) {
        if (validMoveSearch.size() > MOVES_PER_PAGE) {
          offsetMoves = int((MOVESLIDER.i_y - moveSliderStartY)*(validMoveSearch.size()-MOVES_PER_PAGE)/((height - SELECTSCREENSHIFT_Y - moveSliderStartY)-MOVESLIDER.i_h));
        } else {
          offsetMoves = 0;
        }
        if (offsetMoves < 0) {
          offsetMoves = 0;
        }

        draw_text(validMoveSearch.get(i + offsetMoves).replaceAll("-", " "), width*43/280 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[0], width*43/280 + SELECTSCREENSHIFT_X + width*3/35, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[1], width*43/280 + SELECTSCREENSHIFT_X + width*9/70, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[2], width*43/280 + SELECTSCREENSHIFT_X + width*6/35, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[3], width*43/280 + SELECTSCREENSHIFT_X + width/5, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[4], width*43/280 + SELECTSCREENSHIFT_X + width*8/35, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        if (textWidth(moves_data.get(validMoveSearch.get(i + offsetMoves))[6]) < textRestrain) {
          draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[6], width*43/280 + SELECTSCREENSHIFT_X + width*9/35, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
        } else {
          for (int j = moves_data.get(validMoveSearch.get(i + offsetMoves))[6].length(); j > 0; j--) {
            if (textWidth(moves_data.get(validMoveSearch.get(i + offsetMoves))[6].substring(0, j) + "...") < textRestrain) {
              draw_text(moves_data.get(validMoveSearch.get(i + offsetMoves))[6].substring(0, j) + "...", width*43/280 + SELECTSCREENSHIFT_X + width*9/35, SELECTSCREENSHIFT_Y + height*521/900 + gridsize/2 + i*gridsize);
              break;
            }
          }
        }
        if (mousePressed && mousePressValid == true) {
          if (mouseX < width*6/7 - MOVESLIDER.i_w - SELECTSCREENSHIFT_X && mouseX >= width/7 + SELECTSCREENSHIFT_X && mouseY < height*521/900 + (i+1)*gridSize + SELECTSCREENSHIFT_Y && mouseY > height*521/900 + i*gridSize + SELECTSCREENSHIFT_Y && moveSliderFollow == false) {
            selectedMoves[moveSlot] = validMoveSearch.get(i + offsetMoves);
            validMoveSearch = new StringList();
            moveSelect = false;
            moveSearch = "";
          }
        }
      }
      textAlign(CENTER);
      draw_text("Move Name", width*43/280 + SELECTSCREENSHIFT_X + moveScreenNamePos/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("Type", width*43/280 + SELECTSCREENSHIFT_X + width*3/35 + textWidth("fighting")/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("Category", width*43/280 + SELECTSCREENSHIFT_X + width*9/70 + textWidth("physical")/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("Pow", width*43/280 + SELECTSCREENSHIFT_X + width*6/35 + textWidth("150")/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("Acc", width*43/280 + SELECTSCREENSHIFT_X + width/5 + textWidth("100")/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("PP", width*43/280 + SELECTSCREENSHIFT_X + width*8/35 + textWidth("60")/2, SELECTSCREENSHIFT_Y + height*499/900);
      draw_text("Description", width*43/280 + SELECTSCREENSHIFT_X + width*9/35 + textRestrain/2, SELECTSCREENSHIFT_Y + height*499/900);
      textAlign(LEFT);

      fill(0, 0, 0, 150);
      stroke(255);
      strokeWeight(1);
      draw_rect(MOVE_SEARCH_BUTTON.i_x, MOVE_SEARCH_BUTTON.i_y, MOVE_SEARCH_BUTTON.i_w, MOVE_SEARCH_BUTTON.i_h);
      fill(255);
      if (moveSearchBool == false && moveSearch == "") {
        draw_text("Search by Move", 950, SELECTSCREENSHIFT_Y + height*499/900);
      } else {
        draw_text(moveSearch, 950, SELECTSCREENSHIFT_Y + height*499/900);
      }
      //println(offsetMoves, allPokeMoves.size(), MOVESLIDER.i_y, offset);

      if (moveSliderFollow == true) {
        if (mouseY >= SELECTSCREENSHIFT_Y + height*43/75 && mouseY <= height - MOVESLIDER.i_h/2 - SELECTSCREENSHIFT_Y) {
          MOVESLIDER.i_y = mouseY - MOVESLIDER.i_h/2;
        } else if (mouseY <= SELECTSCREENSHIFT_Y + height*43/75) {
          MOVESLIDER.i_y = SELECTSCREENSHIFT_Y + height*43/75;
        } else if (mouseY >= height - SELECTSCREENSHIFT_Y - MOVESLIDER.i_h) {
          MOVESLIDER.i_y = height - SELECTSCREENSHIFT_Y - MOVESLIDER.i_h;
        }
      }
    }
  } else if (statSelect == true) {
    fill(255);
    stroke(255);
    draw_line(width*113/280 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*473/900, width*113/280 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*247/300);
    draw_line(width*21/40 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*473/900, width*21/40 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*247/300);
    draw_line(width*23/280 + SELECTSCREENSHIFT_X + (width*5/7 - SELECTSCREENSHIFT_X*2)/2, SELECTSCREENSHIFT_Y + height*259/450, width*57/280 + SELECTSCREENSHIFT_X + (width*5/7 - SELECTSCREENSHIFT_X*2)/2, SELECTSCREENSHIFT_Y + height*259/450);
    //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 60 + 188, 365, 268); 
    //draw_rect(width/7 + SELECTSCREENSHIFT_X + (width*5/7 - SELECTSCREENSHIFT_X*2)/2 + 85, SELECTSCREENSHIFT_Y + height/4 + 60 + 188, 365, 268);    
    //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 60 + 188, (width*5/7 - SELECTSCREENSHIFT_X*2)/2 - 85, 268);    
    //draw_rect(width/7 + SELECTSCREENSHIFT_X + (width*5/7 - SELECTSCREENSHIFT_X*2)/2 - 85, SELECTSCREENSHIFT_Y + height/4 + 60 + 188 + 45, 170, 223);
    //draw_rect(width/7 + SELECTSCREENSHIFT_X + (width*5/7 - SELECTSCREENSHIFT_X*2)/2 - 85, SELECTSCREENSHIFT_Y + height/4 + 60 + 188, 170, 45);

    if (NATURESLIDER.i_y + NATURESLIDER.i_h > height - SELECTSCREENSHIFT_Y) {
      NATURESLIDER.i_y = height - NATURESLIDER.i_h - SELECTSCREENSHIFT_Y;
    } else if (NATURESLIDER.i_y < natureSliderStartY) {
      NATURESLIDER.i_y = natureSliderStartY;
    }
    draw_rect(NATURESLIDER.i_x, NATURESLIDER.i_y, NATURESLIDER.i_w, NATURESLIDER.i_h);
    fill(255);
    textAlign(RIGHT, CENTER);
    draw_text("HP", width*9/40, height*61/90);
    draw_text("Attack", width*9/40, height*64/90);
    draw_text("Deffence", width*9/40, height*67/90);
    draw_text("Sp. Atk.", width*9/40, height*70/90);
    draw_text("Sp. Def.", width*9/40, height*73/90);
    draw_text("Speed", width*9/40, height*76/90);

    textAlign(LEFT, CENTER);
    natureString = natureName[selectedNature];
    if (natureStat[selectedNature].length > 0) {
      natureString += " (+" + natureStat[selectedNature][0] + ", -" + natureStat[selectedNature][1] + ")";
    }
    draw_text("Nature : " + natureString, width*9/40, height*80/90);

    textAlign(RIGHT, CENTER);
    draw_text("Base", width/4, height*29/45);
    for (int i = 0; i < 6; i++) {
      fill(255);
      draw_text(names_stats.get(num_names.get(pokeNum))[i], width/4, height*61/90 + i*(height/30));
      //draw_rect(355, 606 + i*30, 250, 10);
      if (i == 0) {
        fill(-13 + (stats[i]*180)/714, 205, 205);
        draw_rect(width*71/280, height*101/150 + i*(height/30), (stats[i] * (width*5/28)) / 714, height/90);
      } else {
        fill(-13 + (stats[i]*180)/614, 205, 205);
        draw_rect(width*71/280, height*101/150 + i*(height/30), (stats[i] * (width*5/28)) / 614, height/90);
      }
    }
    fill(255);
    textAlign(CENTER, CENTER);
    draw_text("Nature", width/2, height*29/45);
    textAlign(LEFT, CENTER);
    for (int i = 0; i < NATURES_PER_PAGE; i++) {
      offsetNature = max(0, offsetNature);
      natureString = natureName[i + offsetNature];
      if (natureStat[i + offsetNature].length > 0) {
        natureString += " (+" + natureStat[i + offsetNature][0] + ", -" + natureStat[i + offsetNature][1] + ")";
      }
      draw_text(natureString, width*25/56, height*61/90 + i*(height/45));
    }
    draw_text("Remaining EV: " + EVRemaining, width*4/7, height*44/45 - SELECTSCREENSHIFT_Y);
    textAlign(CENTER, CENTER);
    draw_text("EVs", width*163/280, height*29/45);
    draw_text("IVs", width*4/5 - SELECTSCREENSHIFT_X, height*29/45);

    for (int i = 0; i < 6; i++) {
      EV[i] = round((statSliders.get(i).i_x - statSliderStartX[i])*(252)/((width*31/40 - SELECTSCREENSHIFT_X - statSliderStartX[i])-statSliders.get(i).i_w));

      if (statSliderFollow[i] == true) {
        if (mouseX >= statSliderStartX[i] && mouseX <= width*31/40 - SELECTSCREENSHIFT_X - statSliders.get(i).i_w/2) {
          statSliders.get(i).i_x = mouseX - statSliders.get(i).i_w/2;
        } else if (mouseX <= statSliderStartX[i]) {
          statSliders.get(i).i_x = statSliderStartX[i];
        } else if (mouseX >= width*31/40 - SELECTSCREENSHIFT_X - statSliders.get(i).i_w) {
          statSliders.get(i).i_x = width*31/40 - SELECTSCREENSHIFT_X - statSliders.get(i).i_w;
        } 

        EV[i] = round((statSliders.get(i).i_x - statSliderStartX[i])*(252)/((width*31/40 - SELECTSCREENSHIFT_X - statSliderStartX[i])-statSliders.get(i).i_w));

        int EVRemaining = maxEV;
        for (int j=0; j<6; j++) {
          if (i!=j)
            EVRemaining -= EV[j];
        }

        while (EV[i]>EVRemaining) {
          statSliders.get(i).i_x--;
          EV[i] = round((statSliders.get(i).i_x - statSliderStartX[i])*(252)/((width*31/40 - SELECTSCREENSHIFT_X - statSliderStartX[i])-statSliders.get(i).i_w));
        }
      }
      if (statSliders.get(i).i_x + statSliders.get(i).i_w > width*31/40 - SELECTSCREENSHIFT_X) {
        statSliders.get(i).i_x = width*31/40 - SELECTSCREENSHIFT_X;
      } else if (statSliders.get(i).i_x < statSliderStartX[i]) {
        statSliders.get(i).i_x = statSliderStartX[i];
      }

      EV[i] = round((statSliders.get(i).i_x - statSliderStartX[i])*(252)/((width*31/40 - SELECTSCREENSHIFT_X - statSliderStartX[i])-statSliders.get(i).i_w));

      fill(150);
      strokeWeight(0);
      draw_rect(width*169/280, height*152/225 + i*(height/30), width*6/35 - SELECTSCREENSHIFT_X, height/150);
      strokeWeight(1);
      fill(0, 0, 0, 150);
      draw_rect(width*159/280, height*601/900 + i*(height/30), width/35, height/45);
      draw_rect(width*11/14 - SELECTSCREENSHIFT_X, height*601/900 + i*(height/30), width/35, height/45);
      fill(255);
      draw_rect(statSliders.get(i).i_x, statSliders.get(i).i_y, statSliders.get(i).i_w, statSliders.get(i).i_h);
      fill(255);
      textAlign(LEFT, CENTER);
      draw_text(EV[i], width*4/7, height*611/900 + i*(height/30));
      draw_text(IV[i], width*221/280 - SELECTSCREENSHIFT_X, height*611/900 + i*(height/30));
      textAlign(CENTER, CENTER);
      draw_text(stats[i], width*117/140 - SELECTSCREENSHIFT_X, height*611/900 + i*(height/30));
    }

    textAlign(LEFT);
    fill(255);

    if (natureSliderFollow == true) {
      if (mouseY >= natureSliderStartY && mouseY <= height - NATURESLIDER.i_h/2 - SELECTSCREENSHIFT_Y) {
        NATURESLIDER.i_y = mouseY - NATURESLIDER.i_h/2;
      } else if (mouseY <= natureSliderStartY) {
        NATURESLIDER.i_y = natureSliderStartY;
      } else if (mouseY >= height - SELECTSCREENSHIFT_Y - NATURESLIDER.i_h) {
        NATURESLIDER.i_y = height - SELECTSCREENSHIFT_Y - NATURESLIDER.i_h;
      }
    }
  } else {
    fill(0, 0, 0, 150);
    draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*473/900, width*5/7 - SELECTSCREENSHIFT_X*2, height*67/225);
  }
  fill(0, 0, 0, 150);
  stroke(255);
  for (int i = 0; i < 2; i++) {
    //draw_rect(width/7 + SELECTSCREENSHIFT_X + i*((width*5/7 - SELECTSCREENSHIFT_X*2)/3), SELECTSCREENSHIFT_Y + height/4 + 60, (width*5/7 - SELECTSCREENSHIFT_X*2)/3, 188);
    draw_line(width/7 + SELECTSCREENSHIFT_X + (width*3/14)*(i+1), SELECTSCREENSHIFT_Y + height*19/60, width/7 + SELECTSCREENSHIFT_X + (width*3/14)*(i+1), SELECTSCREENSHIFT_Y + height*473/900);
  }
  draw_line(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*473/900, width*6/7 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height*473/900);
  //draw_rect(width/7 + SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y,400,400);
  //draw_rect(width/7 + SELECTSCREENSHIFT_X + 400, SELECTSCREENSHIFT_Y,width*5/7 - SELECTSCREENSHIFT_X*2 - 400,60);
  //for (int i = 0; i < 3; i++) {
  //draw_rect(width/7 + SELECTSCREENSHIFT_X + 400, SELECTSCREENSHIFT_Y + 60 + i*50,width*5/7 - SELECTSCREENSHIFT_X*2 - 400,50);
  //}
  //println(width/7 + SELECTSCREENSHIFT_X + 2*((width*5/7 - SELECTSCREENSHIFT_X*2)/3));
  textAlign(LEFT, CENTER);
  for (int i = 0; i < 4; i++) {
    fill(0, 0, 0, 150);
    draw_rect(width*29/70, height*79/180 + i*(height*2/45), width*6/35, height/30);
    fill(255);
    if (selectedMoves[i] == "") {
      draw_text("Select a move", width*117/280, height*79/180 + i*(height*2/45) + height/60);
    } else {
      draw_text(selectedMoves[i], width*117/280, height*79/180 + i*(height*2/45) + height/60);
    }
  }
  fill(0, 0, 0, 150);
  textAlign(LEFT);

  draw_rect(width*31/140, SELECTSCREENSHIFT_Y + height*31/72, height/30, height/30);
  draw_rect(width/4, SELECTSCREENSHIFT_Y + height*31/72, height/15, height/30);
  draw_rect(width*3/10, SELECTSCREENSHIFT_Y + height*31/72, height/30, height/30);
  draw_rect(width*31/140, height*103/180, width*11/70, height/30);
  draw_rect(width*39/140 + SELECTSCREENSHIFT_X, height*187/450, width/14, height/30);
  draw_rect(width*43/70, height*79/180, width*141/700, height/6, height/90);

  if (chooseAbility) {
    draw_rect(width*31/140, height*103/180, width*11/70, (abilityCount + 1)*(height/30));
    //draw_rect(310, 515, 220, height/30);
  }
  if (chooseGender) {
    draw_rect(width*39/140 + SELECTSCREENSHIFT_X, height*187/450, width/14, height*3/30);
  }
  //draw_rect(896,405, 205,10);
  //println((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5), ((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5)*205)/714, ((names_stats.get(num_names.get(pokeNum))[0]*2  + IV[0] + EV[0] + 5) / 714)*205);
  for (int i = 0; i < 6; i++) {
    if (i == 0) {
      fill(-13 + (stats[i]*180)/714, 205, 205);
      draw_rect(width*179/280, height*9/20, (stats[i] * (width*41/280)) / 714, height/90);
    } else {
      fill(-13 + (stats[i]*180)/614, 205, 205);
      draw_rect(width*179/280, height*9/20 + i*(height*23/900), (stats[i] * (width*41/280)) / 614, height/90);
    }
  }
  fill(255);

  textAlign(CENTER, CENTER);
  draw_text(level, width/4 + height/30, SELECTSCREENSHIFT_Y + height*161/360);
  draw_text("-", width*31/140 + height/60, SELECTSCREENSHIFT_Y + height*161/360);
  draw_text("+", width*3/10 + height/60, SELECTSCREENSHIFT_Y + height*161/360);
  textAlign(LEFT);
  //draw_text("Name: " + num_names.get(pokeNum), 700,150);
  draw_text("Name : " + num_names.get(pokeNum), width*3/20 + SELECTSCREENSHIFT_X, height*79/180);
  draw_text("Gender :", width*67/280 + SELECTSCREENSHIFT_X, height*79/180);
  //+ names_types.get(num_names.get(pokeNum))[0] + " & " + names_types.get(num_names.get(pokeNum))[1]
  draw_text("Types :", width*3/20 + SELECTSCREENSHIFT_X, height*221/450);
  draw_text("Level :", width*3/20 + SELECTSCREENSHIFT_X, height*163/300);
  draw_text("Ability :", width*3/20 + SELECTSCREENSHIFT_X, height*134/225);

  draw_image(type_image.get(names_types.get(num_names.get(pokeNum))[0]), width*3/20 + SELECTSCREENSHIFT_X + 50, height*221/450 - height/80);
  draw_text(names_types.get(num_names.get(pokeNum))[0], width*3/20 + SELECTSCREENSHIFT_X + 53, height*221/450);
  if (names_types.get(num_names.get(pokeNum))[1] != null) {
    draw_image(type_image.get(names_types.get(num_names.get(pokeNum))[1]), width*3/20 + SELECTSCREENSHIFT_X + 60 + int(textWidth(names_types.get(num_names.get(pokeNum))[0])), height*221/450 - height/80);
    draw_text(names_types.get(num_names.get(pokeNum))[1], width*3/20 + SELECTSCREENSHIFT_X + 63 + int(textWidth(names_types.get(num_names.get(pokeNum))[0])), height*221/450);
  }
  //fill(TYPE_COLOURS.get(names_types.get(num_names.get(pokeNum))[0]));
  //rectMode(CORNER);
  ///draw_rect(width/7 + SELECTSCREENSHIFT_X + 200, height*221/450, int(textWidth(names_types.get(num_names.get(pokeNum))[0])+4), 14);
  //fill(255);
  //draw_text(names_types.get(num_names.get(pokeNum))[0], width/7 + SELECTSCREENSHIFT_X + 200, height*221/450 + 7);
  //if (names_types.get(num_names.get(pokeNum))[1] != null) {
  //fill(TYPE_COLOURS.get(names_types.get(num_names.get(pokeNum))[1]));
  //draw_rect(width*3/20 + SELECTSCREENSHIFT_X + 10, height*221/450, int(textWidth(names_types.get(num_names.get(pokeNum))[1])+4), 14);
  //fill(255);
  //draw_text(names_types.get(num_names.get(pokeNum))[1], width*3/20 + SELECTSCREENSHIFT_X + 8 + 100, height*221/450);
  //}

  if (maleBool) {
    draw_text("Male", width*79/280 + SELECTSCREENSHIFT_X, height*79/180);
  } else if (femaleBool) {
    draw_text("Female", width*79/280 + SELECTSCREENSHIFT_X, height*79/180);
  } else if (unspecifiedBool) {
    draw_text("Unspecified", width*79/280 + SELECTSCREENSHIFT_X, height*79/180);
  } else if (selectedGender == "" || chooseGender == true) {
    draw_text("Select a gender", width*79/280 + SELECTSCREENSHIFT_X, height*79/180);
  } else {
    draw_text(selectedGender, width*79/280 + SELECTSCREENSHIFT_X, height*79/180);
  }

  if (chooseGender) {
    for (int i = 0; i < 2; i++) {
      draw_text(genders[i], width*79/280 + SELECTSCREENSHIFT_X, height*79/180 + (i+1)*height/30);
    }
  }

  textAlign(LEFT, CENTER);
  if (selectedAbility == "" || chooseAbility == true) {
    draw_text("Select an ability", width*8/35, height*103/180 + height/60);
  } else {
    draw_text(selectedAbility, width*8/35, height*103/180 + height/60);
  }


  if (chooseAbility) {
    for (int i = 0; i < abilityCount; i++) {
      if (names_abilities.get(num_names.get(pokeNum))[i] == null) {
        draw_text(names_abilities.get(num_names.get(pokeNum))[i+1], width*8/35, height*103/180 + height/60 + (i+1)*height/30);
      } else {
        draw_text(names_abilities.get(num_names.get(pokeNum))[i], width*8/35, height*103/180 + height/60 + (i+1)*height/30);
      }
    }
  }  
  textAlign(LEFT);
  draw_text("Moves", width*2/5, height*77/180);
  draw_text("1.", width*2/5, height*83/180);
  draw_text("2.", width*2/5, height*91/180);
  draw_text("3.", width*2/5, height*11/20);
  draw_text("4.", width*2/5, height*107/180);
  draw_text("Stats", width*87/140, height*77/180);
  textAlign(RIGHT);
  draw_text("HP", width*89/140, height*83/180);
  draw_text("ATK", width*89/140, height*73/150);
  draw_text("DEF", width*89/140, height*461/900);
  draw_text("SPA", width*89/140, height*121/225);
  draw_text("SPD", width*89/140, height*169/300);
  draw_text("SPE", width*89/140, height*53/90);
  textAlign(LEFT);
  fill(255);

  if (mousePressed && mousePressValid == true) {
    if (moveSliderFollow == false && natureSliderFollow == false && statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
      if (mouseX <= width*19/35 && mouseX >= width*16/35 && mouseY <= SELECTSCREENSHIFT_Y + height*139/450 && mouseY >= SELECTSCREENSHIFT_Y + height*58/225) {
        shinyBool = !shinyBool;
        mousePressValid = false;
      }
      if (mouseX <= width*17/20 - SELECTSCREENSHIFT_X && mouseX >= width*559/700 - SELECTSCREENSHIFT_X && mouseY <= SELECTSCREENSHIFT_Y + height*23/90 + height/18 && mouseY >= SELECTSCREENSHIFT_Y + height*23/90) {
        if (selectedAbility == "") {
          selectedAbility = names_abilities.get(num_names.get(pokeNum))[0];
        }
        if (selectedGender == "") {
          selectedGender = "Male";
        }
        moveSearch = "";
        pokemons.set(slotNumber, new Pokemon(pokeNum, shinyBool, level, selectedAbility, stats, selectedMoves));
        pokemonSelectScreen = false;
        moveSelectScreen = false;
        //moveScreenReset = true;
        tempAnimationLoad = true;
        mousePressValid = false;
      }
      if (mouseX <= width*151/700 + SELECTSCREENSHIFT_X && mouseX >= width*3/20 + SELECTSCREENSHIFT_X && mouseY <= SELECTSCREENSHIFT_Y + height*23/90 + height/18 && mouseY >= SELECTSCREENSHIFT_Y + height*23/90) {
        moveSelectScreen = false;
        mousePressValid = false;
      }
      if (mouseX <= width*53/140 && mouseX >= width*31/140 && mouseY <= height*103/180 + height/30 && mouseY >= height*103/180) {
        chooseAbility = true;
      } else if (mouseX > width*53/140 || mouseX < width*31/140 || mouseY > height*103/180 + (height/30)*(abilityCount+1) || mouseY < height*103/180) {
        chooseAbility = false;
      }
      if (maleBool == false && femaleBool == false && unspecifiedBool == false) {
        if (mouseX <= width*7/20 + SELECTSCREENSHIFT_X && mouseX >= width*39/140 + SELECTSCREENSHIFT_X && mouseY <= height*187/450 + height/30 && mouseY >= height*187/450) {
          chooseGender = true;
        }
      }
    }
    if (chooseGender == false) {
      if (mouseX < width*39/140 + SELECTSCREENSHIFT_X || mouseX > width*7/20 + SELECTSCREENSHIFT_X || mouseY > height*187/450 + height/30 || mouseY < height*187/450) {
        chooseGender = false;
      }
    } else {
      if (mouseX < width*39/140 + SELECTSCREENSHIFT_X || mouseX > width*7/20 + SELECTSCREENSHIFT_X|| mouseY > height*187/450 + height*3/30 || mouseY < height*187/450) {
        chooseGender = false;
      }
    }
    if (chooseAbility == true) {
      for (int i = 0; i < abilityCount; i++) {
        if (mouseX <= width*53/140 && mouseX >= width*31/140 && mouseY <= height*103/180 + (i+2)*(height/30) && mouseY >= height*103/180 + (i+1)*(height/30)) {
          if (names_abilities.get(num_names.get(pokeNum))[i] == null) {
            selectedAbility = names_abilities.get(num_names.get(pokeNum))[i+1];
          } else {
            selectedAbility = names_abilities.get(num_names.get(pokeNum))[i];
          }
          chooseAbility = false;
        }
      }
    }
    if (chooseGender == true) {
      for (int i = 0; i < 2; i++) {
        if (mouseX <= width*7/20 + SELECTSCREENSHIFT_X && mouseX >= width*39/140 + SELECTSCREENSHIFT_X && mouseY <= height*187/450 + (i+2)*height/30 && mouseY >= height*187/450 + (i+1)*height/30) {
          selectedGender = genders[i];
          chooseGender = false;
        }
      }
    }
    if (moveSelect == false) {
      if (mouseX <= width*571/700 && mouseX >= width*43/70 && mouseY <= height*109/180 && mouseY >= height*59/180) {
        statSelect = true;
      }
    }
    if (mouseY <= SELECTSCREENSHIFT_Y + height*31/72 + height/30 && mouseY >= SELECTSCREENSHIFT_Y + height*31/72) {
      if (mouseX <= width*31/140 + height/30 && mouseX >= width*31/140) {
        if (level > 0 && moveSliderFollow == false && natureSliderFollow == false && statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
          level -= 1;
          mousePressValid = false;
        }
      }
      if (mouseX <= width*3/10 + height/30 && mouseX >= width*3/10) {
        if (level < 100 && moveSliderFollow == false && natureSliderFollow == false && statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
          level += 1;
          mousePressValid = false;
        }
      }
    }
    if (natureSliderFollow == false && statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
      for (int i = 0; i < 4; i++) {
        if (mouseX <= width*41/70 && mouseX >= width*29/70 && mouseY <= height*17/36 + i*(height*2/45) && mouseY >= height*79/180 + i*(height*2/45)) {
          moveSelect = true;
          moveSlot = i;
        }
      }
    }
    if (moveSelect) {
      if (mouseX >= MOVESLIDER.i_x && mouseX <= MOVESLIDER.i_x + MOVESLIDER.i_w && mouseY >= MOVESLIDER.i_y && mouseY <= MOVESLIDER.i_y + MOVESLIDER.i_h) {
        moveSliderFollow = true;
      }    
      if (mouseX <= MOVE_SEARCH_BUTTON.i_x + MOVE_SEARCH_BUTTON.i_w && mouseX >= MOVE_SEARCH_BUTTON.i_x && mouseY <= MOVE_SEARCH_BUTTON.i_y + MOVE_SEARCH_BUTTON.i_h && mouseY >= MOVE_SEARCH_BUTTON.i_y) {
        moveSearchBool = true;
      } else {
        moveSearchBool = false;
      }
    } else if (statSelect) {
      if (moveSelect == false && natureSliderFollow == false && statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
        for (int i = 0; i < NATURES_PER_PAGE; i++) {
          if (mouseX <= width*157/280 - NATURESLIDER.i_w && mouseX >= width*123/280 && mouseY <= natureSliderStartY + (i+1)*(height/45) && mouseY >= natureSliderStartY + i*(height/45)) {
            selectedNature = i + offsetNature;
            if (natureStat[i + offsetNature].length > 0) {
              for (int j = 0; j < 5; j++) {
                if (natureStat[i + offsetNature][0] == natureAbility[j]) {
                  nature[j] = 1;
                } else if (natureStat[i + offsetNature][1] == natureAbility[j]) {
                  nature[j] = -1;
                } else {
                  nature[j] = 0;
                }
              }
            } else {
              for (int j = 0; j < 5; j++) {
                nature[j] = 0;
              }
            }
            mousePressValid = false;
          }
        }
      }
      if (statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false) {
        if (mouseX >= NATURESLIDER.i_x && mouseX <= NATURESLIDER.i_x + NATURESLIDER.i_w && mouseY >= NATURESLIDER.i_y && mouseY <= NATURESLIDER.i_y + NATURESLIDER.i_h) {
          natureSliderFollow = true;
        }
      }
      for (int i = 0; i < 6; i++) {
        if (EVRemaining >= 0) {
          if (statSliderFollow[0] == false && statSliderFollow[1] == false && statSliderFollow[2] == false && statSliderFollow[3] == false && statSliderFollow[4] == false && statSliderFollow[5] == false && natureSliderFollow == false) {
            if (mouseX <= statSliders.get(i).i_x + statSliders.get(i).i_w && mouseX >= statSliders.get(i).i_x && mouseY <= statSliders.get(i).i_y + statSliders.get(i).i_h && mouseY >= statSliders.get(i).i_y) {
              statSliderFollow[i] = true;
              lastSliderTouched = i;
            }
          }
        }
      }
    }
  } else {
    moveSliderFollow = false;
    natureSliderFollow = false;
    for (int i = 0; i < 6; i++) {
      statSliderFollow[i] = false;
    }
  }
  draw_image(pokedex, 0, 0);
}

void drawPokemon(PImage[] pAnimation, int x, int y, float s) {
  if (pAnimation.length>0) {
    pushMatrix();
    translate(x, y);
    scale(s, s);
    draw_image(pAnimation[(int) frameCount%pAnimation.length], 0, 0);
    popMatrix();
  }
}

void drawPokemon(PImage[] pAnimation, int x, int y) {
  drawPokemon(pAnimation, x, y, 1);
}

void setup() {
  size(1400, 900, P2D);
  //fullScreen();
  //size(displayWidth, displayHeight, P2D);
  frameRate(50);
  draw_imageMode(CENTER);
  noSmooth();
  colorMode(HSB);

  myClient = new Client(this, IPv4, PORT);

  init_constants();

  Gif.tmpPath = dataPath("");

  validPokemonSearch = new StringList();
  validMoveSearch = new StringList();

  infoButton = loadImage("infoButton.png");
  pokeBall = loadImage("Pokeball.png");
  settingsButton = loadImage("Settings.png");
  backgroundImg = loadImage("Background.jpg");
  startButton = loadImage("Button.jpg");
  pokedex = loadImage("pokedex2.png");
  back = loadImage("back.png");
  confirm = loadImage("Confirm.png");

  settingsButton.resize(width/28, height/18);
  pokeBall.resize(height/30, height/30);
  infoButton.resize(height/30, height/30);
  backgroundImg.resize(width, height);
  startButton.resize(START_BUTTON.i_w, START_BUTTON.i_h);
  pokedex.resize(width, height);
  back.resize(width*23/350, height/18);
  confirm.resize(width*23/350, height/18);

  for (int i = 0; i < types.length; i++) {
    tempImage = loadImage(types[i] + ".png");
    tempImage.resize(int(textWidth(types[i]) + 6), height/60);
    type_image.put(types[i], tempImage);
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
      if (file.getJSONArray("levelmoves").getJSONObject(j).getString("move") != "error") {
        levelMoves[j] = file.getJSONArray("levelmoves").getJSONObject(j).getString("move");
      }
    }
    String[] eggMoves = new String[file.getJSONArray("eggmoves").size()];
    for (int j = 0; j < file.getJSONArray("eggmoves").size(); j++) {
      if (file.getJSONArray("eggmoves").getJSONObject(j).getString("move") != "error") {
        eggMoves[j] = file.getJSONArray("eggmoves").getJSONObject(j).getString("move");
      }
    }
    String[] tutorMoves = new String[file.getJSONArray("tutormoves").size()];
    for (int j = 0; j < file.getJSONArray("tutormoves").size(); j++) {
      if (file.getJSONArray("tutormoves").getJSONObject(j).getString("move") != "error") {
        tutorMoves[j] = file.getJSONArray("tutormoves").getJSONObject(j).getString("move");
      }
    }
    String[] tmMoves = new String[file.getJSONArray("tmmoves").size()];
    for (int j = 0; j < file.getJSONArray("tmmoves").size(); j++) {
      if (file.getJSONArray("tmmoves").getJSONObject(j).getString("move") != "error") {
        tmMoves[j] = file.getJSONArray("tmmoves").getJSONObject(j).getString("move");
      }
    }
    String[][] allMoves = {levelMoves, eggMoves, tutorMoves, tmMoves};
    names_moves.put(file.getString("name"), allMoves);
  }

  pokemons = new ArrayList<Pokemon>();
  for (int i = 0; i < 6; i ++) {
    int pokemonNumber = int(random(1, 808));
    int[] statListPoke = {
      (2*names_stats.get(num_names.get(pokemonNumber))[0] + 31 + int(88/4))*100/100 + 100 + 10, 
      (2*names_stats.get(num_names.get(pokemonNumber))[1] + 31 + int(84/4))*100/100 + 5, 
      (2*names_stats.get(num_names.get(pokemonNumber))[2] + 31 + int(84/4))*100/100 + 5, 
      (2*names_stats.get(num_names.get(pokemonNumber))[3] + 31 + int(84/4))*100/100 + 5, 
      (2*names_stats.get(num_names.get(pokemonNumber))[4] + 31 + int(84/4))*100/100 + 5, 
      (2*names_stats.get(num_names.get(pokemonNumber))[5] + 31 + int(84/4))*100/100 + 5
    };
    String[] movelistPoke = new String[4];
    String[][] l_possible_moves = names_moves.get(num_names.get(pokemonNumber));
    // generate ranbo moves

    Set<String> l_possible_moves_condensed = new HashSet<String>();
    for (int k=0; k<l_possible_moves.length; k++) {
      for (int j=0; j<l_possible_moves[k].length; j++) {
        l_possible_moves_condensed.add(l_possible_moves[k][j]);
      }
    }
    l_possible_moves_condensed.remove("error");

    for (int j=0; j<movelistPoke.length && l_possible_moves_condensed.size()>0; j++) {
      int item = int(random(l_possible_moves_condensed.size()));
      int k = 0;
      for (String cur_move : l_possible_moves_condensed)
      {
        if (k == item) {
          movelistPoke[j] = cur_move;
          l_possible_moves_condensed.remove(cur_move);
          break;
        }
        k++;
      }

      //int i_rand_cat_move = int(random(l_possible_moves_condensed.size()));
      //movelistPoke[j] = l_possible_moves_condensed.get(i_rand_cat_move);
    }

    pokemons.add(new Pokemon(pokemonNumber, boolean(int(random(0, 2))), 100, names_abilities.get(num_names.get(pokemonNumber))[0], statListPoke, movelistPoke));
  }
  for (int i = 0; i < male.length; i++) {
    num_male.put(names_num.get(male[i]), male[i]);
  }
  for (int i = 0; i < female.length; i++) {
    num_female.put(names_num.get(female[i]), female[i]);
  }
  for (int i = 0; i < unspecified.length; i++) {
    num_unspecified.put(names_num.get(unspecified[i]), unspecified[i]);
  }
  /*println(names_stats.get("bulbasaur"));
   println(names_types.get("bulbasaur"));
   println(names_species.get("bulbasaur"));
   println(names_height_weight.get("bulbasaur"));
   println(names_abilities.get("bulbasaur"));
   println();
   println(names_moves.get("bulbasaur"));
   println(names_moves.get("bulbasaur")[1]);*/

  init_console();
  init_battle_screen();
}

void draw() {

  recieve_data();

  background(0);
  stroke(0);

  if (i_battle_state == BATTLING) {
    draw_battle();
  } else {

    drawStartScreen();
    if (moveSelectScreen == true) {
      drawPokemonInformationScreen(pokemonSlotNumber, pokemonNumber, gridSize);
    } else if (pokemonSelectScreen == true) {
      drawPokemonSelectionScreen(pokemonChangeNumber);
    } else if (drawSettingScreen) {
      drawSettingScreen();
    }
    if (i_battle_state == SEARCHING) {
      fill(50, 50);
      draw_rect(0, 0, width, height);
    }
  }

  for (int i=0; i<1; i++) {
    if (random(100)<50) {
      String new_text = num_names.get(int(random(1, 808)));
      add_text_effect(new_text, int(random(width)), int(random(height)), TYPE_COLOURS.get(names_types.get(new_text)[0]));
    }
  }

  draw_all_effects();

  draw_console();
}
