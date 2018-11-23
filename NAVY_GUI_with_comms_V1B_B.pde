/**
N  NAVY GUI version V1B block B
    Date: 23NOV18
    BY Nick 
    Nuvotion P/L
    www.nuvotion.com.au 

 * ControlP5 Slider. Horizontal and vertical sliders, 
 * with and without tick marks and snap-to-tick behavior.
 * by andreas schlegel, 2010
 */

/**
 * ControlP5 Slider
 *
 * Horizontal and vertical sliders, 
 * With and without tick marks and snap-to-tick behavior.
 *
 * find a list of public methods available for the Slider Controller
 * at the bottom of this sketch.
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */


import processing.serial.*;
  Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port


import controlP5.*;
ControlP5 cp5;

Textlabel myTextlabelA;
Textlabel myTextlabelB;
Slider Distance;
Slider Threshold;


Slider sliderYmax;
Slider sliderYmin;
int limitYmax=0;
int limitYmin=0;

Slider sliderXmax;
Slider sliderXmin;
int limitXmax=0;
int limitXmin=0;

int calx=0;
int caly=0;
int closestX = 0;
 int closestY=0;
CheckBox checkbox;


import processing.video.*;
Capture video;
PImage prev;

float threshold = 25;
float motionX = 0;
float motionY = 0;
float lerpX = 0;
float lerpY = 0;

float lerpXprev = 0;
float lerpYprev = 0;


// A variable for the color we are searching for.
color trackColor; 
int MODE=3;
int FIRECNT=0;

int invertX=0;
int invertY=0;
float fbytex=0;
float fbytey=0;


int myColor = color(0, 0, 0);

int sliderValue = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;

void setup() {
  
   // this is the section of code which tells the program what comm port to use it selects from a list of available comm ports, in most cases you will
   // only have one comm device connected to your computer so that would be postion zero in the list of availble comm ports :  Serial.list()[0]; 
  //String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
    String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port

  myPort = new Serial(this, portName, 9600);
println(portName);

  
  size(1000, 600);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  
    prev = createImage(640, 480, RGB);  

  // 183.0 12.0 83.0
  smooth();
  noStroke();
  background(51);
  stroke(255);
  line(770, 0, 770, 600);
  line(0, 560, 1000, 560);


  cp5 = new ControlP5(this);

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("sliderYmax")
    .setPosition(665, 5)
    .setSize(60, 200)
    .setRange(0, 127)
    .setValue(0)
    .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    ;
  //cp5.getController("sliderYmax").setLabelVisible(false);


  // reposition the Label for controller 'slider'
  //cp5.getController("sliderYmax").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  // cp5.getController("sliderYmax").getCaptionLabel().align(ControlP5.TOP, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);




  // create another slider with tick marks, now without
  // default value, the initial value will be set according to
  // the value of variable sliderTicks2 then.
  cp5.addSlider("sliderYmin")
    .setPosition(665, 280)
    .setSize(60, 200)
    .setRange(0, 127)
     .setValue(0)
    .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0);


  ;


  // add a vertical slider
  cp5.addSlider("sliderXmin")
    .setPosition(10, 500)
    .setSize(200, 40)
    .setRange(0, 127)
    .setValue(0)
    .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0);
  ;

  // add a vertical slider
  cp5.addSlider("sliderXmax")
    .setPosition(390, 500)
    .setSize(200, 40)
    .setRange(0, 127)
    .setValue(0)
    .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0);

  ;




  // create another slider with tick marks, now without
  // default value, the initial value will be set according to
  // the value of variable sliderTicks2 then.
  cp5.addSlider("Threshold")
    .setPosition(800, 150)
    .setSize(40, 300)
    .setRange(-50, 50)
    .setValue(15)

    // .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0);


  ;

  // cp5.getController("Threshold").setLabelVisible(false);

  cp5.addSlider("Distance")
    .setPosition(900, 150)
    .setSize(40, 300)
    .setRange(0, 50)
    .setValue(10)

    // .setNumberOfTickMarks(21)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0);


  ;

  // cp5.getController("Threshold").setLabelVisible(false);








  cp5.addCheckBox("checkBox")
    .setPosition(800, 20)
    .setSize(40, 40)
    .setItemsPerRow(2)
    .setSpacingColumn(60)
    .setSpacingRow(30)
    .addItem("INVERT X", 0)
    .addItem("INVERT Y", 50)
    .addItem("Mode: Movement or colour Track", 100)
    

   .toggle(2)
   ;

  cp5.addCheckBox("checkBox2")
 .setPosition(750, 500)
    .setSize(40, 40)
    .setItemsPerRow(2)
    .setSpacingColumn(60)
    .setSpacingRow(30)
    .addItem("Calibrate", 0)
    .addItem("Laser", 50)

 
   

    ;




  myTextlabelA = cp5.addTextlabel("Program Name")
    .setText("FIRE CONTROL - CS02")
    .setPosition(0, 570)
    .setColorValue(0xffffff00)
    .setFont(createFont("Georgia", 20))
    ;

  myTextlabelB = cp5.addTextlabel("Version")
    .setText("Version 1.0 Block 1B")
    .setPosition(800, 570)
    .setColorValue(0xffffff00)
    .setFont(createFont("Georgia", 18))
    ;
}

