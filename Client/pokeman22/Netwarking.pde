import processing.net.*; 

Client myClient; 

int PORT = 17171;

boolean reconnect() {
  if (!myClient.active()) {

    myClient = new Client(this, "127.0.0.1", PORT);
  }
  return myClient.active();
}

String dataIn = ""; 
void recieve_data() { 
  //reconnect();
  if (myClient.available() > 0) { 
    char newChar = char(myClient.read());
    dataIn += newChar;
    if (newChar == '\n') {
      dataIn = dataIn.substring(0, dataIn.length()-1);
      print("Recieved data: ");
      println(dataIn);
      if (dataIn.length()>2) {
        if (dataIn.charAt(0)=='r') {
        } else if (dataIn.charAt(0)=='g') {
        } else if (dataIn.charAt(0)=='b') {
        }
      }
      dataIn = "";
    }
  }
}

void send_hey() {
  if (myClient.active()) {
    myClient.write("hey");
  }
}

void send_pokes() {
  if (myClient.active()) {
    myClient.write("pokes");
  }
}