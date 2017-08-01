//here all Drop means Box
import ddf.minim.*;
Minim minim  = new Minim(this); // created minim library
AudioPlayer song;
AudioSample square, wrong, button;
Catcher catcher;    // One catcher object
Timer timer;        // One timer object
Drop[] drops;       // An array of drop objects
boolean k=false; // for powerUp and Down timer, see in class catcher
Drop firstDrop; //for first drop
int totalDrops = 0; // totalDrops
boolean screen1=false, screen2=false;//screen1=active game screen, screen2=gameover screen
PFont myFont;
int squares=0, score=0, sizeCatcher=30;
float speed=2;
float r=0; // for rotating
PImage square1;
Timer timerX ; // for powerUp
void setup() {
  size(550, 400);
  rectMode(CENTER);
  smooth();
  song = minim.loadFile("song.mp3");
  square= minim.loadSample("square.mp3");
  wrong= minim.loadSample("wrong.mp3");
  button= minim.loadSample("button.mp3");
  song.play();
  song.loop();
  myFont = createFont("serif", 12, true);
  firstDrop=new Drop();
  drops = new Drop[30];    // Create 30 spots in the array
  timer=new Timer(1800);
  timer.start();
  setuper();
}
void gameOver() {
  screen1=false;
  screen2=true;
  background(255);
  drawButton(height/2-100, "Game Over \n Your score is "+score+"", #FFFFFF, 30, false);
  drawButton(height/2+50, "Try Again", #FFFFFF, 30, true);
  totalDrops=0;
}
void drawButton(float y, String s, color clr, int align, boolean k) {
  stroke(0);
  fill(clr);
  float x = width/2;
  if (k) {
    rectMode(CORNER);
    rect(x-90, y-35, 180, 70);
    rectMode(CENTER);
  }
  textFont(myFont, 16);
  textSize(40);
  textAlign(CENTER, CENTER);
  fill(0);
  text(s, x, y);
}
void setuper() {
background(255);
  fill(0);
  textSize(60);
  text("Squares 2", width/4, height/4-25);
 textSize(18);
  text("  ", 65, height/8+25);
  drawButton(height/2-50, "Play", #FFFFFF, 0, true);
  drawButton(height/2+50, "Help", #FFFFFF, 0, true);
}
void displayHelp() {

  textSize(20);
  String mesg = 
    "Squares:\n Pick only black boxes\nRed boxes are your enemies\n Black circles increses your poins by 1000\n Red circles decreses your points by 1000"
    ;
  stroke(255);
  fill(255);
  float x = width/2, y = height/2+100;
  rect(width/2, height/2+150, 300, 300);
  textFont(myFont, 18);
  fill(0);
  text(mesg, x, y);
}
void mouseClicked(){
    if (screen1==false)
    {
      if (screen2) {
        if (mouseX>=width/2-90 && mouseX<=width/2+90 &&mouseY>=height/2+15 && mouseY<=height/2+80) {
          button.trigger();
          score=0;
          squares=0;
          screen1=true;
          screen2=false;
          sizeCatcher=30;
          r=0;
          firstDrop=new Drop();
          timer.start();
        }
      }
      if (screen2==false && (mouseX>=width/2-90 && mouseX<=width/2+90 &&mouseY>=height/2-85 && mouseY<=height/2-20)) {
        button.trigger();
        score=0;
        squares=0;
        screen1=true;
        timer.start();
      }
      if (mouseX>=width/2-90 && mouseX<=width/2+90 &&mouseY>=height/2+15 && mouseY<=height/2+80) { //help
        button.trigger();
        displayHelp();
      }
    }
  
}
void draw() {
  if (screen1) {
    background(255);
    catcher = new Catcher(sizeCatcher); // Create the catcher with a length of 50
    fill(0);
    textSize(82);
    text(""+score+"", width/2, height/3+50);
    textSize(32);
    text("Squares "+squares+"", width/2, height/3+150);

    // Starting the timer
    // Set catcher location
    catcher.setLocation(mouseX, mouseY); 
    //  // Display the catcher
    catcher.display(); 
    //drops[0]=new Drop();
    firstDrop.move();
    firstDrop.display();
    catcher.intersect(firstDrop);
    // Check the timer
    if (timer.isFinished()) {
      // Deal with boxes
      // Initialize one box
      drops[totalDrops] = new Drop();

      // Increment totalDrops
      totalDrops ++ ;
      // If we hit the end of the array
      if (totalDrops >= drops.length) {
        totalDrops = 0; // Start over
      }
      score++;
      timer.start();
    }

    // Move and display all boxes
    for (int i = 0; i < totalDrops; i++ ) {
      drops[i].move();
      drops[i].display();
      catcher.intersect(drops[i]);
    }
  }
}

class Timer {
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}

class Drop {
  // there are 10 variables means that 4 blacks 4 reds, one powerrUp ,one powerDown
  float x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9, x10, y10;   // Variables for location of raindrop
  color c1, c2;
  float l;     // Radius of raindrop 
  Drop() {
    l = 20;
    // in below, l is multiplied to some numbers which means that the squraes will come one by one---keeping a certain distance 
    //up
    x1 = random(width);     
    y1 = -l*90; 
    //down
    x2 = random(width);     
    y2 = height+ l*10;
    //left
    y3 = random(height);     
    x3 = -l*70;
    //right
    y4 = random(height);     
    x4 = width + l*50;
    //powerUp
    y9 = random(height);     
    x9 = width + l*100; // for coming late
    //powerDown
    y10 = random(height);     
    x10 = -l*150;  // for coming late
    //up
    x5 = random(width);     
    y5 = -l*100;
    //down
    x6 = random(width);     
    y6 = height+ l*80;
    //left
    y7 = random(height);     
    x7 = -l*60;
    //right
    y8 = random(height);     
    x8 = width + l*4;
    c2 = color(#FF0000);
    c1 = color(#000000);
  }
  void move() {
    //move all in thier direction
    y1 += speed;
    y2-=speed;
    x3+=speed;
    x4-=speed;
    x9-=speed;
    y5 += speed;
    y6-=speed;
    x7+=speed;
    x10+=speed;
    x8-=speed;
  }
  void display() {
    // Display the box of red
    noStroke();
    fill(c1); 
    ellipse(x9, y9, 25, 25);
    rect(x1, y1, 20, 20);
    rect(x2, y2, 20, 20);
    rect(x3, y3, 20, 20);
    rect(x4, y4, 20, 20);
    // Display the box of black
    fill(c2);
    ellipse(x10, y10, 25, 25); 
    rect(x5, y5, 20, 20);
    rect(x6, y6, 20, 20);
    rect(x7, y7, 20, 20);
    rect(x8, y8, 20, 20);
  }
}

class Catcher {
  float l;   // length
  color col; // color
  float x, y; // location

  Catcher(float tempR) {
    l = tempR;
    col = color(#000000);
    x = 0;
    y = 0;
  }

  void setLocation(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void display() {
    stroke(0);
    fill(col);
    pushMatrix(); // for start rotate
    translate(x, y); 
    rotate(r);
    rect(0, 0, l, l);
    r=r+0.05;
    popMatrix(); // not to rotate any other shape
  }
  // A function that returns true or false based on
  //  // if the catcher intersects a raindrop
  void intersect(Drop d) {

    if (k) {
      if (timerX.isFinished()) {
        speed=2;
      }
    }
    // Calculate distance
    float distance1 = dist(x, y, d.x1, d.y1); 
    float distance2 = dist(x, y, d.x2, d.y2); 
    float distance3 = dist(x, y, d.x3, d.y3); 
    float distance4 = dist(x, y, d.x4, d.y4); 
    float distance5 = dist(x, y, d.x5, d.y5); 
    float distance6 = dist(x, y, d.x6, d.y6); 
    float distance7 = dist(x, y, d.x7, d.y7); 
    float distance8 = dist(x, y, d.x8, d.y8);
    float distance9 = dist(x, y, d.x9, d.y9); 
    float distance10 = dist(x, y, d.x10, d.y10);
    //Compare distance 
    //for blacks -1000 means that it will move beyond the screen
    float dist=(0.6*(l+20)); // minimum distance between catcher and square
    if (distance1<dist) {
      square.trigger();
      squares++;
      score+=50;
      sizeCatcher+=0.75; //for increasing size
      d.y1 = - 1000;
    } else if (distance2<dist) {
      square.trigger();
      squares++;
      score+=50;
      sizeCatcher+=0.75;//for increasing size
      d.y2 = - 1000;
    } else if (distance3<dist) {
      square.trigger();
      squares++;
      score+=50;
      sizeCatcher+=0.75;//for increasing size
      d.x3 = - 1000;
    } else if (distance4<dist) {
      square.trigger();
      squares++;
      score+=50;
      sizeCatcher+=0.75;//for increasing size
      d.x4 = - 1000;
    } else if (distance9<0.5*l/2+12.5) { //for powerUp
      timerX = new Timer(6000);
      k=true;  // for starting timer of speed
      timerX.start();
      square.trigger(); 
      score+=1000; 
      d.x9 = - 1000; 
      speed=0.9;  // for decreasing speed
      textSize(60);
      text("+1000", x-50, y-50);
      if (sizeCatcher>=28) {
        sizeCatcher-=5;//for decreasing size
      }
    } else if (distance10<0.5*l+12.5) {// for powerDown
      timerX = new Timer(6000);
      k=true;
      timerX.start();
      wrong.trigger();
      score-=1000;
      d.x10 = - 1000;
      textSize(60);
      text("+1000", x-50, y-50);
      sizeCatcher+=1;//for increasing size
      speed=2.75; // for increasing speed
    }
    //for reds
    else if (distance5<dist || distance6<dist||distance7<dist||distance8<dist) {
      wrong.trigger();
      gameOver();
    }
  }
}

