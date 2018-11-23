/* RAN FIRE CONTROL WEBCAM TRACKER TO SERVO
  by www.nuvotion.com.au
  littlebird.com.au 
  modified 22/10/2018
  by NICK OWEN

 Version 1.0 Block A
*/

#include <Servo.h>
int c;
int v = 0;
int val; // Data received from the serial port
int ledPin = 13; // Set the pin to digital I/O 13


///pins keep in mind this has been mapped for the makeblock mega pi
int laser = A10; // pin the laser is connected to
int Xservo = A8; // attaches the servo on pin 9 to the servo object
int Yservo = A9; // attaches the servo on pin 9 to the servo object



String str;

unsigned int Xvalue = 0;
Servo Xaxis;  // create servo object to control a servo
Servo Yaxis;  // create servo object to control a servo

// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
  pinMode(laser, OUTPUT);
  digitalWrite(laser, LOW);    // turn the LED off by making the voltage LOW

  Xaxis.attach(Xservo);  // attaches the servo on pin 9 to the servo object
  Yaxis.attach(Yservo);  // attaches the servo on pin 9 to the servo object

  Serial.println("Fight and win at sea");
  //wait 100 milliseconds so we don't drive ourselves crazy
  delay(100);
}

void loop() {
  // read serial-data, if available
  while (Serial.available()) {
    c = Serial.read();
    // handle digits
    if ((c >= '0') && (c <= '9')) {
      v = 10 * v + c - '0';
    }
    // handle delimiter
    else if (c == 'x') {
      Serial1.println(v);
      Xaxis.write(v);              // tell servo to go to position in variable 'pos'

      v = 0;
    }
    else if (c == 'y') {
      Serial1.println(v);
      Yaxis.write(v);              // tell servo to go to position in variable 'pos'

      v = 0;
    }

    else if (c == 'f') {
      //fire laser 
      Serial1.println(v);

      if (v>40){
      digitalWrite(A10, HIGH);   // turn the LED on (HIGH is the voltage level)1
      }else{      digitalWrite(A10, LOW);   // turn the LED on (HIGH is the voltage level)1
      }
      
      v = 0;
    }

  }



}

