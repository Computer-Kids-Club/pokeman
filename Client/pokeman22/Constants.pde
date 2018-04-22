
Rect SLIDER;
Rect MOVESLIDER;
Rect NATURESLIDER;

int sliderStartY;
int moveSliderStartY;
int natureSliderStartY;

Rect INFO_BUTTON;
Rect POKEBALL;

Rect START_BUTTON;
Rect POKEMON_BUTTON;

Rect SEARCH_BUTTON;

Rect POKE_ME_RECT;
Rect POKE_OTHER_RECT;

int HEALTH_BAR_WIDTH = 200;

int POKEMON_PER_PAGE = 20;
int MOVES_PER_PAGE = 7;
int NATURES_PER_PAGE = 11;

String POKEINFO_PATH = "./pokeinfo/";

int NOT_READY = 0;
int SEARCHING = 1;
int BATTLING = 2;

int SELECTSCREENSHIFT_Y;
int SELECTSCREENSHIFT_X;

int ME = 0;
int OTHER = 1;

int PORT = 17171;

char TERMINATING_CHAR = '`';

char FOUND_BATTLE = 'f';
char NEXT_TURN = 't';

char SELECT_POKE = 'p';
char SELECT_MOVE = 'm';
char SELECT_POKE_OR_MOVE = 'o';
char AWAITING_SELECTION = 'w';

char SENDING_POKE = 's';
char CHANGING_POKE = 'c';

char DISPLAY_TEXT = 'd';
char DISPLAY_TEAMS = 'T';
char DISPLAY_POKES = 'P';
char DISPLAY_NONE = 'N';
char DISPLAY_MOVE = 'M';
char DISPLAY_DELAY = 'D';

char DISPLAY_WIN = 'W';
char DISPLAY_LOSE = 'L';

HashMap<String, Integer> TYPE_COLOURS = new HashMap<String, Integer>();

HashMap<Character, Integer> KEY_TO_ID = new HashMap<Character, Integer>();

int TEXT_CHAT_DIVIDE = 1000;

void init_constants() {
  SELECTSCREENSHIFT_Y = height*4/45;
  SELECTSCREENSHIFT_X = width/28;
  SLIDER = new Rect(width*17/20 - SELECTSCREENSHIFT_X, height/9 + SELECTSCREENSHIFT_Y, width/140, height/45);
  MOVESLIDER = new Rect(width*17/20 - SELECTSCREENSHIFT_X, SELECTSCREENSHIFT_Y + height/4 + 291, width/140, height/45);
  NATURESLIDER = new Rect(width*31/56, height*299/450, width/140, height/45);
  sliderStartY = height/9 + SELECTSCREENSHIFT_Y;
  moveSliderStartY = SELECTSCREENSHIFT_Y + height/4 + 291;
  natureSliderStartY = height*299/450;

  START_BUTTON = new Rect(width/2, height/2, 400, 200);
  POKEMON_BUTTON = new Rect(width/7, height*5/6, width/7, height*2/9);

  INFO_BUTTON = new Rect(POKEMON_BUTTON.i_x - POKEMON_BUTTON.i_w/2 + width*9/700, POKEMON_BUTTON.i_y + POKEMON_BUTTON.i_h/2 - height/50);
  POKEBALL = new Rect(POKEMON_BUTTON.i_x + POKEMON_BUTTON.i_w/2 - width*9/700, POKEMON_BUTTON.i_y + POKEMON_BUTTON.i_h/2 - height/50);

  SEARCH_BUTTON = new Rect(width/7 + 10 + SELECTSCREENSHIFT_X, 10 + SELECTSCREENSHIFT_Y, 200, 30);

  POKE_ME_RECT = new Rect(150, 400+3*40);
  POKE_OTHER_RECT = new Rect(TEXT_CHAT_DIVIDE-150, 50+3*40);

  KEY_TO_ID.put('q', 0);
  KEY_TO_ID.put('w', 1);
  KEY_TO_ID.put('e', 2);
  KEY_TO_ID.put('r', 3);

  // hard code all the type colours
  TYPE_COLOURS.put("normal", color(#A8A878));
  TYPE_COLOURS.put("fighting", color(#C03028));
  TYPE_COLOURS.put("flying", color(#A890F0));
  TYPE_COLOURS.put("poison", color(#A040A0));
  TYPE_COLOURS.put("ground", color(#E0C068));
  TYPE_COLOURS.put("rock", color(#B8A038));
  TYPE_COLOURS.put("bug", color(#A8B820));
  TYPE_COLOURS.put("ghost", color(#705898));
  TYPE_COLOURS.put("steel", color(#B8B8D0));
  TYPE_COLOURS.put("fire", color(#F08030));
  TYPE_COLOURS.put("water", color(#6890F0));
  TYPE_COLOURS.put("grass", color(#78C850));
  TYPE_COLOURS.put("electric", color(#F8D030));
  TYPE_COLOURS.put("psychic", color(#F85888));
  TYPE_COLOURS.put("ice", color(#98D8D8));
  TYPE_COLOURS.put("dragon", color(#7038F8));
  TYPE_COLOURS.put("dark", color(#705848));
  TYPE_COLOURS.put("fairy", color(#EE99AC));
  TYPE_COLOURS.put("error", color(#555555));
  TYPE_COLOURS.put("???", color(#555555));
}

class Rect {
  int i_x;
  int i_y;
  int i_w;
  int i_h;
  Rect(int x, int y, int w, int h) {
    i_x = x;
    i_y = y;
    i_w = w;
    i_h = h;
  }
  Rect(int x, int y) {
    i_x = x;
    i_y = y;
  }
}

int interpolate(int x1, int x2, int m, int mt) {
  return x1+(x2-x1)*m/mt;
}

void translate_interpolation(Rect r1, Rect r2, int m, int mt) {
  translate(interpolate(r1.i_x, r2.i_x, m, mt), interpolate(r1.i_y, r2.i_y, m, mt));
}