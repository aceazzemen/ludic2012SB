/*
 *
 * The HuntDemo sketch
 *
 */
 
public static int PLAYER_NUM = 10;
public static float WANDERDIST = 50;



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
  
  /*** Hunter Agent ***/
  // Create the agent
  players = new ArrayList<Agent>();  
  for (int i = 0; i<PLAYER_NUM;i++){
    players.add(new Agent(10,10,randomPoint()));
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
/* text("Click to move the target",10, 65);
  text("------ Player 1 -------",10, 80);
  //text("behaviour (z/Z) = " + player1.getBehaviour() ,10,95); 
  text("Mass (q/a) = " + player1.mass, 10, 110);
  text("Max. Force (w/s) = " + player1.maxForce, 10, 125);
  text("Max. Speed (e/d) = " + player1.maxSpeed, 10, 140);
  text("------- Target -------",10, 155);
  //text("behaviour (v/V) = " + player2.getBehaviour(),10,170); 
  text("Mass (r/f) = " + player2.mass, 10, 185);
  text("Max. Force (t/g) = " + player2.maxForce, 10, 200);
  text("Max. Speed (y/h) = " + player2.maxSpeed, 10, 215);*/
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
     
   }// else if (key == '2' || key == '@') {
   //  player1.toggleAnnotate();
   
     /*** HUNTER ***/
     // Vary the hunter's behaviour
//   } else if(key == 'z' || key == 'Z'){
 //    changeHunterBehaviour();
     
     // Vary the hunter's mass
/*   } else if (key == 'q' || key == 'Q') {
     player1.incMass();
   } else if (key == 'a' || key == 'A') {
     player1.decMass();
     
     // Vary the huntert's maximum force
   } else if (key == 'w' || key == 'W') {
     player1.incMaxForce();
   } else if (key == 's' || key == 'S') {
     player1.decMaxForce();

    //  Vary the hunter's maximum speed
   } else if (key == 'e' || key == 'E') {
     player1.incMaxSpeed();
   } else if (key == 'd' || key == 'D') {
     player1.decMaxSpeed();*/
   
     /*** TARGET ***/  
   /*} else if(key == 'v' || key == 'V'){
     changeTargetBehaviour();  
     
   // Vary the target's mass
   } else if (key == 'r' || key == 'R') {
     player2.incMass();
   } else if (key == 'f' || key == 'F') {
     player2.decMass();
     
     // Vary the target's maximum force
   } else if (key == 't' || key == 'T') {
     player2.incMaxForce();
   } else if (key == 'g' || key == 'G') {
     player2.decMaxForce();

     // Vary the target's maximum speed
   } else if (key == 'y' || key == 'Y') {
     player2.incMaxSpeed();
   } else if (key == 'h' || key == 'H') {
     player2.decMaxSpeed();
   
   }*/
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
    println("caught");
    chaser.velocity = new PVector(0,0);
    int aux = catcher;
    catcher = closestAgent;
    closestAgent = aux;
    Agent count = players.get(catcher);
    count.setMode(COUNTING,null);
    timer = COUNT_TIME;
  }
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
      p.sub(runner.position);
      if(shortestDist == -1||p.mag()<shortestDist){
        shortestDist = p.mag();
        closestAgent = i;
      }
      if(timer>0){
        runner.setMode(FLEEING, chaser);
      }else{
        runner.setMode(WANDERING,null);
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
