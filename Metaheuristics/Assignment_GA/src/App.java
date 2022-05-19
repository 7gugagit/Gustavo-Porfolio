import org.json.simple.JSONObject;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class App {
    public static void main(String[] args) {
        App application = new App();

        int allConfigs = 29;
        String config = "";
        int step = 1;
        int jsonMake = 0;

        if (args.length > 0) { //used for the command line arguments
            if (args[0].equalsIgnoreCase("search_best_configuration")){ //uses all configurations
                allConfigs = 29;
                jsonMake = 1000;
            }
            else {
                System.out.println(args[1].substring(17, 19)); //only selected configuration
                config = args[1].substring(17, 19);
                allConfigs = Integer.parseInt(config)+1;
                step = allConfigs-1;
            }
        }
        else { //if terminal isnt used or no arguments are given user is asked for input
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter configuration number: (enter 999 for search_best_configuration)");
            allConfigs = sc.nextInt() + 1;
            step = allConfigs - 1;
            if (allConfigs == 1000) {
                jsonMake = 1000;
                allConfigs = 29;
                step = 1;
            }
        }
        int bestConfiguration = 0;
        int bestConfigFitness = 0;
        int currentBestFitness = 0;

        try {
            for (int j = step; j <allConfigs; j++) {

                long runtimeStart = System.currentTimeMillis();
                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(j));

                double crossOverRatio = json.getCrossover_ratio();
                double mutationRatio = json.getMutationRatio();
                String selection_method = json.getSelectionMethod();
                String configuration = json.getConfiguration();
                String crossover_method = json.getCrossoverMethod();
                String mutation_method = json.getMutationMethod();

                Report report = new Report(json.getConfiguration(), false);

                report.heading(json.getConfiguration(), "GA  |  #" + Configuration.instance.MAX_ITERATIONS
                        + "  |  " + selection_method + "  |  " + crossover_method
                        + " (" + crossOverRatio + ")  |  " + mutation_method +
                        "  (" + mutationRatio + ")");

                Population population = new Population(Configuration.instance.POPULATION, //make a new population with configuration
                        selection_method,
                        crossover_method,
                        mutation_method,
                        crossOverRatio,
                        Configuration.instance.elitismRatio,
                        mutationRatio);

                int i = 0;
                Chromosome bestChromosome = population.getPopulation()[0]; //best chromosome will be the first in the array
                double squality = 0;
                int quarter = (int) (0.25 * Configuration.instance.MAX_ITERATIONS);

                String[] converge = new String[4];
                int count = 0;
                while ((i++ <= Configuration.instance.MAX_ITERATIONS)) {
                    population.evolve();
                    if (i == quarter || i == (quarter + quarter) || i == (quarter + quarter + quarter) || i == (quarter + quarter + quarter + quarter)) { //this takes the quarter of the iterations for statistics
                        squality = bestChromosome.getFitness() / Configuration.instance.bestKnown;
                        converge[count] = ("                " + i + "    " + bestChromosome.getWeight() + "         " + bestChromosome.getFitness() +
                                "         " + squality*100 + "%");
                        count++;
                    }
                    bestChromosome = population.getPopulation()[0];
                    if (bestChromosome.getFitness() > currentBestFitness) { //update best fitness
                        currentBestFitness = bestChromosome.getFitness();
                        squality = bestChromosome.getFitness() / Configuration.instance.bestKnown;
                    }
                    report.writeToFile(Configuration.instance.decimalFormat.format(i) + "     " +
                            bestChromosome.getWeight() + "     " + bestChromosome.getFitness() + "     " +
                            squality * 100 + "%     " + bestChromosome.getGeneString());
                }
                report.Statistics((System.currentTimeMillis() - runtimeStart) + "ms");

                for (String x : converge) {
                    report.writeToFile(x);
                }

                if (bestChromosome.getFitness() > bestConfigFitness){
                    bestConfigFitness = bestChromosome.getFitness();
                    bestConfiguration = j;
                }

                System.out.println("generation                  : " + Configuration.instance.decimalFormat.format(i) + " : "
                        + bestChromosome.getGeneString());
                System.out.println("fitness                     : " + bestChromosome.getFitness());
                System.out.println("runtime                     : " + (System.currentTimeMillis() - runtimeStart) + " ms");
                System.out.println("numberOfCrossoverOperations : " + population.getNumberOfCrossoverOperations());
                System.out.println("numberOfMutationOperations  : " + population.getNumberOfMutationOperations());
            }

            if(jsonMake == 1000) {
                System.out.println("Best configuration is: " + bestConfiguration);
                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(bestConfiguration));

                JSONObject jsonObject = new JSONObject();

                jsonObject.put("selection_method", json.getSelectionMethod());
                jsonObject.put("configuration", json.getConfiguration());
                jsonObject.put("mutation_ratio", json.getMutationRatio());
                jsonObject.put("crossover_ratio", json.getCrossover_ratio());
                jsonObject.put("crossover_method", json.getCrossoverMethod());
                jsonObject.put("mutation_method", json.getMutationMethod());

                try {
                    FileWriter file = new FileWriter("../Assignment_GA/outputs/ga_best.json");
                    file.write(jsonObject.toJSONString());
                    file.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println("JSON file created: " + jsonObject);
            }
        }
        catch (IOException e){
            e.printStackTrace();
        }
        }
}

