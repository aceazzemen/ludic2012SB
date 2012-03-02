/*
 *
 * The SeekDemo sketch
 *
 */

// A single agent
Agent seeker;
Agent fat;
// It's steering behaviour
Seek seek;
Seek fats;
// Are we paused?
boolean pause;
// Is this information panel being displayed?
boolean showInfo;

// Initialisation
void setup() {
  size(1000,600); // Large display window
  pause = false;
  showInfo = true;
  
  // Create the agent
  seeker = new Agent(10, 10, randomPoint());
  fat = new Agent(20,20,randomPoint());
  // Create a Seek behaviour
  seek = new Seek(seeker,randomPoint(), 10);
  fats = new Seek(fat,seek.target, 10);
  
  // Add the behaviour to the agent
  seeker.behaviours.add(seek);
  fat.behaviours.add(fats);

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
  if (!pause) seeker.update();fat.update();
  
  // Draw the agent
  seeker.draw();
  fat.draw();
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
  text("Mass (small) (q/a) = " + seeker.mass, 10, 65);
  text("Max. Force (small) (w/s) = " + seeker.maxForce, 10, 80);
  text("Max. Speed (small) (e/d) = " + seeker.maxSpeed, 10, 95);
  text("Mass (big) (q/a) = " + fat.mass, 10, 110);
  text("Max. Force (big) (w/s) = " + fat.maxForce, 10, 125);
  text("Max. Speed (big) (e/d) = " + fat.maxSpeed, 10, 140);
  text("Click to move the target", 10, 155);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Mouse clicked, so move the target
void mouseClicked() {
   seek.target = new PVector(mouseX, mouseY); 
   fats.target = seek.target;
}

// Key pressed
void keyPressed() {
   if (key == ' ') {
     togglePause();
     
   } else if (key == '1' || key == '!') {
     toggleInfo();
     
   } else if (key == '2' || key == '@') {
     seeker.toggleAnnotate();
     
     // Vary the agent's mass
   } else if (key == 'q' || key == 'Q') {
     seeker.incMass();
   } else if (key == 'a' || key == 'A') {
     seeker.decMass();
     
     // Vary the agent's maximum force
   } else if (key == 'w' || key == 'W') {
     seeker.incMaxForce();
   } else if (key == 's' || key == 'S') {
     seeker.decMaxForce();

     // Vary the agent's maximum speed
   } else if (key == 'e' || key == 'E') {
     seeker.incMaxSpeed();
   } else if (key == 'd' || key == 'D') {
     seeker.decMaxSpeed();
   } else if (key =='u'||key == 'U'){
     fat.incMass();
   } else if (key =='j'||key == 'J'){
     fat.decMass();
   } else if (key =='i'||key == 'I'){
     fat.incMaxForce();
   } else if (key =='k'||key == 'K'){
     fat.decMaxForce();
   } else if (key =='o'||key == 'O'){
     fat.incMaxSpeed();
   } else if (key =='l'||key == 'L'){
     fat.decMaxSpeed();
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

