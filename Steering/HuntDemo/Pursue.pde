/* 
 * The Pursue Steering Behaviour
 */
 
class Pursue extends Steering {

  // Position/size of target
  PVector targetPos;
  PVector targetVel;
  float radius;
  
  // Initialisation
  Pursue(Agent a, Agent t, float r) {
      super(a);
      targetPos = t.position;
      targetVel = t.velocity;
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
    PVector d = targetVel;
    d.mult(calculateTimeToTarget());
    PVector predPos = PVector.add(targetPos, d );
    return predPos;
  }
  
  PVector calculateTimeToTarget(){
    int k = 1;
    PVector v = agent.velocity;
    v.normalize();
    PVector timeToTarget = PVector.sub(targetPos,agent.position);
    timeToTarget.normalize();
    timeToTarget.mult(k);
    timeToTarget.div(v);
    return timeToTarget;
  }
  
  void draw (){
  
  }
}
