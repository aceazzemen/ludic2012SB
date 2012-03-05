/*
 * A Steered Agent
 */
 
  public static final int CATCHER = 0;
  public static final int CHASED = 1;
  public static final int WANDERING = 2;
  public static final int FLEEING = 3; 
  public static final int SEEKING = 4;
  public static final int COUNTING = 5;  
  public static final int COUNT_TIME = 7;
  
class Agent {

    
  // Body  
  float mass;
  float radius;

  // Physics
  PVector position;    
  PVector velocity;
  PVector acceleration;
  PVector force;
  
  // Limits
  float maxSpeed;
  float maxForce;

  //current behaviour;
  int mode;
  
  // Unit vector in direction agent is facing
  PVector forward; 
  // Unit vector orthogonal to forward, to the right of the agent
  PVector side;
  
  // A list of steering behaviours  
  ArrayList<Steering> behaviours;
  
  // Should we draw steering annotations on agent?
  // e.g. draw the force vector
  boolean annotate;

  // Initialisation
  Agent(float m, float r, PVector p) {
    mass = m;
    radius = r;
    position = p;
  
    // Agents starts at rest
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    force = new PVector(0,0);
    
    // Some arbitary initial limits
    maxSpeed = 3;
    maxForce = 3;
   
    // Because velocity is zero vector 
    forward = new PVector(0,0);
    side = new PVector(0,0);
    
    // Any empty list of steering behaviours
    behaviours = new ArrayList<Steering>();
     
    Seek seek = new Seek(this, new PVector(0,0), 10);
    Flee flee = new Flee(this, new PVector(0,0), 10);
    Wander wander = new Wander(this,randomPoint(),10);
    Pursue pursue = new Pursue(this, new PVector(0,0),new PVector(0,0), 10);
    Evade evade = new Evade(this, this.position, this.velocity, 10);
  
    this.behaviours.add(pursue);
    this.behaviours.add(evade);
    this.behaviours.add(wander);
    this.behaviours.add(flee);

    seek.active = false;
    flee.active = false;
    wander.active = false;
    pursue.active = false;    
    evade.active = false;
    
    // Don't draw annotations
    annotate = false;
  }  
  
  // Agent's behavoiur
  String getBehaviour(){
    for (int i = 0; i < behaviours.size(); i++) {
       Steering sb = (Steering) behaviours.get(i);
       if (sb.active) {
         return sb.name;
       } 
    }
    return "null";
  }
  
  // Agent simulation step
  void update() {
    
    // Sum the list of steering forces
    PVector sf = new PVector(0,0);
    for (int i = 0; i < behaviours.size(); i++) {
       Steering sb = (Steering) behaviours.get(i);
       PVector sfi = sb.getForce();
       sf.add(sfi); 
    }
    // Trim the steering force
    if (maxForce > 0) sf.limit(maxForce);    
    force = sf;
    
    // Physics update
    acceleration = PVector.div(force, mass);
    velocity.add(acceleration);
    if (maxSpeed > 0) velocity.limit(maxSpeed);
    position.add(velocity);
    
    // Dead stop at vertical boundaries
    if (position.x <= 0) {
      position.x = 0;
      velocity = new PVector(0,0);
    } else if (position.x >= width) {
      position.x = width;
      velocity = new PVector(0,0);
    }

    // Dead stop at horizontal boundaries    
    if (position.y <= 0) {
      position.y = 0;
      velocity = new PVector(0,0);
    } else if (position.y >= height) {
      position.y = height;
      velocity = new PVector(0,0);
    }
    
    // Calculate forward and side vectors
    forward.x = velocity.x;
    forward.y = velocity.y;
    forward.normalize();
    side.x = -forward.y;
    side.y = forward.x;
    
  }
  
  PVector randomPoint() {
  return new PVector(random(width), random(height));
  }
  // Draw agent etc.
  void draw() {
    
    // Draw any steering behaviour related stuff
    //for (int i = 0; i < behaviours.size(); i++) {
      // Steering sb = (Steering) behaviours.get(i);
       //sb.draw();
    //}  

    // Draw the agent
    //   Draw circle
    if(mode == CATCHER){
      fill(125);
    } else {
      fill(255);
    }
    
    float d = radius * 2;
    ellipse(position.x, position.y, d, d);
    //   Draw radial line in forward direction
    PVector heading = PVector.mult(forward, radius);
    heading.add(position);
    line(position.x, position.y, heading.x, heading.y);
    
    // Draw force vector if required
    if (annotate) {
      pushStyle();
      stroke(204, 102, 0);
      // Scale the force vector x10 so it's visible
      float forceX = position.x + (10 * force.x);
      float forceY = position.y + (10 * force.y);
      line(position.x, position.y, forceX, forceY);
      popStyle();
    }
  }
  
  // Toggle annotations
  void toggleAnnotate() {
    if (annotate) {
       annotate = false;
    } else {
       annotate = true;
    } 
  }
  
  /*
   * Change parameters
   */
  // Vary maximum speed
  void incMaxSpeed() {    
    maxSpeed++;
  }
  void decMaxSpeed() {    
    maxSpeed--;
    if (maxSpeed < 1) maxSpeed = 1;
  }

  // Vary maximum force  
  void incMaxForce() {    
    maxForce++;
  }
  void decMaxForce() {    
    maxForce--;
    if (maxForce < 1) maxForce = 1;
  }

  // Vary mass
  void incMass() {    
    mass++;
  }
  void decMass() {    
    mass--;
    if (mass < 1) mass = 1;
  }
  
  /*
   * Translate between global space and the agent's local space
   *
   * Global: Processing's default co-ordinate system.
   * Local: co-ordinate system with agent at the origin, facing along the
   * x-axis, with the y-axis extending to it's right.
   */ 
  
  PVector toLocalSpace(PVector vec) {
    PVector trans = PVector.sub(vec, position);
    PVector local =  new PVector(trans.dot(forward), trans.dot(side));
    return local;
  }
  
  PVector toGlobalSpace(PVector vec) {
    PVector global = PVector.mult(forward, vec.x);
    global.add(PVector.mult(side, vec.y)); 
    global.add(position);    
    
    return global;
  }
  
  //changes behaviour accordingly. if no other agent is needed to be known use NULL
  void setMode(int setting,Agent aux){
    switch(setting){
      case CATCHER:
         
        if(mode != setting){
          behaviours.get(mode).active = false;
          mode = setting;
        }
        Pursue pur = (Pursue)behaviours.get(mode);
        pur.targetPos = aux.position;
        pur.targetVel = aux.velocity;
        pur.active = true;
        break;
      case CHASED:
         if(mode != setting){
          behaviours.get(mode).active = false;
          mode = setting;
        } 
        Evade ev = (Evade)behaviours.get(mode);
        ev.hunterPos = aux.position;
        ev.hunterVel = aux.velocity;
        ev.active = true;
        break;        
      case WANDERING:
         if(mode != setting){
          behaviours.get(mode).active = false;
          mode = setting;
        }      
        behaviours.get(mode).active = true;
        break;        
    }
        
    
  }
   
}
  
  
 
