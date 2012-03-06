/*
 *
 * The WanderDemo sketch
 *
 */

// A single agent
Agent wanderer;
// It's steering behaviour
Wander wander;
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
  wanderer = new Agent(10, 10, randomPoint());
  // Create a wander behaviour
  wander = new Wander(wanderer, 10);
  // Add the behaviour to the agent
  wanderer.behaviours.add(wander);

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
  if (!pause) wanderer.update();
  
  // Draw the agent
  wanderer.draw();
  
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
  text("Mass (q/a) = " + wanderer.mass, 10, 65);
  text("Max. Force (w/s) = " + wanderer.maxForce, 10, 80);
  text("Max. Speed (e/d) = " + wanderer.maxSpeed, 10, 95);
  text("Wander radius (r/f) = " + wander.wradius, 10, 110);
  text("Wander distance (t/g) = " + wander.wdistance, 10, 125);
  text("Target jitter (y/h) = " + wander.jitter, 10, 140);
  text("Click to move agent", 10, 155);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */
 // Mouse clicked, so move the target
void mouseClicked() {
   wanderer.position = new PVector(mouseX, mouseY); 
}

// Key pressed
void keyPressed() {
   if (key == ' ') {
     togglePause();
     
   } else if (key == '1' || key == '!') {
     toggleInfo();
     
   } else if (key == '2' || key == '@') {
     wanderer.toggleAnnotate();
     
     // Vary the agent's mass
   } else if (key == 'q' || key == 'Q') {
     wanderer.incMass();
   } else if (key == 'a' || key == 'A') {
     wanderer.decMass();
     
     // Vary the agent's maximum force
   } else if (key == 'w' || key == 'W') {
     wanderer.incMaxForce();
   } else if (key == 's' || key == 'S') {
     wanderer.decMaxForce();

     // Vary the agent's maximum speed
   } else if (key == 'e' || key == 'E') {
     wanderer.incMaxSpeed();
   } else if (key == 'd' || key == 'D') {
     wanderer.decMaxSpeed();
     
     // Vary the agent's wander radius
   } else if (key == 'r' || key == 'R') {
     wander.incRadius();
   } else if (key == 'f' || key == 'F') {
     wander.decRadius();
     
      // Vary the agent's wander distance
   } else if (key == 't' || key == 'T') {
     wander.incDistance();
   } else if (key == 'g' || key == 'G') {
     wander.decDistance();
     
      // Vary the agent's target jitter
   } else if (key == 'y' || key == 'Y') {
     wander.incJitter();
   } else if (key == 'h' || key == 'H') {
     wander.decJitter();

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