void draw() {

 if (MODE==0){
     background(51);
     
        
      video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);

 textSize(18);
    fill(255, 0, 0);
    text("Movement Track",20,20);

    
  //threshold = map(mouseX, 0, width, 0, 100);


  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        //stroke(255);
        //strokeWeight(1);
        //point(x, y);
        avgX += x;
        avgY += y;
        count++;
       //pixels[loc] = color(255);
      }// else {
        //pixels[loc] = color(0);
      //}
    }
  }
  updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
    // Draw a circle at the tracked pixel
  }
  
  
  
  
  lerpX = lerp(lerpX, motionX, 0.1); 
  lerpY = lerp(lerpY, motionY, 0.1); 

    
  float fbytex=map(lerpX,0,640+limitXmin,0,127-limitXmax);
   float fbytey=map(lerpY,0,480,0+limitYmin,127-limitYmax);

  byte bytex=byte(fbytex);
  byte  bytey=byte(fbytey);
  
      myPort.write(Integer.toString(bytex));         //send a 1
   myPort.write('x');
  print("x " +(Integer.toString(bytex)));         //send a 1
////////////
    myPort.write(Integer.toString(bytey));         //send a 1

   myPort.write('y');
   
   println("y "+(Integer.toString(bytey)));         //send a 1

    myPort.write(Integer.toString(byte(50)));         //send a 1

    myPort.write('f');
   


}
  
 
  //println("lerpx " + lerpX + "lerpy" +lerpY);
  
    
  fill(255, 0, 0);
  strokeWeight(1.0);
  stroke(255);
  ellipse(lerpX, lerpY, 10, 10);

  //image(video, 0, 0, 100, 100);
  //image(prev, 100, 0, 100, 100);

  //println(mouseX, threshold);
  

   
   
     if ((lerpX -lerpXprev)>2){
    FIRECNT++;
     
 // println("FIRE "+FIRECNT);
  
 
   
 lerpXprev = lerpX;
  lerpYprev = lerpY;   
   
    
}

 

if (MODE==3){
       background(51);

    image(video, 0, 0);
  loadPixels();
   textSize(18);
    fill(255, 0, 0);
    text("Select Mode to Enable",20,20);
}


if (MODE==1){
         background(51);


    video.loadPixels();
  image(video, 0, 0);
  
       
        textSize(18);
    fill(255, 0, 0);
    text("Colour Track",20,20);
  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) {
        worldRecord = d;
        closestX = x;
        closestY = y;
        
          
          
          
          
        
        
      }
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < threshold) { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
    
    if (invertX==0){fbytex=map(closestX,0,640,limitXmin+0,127-limitXmax);}
        if (invertX==1){fbytex=map(closestX,0,640,127-limitXmax,limitXmin+0);}

    if (invertY==0){fbytey=map(closestY,0,480,0+limitYmin,127-limitYmax);  }
       if (invertY==1){fbytey=map(closestY,0,480,127-limitYmax,0+limitYmin);}

   

 
  byte bytex=byte(fbytex);
  
  
  byte  bytey=byte(fbytey);
 // print("closest ");
    // print("x " +(Integer.toString(bytex)));         //send a 1
   //println("   y "+(Integer.toString(bytey)));         //send a 1


   myPort.write(Integer.toString(bytex));         //send a 1
   myPort.write('x');
 //println("x " +(Integer.toString(bytex)));         //send a 1
   
       myPort.write(Integer.toString(bytey));         //send a 1
   myPort.write('y');
 // println("y "+(Integer.toString(bytey)));         //send a 1

 myPort.write((Integer.toString(byte(50))));         //send a 1
    //println("fire "+(Integer.toString(byte(50))));         //send a 1

    myPort.write('f');
      //  println("FIRE");
        
        
    
    
  }
  else {
 myPort.write((Integer.toString(byte(0))));         //send a 1
    myPort.write('f');
               // println("LASER OFF");

  }
  
  
  
  
  
  
  
}

  
  
