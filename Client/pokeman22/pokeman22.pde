/*
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

boolean transitionStart = false; 

boolean sliderFollow = false;

int pokemonChangeNumber;
boolean pokemonSelectScreen = false;

float mouseWheelChange = 0;

String pokemonSearch = "";
String alphabet_lower = "abcdefghijklmnopqrstuvwxyz";
String alphabet_upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
String punctuation = " -:";

boolean pokemonSearchBool = false;

StringList validPokemonSearch;

PImage infoButton;
PImage pokeBall;
PImage settingsButton;
PImage backgroundImg;

//int[] settingsButton = {width - 60, 60, 100, 100};

PImage[][] loadPokemon(int num, JSONObject file, boolean shiny) {
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
  text("Find Match", START_BUTTON.i_x, START_BUTTON.i_y);
  //text("Find Match", startButton[0], startButton[1]);
  //text("Settings", settingsButton[0], settingsButton[1]);
  fill(255);
  textAlign(CORNER);

  if (mousePressed && mousePressValid == true && pokemonSelectScreen == false) {
    for (int i = 0; i < 6; i++) {
      if (dist(mouseX, mouseY, POKEBALL.i_x + i*POKEMON_BUTTON.i_w, POKEBALL.i_y) <= height/60) {
        println("HEYEHEYEHEHEHHEHE", i);
        pokemonChangeNumber = i;
        pokemonSelectScreen = true;
        //pokemons.set(i, new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
        mousePressValid = false;
      }
      if (dist(mouseX, mouseY, INFO_BUTTON.i_x + i*POKEMON_BUTTON.i_w, INFO_BUTTON.i_y) <= height/60) {
        println("sdjfghsldjkhfgasldhjfg", i);
        mousePressValid = false;
      }
    }
  }

  // line(width/2, 0, width/2, height);
  //line(0, height/2, width, height/2);
}

void drawPokemonSelectionScreen(int slotNumber) {

  float gridSize = (height - height/9)*1.0f/POKEMON_PER_PAGE;
  int BST = 0;
  float textHight = height/9-10;

  rectMode(CORNER);
  rect(width/7, height/9, width*5/7, (height/9)*8);
  rect(width/7, 0, width*5/7, height/9);
  //rect(width/7, height/18, width*5/7, height/18);

  fill(0);
  text("Number", (width/280)*43, textHight);
  text("Name", (width/14)*3, textHight);
  text("Types", (width/56)*19, textHight);
  text("Abilities", width/2, textHight);
  text("HP", (width/20)*13, textHight);
  text("ATK", (width/28)*19, textHight);
  text("DEF", (width/140)*99, textHight);
  text("SPA", (width/140)*103, textHight);
  text("SPD", (width/140)*107, textHight);
  text("SPE", (width/140)*111, textHight);
  text("BST", (width/140)*115, textHight);

  rect((width/7)*6 - SLIDER.i_w, height/9, SLIDER.i_w, (height/9)*8);

  textHight = - gridSize/2 + height/9;

  textAlign(LEFT, CENTER);

  offset = int((SLIDER.i_y - sliderStartY)*(807.0-POKEMON_PER_PAGE)/((height/9.0)*8.0-SLIDER.i_h));
  for (int i = 0; i < POKEMON_PER_PAGE && i + 1 + offset <= num_names.size(); i++) {
    line(width/7, i*gridSize+textHight+gridSize/2, (width/7)*6, i*gridSize+textHight+gridSize/2);
    if (pokemonSearch == "") {
      text(i + 1 + offset, (width/280)*43, textHight + (i+1)*gridSize);
      text(num_names.get(i + 1 + offset), (width/14)*3, textHight + (i+1)*gridSize);
      for (int j = 0; j < 2; j++) {
        if (names_types.get(num_names.get(i + 1 + offset))[j] != null) {
          text(names_types.get(num_names.get(i + 1 + offset))[j], (width/35)*11 + j*(width/20), textHight + (i+1)*gridSize);
        }
      }
      for (int j = 0; j < 3; j++) {
        if (names_abilities.get(num_names.get(i + 1 + offset))[j] != null) {
          text(names_abilities.get(num_names.get(i + 1 + offset))[j], (width/20)*9 + j*(width/20), textHight + (i+1)*gridSize);
        }
      }
      BST = 0;
      for (int j = 0; j < 6; j++) {
        BST += names_stats.get(num_names.get(i + 1 + offset))[j];
        text(names_stats.get(num_names.get(i + 1 + offset))[j], (width/20)*13 + j*(width/35), textHight + (i+1)*gridSize);
      }
      text(BST, (width/140)*115, textHight + (i+1)*gridSize);
      if (mousePressed && mousePressValid == true) {
        if (mouseX < (width/7)*6 - SLIDER.i_w && mouseX >= width/7 && mouseY < (height/45)*7 + i*gridSize && mouseY > height/9 + i*gridSize && sliderFollow == false) {
          pokemons.set(pokemonChangeNumber, new Pokemon(i+1+offset, boolean(int(random(0, 2)))));
          SLIDER.i_y = sliderStartY;
          pokemonSelectScreen = false;
          mousePressValid = false;
        }
      }
    } else {
      if (i < validPokemonSearch.size()) {
        if (validPokemonSearch.size() > POKEMON_PER_PAGE) {
          offset = int(((SLIDER.i_y - sliderStartY)*(validPokemonSearch.size() - POKEMON_PER_PAGE)/((height/9)*8 - SLIDER.i_h)));
        } else {
          offset = 0;
        }
        println(validPokemonSearch.size(), validPokemonSearch.size()-POKEMON_PER_PAGE, offset, (height/9)*8 - SLIDER.i_h, SLIDER.i_y - sliderStartY);
        text(names_num.get(validPokemonSearch.get(i + offset)), (width/280)*43, textHight + (i+1)*gridSize);
        text(validPokemonSearch.get(i + offset), (width/14)*3, textHight + (i+1)*gridSize);
        for (int j = 0; j < 2; j++) {
          if (names_types.get(validPokemonSearch.get(i + offset))[j] != null) {
            text(names_types.get(validPokemonSearch.get(i + offset))[j], (width/35)*11 + j*(width/20), textHight + (i+1)*gridSize);
          }
        }
        for (int j = 0; j < 3; j++) {
          if (names_abilities.get(validPokemonSearch.get(i + offset))[j] != null) {
            text(names_abilities.get(validPokemonSearch.get(i + offset))[j], (width/20)*9 + j*(width/20), textHight + (i+1)*gridSize);
          }
        }
        BST = 0;
        for (int j = 0; j < 6; j++) {
          BST += names_stats.get(validPokemonSearch.get(i + offset))[j];
          text(names_stats.get(validPokemonSearch.get(i + offset))[j], (width/20)*13 + j*(width/35), textHight + (i+1)*gridSize);
        }
        text(BST, (width/140)*115, textHight + (i+1)*gridSize);
        if (mousePressed && mousePressValid == true) {
          if (mouseX < (width/7)*6 - SLIDER.i_w && mouseX >= width/7 && mouseY < (height/45)*7 + i*gridSize && mouseY > height/9 + i*gridSize && sliderFollow == false) {
            pokemons.set(pokemonChangeNumber, new Pokemon(names_num.get(validPokemonSearch.get(i + offset)), boolean(int(random(0, 2)))));
            SLIDER.i_y = sliderStartY;
            pokemonSearch = "";
            pokemonSearchBool = false;
            pokemonSelectScreen = false;
            mousePressValid = false;
          }
        }
      }
    }
  }
  fill(255);
  rect(SLIDER.i_x, SLIDER.i_y, SLIDER.i_w, SLIDER.i_h);
  rect(SEARCH_BUTTON.i_x, SEARCH_BUTTON.i_y, SEARCH_BUTTON.i_w, SEARCH_BUTTON.i_h);
  textAlign(LEFT);
  fill(0);
  if (pokemonSearchBool == false) {
    text("Search by Name", width/7 + 15, 30);
  } else {
    text(pokemonSearch, width/7 + 15, 30);
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
        pokemonSearchBool = false;
      }
    }
  } else {
    sliderFollow = false;
  }

  if (sliderFollow == true) {
    if (mouseY >= height/9 && mouseY <= height - SLIDER.i_h/2) {
      SLIDER.i_y = mouseY - SLIDER.i_h/2;
    } else if (mouseY <= height/9) {
      SLIDER.i_y = height/9;
    } else if (mouseY >= height - SLIDER.i_h) {
      SLIDER.i_y = height - SLIDER.i_h;
    }
  }
  if (SLIDER.i_y + SLIDER.i_h > height) {
    SLIDER.i_y = height - SLIDER.i_h;
  } else if (SLIDER.i_y < height/9) {
    SLIDER.i_y = height/9;
  }
}

void drawPokemonInformationScreen(int slotNumber) {
}

void drawPokemon(PImage[] pAnimation, int x, int y) {
  if (pAnimation.length>0) {
    image(pAnimation[(int) frameCount%pAnimation.length], x, y);
  }
}

void setup() {
  size(1400, 900, P2D);
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
  settingsButton = loadImage("settingsButton.png");
  backgroundImg = loadImage("Background.jpg");

  settingsButton.resize(width/28, height/18);
  pokeBall.resize((width/140)*3, height/30);
  infoButton.resize((width/140)*3, height/30);
  backgroundImg.resize(width, height);

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
    String[] abilities = {file.getString("ability1"), file.getString("ability2"), file.getString("hiddenability")};
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
  drawStartScreen();
  if (pokemonSelectScreen == true) {
    drawPokemonSelectionScreen(pokemonChangeNumber);
  }
}