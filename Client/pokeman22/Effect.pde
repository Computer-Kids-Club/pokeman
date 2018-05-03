
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

void add_searching_text_effect() {

  Effect new_effect = new Effect(-200, int(random(height)), random(3, 7), 0);

  new_effect.add_text("Searching...", 100, 200, 200);

  new_effect.change_life(25);
  
  new_effect.i_alpha = 0;

  new_effect.i_text_red = int(random(255));
  new_effect.i_text_green = 255;
  new_effect.i_text_blue = 255;
  new_effect.i_text_alpha = 255;
  
  new_effect.b_die_from_right = true;

  new_effect.b_big_text = true;
  new_effect.i_text_size = int(random(12, 72));

  l_effects.add(new_effect);
}

void add_text_effect(String str_text, int i_x, int i_y, color text_clr) {

  Effect new_effect = new Effect(i_x, i_y, random(-2, 2), random(-2, 2));

  new_effect.b_fade_in = true;
  new_effect.b_fade_out = true;

  new_effect.add_text(str_text, 0, 200, 100);
  
  new_effect.i_alpha = 0;

  new_effect.i_text_red = (int)red(text_clr);
  new_effect.i_text_green = (int)green(text_clr);
  new_effect.i_text_blue = (int)blue(text_clr);
  new_effect.i_text_alpha = 30;

  l_effects.add(new_effect);
}

void add_dmg_text_effect(int i_x, int i_y) {

  i_x += random(-35, 35);
  i_y += random(-35, 35);

  Effect new_effect = new Effect(i_x, i_y, 0, random(-1, -2));

  new_effect.rect_radius = 3;

  new_effect.b_fade_out = true;

  new_effect.f_ay = -0.5;

  new_effect.i_alpha = 255;

  new_effect.add_text("-1%HP", 0, 200, 100);

  new_effect.i_text_red = 255;
  new_effect.i_text_green = 100;
  new_effect.i_text_blue = 255;
  new_effect.i_text_alpha = 255;

  l_effects.add(new_effect);
}

void add_heal_text_effect(int i_x, int i_y) {

  i_x += random(-35, 35);
  i_y += random(-35, 35);

  Effect new_effect = new Effect(i_x, i_y, 0, random(-1, -2));

  new_effect.rect_radius = 3;

  new_effect.b_fade_out = true;

  new_effect.f_ay = -0.5;

  new_effect.i_alpha = 255;

  new_effect.add_text("+1%HP", 100, 200, 200);

  new_effect.i_text_red = 100;
  new_effect.i_text_green = 100;
  new_effect.i_text_blue = 255;
  new_effect.i_text_alpha = 255;

  l_effects.add(new_effect);
}

void add_effect_text_effect(String str_effect, int i_x, int i_y, color clr) {

  Effect new_effect = new Effect(i_x, i_y, 0, 0);

  new_effect.b_fade_out = true;

  new_effect.f_scale = 0.05;
  new_effect.f_dscale = 0.02;

  new_effect.add_text(str_effect, 100, 200, 200);
  
  new_effect.i_alpha = 0;

  new_effect.change_life(25);

  new_effect.i_text_red = (int)hue(clr);
  new_effect.i_text_green = (int)saturation(clr);
  new_effect.i_text_blue = 255;
  new_effect.i_text_alpha = 255;

  new_effect.b_big_text = true;
  new_effect.i_text_size = 56;
  new_effect.f_dy = new_effect.i_text_size*0.00;

  l_effects.add(new_effect);
}

void add_ad_hoc_text_effect(String str_effect, int i_x, int i_y, color clr) {

  Effect new_effect = new Effect(i_x, i_y, 0, 0);

  new_effect.b_fade_out = true;

  new_effect.f_scale = 0.05;
  new_effect.f_dscale = 0.02;

  new_effect.add_text(str_effect, 100, 200, 200);
  
  new_effect.i_alpha = 0;

  new_effect.change_life(25);

  new_effect.i_text_red = (int)hue(clr);
  new_effect.i_text_green = (int)saturation(clr);
  new_effect.i_text_blue = 255;
  new_effect.i_text_alpha = 255;

  new_effect.b_big_text = true;
  new_effect.i_text_size = 56;
  new_effect.f_dy = new_effect.i_text_size*0.00;

  l_effects.add(new_effect);
}

