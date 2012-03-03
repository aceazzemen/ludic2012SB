/*
 *
 * The HuntDemo sketch
 *
 */

// Agents
Agent hunter;
Agent target;

// It's steering behaviour
Seek seek;
Flee flee;
Pursue pursue;

int counterHunter=0;

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
  hunter = new Agent(10, 10, randomPoint());
  target = new Agent(10, 10, randomPoint());
  
  // Create behaviours
  seek = new Seek(hunter, target.position, 10);
  flee = new Flee(target, hunter.position, 10);
  
  //pursue = new Pursue(hunter, target, 10);
  //evade = new Evade(target, hunter.position, 10);
  //pursue.active = false;
  
  // Add the behaviour to the agent
  hunter.behaviours.add(seek); 
  //hunter.behaviours.add(pursue);
  target.behaviours.add(flee);
  
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
    hunter.update(); 
    target.update();
  }
  /**/
  
  // Draw the agent
  hunter.draw(0);
  target.draw(255); 
  
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
  text("------- Hunter -------",10, 80);
  text("behaviour = " + hunter.getBehaviour() ,10,95); 
  text("Mass (q/a) = " + hunter.mass, 10, 110);
  text("Max. Force (w/s) = " + hunter.maxForce, 10, 125);
  text("Max. Speed (e/d) = " + hunter.maxSpeed, 10, 140);
  text("------- Target -------",10, 155);
  text("behaviour = " + target.getBehaviour(),10,170); 
  text("Mass (r/f) = " + target.mass, 10, 185);
  text("Max. Force (t/g) = " + target.maxForce, 10, 200);
  text("Max. Speed (y/h) = " + target.maxSpeed, 10, 215);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Mouse clicked, so move the target
void mouseClicked() {
  target.position = new PVector (mouseX, mouseY);
  seek.targetPos = target.position;
  //pursue.targetPos = target.position;
  flee.hunterPos = hunter.position;
}

// Key pressed
void keyPressed() {
   if (key == ' ') {
     togglePause();
     
   } else if (key == '1' || key == '!') {
     toggleInfo();
     
   } else if (key == '2' || key == '@') {
     hunter.toggleAnnotate();
   
     /*** HUNTER ***/
     // Vary the hunter's behaviour
   } else if(key == 'z' || key == 'Z'){
     changeBehaviour();
     
     // Vary the hunter's mass
   } else if (key == 'q' || key == 'Q') {
     hunter.incMass();
   } else if (key == 'a' || key == 'A') {
     hunter.decMass();
     
     // Vary the huntert's maximum force
   } else if (key == 'w' || key == 'W') {
     hunter.incMaxForce();
   } else if (key == 's' || key == 'S') {
     hunter.decMaxForce();

     // Vary the hunter's maximum speed
   } else if (key == 'e' || key == 'E') {
     hunter.incMaxSpeed();
   } else if (key == 'd' || key == 'D') {
     hunter.decMaxSpeed();
   
     /*** TARGET ***/  
   // Vary the target's mass
   } else if (key == 'r' || key == 'R') {
     target.incMass();
   } else if (key == 'f' || key == 'F') {
     target.decMass();
     
     // Vary the target's maximum force
   } else if (key == 't' || key == 'T') {
     target.incMaxForce();
   } else if (key == 'g' || key == 'G') {
     target.decMaxForce();

     // Vary the target's maximum speed
   } else if (key == 'y' || key == 'Y') {
     target.incMaxSpeed();
   } else if (key == 'h' || key == 'H') {
     target.decMaxSpeed();
   
   }
}

void changeBehaviour(){
  int n = hunter.behaviours.size();
  if (n>1){
    Steering sb = (Steering) hunter.behaviours.get(counterHunter % n);
    sb.active = false;
    counterHunter++;
    sb = (Steering) hunter.behaviours.get(counterHunter % n);
    sb.active = true;
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

