import java.io.IOException;

public class Swarm {
    private Particle[] swarm; //swarm is made up of number of particles
    private Particle bestGlobal;
    private int bestValueGlobal;
    private Report report;
    private String[] converge;
    private JSONreader json;

    public Swarm(JSONreader json) {
        this.json = json;
        this.swarm = new Particle[json.getNumber_particles()];
        this.bestGlobal = Particle.generateRandom(json);
        this.bestValueGlobal = bestGlobal.calcFitness();
        report = new Report(json.getConfiguration(), false);
        converge = new String[4];
    }

    public int execute() {
        for (int i = 0; i < swarm.length; i++) {
            swarm[i] = Particle.generateRandom(json); //initial population filled with random particles
        }
        int count = 0;
        for (int i = 0; i < Configuration.instance.maximumNumberOfIterations; i++) {
            updateParticles(); //this is the main part of this function
            double best = (double) bestValueGlobal;
            double known = Configuration.instance.BEST_KNOWN;
            double squality = best / known;
            int quarter = (int) (0.25 * Configuration.instance.maximumNumberOfIterations);


            if (i == quarter || i == (quarter + quarter) || i == (quarter + quarter + quarter) || i == (quarter * 4)) {
                converge[count] = ("                " + i + "    " + bestGlobal.getWeight() + "         " + bestValueGlobal +
                        "         " + Configuration.instance.percentFormat.format(squality * 100) + "%");
                count++;
            }

            try {
                report.writeToFile(Configuration.instance.decimalFormat.format(i) + "     " +
                        bestGlobal.getWeight() + "     " + bestValueGlobal + "     " +
                        Configuration.instance.percentFormat.format(squality * 100) + "%     " + bestGlobal.toString());
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        return bestValueGlobal;
    }

    public void updateParticles() { //this uses a double for loop to go through each particle and each particles knapsack and update the position of each item.
        for (int i = 0; i < swarm.length; i++) {
            for (int j = 0; j < Configuration.instance.KNAPSACK_SIZE; j++) {
                double v = swarm[i].velocity(j, bestGlobal.getPosition()[j]); //sets new velocity
                swarm[i].setPosition(j); //uses previous velocity for setting position
            }
            int currentValue = swarm[i].calcFitness();
            if (currentValue > bestValueGlobal) {
                bestValueGlobal = currentValue;
                bestGlobal = swarm[i]; //keep bestGlobal particle
            }
        }
    }

    public String[] getConverge() {
        return converge;
    }

}
