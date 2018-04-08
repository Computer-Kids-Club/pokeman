
class Button {
  int i_x;
  int i_y;
  int i_w;
  int i_h;
  Button(int x, int y, int w, int h) {
    i_x = x;
    i_y = y;
    i_w = w;
    i_h = h;
  }
}

void init_constants() {
  sliderH = height/45;
  sliderW = width/140;
  sliderX = (width/7)*6 - sliderW;
  sliderY = height/9;
  sliderStartY = height/9;

  startButton = new Button(width/2, (height/9)*5, (width/7)*2, height/9);
  pokemonButton = new Button(width/7, (height/6)*5, width/7, (height/9)*2);

  infoButtonX = pokemonButton[0] - pokemonButton[2]/2 + (width/700)*9;
  infoButtonY = pokemonButton[1] + pokemonButton[3]/2 - height/50;
  pokeBallX = pokemonButton[0] + pokemonButton[2]/2 - (width/700)*9;
  pokeBallY = pokemonButton[1] + pokemonButton[3]/2 - height/50;
}