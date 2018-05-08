void login() {
  textFont(font_plain_big);
  fill(255);
  draw_rect(width/2, height/2, width, height);
  imageMode(CORNER);
  draw_image(loginBack, 0, 0);
  imageMode(CENTER);
  draw_image(loginbutton, width/2, height/5*4);
  textSize(100);
  textAlign(CENTER, CENTER);
  fill(0);
  draw_text("Login", width/2, 100);
  textSize(40);
  fill(255);
  rectMode(CENTER);
  draw_rect(width/2, height/5*2, width-300, 60);
  draw_rect(width/2, height/5*3, width-300, 60);
  if (username=="") {
    fill(150);
    draw_text("Username", width/2, height/5*2);
  }
  if (password=="") {
    fill(150);
    draw_text("Password", width/2, height/5*3);
  }

  if (mousePressed) {
    if (mouseX>=width/2-(width-300)/2 && mouseX<=width/2+(width-300)/2) {
      if (mouseY>=height/5*2-30 && mouseY<=height/5*2+30) {
        current="username";
      } else if (mouseY>=height/5*3-30 && mouseY<=height/5*3+60) {
        current="password";
      } else {
        current="";
      }
    }
    if (mouseX>=width/2-width/6 &&mouseX<=width/2) {
      if (mouseY>=height/5*4-height/14&&mouseY<=height/5*4+height/14) {
        //myClient.write(username);
        textFont(font_plain);
        login=false;
      }
    } else if (mouseX>=width/2 &&mouseX<=width/2+width/6) { 
      if (mouseY>=height/5*4-height/14&&mouseY<=height/5*4+height/14) {
        password="";
        username="";
        current="";
        register=true;
        login=false;
      }
    }
  }

  fill(0);
  draw_text(username, width/2, height/5*2-10);
  String coded="";
  for (int i=0; i<password.length(); i++) {
    coded+="*";
  }
  draw_text(coded, width/2, height/5*3);
  if (keyPressed && (key == RETURN||key==ENTER)) {
    textFont(font_plain);
    login=false;
  }
}

void register() {
  textFont(font_plain_big);
  fill(255);
  draw_rect(width/2, height/2, width, height);
  imageMode(CORNER);
  draw_image(loginBack, 0, 0);
  //imageMode(CENTER);
  //draw_image(loginbutton, width/2, height/5*4);
  textSize(100);
  textAlign(CENTER, CENTER);
  fill(0);
  draw_text("Register", width/2, 100);
  textSize(40);
  fill(255);
  rectMode(CENTER);
  draw_rect(width/2, height/5*2, width-300, 60);
  draw_rect(width/2, height/5*3, width-300, 60);
  if (username=="") {
    fill(150);
    draw_text("Enter A Username", width/2, height/5*2);
  }
  if (password=="") {
    fill(150);
    draw_text("Enter A Password", width/2, height/5*3);
  }

  if (mousePressed) {
    if (mouseX>=width/2-(width-300)/2 && mouseX<=width/2+(width-300)/2) {
      if (mouseY>=height/5*2-30 && mouseY<=height/5*2+30) {
        current="username";
      } else if (mouseY>=height/5*3-30 && mouseY<=height/5*3+60) {
        current="password";
      } else {
        current="";
      }
    } else {
      current="";
    }
    if (mouseX>=width/2-width/6 &&mouseX<=width/2+width/6) {
      if (mouseY>=height/5*4-height/14&&mouseY<=height/5*4+height/14) {
        //myClient.write(username);
        //textFont(font_plain);
        //register=false;
      }
    }
  }

  fill(0);
  draw_text(username, width/2, height/5*2-10);
  String coded="";
  for (int i=0; i<password.length(); i++) {
    coded+="*";
  }
  draw_text(coded, width/2, height/5*3);
  if (keyPressed && (key == RETURN||key==ENTER)) {
    textFont(font_plain);
    register=false;
  }
}


void drawSettingScreen() {
  textAlign(CENTER, CENTER);
  textSize(40);
  fill(0);
  draw_rect(0, 0, width, height);
  for (int i=0; i<3; i++) {
    if (buttonLst[i]==0) {
      fill(150);
    } else {
      fill(buttonLst[i], 255, 255);
    }
    ellipse(width/4, height/4*(1+i), width/8, width/8);
    fill(0);
    draw_text("ON", width/4, height/4*(1+i));
  }
  for (int i=3; i<6; i++) {
    if (buttonLst[i]==0) {
      fill(150);
    } else {
      fill(buttonLst[i], 255, 255);
    }
    ellipse(width/4*3, height/4*(1+i-3), width/8, width/8);
    fill(0);
    draw_text("OFF", width/4*3, height/4*(1+i-3));
  }
  textSize(20);
  fill(255);
  ellipse(width/8, height/2, width/15, width/15);
  fill(0);
  draw_text("BACK", width/8, height/2);
  fill(255);
  textSize(40);
  draw_text("Music", width/2, height/4);
  draw_text("Sound Effects", width/2, height/4*2);
  draw_text("Game", width/2, height/4*3);
  textSize(80);
  draw_text("SETTINGS", width/2, height/8);
  textSize(12);
  if (mousePressed) {
    if (dist(mouseX, mouseY, width/4, height/4)<=width/16) {
      sound=true;
      buttonLst[0]=100;
      buttonLst[3]=0;
    } else if (dist(mouseX, mouseY, width/4*3, height/4)<=width/16) {
      sound=false;


      print("lol");
      buttonLst[0]=0;
      buttonLst[3]=255;
    } else if (dist(mouseX, mouseY, width/4, height/4*2)<=width/16) {
      soundFX=true;
      buttonLst[1]=100;
      buttonLst[4]=0;
    } else if (dist(mouseX, mouseY, width/4*3, height/4*2)<=width/16) {
      soundFX=false;
      buttonLst[1]=0;
      buttonLst[4]=255;
    } else if (dist(mouseX, mouseY, width/4, height/4*3)<=width/16) {
      game=true;
      buttonLst[2]=100;
      buttonLst[5]=0;
    } else if (dist(mouseX, mouseY, width/4*3, height/4*3)<=width/16) {
      game=false;
      buttonLst[2]=0;
      buttonLst[5]=255;
      exit();
    } else if (dist(mouseX, mouseY, width/8, height/2)<=width/30) {
      drawSettingScreen=false;
    }
  }
}