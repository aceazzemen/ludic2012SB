/* 
 * The EvadeSteering Behaviour
 */
 
class Evade extends Steering {

  // Position/size of target
  PVector hunterPos;
  PVector hunterVel;
  float radius;
  
  // Initialisation
  Evade(Agent a, PVector t, PVector v, float r) {
      super(a);
      hunterPos = t;
      hunterVel = v;
      radius = r;
      name = "Evade";
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over targetPos
     if (PVector.dist(agent.position,hunterPos) > radius) {
       PVector evade = PVector.sub(agent.position, calculatePredictedPosition());
       evade.normalize();
       evade.mult(agent.maxSpeed);
       evade.sub(agent.velocity);
       return evade;
     } else  {
        // If agent's centre is over targetPos stop pursueing
        return new PVector(0,0); 
      }
  }
  
  PVector calculatePredictedPosition(){
    PVector d = new PVector(hunterVel.x,hunterVel.y);
    float t = min(4,calculateTimeToTarget());
    d.mult(t);
    PVector predPos = PVector.add(hunterPos, d);
    if (predPos.mag()>0){
      return predPos;
    }
    return new PVector(0,0);
  }
  
  float calculateTimeToTarget(){
    float k = 1;
    PVector v = agent.velocity;
    PVector timeToTarget = PVector.sub(agent.position,hunterPos);
    return k*(timeToTarget.mag()/v.mag());
  }
  
  void draw (){
  }
}
