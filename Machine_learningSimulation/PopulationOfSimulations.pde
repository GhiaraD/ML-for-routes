class PopulationOfSimulations {
  Dot[] simulated_drones;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best drone in the simulated_drones[]

  int minStep = 1000;

  PopulationOfSimulations(int size) {
    simulated_drones = new Dot[size];
    for (int i = 0; i< size; i++) {
      simulated_drones[i] = new Dot();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------
  //show all simulated_drones
  void show() {
    for (int i = 1; i< simulated_drones.length; i++) {
      simulated_drones[i].show();
    }
    simulated_drones[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  //update all simulated_drones 
  void update() {
    for (int i = 0; i< simulated_drones.length; i++) {
      if (simulated_drones[i].SimulationThinking.step > minStep) {//if the drone has already taken more steps than the best drone has taken to reach the target position
        simulated_drones[i].dead = true;//then it is dead(it exited range or tried to go back into the usual route, which would ruin our simulation
      } else {
        simulated_drones[i].update();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  //calculate all the fitnesses
  void calculateFitness() {
    for (int i = 0; i< simulated_drones.length; i++) {
      simulated_drones[i].calculateFitness();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the simulated_drones are either dead or have reached the goal
  boolean allsimulated_dronesDead() {
    for (int i = 0; i< simulated_drones.length; i++) {
      if (!simulated_drones[i].dead && !simulated_drones[i].reachedGoal) { 
        return false;
      }
    }

    return true;
  }



  //-------------------------------------------------------------------------------------------------------------------------------------

  //gets the next generation of simulated_drones
  void naturalSelection() {
    Dot[] newsimulated_drones = new Dot[simulated_drones.length];//next gen
    setBestDot();
    calculateFitnessSum();

    //the champion lives on 
    newsimulated_drones[0] = simulated_drones[bestDot].gimmeBaby();
    newsimulated_drones[0].isBest = true;
    for (int i = 1; i< newsimulated_drones.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newsimulated_drones[i] = parent.gimmeBaby();
    }

    simulated_drones = newsimulated_drones.clone();
    gen ++;
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //you get it
  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< simulated_drones.length; i++) {
      fitnessSum += simulated_drones[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //chooses dot from the population to return randomly(considering fitness)

  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the simulated_drones and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since simulated_drones with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  Dot selectParent() {
    float rand = random(fitnessSum);


    float runningSum = 0;

    for (int i = 0; i< simulated_drones.length; i++) {
      runningSum+= simulated_drones[i].fitness;
      if (runningSum > rand) {
        return simulated_drones[i];
      }
    }

    //should never get to this point

    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //mutates all the SimulationThinkings of the babies
  void mutateDemBabies() {
    for (int i = 1; i< simulated_drones.length; i++) {
      simulated_drones[i].SimulationThinking.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i< simulated_drones.length; i++) {
      if (simulated_drones[i].fitness > max) {
        max = simulated_drones[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;

    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (simulated_drones[bestDot].reachedGoal) {
      minStep = simulated_drones[bestDot].SimulationThinking.step;
      println("step:", minStep);
    }
  }
}
