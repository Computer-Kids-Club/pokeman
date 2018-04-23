import static java.awt.event.KeyEvent.*;

ArrayList<String> l_console = new ArrayList<String>();

boolean b_console = false;

Rect rect_console_window;

void init_console() {
  rect_console_window = new Rect((width-600)/2, (height-600)/2, 600, 600);
}

void draw_console() {
  if (!b_console)
    return;

  fill(100);
  stroke(255);
  rect_console_window.draw_rect();
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
}

void key_released_console() {
  //print(keyCode);
  if (keyCode == 97) {
    b_console = !b_console;
  }
}