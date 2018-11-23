/* RAN ROVER REMOTE CONTROL for Makeblock MegaPi
  by www.nuvotion.com.au
  littlebird.com.au
  modified 22/10/2018
  by NICK OWEN
  Version 1.0 Block A
*/

#include "MeMegaPi.h"
MeMegaPiDCMotor motor1(PORT4A);
MeMegaPiDCMotor motor2(PORT4B);
MeMegaPiDCMotor motor3(PORT3A);
MeMegaPiDCMotor motor4(PORT3B);
MeMegaPiDCMotor motor5(PORT2A);
MeMegaPiDCMotor motor6(PORT2B);
MeMegaPiDCMotor motor7(PORT1A);
MeMegaPiDCMotor motor8(PORT1B);


uint8_t motorSpeed = 200;

int Mode = 0;

int ch1; // Here's where we'll keep our channel values
int ch2;
int ch3;
int ch4;
int ch5;


void setup() {
  pinMode(24, INPUT); // Set our input pins as such
  pinMode(26, INPUT); // Set our input pins as such
  pinMode(28, INPUT);
  pinMode(30, INPUT);

  Serial.begin(9600); // Pour a bowl of Serial

}

void loop() {

  ch1 = pulseIn(30, HIGH, 100000); // Read the pulse width of
  ch2 = pulseIn(28, HIGH, 100000); // each channel
  ch3 = pulseIn(26, HIGH, 100000);
  ch4 = pulseIn(24, HIGH, 100000);
  ch5 = pulseIn(22, HIGH, 100000);






  /////////////////////////////MODE SELECT SWITCH CH5////
  Serial.print("  Channel 5 Switch:  "); // Ch5 Switch
  int E = map(ch5, 1000, 2000, -255, 255); // center at 0
  Serial.println(E); // center at 0
  if (E > 100) {
    Mode = 0;
    Serial.println("Mode 0");
  }
  if (E < -100) {
    Mode = 1;
    Serial.println("Mode 1");
  }
  //////////////////////////////////////////


  if (Mode == 0) {
    ///////////////////////right stick x//////////////////////
    Serial.print("Right Stick up down C:"); // Ch3 was x-axis
    int C = map(ch3, 1000, 2000, -255, 255); // center at 0
    // C deadzone
    if ((C < 50) && (C > -50)) {
      C = 0;
    }
    Serial.print(C); // center at 0
    if (C > 50) { // move forward
      forward(C);
    }
    if (C < -50) { // move forward
      reverse(C);
    }
    ////////////////////////



    ///////////////////////right stick y/////////////////////////
    Serial.print("  Right Stick  LEFT/RIGHT D:"); // Ch3 was x-axis
    int D = map(ch1, 1000, 2000, -255, 255); // center at 0
    // D deadzone
    if ((D < 50) && (D > -50)) {
      D = 0;
    }
    Serial.println(D); // center at 0
    if (D > 50) { //move left
      LEFT(D);
    }
    if (D < -50) { //move left
      RIGHT(D);
    }
    ////////////////////////

    /////////////////STOP///////////////////
    if ((C == 0) && (D == 0)) {
      stop();
    }
    ///////////////////////


    /////////////////////////////LEFT STICK UP/DOWN////
    Serial.print("  LEFT Stick  UP/DOWN A:"); // Ch3 was x-axis
    int A = map(ch2, 1000, 2000, -255, 255); // center at 0
    // A deadzone
    if ((A < 50) && (A > -50)) {
      A = 0;
    }
    Serial.println(A); // center at 0
    motor1.run(A);
    //////////////////////////////////////////

    /////////////////////////////LEFT STICK UP/DOWN////
    Serial.print("  LEFT Stick  UP/DOWN B:"); // Ch3 was x-axis
    int B = map(ch4, 1000, 2000, -255, 255); // center at 0
    // B deadzone
    if ((B < 50) && (B > -50)) {
      B = 0;
    }
    Serial.println(B); // center at 0
    motor3.run(B);
    //////////////////////////////////////////

  } //end of mode 0



  if (Mode == 1) {
    ///////////////////////right stick x//////////////////////
    Serial.print("Right Stick up down C:"); // Ch3 was x-axis
    int C = map(ch3, 1000, 2000, -255, 255); // center at 0
    // C deadzone
    if ((C < 50) && (C > -50)) {
      C = 0;
    }
    Serial.print(C); // center at 0
    motor2.run(C);

    ////////////////////////



    ///////////////////////right stick y/////////////////////////
    Serial.print("  Right Stick  LEFT/RIGHT D:"); // Ch3 was x-axis
    int D = map(ch1, 1000, 2000, -255, 255); // center at 0
    // D deadzone
    if ((D < 50) && (D > -50)) {
      D = 0;
    }
    Serial.println(D); // center at 0
    motor4.run(D);

    ////////////////////////


    /////////////////////////////LEFT STICK UP/DOWN////
    Serial.print("  LEFT Stick  UP/DOWN A:"); // Ch3 was x-axis
    int A = map(ch2, 1000, 2000, -255, 255); // center at 0
    // A deadzone
    if ((A < 50) && (A > -50)) {
      A = 0;
    }
    Serial.println(A); // center at 0
    motor1.run(A);
    //////////////////////////////////////////

    /////////////////////////////LEFT STICK UP/DOWN////
    Serial.print("  LEFT Stick  UP/DOWN B:"); // Ch3 was x-axis
    int B = map(ch4, 1000, 2000, -255, 255); // center at 0
    // B deadzone
    if ((B < 50)
        && (B > -50)) {
      B = 0;
    }
    Serial.println(B); // center at 0
    motor3.run(B);
    //////////////////////////////////////////

  } //end of mode 1











  Serial.println(); //make some room

  delay(100);// I put this here just to make the terminal
  // window happier
}

void forward(int speed) {

  motor6.run(-speed); /* value: between -255 and 255. */

  motor8.run(speed); /* value: between -255 and 255. */
  Serial.println("FWD"); //
}

void reverse(int speed) {

  motor6.run(-speed); /* value: between -255 and 255. */

  motor8.run(speed); /* value: between -255 and 255. */
  Serial.println("REV"); //

}
void stop(void) {

  motor6.run(0); /* value: between -255 and 255. */

  motor8.run(0); /* value: between -255 and 255. */
}


void LEFT(int speed) {
  motor6.run(speed); /* value: between -255 and 255. */
  motor8.run(speed); /* value: between -255 and 255. */
}

void RIGHT(int speed) {
  motor6.run(speed); /* value: between -255 and 255. */
  motor8.run(speed); /* value: between -255 and 255. */
}






