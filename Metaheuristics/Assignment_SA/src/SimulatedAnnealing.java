import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;

public class SimulatedAnnealing {

    private Solution bestSolutionX;
    private Solution currentSolutionX;
    private int initial_temperature;
    private double cooling_rate;
    private int minimum_temperature;
    private int maximum_coordinate;
    private String[] converge;
    private Report report;


    public SimulatedAnnealing(JSONreader json) {
        this.initial_temperature = json.getInitialTemperature();
        this.cooling_rate = json.getCoolingRate();
        report = new Report(json.getConfiguration(), false);
    }

    public double getEnergy(Solution x) {
        return x.getFitness();
    } //used the total value of a knapsack(solution) as the solution

    public double AcceptanceProbability(double energy, double newEnergy, double temperature) { //accepts bigger energies

        if (newEnergy > energy) {
            return 1;
        }

        double acceptance = (newEnergy - energy) / temperature;
        acceptance = Math.exp(acceptance);
        return acceptance; //numberr is used to compare to a random number to accept or reject
    }

    public int execute() {
        double temperature = initial_temperature;
        currentSolutionX = Solution.generateRandom(); //initialize population
        bestSolutionX = currentSolutionX;

        int count = 0;

        while (temperature > Configuration.instance.minimum_temperature) { //run while temperature is > minimum

            int random = Configuration.instance.randomNumber.nextInt(Configuration.instance.maximum_coordinate);
            Solution newSolX = currentSolutionX.flipBit(random); //flip a bit in the solution

            double energy = getEnergy(currentSolutionX);
            double newEnergy = getEnergy(newSolX);

            if (AcceptanceProbability(energy, newEnergy, temperature) > (Configuration.instance.randomNumber.nextDouble())) {
                currentSolutionX = newSolX; //acceptance function call
            }
            if (getEnergy(currentSolutionX) > getEnergy(bestSolutionX)) { //make new best solution
                bestSolutionX = currentSolutionX;
                System.out.println("temperature = " + Configuration.instance.decimalFormat.format(temperature) + " | x = " +
                        Configuration.instance.decimalFormat.format(bestSolutionX.getFitness()) + " | f(x) = " +
                        Configuration.instance.decimalFormat.format(getEnergy(bestSolutionX)));
            }
            temperature *= (1 - cooling_rate); //cool temperature
            double best = (double) bestSolutionX.getFitness();
            double known = Configuration.instance.BEST_KNOWN;
            double squality = best / known;

            try { //writing to file
                report.writeToFile(Configuration.instance.tempFormat.format(temperature) + "             " +
                        bestSolutionX.getWeight() + "        " + best + "       " +
                        Configuration.instance.percentFormat.format(squality * 100) + "%     " + bestSolutionX.toString());

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        System.out.println();
        System.out.println("global optimum | x = " + Configuration.instance.decimalFormat.format(bestSolutionX.getFitness()) + " | f(x) = " +
                Configuration.instance.decimalFormat.format(getEnergy(bestSolutionX)));

        return bestSolutionX.getFitness();
    }

    public Solution getBestSolutionX() {
        return bestSolutionX;
    }

}


