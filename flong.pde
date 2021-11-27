
int gmscr = 0;
int ballx, bally, ballsize = 20;
int gravity = 1, ballspeedvrt = 0;
int airfriction = 1,friction = 1;
color racketcolor = color(0), ballcolor = color(0);
int racketwidth = 100,racketheight = 10,racketboncerate = 20;
int ballspeedhorz = 10;
int wallSpeed = 5,wallInterval = 1000,lastAddTime = 0;
int wallWidth = 80,wallColors = color(0);

int minGapHeight = 200,maxGapHeight = 300;
//arraylist stores data of gaps b/w walls
//[gapWallX,gapWallY,gapWallWidth,gapWalHeight]

ArrayList<int[]> walls = new ArrayList<int[]>();

int health = 100,maxHealth = 100,healthDrop = 1,healthBar = 70;

/********** setup block************/  
void setup() {
size(500, 500);
ballx = width / 4;
bally = height / 5;

}
void mousePressed() {
if (gmscr==0) {
gmscr=1;
}else if (gmscr==2) {
gmscr=3;
}else if(gmscr==3){
gmscr=0;
}
}

/***********draw block******/
void draw() {
    if (gmscr == 0) {
        intiscreen();
    } 
    if (gmscr == 1) {
        gamescreen();
    } 
    if (gmscr == 2) {
        restart();
      
    if(gmscr==3){
      gameover();
      
    }
           
    }
}
/*****screen block******* */

void intiscreen() {
background(0);
textAlign(CENTER);
text("start", height / 2, width / 2);

}


void gamescreen() {
background(255);
drawball();
applygarvty();
keepinscreen();
drawracket();
watchracketbounce();
applyhorspeed();
wallAdder();
wallHandler();
drawHealthbar();
printScore();
}


void applygarvty() {
ballspeedvrt += gravity;
bally += ballspeedvrt;
ballspeedvrt -= (ballspeedvrt*(airfriction/1000));

}

void makebouncebotom(int surface) {
bally = surface - (ballsize / 2);
ballspeedvrt *= -1;
ballspeedvrt -= (ballspeedvrt * (friction/10));

}

void makebouncetop(int surface) {
bally = surface + (ballsize / 2);
ballspeedvrt *= -1;
ballspeedvrt -= (ballspeedvrt * (friction/10));

}

void drawracket() {
fill(racketcolor);
rectMode(CENTER);
rect(mouseX,mouseY,racketwidth,racketheight);

}

void watchracketbounce() {
int overhead = mouseY - pmouseY;
if (ballx + (ballsize / 2)>mouseX - (racketwidth / 2) && 
(ballx - (ballsize / 2)<mouseX + (racketwidth / 2))) {
if (dist(ballx,bally,ballx,mouseY)<= (ballsize / 2) + abs(overhead)) {
makebouncebotom(mouseY);
ballspeedhorz = (ballx - mouseX) / 5;
//racket moving up
if (overhead < 0) {
bally += overhead;
ballspeedvrt += overhead;
}

}
    }


}

void applyhorspeed() {
ballx += ballspeedhorz;
ballspeedhorz -= (ballspeedhorz * (airfriction/1000));
}

void makebounceleft(int surface) {
ballx = surface + (ballsize / 2);
ballspeedhorz *= -1;
ballspeedhorz -= (ballspeedhorz * (friction/10));
}
void makebounceright(int surface) {
ballx = surface - (ballsize / 2);
ballspeedhorz *= -1;
ballspeedhorz -= (ballspeedhorz * (friction/10));

}
void keepinscreen() {
//ball hits floor
if (bally + (ballsize / 2) > height) {
makebouncebotom(height);
    }
if (bally - (ballsize / 2) < 0) {
makebouncetop(0);
    }
if ((ballx + (ballsize / 2))>width) {
makebounceright(width);
    }
if (ballx - (ballsize/2)<0) {
makebounceleft(0);
}

}

