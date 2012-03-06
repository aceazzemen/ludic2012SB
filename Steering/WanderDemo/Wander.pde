/*
 * The wander Steering Behaviour
 */
class Wander extends Steering {
  
  // Position/size of target
  float radius;
  
  // Parameters
  float wradius;
  float wdistance;
  float jitter;
  
  // c
  PVector c;
  
  // Initialisation
  Wander(Agent a, float r) {
      super(a);
      radius = r;
      wradius = 10.0;
      wdistance = 15.0;
      jitter = 1.0;
      c = new PVector();
  }
  
    // Vary wander radius
  void incRadius() {    
    wradius++;
  }
  void decRadius() {    
    wradius--;
    if (wradius < 1) wradius = 1;
  }
  
    // Vary wander distance
  void incDistance() {    
    wdistance++;
  }
  void decDistance() {    
    wdistance--;
    if (wdistance < 1) wdistance = 1;
  }
  
    // Vary target jitter
  void incJitter() {    
    jitter++;
  }
  void decJitter() {    
    jitter--;
    if (jitter < 1) jitter = 1;
  }
  
  PVector wanderCalculation() {
      // Calculate the wander values
      PVector target = new PVector();
      
      target.set(agent.velocity);
      target.normalize();
      target.mult(wdistance);
      target.add(agent.position);
      float x = jitter * random(-1, 1);
      float y = jitter * random(-1, 1);
      c.add(x, y, 0);
      c.normalize();
      c.mult(wradius);
      target.add(c);
      
      return target;
  }
  
  PVector calculateRawForce() {
      PVector target = wanderCalculation();
    
      // Check that agent's centre is not over target
      if (PVector.dist(target, agent.position) > radius) {
        // Calculate wander Force
        PVector wander = PVector.sub(target, agent.position);
        wander.normalize();
        wander.mult(agent.maxSpeed);
        wander.sub(agent.velocity);
        return wander;

      } else  {
        // If agent's centre is over target stop wandering
        return new PVector(0,0);
      }   
  }
  
  // Draw the target
  void draw() {
  }
}
