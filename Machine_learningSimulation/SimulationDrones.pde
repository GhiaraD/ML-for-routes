class Dot{
  PVector pos;
  PVector vel;
  PVector acc;
  SimulationThinking SimulationThinking;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this drone is the best drone from the previous generation

  float fitness = 0;

  Dot() {
    SimulationThinking = new SimulationThinking(1000);//new SimulationThinking with 1000 instructions

    //start the drones at the bottom of the window with a no velocity or acceleration
    pos = new PVector(width/2, height- 10);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }


  //-----------------------------------------------------------------------------------------------------------------
  //draws the drone on the screen
  void show() {
    //if this drone is the best drone from the previous generation then draw it as a big green dot
    if (isBest) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    } else {//all other dots are just smaller black dots
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //moves the drone according to the SimulationThinkings directions
  void move() {

    if (SimulationThinking.directions.length > SimulationThinking.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      acc = SimulationThinking.directions[SimulationThinking.step];
      SimulationThinking.step++;
    } else {//if at the end of the directions array then the drone is dead
      dead = true;
    }

    //apply the acceleration and move the dot
    vel.add(acc);
    vel.limit(5);//not too fast
    pos.add(vel);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    if (!dead && !reachedGoal) {
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {//if near the edges of the window then kill it (went off course and lost connection)
        dead = true;
      } else if (dist(pos.x, pos.y, goal.x, goal.y) < 5) {//if reached goal

        reachedGoal = true;
      } else if (pos.x>600 && pos.y < 310 && pos.x > 0 && pos.y > 300) {//if hit obstacle(regressed to usual route wich we couldn't in a real-life situation
        dead = true;
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  void calculateFitness() {
    if (reachedGoal) {//if the drone reached the goal then the fitness is based on the amount of steps it took to get there
      fitness = 1.0/16.0 + 10000.0/(float)(SimulationThinking.step * SimulationThinking.step);
    } else {//if the drone didn't reach the goal then the fitness is based on how close it is to the goal
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal);
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot gimmeBaby() {
    Dot baby = new Dot();
    baby.SimulationThinking = SimulationThinking.clone();//babies have the same SimulationThinking as their parents
    return baby;
  }
}
