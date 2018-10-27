

//this code send outputs from matlab to arduino. Channel Available in arduino:
// 2,3,4,5,6,7
// this is becasue 0 and 1 doesen't works, and from 8 to 13 neither.Don't know why

// in order to use these ports on matlab, see the matlab code in the folder

int ledPin2 = 2;
int ledPin3 = 3;
int ledPin4 = 4;
int ledPin5 = 5;
int ledPin6 = 6;
int ledPin7 = 7;

int matlabData;
 
void setup() 
{
  pinMode(ledPin2,OUTPUT);
  pinMode(ledPin3,OUTPUT);
  pinMode(ledPin4,OUTPUT);
  pinMode(ledPin5,OUTPUT);
  pinMode(ledPin6,OUTPUT);
  pinMode(ledPin7,OUTPUT);

  Serial.begin(9600);
}
 
void loop() 
{
   
   if(Serial.available()>0) // if there is data to read
   {
    matlabData=Serial.read(); // read data

    // pin da 2 a 4
     if (matlabData==3)
        digitalWrite(ledPin2,HIGH); // turn light on
    else if(matlabData==4)
      digitalWrite(ledPin2,LOW); // turn light off
    if(matlabData==5)
      analogWrite(ledPin3,255); // turn light on
    else if(matlabData==6)
      analogWrite(ledPin3,0); // turn light off
      else if (matlabData==7)
        digitalWrite(ledPin4,HIGH); // turn light on
    else if(matlabData==8)
      digitalWrite(ledPin4,LOW); // turn light off

  // pin da 5 a 7
  
    else  if(matlabData==9)
      analogWrite(ledPin5,255); // turn light on
    else if(matlabData==10)
      analogWrite(ledPin5,0); // turn light off
      else if (matlabData==11)
        analogWrite(ledPin6,255); // turn light on
    else if(matlabData==12)
      analogWrite(ledPin6,0); // turn light off
    if(matlabData==13)
      digitalWrite(ledPin7,HIGH); // turn light on
    else if(matlabData=14)
      digitalWrite(ledPin7,LOW); // turn light off
  }
}
