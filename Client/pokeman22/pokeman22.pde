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
HashMap<String, Integer> type_colors = new HashMap<String, Integer>();

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

PImage[] pokemonImages = new PImage[807];

int offset = 0;

boolean transitionStart = false; 

boolean sliderFollow = false;

int sliderH = 20;
int sliderW = 10;
int sliderX;
int sliderY;

int pokemonChangeNumber;
boolean pokemonSelectScreen = false;

int sliderStartY;

String fileName = ".\\pokeinfo\\";

class Pokemon {
  String name, type1, type2, species, h, weight, ability1, ability2, hiddenability, move1, move2, move3, move4, ability;
  int number, HP, ATK, DEF, SPA, SPD, SPE;
  Boolean shiny;
  String[][] moves;
  PImage[] animation;
  PImage[] animationBack;
  Pokemon (int num, Boolean s /*, String m1, String m2, String m3, String m4, String ab*/) {
    pokemonLocation = loadJSONObject(fileName+"pokemon\\"+num+".txt");
    //pokemonLocation = loadJSONObject("https://raw.githubusercontent.com/Komputer-Kids-Klub/pokeman/master/pokeinfo/pokemon/"+num+".txt");

    // All Strings
    name = pokemonLocation.getString("name");
    type1 = pokemonLocation.getString("type1");
    type2 = pokemonLocation.getString("type2");
    species = pokemonLocation.getString("species");
    h = pokemonLocation.getString("height");
    weight = pokemonLocation.getString("weight");
    ability1 = pokemonLocation.getString("ability1");
    ability2 = pokemonLocation.getString("ability2");
    hiddenability = pokemonLocation.getString("hiddenabililty");

    // All Integers
    number = num;
    HP = int(pokemonLocation.getString("HP"));
    ATK = int(pokemonLocation.getString("ATK"));
    DEF = int(pokemonLocation.getString("DEF"));
    SPA = int(pokemonLocation.getString("SPA"));
    SPD = int(pokemonLocation.getString("SPD"));
    SPE = int(pokemonLocation.getString("SPE"));

    shiny = s;

    // All String Arrays
    moves = names_moves.get(name);

    // All PImage Arrays
    PImage[][] animations = loadPokemon(num, pokemonLocation, s);
    if (s) {
      animation = animations[0];
      animationBack = animations[1];
    } else {
      animation = animations[0];
      animationBack = animations[1];
    }

    // All Given
    /*
    move1 = m1;
     move2 = m2;
     move3 = m3;
     move4 = m4;
     ability = ab;
     */
  }
}

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

  JSONObject move_json = loadJSONObject(fileName+"move\\"+move_name+".txt");
  //JSONObject move_json = loadJSONObject("https://raw.githubusercontent.com/Komputer-Kids-Klub/pokeman/master/pokeinfo/move/"+move_name+".txt");

  //println(move_json.getString("type"));
  fill(type_colors.get(move_json.getString("type")));
  rect(300, 700, 600, 100);

  fill(255); 
  text(move_json.getString("name"), 400, 720);

  //fill(type_colors.get(move_json.getString("type")));
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
  PImage infoButton = loadImage("infoButton.png");
  infoButton.resize(30, 30);
  PImage pokeBall = loadImage("Pokeball.png");
  pokeBall.resize(30, 30);
  PImage settingsButton = loadImage("settingsButton.png");
  settingsButton.resize(50, 50);

  int[] startButton = {width/2, height/2 + 50, 400, 100};
  int[] pokemonButton = {width/2 - 500, height - 150, 200, 200};
  //int[] settingsButton = {width - 60, 60, 100, 100};

  int infoButtonX = pokemonButton[0] - pokemonButton[2]/2+ 18;
  int infoButtonY = pokemonButton[1] + pokemonButton[3]/2 - 18;
  int pokeBallX = pokemonButton[0] + pokemonButton[2]/2 - 18;
  int pokeBallY = pokemonButton[1] + pokemonButton[3]/2 - 18;

  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  rect(startButton[0], startButton[1], startButton[2], startButton[3]);
  for (int i = 0; i < 6; i++) {
    rect(pokemonButton[0] + i*pokemonButton[2], pokemonButton[1], pokemonButton[2], pokemonButton[3]);
    drawPokemon(pokemons.get(i).animation, pokemonButton[0] + i*pokemonButton[2], pokemonButton[1]);
    fill(0);
    text(pokemons.get(i).name, pokemonButton[0] + i*pokemonButton[2], pokemonButton[1] + pokemonButton[3]/2 - 10);
    fill(255);
    image(infoButton, infoButtonX + i*pokemonButton[2], infoButtonY);
    image(pokeBall, pokeBallX + i*pokemonButton[2], pokeBallY);
  }
  image(settingsButton, width-30, 30);
  //rect(settingsButton[0], settingsButton[1], settingsButton[2], settingsButton[3]);
  imageMode(CORNER);
  textAlign(CORNER);
  rectMode(CORNER);

  textAlign(CENTER);
  fill(0);
  text("Find Match", startButton[0], startButton[1]);
  //text("Find Match", startButton[0], startButton[1]);
  //text("Settings", settingsButton[0], settingsButton[1]);
  fill(255);
  textAlign(CORNER);

  if (mousePressed && mousePressValid) {
    for (int i = 0; i < 6; i++) {
      if (dist(mouseX, mouseY, pokeBallX + i*pokemonButton[2], pokeBallY) <= 15) {
        println("HEYEHEYEHEHEHHEHE", i);
        pokemonChangeNumber = i;
        pokemonSelectScreen = true;
        //pokemons.set(i, new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
        mousePressValid = false;
      }
      if (dist(mouseX, mouseY, infoButtonX + i*pokemonButton[2], infoButtonY) <= 15) {
        println("sdjfghsldjkhfgasldhjfg", i);
        mousePressValid = false;
      }
    }
  }

  // line(width/2, 0, width/2, height);
  //line(0, height/2, width, height/2);
}

