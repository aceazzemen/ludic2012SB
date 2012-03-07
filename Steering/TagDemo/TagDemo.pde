/*
 *
 * The tagDemo sketch
 *
 */
 
public static int PLAYER_NUM = 30;
public static float WANDERDIST = 50;
public static int KEEP_AWAY = 150;
public static int WALL = 10;

public static float cMass;
public static float cForce;
public static float cSpeed;

public static float tMass;
public static float tForce;
public static float tSpeed;

public static float fMass;
public static float fForce;
public static float fSpeed;

public static float wMass;
public static float wForce;
public static float wSpeed;

// Agents
ArrayList<Agent> players;

//Catcher num;
int catcher;

//Chased;
int closestAgent;

//timer
int timer;

// Are we paused?
boolean pause;
// Is this information panel being displayed?
boolean showInfo;

// Initialisation
void setup() {
  size(1000,600); // Large display window
  pause = false;
  showInfo = true;
  
  cMass = 20;
  cForce = 3;
  cSpeed = 5;

  tMass = 8;
  tForce = 4;
  tSpeed = 4;

  fMass = 10;
  fForce = 3;
  fSpeed = 3;

  wMass = 10;
  wForce = 3;
  wSpeed = 3;

   
  /*** Hunter Agent ***/
  // Create the agent
  players = new ArrayList<Agent>();  
  for (int i = 0; i<PLAYER_NUM;i++){
    players.add(new Agent(10,10,randomPoint(),i));
  }
  
  catcher = 0;
  closestAgent = -1;
  //set first tagger
  setChased(); 
  
  timer = 0;
  
  smooth(); // Anti-aliasing on
}

// Pick a random point in the display window
PVector randomPoint() {
  return new PVector(random(width), random(height));
}

// The draw loop
void draw() {
  // Clear the display
  background(255); 
  
  // Move forward one step in steering simulation
  if (!pause) {
//update players
    setCatcher();

    setChased();

    for (int i = 0; i<PLAYER_NUM;i++){
      players.get(i).update();
    }
  }
  /**/
  
  // Draw the agent
    for (int i = 0; i<PLAYER_NUM;i++){
      players.get(i).draw();
    }
  
  // Draw the information panel
  if (showInfo) drawInfoPanel();
}
  
