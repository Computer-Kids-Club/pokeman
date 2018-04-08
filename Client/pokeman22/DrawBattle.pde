
ArrayList<String> text_chat = new ArrayList<String>();

void draw_battle() {
  textAlign(CENTER, CENTER);
  fill(0);
  for (int i=0; i<text_chat.size() && height - i*30 - 30 > 30; i++) {
    text(text_chat.get(i), width/2, height - i*30 - 30);
  }
}

void select_poke(int i_poke_id) {
  
}

void select_move(int i_move_id) {
  
}