void wallAdder() {
if (millis() - lastAddTime > wallInterval) {
int randHeight = round(random(minGapHeight,maxGapHeight));
int randY = round(random(0,height - randHeight));
int[] randWall = {width,randY,wallWidth,randHeight,0};
walls.add(randWall);
lastAddTime = millis();

    }

}
void wallHandler() {
for (int i = 0; i < walls.size(); i++) {
wallRemover(i);
wallMover(i);
wallDrawer(i);
watchWallcollision(i);
    }

}

void wallDrawer(int index) {
int[] wall = walls.get(index);

int gapWallX = wall[0];
int gapWallY = wall[1];
int gapWallWidth = wall[2];
int gapWalHeight = wall[3];

rectMode(CORNER);
fill(wallColors);
rect(gapWallX,0,gapWallWidth,gapWallY);
rect(gapWallX,gapWallY + gapWalHeight,gapWallWidth,height - (gapWallY + gapWalHeight));

}
void wallMover(int index) {
int[]wall = walls.get(index);
wall[0] -= wallSpeed;

}
void wallRemover(int index) {
int[]wall = walls.get(index);
if (wall[0] + wall[2] <=  0) {
walls.remove(index);
    }

}

void drawHealthbar(){
noStroke();
fill(236, 240, 231);
rectMode(CORNER);
rect(ballx-(healthBar/2),bally-30,healthBar,5);
if (health>60) {
fill(46, 204, 113);
    }else if (health>30) {
fill( 222,45,45 );
    }else {
fill( 231 ,76 ,60 );
    }
rectMode(CORNER);
rect(ballx-(healthBar/2),bally-30,healthBar*(health/maxHealth),5);
}

void decreaseHealth(){
health -= healthDrop;

}

void gameover(){

background(0);

textAlign(CENTER);
fill(255);
textSize(30);
text(  "GAMOVER",height/2,width/2-20);
textSize(15);
text(  "click to restart", height/2, width/2-10);


 
}


int score;
void restart(){
score=0;
health=maxHealth;
ballx=width/4;
bally=height/5;
lastAddTime=0;
walls.clear();


}



void watchWallcollision(int index){
int[] wall=walls.get(index);
//gap wall settings
int gapWallX=wall[0];
int gapWallY=wall[1];
int gapWallWidth=wall[2];
int gapWalHeight=wall[3];
int wallScored=wall[4];
int wallTopX=gapWallX;
int wallTopY=0;
int wallTopWidth=gapWallWidth;
int wallTopheight=gapWallY;
int wallbottomx=gapWallX;
int wallbottomy=gapWallY+gapWalHeight;
int wallbottomheight=height-(gapWallY-gapWalHeight);
int wallbottomwidth=gapWallWidth;


if(
(ballx+(ballsize/2)>wallTopX)&&
(ballx-(ballsize/2)<wallTopX+wallTopWidth)&&
(bally+(ballsize/2)>wallTopY)&&
(bally-(ballsize/2)<wallTopY+wallTopheight)
){
//collids with upper wall
decreaseHealth();
}
if((ballx+(ballsize/2)> wallbottomx) &&
(ballx-(ballsize/2)<wallbottomx+wallbottomwidth) &&
(bally+(ballsize/2)>wallbottomy) &&
(bally-(ballsize/2)<wallbottomy+wallbottomheight)
){
//collids with bottom wall
decreaseHealth();
}
if (ballx>gapWallX+(gapWallWidth/2)&&wallScored==0) {
wallScored=1;
wall[4]=1;
score++;
if (health<=0) {
  background(0);
  textAlign(CENTER);
textSize(30);
  fill(27,216,11);

text(  score, height/2,200);
gmscr=2;

    }
}

}

void printScore(){
textAlign(CENTER);
fill(0);
textSize(30);
text(  score, height/2, 50);
}




void drawball() {
fill(ballcolor);
ellipse(ballx, bally, ballsize, ballsize);

}
