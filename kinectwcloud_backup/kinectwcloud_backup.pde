import hypermedia.net.*;    // import UDP library
import processing.video.*;

ArrayList poop = new ArrayList();
int bg=0;
Cloud c;

Capture video;
int w=640, h=480;
PImage img, fullscreenImg;

int bodyfrontleft;
int speedfrontleft;
int bodyfrontright;
int speedfrontright;

int bodymiddleleft;
int speedmiddleleft;
int bodymiddleright;
int speedmiddleright;

int bodybackleft;
int speedbackleft;
int bodybackright;
int speedbackright;

int allbodies;
int allspeed;

boolean opacityplacement[] = new boolean[70];


UDP udp;  // define the UDP object (sets up)

/**
 * init
 */
void setup() {
 size(640,480);
 //fullScreen();
 background(0);
 smooth();
  // create a new datagram connection on port 6000
  // and wait for incoming message
  udp = new UDP( this, 11000 );  
  udp.log( false );     // <-- printout the connection activity
  udp.listen( true );
 video = new Capture(this, w, h); 
 video.start();
 
 println(udp.address());
 
 }
 

// void receive( byte[] data ) {       // <-- default handler
void receive( byte[] data, String ip, int port ) {  // <-- extended handler
  
  
  // get the "real" message =
  String message = new String( data );
  String[] parts = split(message, ";");


bodyfrontleft = parseInt(parts[0]);
speedfrontleft = parseInt(parts[1]); //accumulated speed for all people in space, must be divided by body
bodyfrontright = parseInt(parts[2]);
speedfrontright = parseInt(parts[3]);

bodymiddleleft = parseInt(parts[4]);
speedmiddleleft = parseInt(parts[5]);
bodymiddleright = parseInt(parts[6]);
speedmiddleright = parseInt(parts[7]);

bodybackleft = parseInt(parts[8]);
speedbackleft = parseInt(parts[9]);
bodybackright = parseInt(parts[10]);
speedbackright = parseInt(parts[11]);

allbodies = parseInt(parts[12]);
allspeed = parseInt(parts[13]); //between 0-255

for (int e = 0; e  < 70; e++){
  if(parts[14].charAt(e)== '0'){
    opacityplacement[e] = false;
    }
   else{
   opacityplacement[e] = true;
  }
  }

 

//part 14 goes into new string, parceInt to array of 70 (7*10), if part is over = 1, opacity)
//create opacity layer that writes opacityplacement[e] = false;, make dark
//

  // print the result
  println( parts[14]);

  
}

void draw()  {
  video.loadPixels();
  if(allbodies>3){
  for (int y = 0; y< h; y++)
  {
    for (int x = 0; x< w; x++)
    {
      color c = video.pixels[y*video.width+x]; 
      video.pixels[y*w+x] = c << ((int) map(allbodies, 0, width, 10, 64*4));
    }
 
  video.updatePixels();
  }
  }
  else{
   for (int y = 0; y< h; y++)
  {
    for (int x = 0; x< w; x++)
    {
      color c = video.pixels[y*video.width+x]; 
      video.pixels[y*w+x] = c << ((int) map(0, 0, width, 0, 64*4));
    }
 
  video.updatePixels();
  }
  }
 

  fullscreenImg = video; // Load video to new image
  pushMatrix();
  scale(-1, 1); 
  image(video, 0, 0, -width, height);
 
  popMatrix();
  
  if(bodyfrontleft > 0){
  fill(0,0,255,100);
  rect(0,0,width,height);
        
          if(speedfrontleft > 200){
          fill(0,0,255,150);
          rect(0,0,width,height);
          }
  }
  if(bodymiddleleft > 0){
  fill(255,0,0,100);
  rect(0,0,width,height);
  }
  if(bodybackleft > 0){
  fill(0,255,0,100);
  rect(0,0,width,height);
  }
    if(bodyfrontright > 0){
  fill(0,0,255,100);
  rect(0,0,width,height);
  }
  if(bodymiddleright > 0){
  fill(255,0,0,100);
  rect(0,0,width,height);
  }
  if(bodybackright > 0){
  fill(0,255,0,100);
  rect(0,0,width,height);
  }
  
  for(int i = 0; i < 10; i++){
      for (int x = 0; x < 7; x++){
                  if(!opacityplacement[i*7+x]){
                  //fill(0,0,0,255); 
                  //rect((width/10)*i,(height/7)*x, width/10, height/7);
                  for (int clo=0;clo<100;clo++) {
                  Cloud c = new Cloud((int)random((width/10*i)-20, (width/10*i)+20), (int)random((height/7*x)-20, (height/7*x)+20), random(0, 2*PI)); 
                  poop.add(c);
                  }
                  for (int clo=0;clo<poop.size();clo++) {
                  Cloud c = (Cloud) poop.get(clo);
                  c.display();
                  c.run();
                  }
                  }
  }
  }

}


class Cloud {
  int x, y;
  PVector loc, center, increment;
  float t, esize, angle, SIZE, acc= 0.98;
  Cloud(int _x, int _y, float _angle) {
    x = _x;
    y = _y;
    loc = new PVector(x, y);
    center = new PVector(x, y);
    esize = random(0, 80);
    SIZE = random(150);
    angle = _angle;
    t = random(PI);
    int xp = (int)random(-5, 5);
    int yp = (int)random(-5, 5);
    increment = new PVector(xp, yp);
  }

  void display() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(angle);
    noFill();
    stroke(0, 150);
    strokeWeight(0);
    arc(0, 0, esize, esize, t+QUARTER_PI, TWO_PI);
    noStroke();
    fill(0, 150);
    ellipse(0, 0, esize, esize);
    popMatrix();
    fill(0, 10);
    ellipse(x, y, 100, 100);
  }
  void run() {
    if (loc.dist(center)<random(150)-esize/2 && 100<loc.y && loc.y<height-100) {
      loc.add(increment);
      //loc.mult(1.08);
    }

    if (esize < SIZE )esize = esize+1;
  }
}


void captureEvent(Capture c) { 
c.read();
}

 