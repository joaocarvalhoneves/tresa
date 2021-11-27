import oscP5.*;                                      //////////////////////////////////
import netP5.*;                                      /////////// LIBRARIES ////////////
import processing.video.*;                           //////////////////////////////////

Capture cam;                                         // CAMERA
OscP5 oscP5;                                         // COMMUNICATION PD
NetAddress Remote;                                   // SEND TO

OscMessage volmsg;                                   //////////////////////////////////
OscMessage notemsg;                                  ////////////////////////////////// 
OscMessage note2msg;                                 //////////// MESSAGES //////////// 
OscMessage sequencemsg;                              /////////////// TO ///////////////
OscMessage metmsg;                                   //////////// PUREDATA ////////////                               
OscMessage cutmsg;                                   //////////////////////////////////
OscMessage switchmsg;                                //////////////////////////////////

ArrayList  <Note> note = new ArrayList <Note> (15);  // NOTES
float noteSeq []       = new float [15];             // NOTES SEQUENCE - ORDER BY FREQ
PImage img;                                          // OTIMIZED CAMERA
PImage base;                                         // BASE IMAGE FOR DETECTION
float metScan     = 0;                               // METRONOME RAW
float metFinal    = 0;                               // METRONOME MAPPED
float cutoffScan  = 0;                               // CUTOFF RAW
float cutoffFinal = 0;                               // CUTOFF MAPPED
float highVol []  = new float [5];                   // LOW KEYS VOLUME
float medVol []   = new float [5];                   // MEDIUM KEYS VOLUME
float lowVol []   = new float [5];                   // HIGH KEYS VOLUME
int sequenceSize  = 0;                               // NOTES ON SEQUENCER
int sequenceSizeO = 0;                               // OLD NOTES ON SEQUENCER
int triggerInt    = 0;                               // VAR FOR SWITCH MODES
boolean trigger   = false;                           // MODE STATE
String[] cameras = Capture.list();

void setup() {
  size(640, 480);
  frameRate(15);

  // INI STUFF
  cam = new Capture(this, cameras[1]);
  oscP5 = new OscP5(this, 9000);
  Remote = new NetAddress("127.0.0.1", 9001);
  base = loadImage("base.png");
  img = createImage(width, height, HSB);

  // CREATE 15 NOTES
  for (int i = 0; i < 15; i++) {
    note.add(new Note(0, 0));
  }

  // SET MAX FOR EACH NOTE
  notasini();

  // START CAMERA
  cam.start();
}


void draw() {
  colorMode(HSB);

  // REFRESH CAM
  cam.read();

  // CREATE A MESSAGE FOR EACH FRAME
  notemsg = new OscMessage("/note");
  note2msg = new OscMessage("/note2");
  volmsg = new OscMessage("/vol");
  metmsg = new OscMessage("/met");
  cutmsg = new OscMessage("/cut");
  sequencemsg = new OscMessage("/seq");
  switchmsg = new OscMessage("/swi");

  // OPTIMIZE CAM QUALITY FOR DETECTION
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color c = cam.get(x, y);
      float h = hue(c);
      float s = saturation(c);
      float b = brightness(c);
      img.set(x, y, color(h, s-25, b+15));
    }
  }
 //println(mouseX, mouseY);
  img.updatePixels();

  // DRAW STUFF
  image(img, 0, 0);
  colorMode(RGB);
  noFill();
  strokeWeight(2);
  stroke(255, 255, 0);
  ellipse(width/2, height/2, 450, 450);
  ellipse(width/2, height/2, 285, 285);
  ellipse(width/2, height/2, 130, 130);

  for (int i = 0; i < 5; i++) {
    float ang = TWO_PI/5;
    line(width/2+147*cos((-PI/2) + (i*ang)), height/2+147*sin((-PI/2) + (i*ang)), (width/2)+224*cos((-PI/2) + (i*ang)), (height/2)+224*sin((-PI/2) + (i*ang)));
  }

  // PIXEL DETECTION
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      color bc = base.get(x, y);
      float br = red(bc);
      float bg = green(bc);
      float bb = blue(bc);
      float redc =  red((img.pixels[x + y * width]));
      float bluec =  blue((img.pixels[x + y * width]));
      float greenc = green((img.pixels[x + y * width]));
      float h = hue(img.pixels[x + y * width]);
      float s = saturation(img.pixels[x + y * width]);
      float b = brightness(img.pixels[x + y * width]);
      met(x, y, h, b);
      cutoff(x, y, h);
      high(x, y, br, bg, bb, h, s, b, redc, greenc, bluec);
      med(x, y, br, bg, bb, h, s, b, redc, greenc, bluec);
      low(x, y, br, bg, bb, h, s, b, redc, greenc, bluec);
    }
  }


  // PIXEL MAPPING
  float maxVol = 2;
  metScan = map(metScan, 0, 13237, 60, 900);
  cutoffScan = map(cutoffScan, 0, 50028, 50, 130);

  for (int i = 0; i < 5; i++) {
    highVol[i] = map(highVol[i], 0, 20895, 0, maxVol);
    medVol[i] = map(medVol[i], 0, 20895, 0, maxVol);
    lowVol[i] = map(lowVol[i], 0, 20895, 0, maxVol);
  } 

  //  println(lowVol[0]);

  // FADE IN/OUT OF FEATURES
  for (int i = 0; i < 5; i++) note.get(i).setVol(lowVol[i]);
  for (int i = 5; i < 10; i++) note.get(i).setVol(medVol[i-5]);
  for (int i = 10; i < 15; i++) note.get(i).setVol(highVol[i-10]);

  cutoffFinal = lerp(cutoffFinal, cutoffScan, 0.05);

  // FREQUENCIES BASED ON VOLUME
  notas(); 

  // SEQUENCER SIZE BASED ON VOLUME
  for (int i = 0; i < 15; i++) {
    if (note.get(i).getVol() > 0.005) sequenceSize++;
  }


  // WRITE AND SEND MESSAGES TO PUREDATA
  metmsg.add(metScan);
  cutmsg.add(cutoffFinal);



  for (int i = 0; i < note.size(); i++) {
    notemsg.add(note.get(i).getFreq());
    volmsg.add(note.get(i).getVol());
  }
  
    refreshSeq();






  oscP5.send(cutmsg, Remote);
  oscP5.send(volmsg, Remote);
  oscP5.send(notemsg, Remote);



  for (int i = 0; i < 5; i++) {
    lowVol[i] = 0;
    medVol[i] = 0;
    highVol[i] = 0;
  }
  metScan = 0;
  cutoffScan = 0;
  sequenceSize = 0;
  for (int i = 0; i < 15; i++) {
    noteSeq[i] = 0;
  }
}

// GET COLOR FROM CAM
void mousePressed() {
  save("imagem.jpg");
  float red = red(img.pixels[mouseX + mouseY * width]);
  float green = green(img.pixels[mouseX + mouseY * width]);
  float blue = blue(img.pixels[mouseX + mouseY * width]);
  float hue = hue(img.pixels[mouseX + mouseY * width]);
  float sat = saturation(img.pixels[mouseX + mouseY * width]);
  float bright = brightness(img.pixels[mouseX + mouseY * width]);
  println("RGB: " + red, green, blue + " - HSB: " + hue, sat, bright);
}