// Draw the information panel!
void drawInfoPanel() {
 
  pushStyle(); // Push current drawing style onto stack 
  fill(0);
  text("1 - toggle display", 10, 20);
  text("2 - toggle annotation", 10, 35);
  text("Space - play/pause", 10, 50);
  text("Click to move the target",10, 65);
  text("------ CATCHER -------",10, 80);
  text("Catcher: Player No. "+(catcher+1),10,95);
  text("Mass (q/a) = " + cMass, 10, 110);
  text("Max. Force (w/s) = " + cForce, 10, 125);
  text("Max. Speed (e/d) = " + cSpeed, 10, 140);
  text("------- CHASED -------",10, 155);
  text("Chased: Player No. "+(closestAgent+1),10,170);
  text("Mass (r/f) = " + tMass, 10, 185);
  text("Max. Force (t/g) = " + tForce, 10, 200);
  text("Max. Speed (y/h) = " + tSpeed, 10, 215);
  text("------- FLEE -------",200, 20);
  text("Mass (u/j) = " + fMass, 200, 35);
  text("Max. Force (i/k) = " + fForce, 200,50);
  text("Max. Speed (o/l) = " + fSpeed, 200,65);
  text("------- WANDER -------",200, 80);
  text("Mass (z/x) = " + wMass, 200, 95);
  text("Max. Force (c/v) = " + wForce, 200,110);
  text("Max. Speed (b/n) = " + wSpeed, 200,125);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Mouse clicked, so move the target
void mouseClicked() {
  players.get(catcher).position = new PVector (mouseX, mouseY);
  setChased();
}

// Key pressed
void keyPressed() {
   if (key == ' ') {
     togglePause();
     
   } else if (key == '1' || key == '!') {
     toggleInfo();
   } else if (key == '2' || key == '"') {
     for(int k=0;k<PLAYER_NUM;k++){
       players.get(k).toggleAnnotate();
     }   
   } else if (key == 'q' || key == 'Q') {
     cMass++;
   } else if (key == 'a' || key == 'A') {
     cMass--;
     if(cMass<1){cMass=1;}
     // Vary the huntert's maximum force
   } else if (key == 'w' || key == 'W') {
     cForce++;
   } else if (key == 's' || key == 'S') {
     cForce--;
     if(cForce<1){cForce=1;}
    //  Vary the hunter's maximum speed
   } else if (key == 'e' || key == 'E') {
     cSpeed++;
   } else if (key == 'd' || key == 'D') {
     cSpeed--;
     if(cSpeed<1){cSpeed=1;}
     /*** TARGET ***/  
   // Vary the target's mass
   } else if (key == 'r' || key == 'R') {
     tMass++;
   } else if (key == 'f' || key == 'F') {
     tMass--;
     if(tMass<1){tMass=1;}
     // Vary the target's maximum force
   } else if (key == 't' || key == 'T') {
     tForce++;
   } else if (key == 'g' || key == 'G') {
     tForce--;
     if(tForce<1){tForce=1;}
     // Vary the target's maximum speed
   } else if (key == 'y' || key == 'Y') {
     tSpeed++;
   } else if (key == 'h' || key == 'H') {
     tSpeed--;
     if(tSpeed<1){tSpeed=1;}
     //For Flee parameters
   } else if (key == 'u' || key == 'U') {
     fMass++;
   } else if (key == 'j' || key == 'J') {
     fMass--;
     if(fMass<1){fMass=1;}
     // Vary the target's maximum force
   } else if (key == 'i' || key == 'I') {
     fForce++;
   } else if (key == 'k' || key == 'K') {
     fForce--;
     if(fForce<1){fForce=1;}
     // Vary the target's maximum speed
   } else if (key == 'o' || key == 'O') {
     fSpeed++;
   } else if (key == 'l' || key == 'L') {
     fSpeed--;
     if(fSpeed<1){fSpeed=1;}
   //For Wander
   } else if (key == 'z' || key == 'Z') {
     wMass++;
   } else if (key == 'x' || key == 'X') {
     wMass--;
     if(wMass<1){wMass=1;}
     // Vary the target's maximum force
   } else if (key == 'c' || key == 'C') {
     wForce++;
   } else if (key == 'v' || key == 'V') {
     wForce--;
     if(wForce<1){wForce=1;}
     // Vary the target's maximum speed
   } else if (key == 'b' || key == 'B') {
     wSpeed++;
   } else if (key == 'n' || key == 'N') {
     wSpeed--;
     if(wSpeed<1){wSpeed=1;}
   }
}

// Toggle the pause state
void togglePause() {
     if (pause) {
       pause = false; 
     } else {
       pause = true;
     }
}

// Toggle the display of the information panel
void toggleInfo() {
     if (showInfo) {
       showInfo = false; 
     } else {
       showInfo = true;
     }
}
//finds out if anyone was caught.
void setCatcher(){
  Agent chaser = players.get(catcher);
  PVector p = new PVector(chaser.position.x,chaser.position.y);
  p.sub(players.get(closestAgent).position);
  if(p.mag()<10&&timer<=0){
    int aux = catcher;
    catcher = closestAgent;
    closestAgent = aux;
    Agent count = players.get(catcher);
    count.setMode(COUNTING,null);
    chaser.setMode(FLEEING,count);
 
    timer = COUNT_TIME;
  }

}
//run if too close;
boolean setRun(Agent runner){
  Agent chaser = players.get(catcher);
  PVector p = new PVector(chaser.position.x,chaser.position.y);
  p.sub(runner.position);
  return p.mag()<KEEP_AWAY;
} 

//finds the closest agent to the agent input
// and sets behaviours.
void setChased(){
  float shortestDist = -1;
  Agent chaser = players.get(catcher);

  for(int i=0;i<PLAYER_NUM;i++){
    if(i != catcher){
      PVector p = new PVector(chaser.position.x,chaser.position.y);
      Agent runner = players.get(i);
      
      //TODO:
      for(int j=0;j<PLAYER_NUM;j++){
        //if its not itself or catcher
        if(j!=i&&j!=catcher){
          //get fellow agent
          Agent neighbour = players.get(j);
          //get its own pos vector
          PVector pos = new PVector(runner.position.x,runner.position.y);
          //subtract fellow's position
          pos.sub(neighbour.position);
          //find distance between
          pos.mag();
    
        }
      }
      p.sub(runner.position);
      if(shortestDist == -1||p.mag()<shortestDist){
        shortestDist = p.mag();
        closestAgent = i;
      }
      if(!setRun(runner)||
      runner.position.x<WALL||
        runner.position.x>width-WALL||
        runner.position.y<WALL||
        runner.position.y>height-WALL){
        runner.setMode(WANDERING,null);        
      }else{
        runner.setMode(FLEEING,chaser);
      }
    }
  }
  if(timer>0){
    timer--;
    chaser.velocity = new PVector(0,0);
  } else{
    Agent chased = players.get(closestAgent);
    chaser.setMode(CATCHER, chased ); 
    chased.setMode(CHASED, chaser );    
  }
}