void drawPokemonSelectionScreen(int slotNumber) {
  rectMode(CORNER);
  println(height/9);
  offset = int(((sliderY - sliderStartY)*792)/580);
  rect(width/7, height/9, width/1.4, (height/9)*8);
  rect(width/7, 0, width/1.4, height/18);
  rect(width/7, height/18, width/1.4, height/18);

  fill(0);
  int textHight = (height/180)*17;
  text("Number", (width/280)*43, textHight);
  text("Name", (width/3)*14, textHight);
  text("Types", (width/56)*19, textHight);
  text("Abilities", width/2, textHight);
  text("HP", (width/20)*13, textHight);
  text("ATK", (width/28)*19, textHight);
  text("DEF", (width/140)*99, textHight);
  text("SPA", (width/140)*103, textHight);
  text("SPD", (width/140)*107, textHight);
  text("SPE", (width/140)*111, textHight);
  text("BST", (width/140)*115, textHight);
  
  rect((width/7)*6 - sliderW, height/9, sliderW, (height/9)*8);
  
  int gridSize = (height/180)*8;
  int BST = 0;
  for (int i = 0; i <= 19; i++) {
    line(width/7, height/9 + i*gridSize, (width/7)*6, height/9 + i*gridSize);
    text(i + 1 + offset, width/2 - 485, (height/2) - 315 + i*gridSize);
    text(num_names.get(i + 1 + offset), width/2 - 400, (height/2) - 315 + i*gridSize);
    for (int j = 0; j < 2; j++) {
      if (names_types.get(num_names.get(i + 1 + offset))[j] != null) {
        text(names_types.get(num_names.get(i + 1 + offset))[j], width/2 - 260 + j*70, (height/2) - 315 + i*gridSize);
      }
    }
    for (int j = 0; j < 3; j++) {
      if (names_abilities.get(num_names.get(i + 1 + offset))[j] != null) {
        text(names_abilities.get(num_names.get(i + 1 + offset))[j], width/2 - 70 + j*70, (height/2) - 315 + i*gridSize);
      }
    }
    BST = 0;
    for (int j = 0; j < 6; j++) {
      BST += names_stats.get(num_names.get(i + 1 + offset))[j];
      text(names_stats.get(num_names.get(i + 1 + offset))[j], width/2 + 210 + j*40, (height/2) - 315 + i*gridSize);
    }
    text(BST, width/2 + 450, (height/2) - 315 + i*gridSize);
    if (mousePressed && mousePressValid == true) {
      if (mouseX < width/2 + 490 && mouseX >= width/2 - 500 && mouseY < (height/2) - 295 + i*gridSize && mouseY > (height/2) - 335 + i*gridSize && sliderFollow == false) {
        pokemons.set(pokemonChangeNumber, new Pokemon(i+offset, boolean(int(random(0, 2)))));
        pokemonSelectScreen = false;
        mousePressValid = false;
      }
    }
  }
  fill(255);

  rectMode(CENTER);
  rect(sliderX, sliderY, sliderW, sliderH);
  rectMode(CORNER);

  if (mousePressed) {
    if (mouseX >= sliderX - sliderW/2 && mouseX <= sliderX + sliderW/2 && mouseY >= sliderY - sliderH/2 && mouseY <= sliderY + sliderH/2) {
      sliderFollow = true;
    }
    if (mouseX < width/2 - 500 || mouseX > width/2 + 500 /*|| mouseY < height/2 + startY - 350 || mouseY > height/2 + startY + 300*/) {
      pokemonSelectScreen = false;
    }
  } else {
    sliderFollow = false;
  }

  if (sliderFollow == true) {
    if (mouseY >= height/2 - 300 + sliderH/2 && mouseY <= height/2 + 300 + sliderH/2) {
      sliderY = mouseY;
    } else if (mouseY <= height/2 - 300 + sliderH/2) {
      sliderY = height/2 - 300 + sliderH/2;
    } else if (mouseY >= height/2 + 300 + sliderH/2) {
      sliderY = height/2 + 300 + sliderH/2;
    }
  }
  if (sliderY >= height/2 + 300 - sliderH/2) {
    sliderY = height/2 + 300 - sliderH/2;
  } else if (sliderY <= height/2 - 300 + sliderH/2) {
    sliderY = height/2 - 300 + sliderH/2;
  }
}

