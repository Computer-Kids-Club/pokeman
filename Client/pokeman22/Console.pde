import static java.awt.event.KeyEvent.*;

ArrayList<String> l_console = new ArrayList<String>();

ArrayList<String> l_console_current = new ArrayList<String>();

boolean b_console = false;

int i_console_cursor = 0;

Rect rect_console_window;

void init_console() {
  rect_console_window = new Rect(0, 0, 600, 600);
}

void draw_console() {
  if (!b_console)
    return;

  // update things

  i_console_cursor = constrain(i_console_cursor,0,l_console_current.size());

  // draw things

  pushMatrix();
  translate(width/2, height/2);

  int console_margin_size = 15;
  int console_text_size = 20;

  fill(100);
  noStroke();
  rectMode(CENTER);

  // entire console background
  rect(0, 0, rect_console_window.i_w, rect_console_window.i_h);

  // display all text 
  fill(255);
  textAlign(LEFT, CENTER);

  // console current text
  String str_console_current = "";
  for (int i=0; i<l_console_current.size(); i++) {
    str_console_current += l_console_current.get(i);
  }
  while (textWidth(str_console_current) > rect_console_window.i_w - console_margin_size*2 - textWidth(" ")) {
    str_console_current = string_pop(str_console_current, 0);
  }
  text(str_console_current, -rect_console_window.i_w/2 + console_margin_size + textWidth(" ")/2, rect_console_window.i_h/2 - console_margin_size - console_text_size/2);

  // blinking cursor
  if (frameCount%30<15) {
    stroke(255);
    pushMatrix();
    translate(-rect_console_window.i_w/2 + console_margin_size + textWidth(" ")/2 + textWidth(str_console_current.substring(0, i_console_cursor)), rect_console_window.i_h/2 - console_margin_size - console_text_size/2);
    line(0, -7, 0, 7);
    popMatrix();
  }

  // lots of console texts
  String str_console = "";
  for (int i=0; i<l_console_current.size(); i++) {
    str_console += l_console_current.get(i);
  }
  text(str_console, -rect_console_window.i_w/2 + console_margin_size + textWidth(" ")/2, 0);

  fill(75);
  noStroke();
  rectMode(CORNER);

  // left and right margin
  rect(-rect_console_window.i_w/2, -rect_console_window.i_h/2, console_margin_size, rect_console_window.i_h);
  rect(rect_console_window.i_w/2 - console_margin_size, -rect_console_window.i_h/2, console_margin_size, rect_console_window.i_h);

  // top and bottom margin
  rect(-rect_console_window.i_w/2, -rect_console_window.i_h/2, rect_console_window.i_w, console_margin_size);
  rect(-rect_console_window.i_w/2, rect_console_window.i_h/2 - console_margin_size, rect_console_window.i_w, console_margin_size);

  // sandwich margin
  rect(-rect_console_window.i_w/2, rect_console_window.i_h/2 - console_margin_size*2 - console_text_size, rect_console_window.i_w, console_margin_size);

  noFill();
  stroke(200);
  rectMode(CORNER);

  // lots of text box outline
  rect(-rect_console_window.i_w/2 + console_margin_size, -rect_console_window.i_h/2 + console_margin_size, rect_console_window.i_w - console_margin_size*2, rect_console_window.i_h - console_margin_size*3 - console_text_size);

  // text box outline
  rect(-rect_console_window.i_w/2 + console_margin_size, rect_console_window.i_h/2 - console_margin_size - console_text_size, rect_console_window.i_w - console_margin_size*2, console_text_size);

  noFill();
  stroke(200);
  rectMode(CENTER);

  // entire console outline
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

void mouse_wheel_console() {
  if (!b_console)
    return;
}

void key_pressed_console() {

  if (key == '`') {
    b_console = !b_console;
    return;
  }

  if (!b_console)
    return;

  if (keyCode == BACKSPACE) {
    if (l_console_current.size()>0) {
      l_console_current.remove(l_console_current.size()-1);
      i_console_cursor--;
    }
  } else if (keyCode == ENTER || keyCode == RETURN) {
    l_console_current.clear();
    i_console_cursor = 0;
  } else if (keyCode == LEFT) {
    i_console_cursor--;
  } else if  (keyCode == RIGHT) {
    i_console_cursor++;
  } else if (key != CODED) {
    l_console_current.add(i_console_cursor, ""+key);
    i_console_cursor++;
  }
}

void key_released_console() {
  //print(keyCode);

  if (!b_console)
    return;
}