if(MODE==5){
           
      video.loadPixels();
  prev.loadPixels();
  image(video, 0, 0);
 
if ((calx<639)&&(caly<479)){

   closestX = calx;
  closestY = caly;
  
 
}
  fill(128, 0, 0);
  strokeWeight(1.0);
  stroke(240);
  ellipse(closestX, closestY, 40, 40);
  
   
  if (invertX==0){fbytex=map(closestX,0,640,limitXmin+0,127-limitXmax);}
        if (invertX==1){fbytex=map(closestX,0,640,127-limitXmax,limitXmin+0);}

    if (invertY==0){fbytey=map(closestY,0,480,0+limitYmin,127-limitYmax);  }
       if (invertY==1){fbytey=map(closestY,0,480,127-limitYmax,0+limitYmin);}
 
  byte bytex=byte(fbytex);
  
  
  byte  bytey=byte(fbytey);
 // print("closest ");
    // print("x " +(Integer.toString(bytex)));         //send a 1
   //println("   y "+(Integer.toString(bytey)));         //send a 1


   myPort.write(Integer.toString(bytex));         //send a 1
   myPort.write('x');
 println("x " +(Integer.toString(bytex)));         //send a 1
   
       myPort.write(Integer.toString(bytey));         //send a 1
   myPort.write('y');
 println("y "+(Integer.toString(bytey)));         //send a 1
  delay(100);
  }

 
}

void Distance(int distance) {
  println("Disrance "+distance);
}


void Threshold(int thres) {
  println("Threshold "+thres);
  threshold=thres;
}


void sliderYmax(int maxY){
  println("Ylimit MAX  "+maxY);
  limitYmax=maxY;
}
void sliderYmin(int minY){
  println("Ylimit min  "+minY);
  limitYmin=minY;
}

void sliderXmax(int maxX){
  println("Xlimit MAX  "+maxX);
  limitXmax=maxX;
}
void sliderXmin(int minX){
  println("Xlimit min  "+minX);
  limitXmin=minX;
}








void checkBox(float[] a) {
  println("Checkbox value");

  println(a);

  if (a[0]==1) {
    println("invert X");
    invertX=1;
  }else {
    println("not inverted X");
    invertX=0;
  }
  
    if (a[1]==1) {
    println("invert Y");
  invertY=1;
  }else {
 
    println("not inverted Y");
     invertY=0;
  
  }
  
  
  if (MODE!=5){
    if (a[2]==1) {
    println("Colour Track");
  cp5.getController("Distance").setVisible(false);
  MODE=1;
        println("MODE =1");

  
  }
  
  
  
   if (a[2]==0) {
      cp5.getController("Distance").setVisible(true);
      MODE=0;
      println("MODE =0");
 
  }
  }
  
  
  
  
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}


void captureEvent(Capture video) {
  prev.copy(video,0,0, 640,480,0,0,640,480);
  prev.updatePixels();
  video.read();
}





void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  
  
  int loc = constrain(mouseX, 0, 639) + (constrain(mouseY, 0, 479))*video.width;
  
 print("X "+constrain(mouseX, 0, 639));
  println(" Y "+constrain(mouseX, 0, 479));

calx=constrain(mouseX, 0, 639);
caly=constrain(mouseY, 0, 479);


   print("Colour = ");

  trackColor = video.pixels[loc];
  println(red(trackColor), green(trackColor), blue(trackColor));
  
  
  
  
}







void checkBox2(float[] a) {
  println("Checkbox2 value");

  println(a);

  if (a[0]==1) {
    println("Cal mode");
      MODE=5;
     
  
  if (MODE==5){ //calibration mode
 
  }
     
     
     
     
    
  }
 if (a[0]==0) {
    println("Normal Mode");
        MODE=3;

  }
  
  
  
   if (a[1]==1) {
    println("Laser on");
    
 myPort.write((Integer.toString(byte(50))));         //send a 1
    //println("fire "+(Integer.toString(byte(50))));         //send a 1

    myPort.write('f');
      //  println("Laser ON");
    
  }
  if (a[1]==0) {
    println("Laser off");
      
 myPort.write((Integer.toString(byte(0))));         //send a 1
    //println("fire "+(Integer.toString(byte(50))));         //send a 1

    myPort.write('f');
      //  println("Laser OFF");
  }
  
  
  
  
  
  
}