void drawPokemonInformationScreen(int slotNumber) {
}

void drawPokemon(PImage[] pAnimation, int x, int y) {
  if (pAnimation.length>0) {
    image(pAnimation[(int) frameCount%pAnimation.length], x, y);
  }
}

public void setup() {
  size(1400, 900, P2D);
  frameRate(50);
  imageMode(CENTER);
  noSmooth();
  colorMode(HSB);

  sliderX = (width/7)*6 - sliderW/2;
  sliderY = height/9 + sliderH/2;
  sliderStartY = height/9 + sliderH/2;

  Gif.tmpPath = dataPath("");

  pokemons = new ArrayList<Pokemon>();
  for (int i = 0; i < 6; i ++) {
    pokemons.add(new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
  }

  for (int i = 1; i <= 807; i++) {
    JSONObject file = loadJSONObject(fileName+"pokemon\\"+i+".txt");
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

  type_colors.put("normal", color(#A8A878));
  type_colors.put("fighting", color(#C03028));
  type_colors.put("flying", color(#A890F0));
  type_colors.put("poison", color(#A040A0));
  type_colors.put("ground", color(#E0C068));
  type_colors.put("rock", color(#B8A038));
  type_colors.put("bug", color(#A8B820));
  type_colors.put("ghost", color(#705898));
  type_colors.put("steel", color(#B8B8D0));
  type_colors.put("fire", color(#F08030));
  type_colors.put("water", color(#6890F0));
  type_colors.put("grass", color(#78C850));
  type_colors.put("electric", color(#F8D030));
  type_colors.put("psychic", color(#F85888));
  type_colors.put("ice", color(#98D8D8));
  type_colors.put("dragon", color(#7038F8));
  type_colors.put("dark", color(#705848));
  type_colors.put("fairy", color(#EE99AC));
  type_colors.put("error", color(#555555));
  type_colors.put("???", color(#555555));
}

void draw() {
  background(200);
  drawStartScreen();
  if (pokemonSelectScreen == true) {
    drawPokemonSelectionScreen(pokemonChangeNumber);
  }
}

void mousePressed() {
}

void mouseReleased() {
  mousePressValid = true;
}

void mouseClicked() {
  //offset += 1;
}

void keyPressed() {
  pokemons = new ArrayList<Pokemon>();
  for (int i = 0; i < 6; i ++) {
    pokemons.add(new Pokemon(int(random(1, 808)), boolean(int(random(0, 2)))));
  }
}