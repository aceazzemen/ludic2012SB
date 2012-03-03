/*
 * The Seek Steering Behaviour
 */
class Seek extends Steering {
  
  // Position/size of targetPos
  PVector targetPos;
  
  float radius;
  
  // Initialisation
  Seek(Agent a, PVector t, float r) {
      super(a);
      targetPos = t;
      radius = r;
      name = "Seek";
  }
  
  PVector calculateRawForce() {
      // Check that agent's centre is not over targetPos
      if (PVector.dist(targetPos, agent.position) > radius) {
        // Calculate Seek Force
        print (targetPos);
        PVector seek = PVector.sub(targetPos, agent.position);
        seek.normalize();
        seek.mult(agent.maxSpeed);
        seek.sub(agent.velocity);
        return seek;

      } else  {
        // If agent's centre is over targetPos stop seeking
        return new PVector(0,0); 
      }   
  }
  
  // Draw the targetPos
  void draw() {
  }
}
