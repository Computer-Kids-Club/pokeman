import static java.awt.event.KeyEvent.*;

ArrayList<String> l_console = new ArrayList<String>();

boolean b_console = false;

Rect rect_console_window;

void init_console() {
  rect_console_window = new Rect(0, 0, 600, 600);
}

void draw_console() {
  if (!b_console)
    return;

  pushMatrix();
  translate((width-600)/2, (height-600)/2);

  fill(100);
  noStroke();
  rectMode(CENTER);
  
  rect_console_window.draw_rect();
  
  fill(100);
  noStroke();
  rectMode(CORNER);
  
  int console_size = 15;
  
  rect(-rect_console_window.i_w/2,-rect_console_window.i_h/2,15,rect_console_window.i_h);
  
  noFill();
  stroke(255);
  rectMode(CENTER);
  
  rect_console_window.draw_rect();

  popMatrix();
}

void mouse_pressed_console() {
  if (!b_console)
    return;
}

void mouse_released_console() {
  if (!b_console)
    return;
}

void key_pressed_console() {
  if (!b_console)
    return;

  if (keyCode == 97) {
    b_console = !b_console;
  }
}

void key_released_console() {
  //print(keyCode);

  if (!b_console)
    return;
}