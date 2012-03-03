/* 
 * The Pursue Steering Behaviour
 */
 
class Pursue extends Steering {

  // Position/size of target
  PVector targetPos;
  PVector targetVel;
  float radius;
  
  // Initialisation
  Pursue(Agent a, PVector t, PVector v, float r) {
      super(a);
      targetPos = t;
      targetVel = v;
      radius = r;
      name = "Pursue";
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over targetPos
     if (PVector.dist(targetPos, agent.position) > radius) {
       PVector pursue = PVector.sub(calculatePredictedPosition(), agent.position);
       pursue.normalize();
       pursue.mult(agent.maxSpeed);
       pursue.sub(agent.velocity);
       return pursue;
     } else  {
        // If agent's centre is over targetPos stop pursueing
        return new PVector(0,0); 
      }
  }
  
  PVector calculatePredictedPosition(){
    PVector d = new PVector(targetVel.x,targetVel.y);
    float t = min(3,calculateTimeToTarget());
    d.mult(t);
    PVector predPos = PVector.add(targetPos, d);
    if (predPos.mag()>0){
      return predPos;
    }
    return new PVector(0,0);
  }
  
  float calculateTimeToTarget(){
    float k = 1;
    PVector v = agent.velocity;
    PVector timeToTarget = PVector.sub(targetPos,agent.position);
    return k*(timeToTarget.mag()/v.mag());
  }
  
  void draw (){
  }
}
