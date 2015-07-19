import controlP5.*;
import java.awt.Frame;
import java.awt.BorderLayout;
import processing.video.*;

ControlP5 cp5;
Capture cam;

ControlFrame cf;

int pixelAmount = 50;
int pixelHeight = 10;
float cameraX;
float cameraY;
int depth = 10;

float camXInc;
float camYInc;

void setup() {
  size(1280, 720, P3D);
  
  camXInc = random(width);
  camYInc = random(height);
  
  cameraX = width/2;
  cameraY = height/2;
  
  cf = addControlFrame("extra", 300,200);
  
  CP5setup();

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void CP5setup() {
   cp5 = new ControlP5(this);
  
   
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

void draw() {
  
  
  background(0);
  
  camXInc += 0.005;
  camYInc += 0.001;
  
  cameraX = sin(camXInc) * (float)width/5 + width/2;
  cameraY = sin(camYInc) * (float)height/5 + height/2;
  
  if (mousePressed)
  {
     cameraX = mouseX;
     cameraY = mouseY; 
     
     noCursor();
  }
  
  //camera(cameraX, cameraY, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  
  
  if (cam.available() == true) {
    cam.read();
  }
  
  cam.loadPixels();
  
  for (int x = 0; x < cam.width; x+=pixelAmount)
  {
     for (int y = 0; y < cam.height; y+=pixelAmount)
    {
       color c = cam.pixels[x + y * cam.width];
       fill(c);
       noStroke();
       //rect(x, y, pixelAmount, pixelAmount);
       
       float brightness = red(c) + blue(c) + green(c);
       
       //fill(brightness / 3);
       
       pushMatrix();
         //translate(x, y, depth);
         //box(pixelAmount, pixelAmount, ((brightness/765)) * pixelHeight);
         translate(x, y, depth  + ((brightness/765)) * pixelHeight);
         box(pixelAmount, pixelAmount, pixelAmount);
       popMatrix();
    } 
    
  }
  
  noCursor();
  
  //image(cam, 0, 0);
}

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  int pixelAmount = 50;
  int pixelHeight = 10;
  int cameraX = 10;
  int cameraY = 10;
  int depth = 10;
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    
    cp5.addSlider("pixelAmount")
     .plugTo(parent,"pixelAmount")
     .setPosition(10,50)
     .setSize(20, 100)
     .setRange(5,80)
     ;
     
   cp5.addSlider("pixelHeight")
     .plugTo(parent,"pixelHeight")
     .setPosition(60,50)
     .setSize(20, 100)
     .setRange(1,2000)
     ;
     
   cp5.addSlider("cameraX")
     //.plugTo(parent,"cameraX")
     .setPosition(110,50)
     .setSize(20, 100)
     .setRange(1,1280)
     ;
     
   cp5.addSlider("cameraY")
     //.plugTo(parent,"cameraY")
     .setPosition(160,50)
     .setSize(20, 100)
     .setRange(1,720)
     ;
     
   cp5.addSlider("depth")
     .plugTo(parent,"depth")
     .setPosition(210,50)
     .setSize(20, 100)
     .setRange(-1000,10)
     ;
    
  }

  public void draw() {
      background(0);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}
