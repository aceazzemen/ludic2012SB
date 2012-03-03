/* 
 * The Flee Steering Behaviour
 */
 
class Flee extends Steering {

  
  // Position/size of target
  PVector hunterPos;
  float radius;
  
  // Initialisation
  Flee(Agent a, PVector t, float r) {
      super(a);
      hunterPos = t;
      radius = r;
      name = "Flee";
  }
  
  PVector calculateRawForce() {
   // Check that agent's centre is not over hunterPos
      if (PVector.dist(agent.position, hunterPos) > radius) {
        // Calculate Seek Force
        PVector flee = PVector.sub(agent.position,hunterPos);
        flee.normalize();
        flee.mult(agent.maxSpeed);
        flee.sub(agent.velocity);
        return flee;
      } else  {
         //If agent's centre is over target stop seeking
        return new PVector(0,0); 
      } 
  }
  
  
  void draw (){
  
  }
}
