PopulationOfSimulations test;
PVector goal  = new PVector(400, 10);


void setup() {
  size(1080, 1080); //size of the window
  frameRate(90000);//increase this to make the drones go faster
  test = new PopulationOfSimulations(1000);//create a new population with 1000 members
}


void draw() { 
  background(255);

  //draw the target position
  fill(188, 19, 254);
  ellipse(goal.x, goal.y, 10, 10);

  //draw obstacle(s) which define our deviation
  fill(255, 0, 0);

  rect(600, 300, 600, 10);

  if (test.allsimulated_dronesDead()) {
    //genetic algorithm
    test.calculateFitness();
    test.naturalSelection();
    test.mutateDemBabies();
  } else {
    //if any of the drones are still alive then update and then show them

    test.update();
    test.show();
  }
}