void add_ad_hoc_text_effect(String str_effect, int me_or_other, color clr) {

  int i_x = POKE_OTHER_RECT.i_x; 
  int i_y = POKE_OTHER_RECT.i_y;

  if (me_or_other == ME) {
    i_x = POKE_ME_RECT.i_x; 
    i_y = POKE_ME_RECT.i_y;
  }

  add_ad_hoc_text_effect(str_effect, i_x, i_y, clr);
}

class Effect {

  float f_x, f_y, f_dx, f_dy;
  float f_scale, f_dscale, f_rot, f_drot;
  float f_ax, f_ay;

  String str_text;
  Rect rect;
  int i_red, i_green, i_blue, i_alpha;
  int i_text_red, i_text_green, i_text_blue, i_text_alpha;
  PImage img;
  PImage[] anime;

  boolean b_big_text;
  int i_text_size;

  int rect_radius;

  int i_lifetime, i_life;

  boolean b_fade_in, b_fade_out;
  
  boolean b_die_from_right;

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1, float f_scale1, float f_dscale1, float f_rot1, float f_drot1) {
    f_x = f_x1;
    f_y = f_y1;
    f_dx = f_dx1;
    f_dy = f_dy1;
    f_scale = f_scale1;
    f_dscale = f_dscale1;
    f_rot = f_rot1;
    f_drot = f_drot1;

    b_big_text = false;
    i_text_size = 18;
    
    b_die_from_right = false;

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

    i_lifetime = 60;
    i_life = i_lifetime;

    b_fade_in = false;
    b_fade_out = false;
  }

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1, float f_scale1, float f_dscale1) {
    this(f_x1, f_y1, f_dx1, f_dy1, f_scale1, f_dscale1, 0, 0);
  }

  Effect(float f_x1, float f_y1, float f_dx1, float f_dy1) {
    this(f_x1, f_y1, f_dx1, f_dy1, 1, 0, 0, 0);
  }

  Effect(float f_x1, float f_y1) {
    this(f_x1, f_y1, 0, 0, 1, 0, 0, 0);
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

  void change_life(int i_lifetime1) {
    i_lifetime = i_lifetime1;
    i_life = i_lifetime;
  }

  void draw_effect() {

    if(b_die_from_right) {
      if(f_x > width + 200) {
        i_life = 0; 
      }
    } else {
      i_life--;
    }

    f_x += f_dx;
    f_y += f_dy;
    f_dx += f_ax;
    f_dy += f_ay;
    f_scale += f_dscale;
    f_rot += f_drot;

    pushMatrix();

    translate(f_x, f_y);

    rotate(f_rot);

    scale(f_scale);

    float i_usable_alpha = 1;

    if (b_fade_out && i_life < i_lifetime/3) {
      i_usable_alpha = (float)i_life/i_lifetime*3.0;
    }
    if (b_fade_in && i_life > i_lifetime - i_lifetime/3) {
      i_usable_alpha = (float)(i_lifetime - i_life)/i_lifetime*3.0;
    }

    //println(i_usable_alpha);

    if (str_text != null) {

      draw_rectMode(CENTER);
      textAlign(CENTER, BASELINE);

      fill(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      noStroke();
  
      draw_rect(1, -4, round(textWidth(str_text))+4+100, 14+100, rect_radius);
      
      textSize(i_text_size);

      fill(i_text_red, i_text_green, i_text_blue, round(i_usable_alpha*i_text_alpha));
      if (b_big_text) {

        textFont(font_big_solid);
        textSize(i_text_size);
        draw_text(str_text, 0, 0);

        fill(i_text_red, 50, i_text_blue, round(i_usable_alpha*i_text_alpha));
        textFont(font_big_hollow);
        textSize(i_text_size);
        draw_text(str_text, 0, 0);
        
      } else {

        draw_text(str_text, 0, 0);
      }

      textFont(font_plain);
      textSize(i_plain_font_size);
    }
    if (rect != null) {
      draw_rectMode(CENTER);
      noStroke();
      fill(i_red, i_green, i_blue, i_usable_alpha*i_alpha);
      draw_rect(0, 0, rect.i_w, rect.i_h, rect_radius);
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