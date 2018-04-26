
ArrayList<Effect> l_effects = new ArrayList<Effect>();

String [] l_flying_text = {"!", "ah", "wow", "much", "great", "beauty", "amazing", "terrific", "wonderful"};

void draw_all_effects() {
  for (int i=l_effects.size()-1; i>=0; i--) {
    Effect cur_eff = l_effects.get(i);
    cur_eff.draw_effect();
    if (cur_eff.i_life<0) {
      l_effects.remove(i);
    }
  }
}

void add_text_effect(String str_text, int i_x, int i_y, color text_clr) {

  Effect new_effect = new Effect(i_x, i_y, random(-2, 2), random(-2, 2));

  new_effect.b_fade = true;

  new_effect.i_alpha = 0;

  new_effect.add_text(str_text, 0, 200, 100);

  new_effect.i_text_red = (int)red(text_clr);
  new_effect.i_text_green = (int)green(text_clr);
  new_effect.i_text_blue = (int)blue(text_clr);
  new_effect.i_text_alpha = (int)alpha(text_clr);

  l_effects.add(new_effect);
}

class Effect {

  float f_x, f_y, f_dx, f_dy;
  float f_scale, f_dscale, f_rot, f_drot;

  String str_text;
  Rect rect;
  int i_red, i_green, i_blue, i_alpha;
  int i_text_red, i_text_green, i_text_blue, i_text_alpha;
  PImage img;
  PImage[] anime;

  int i_lifetime, i_life;

  boolean b_fade;

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1, float f_scale1, float f_dscale1, float f_rot1, float f_drot1) {
    f_x = f_x1;
    f_y = f_y1;
    f_dx = f_dx1;
    f_dy = f_dy1;
    f_scale = f_scale1;
    f_dscale = f_dscale1;
    f_rot = f_rot1;
    f_drot = f_drot1;

    i_red = 255;
    i_green = 255;
    i_blue = 255;
    i_alpha = 255;

    i_text_red = 255;
    i_text_green = 255;
    i_text_blue = 255;
    i_text_alpha = 255;

    str_text = null;
    rect = null;
    img = null;
    anime = null;

    i_lifetime = 50;
    i_life = i_lifetime;

    b_fade = false;
  }

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1, float f_scale1, float f_dscale1) {
    this(f_x1, f_y1, f_dx1, f_dy1, f_scale1, f_dscale1, 0, 0);
  }

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1) {
    this(f_x1, f_y1, f_dx1, f_dy1, 1, 1, 0, 0);
  }

  Effect(float f_x1, float f_y1) {
    this(f_x1, f_y1, 0, 0, 1, 1, 0, 0);
  }

  void add_text(String str_text1, int r1, int g1, int b1) {
    str_text = str_text1;
    i_red = r1;
    i_green = g1;
    i_blue = b1;
  }

  void add_rect(Rect rect1, int r1, int g1, int b1) {
    i_red = r1;
    i_green = g1;
    i_blue = b1;
    rect = rect1;
  }

  void add_img(PImage img1) {
    img = img1;
  }

  void add_anime(PImage[] anime1) {
    anime = anime1;
  }

  void draw_effect() {

    i_life--;

    f_x += f_dx;
    f_y += f_dy;
    f_scale *= f_dscale;
    f_rot += f_drot;

    pushMatrix();

    translate(f_x, f_y);

    rotate(f_rot);

    scale(f_scale);

    float i_usable_alpha = 255;

    if (b_fade) {
      i_usable_alpha = (float)i_life/i_lifetime;
    }

    if (str_text != null) {

      draw_rectMode(CENTER);
      textAlign(CENTER, BASELINE);

      fill(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      noStroke();

      draw_rect(1, -4, round(textWidth(str_text))+4, 14);

      fill(i_text_red, i_text_green, i_text_blue, i_usable_alpha*i_text_alpha);

      draw_text(str_text, 0, 0);
    }
    if (rect != null) {
      draw_rectMode(CENTER);
      noStroke();
      fill(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      draw_rect(0, 0, rect.i_w, rect.i_h);
    }
    if (img != null) {
      draw_imageMode(CENTER);
      tint(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      draw_image(img, 0, 0);
      noTint();
    }
    if (anime != null) {
      draw_imageMode(CENTER);
      tint(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      draw_image(anime[(i_lifetime - i_life)%anime.length], 0, 0);
      noTint();
    }

    popMatrix();
  }
}