
import java.util.Arrays;

public class Population { //population of chromosomes, parent selection and crossover happens here
    private double elitismRatio;
    private double mutationRatio;
    private double crossoverRatio;
    private String selection_method;
    private String configuration;
    private String crossover_method;
    private String mutation_method;
    private Chromosome[] population;
    private int numberOfCrossoverOperations = 0;
    private int numberOfMutationOperations = 0;

    public Population(int size,String selection_method, String crossover_method, String mutation_method, double crossoverRatio, double elitismRatio, double mutationRatio) { //get created at app with configurations values.

        this.population = new Chromosome[size];

        for (int i = 0; i <size; i++){
            population[i] = Chromosome.generateRandom(); //make a random population of chromosomes (knapsacks)
        }
        this.selection_method = selection_method; //all of these come from the json file
        this.crossover_method = crossover_method;
        this. mutation_method = mutation_method;
        this.crossoverRatio = crossoverRatio;
        this.elitismRatio = elitismRatio;
        this.mutationRatio = mutationRatio;

    }

    public void evolve() {
        Chromosome[] chromosomeArray = new Chromosome[population.length];
        Chromosome[] parents = new Chromosome[2];
        Chromosome[] children = new Chromosome[2];
        int index = (int) Math.round(population.length * elitismRatio); //selection biased of the algorithm
        System.arraycopy(population, 0, chromosomeArray, 0, index);

        while (index < chromosomeArray.length) {
            if (Configuration.instance.randomNumber.nextFloat() <= crossoverRatio) { //using json configurations decide what selection and crossover methoods to use
                if (selection_method.equalsIgnoreCase("RWS")) {
                    parents = selectParentsRoulette();
                }
                else if (selection_method.equalsIgnoreCase(("TS"))){
                    parents = selectParentsTournament();
                }
                if (crossover_method.equalsIgnoreCase("1PX")){
                    children = parents[0].onePointCrossOver(parents[1]);

                }
                else if (crossover_method.equalsIgnoreCase("2PX")) {
                    children = parents[0].twoPointCrossOver(parents[1]);
                }
                numberOfCrossoverOperations++;



                if (Configuration.instance.randomNumber.nextFloat() <= mutationRatio) { //mutation method selection
                    switch (mutation_method) {
                        case "BFM":
                            chromosomeArray[(index)] = children[0].bitFlipMutate();
                            break;
                        case "EXM":
                            chromosomeArray[(index)] = children[0].exchangeMut();
                            break;
                        case "IVM":
                            chromosomeArray[(index)] = children[0].inversionMut();
                            break;
                        case "ISM":
                            chromosomeArray[(index)] = children[0].insertionMut();
                            break;
                        case "DPM":
                            chromosomeArray[(index)] = children[0].displacementMut();
                            break;
                    }

                    index++;
                    numberOfMutationOperations++;
                } else { //if mutation doesnt happen
                    chromosomeArray[(index)] = children[0];
                    index++;
                }

                if (index < chromosomeArray.length){ //same thing with second child
                    if (Configuration.instance.randomNumber.nextFloat() <= mutationRatio) {
                        switch (mutation_method) {
                            case "BFM":
                                chromosomeArray[(index)] = children[1].bitFlipMutate();
                                break;
                            case "EXM":
                                chromosomeArray[(index)] = children[1].exchangeMut();
                                break;
                            case "IVM":
                                chromosomeArray[(index)] = children[1].inversionMut();
                                break;
                            case "ISM":
                                chromosomeArray[(index)] = children[1].insertionMut();
                                break;
                            case "DPM":
                                chromosomeArray[(index)] = children[1].displacementMut();
                                break;
                        }
                        numberOfMutationOperations++;
                    } else {
                        chromosomeArray[index] = children[1];
                    }
                }
            } else if (Configuration.instance.randomNumber.nextFloat() <= mutationRatio) { //mutates a member of the population
                switch (mutation_method) {
                    case "BFM":
                        chromosomeArray[(index)] = population[index].bitFlipMutate();
                        break;
                    case "EXM":
                        chromosomeArray[(index)] = population[index].exchangeMut();
                        break;
                    case "IVM":
                        chromosomeArray[(index)] = population[index].inversionMut();
                        break;
                    case "ISM":
                        chromosomeArray[(index)] = population[index].insertionMut();
                        break;
                    case "DPM":
                        chromosomeArray[(index)] = population[index].displacementMut();
                        break;
                }
                numberOfMutationOperations++;
            } else {
                chromosomeArray[index] = population[index];
            }
            index++;
        }
        Arrays.sort(chromosomeArray); //uses compareTo, highest fitness at the front
        population = chromosomeArray;
    }

    public Chromosome[] getPopulation(){
        return population;
    }

    public double getNumberOfCrossoverOperations(){
        return numberOfCrossoverOperations;
    }
    public double getNumberOfMutationOperations(){
        return numberOfMutationOperations;
    }

    public Chromosome[] selectParentsTournament() { //tournament selection of size 5
        Chromosome[] parents = new Chromosome[2];
        Chromosome[] tournament = new Chromosome[5];
        double p = 0.6;
        double p1 = (1-p);
        for (int i = 0; i < tournament.length ; i++) { //takes 5 random members from population
            int random = Configuration.instance.randomNumber.nextInt(population.length);
            tournament[i] = population[random];
        }
        Arrays.sort(tournament); //best 2 win
        parents[0] = tournament[0];
        parents[1] = tournament[1];

        return parents;
    }

    public Chromosome[] selectParentsRoulette() { //#4, uses probability to select parents
        Chromosome[] parents = new Chromosome[2];
        double totalFit =0;
        for (Chromosome x : population){
            totalFit += x.getFitness();
        }
        double[] probabilities = new double[population.length]; //array of probabilities corresponding to the population array
        double totalProb = 0;
        double popFit = 0;
        double countFit = 0;
        for (int i = 0; i < population.length; i++) {

            popFit = population[i].getFitness()/totalFit;
            totalProb += popFit;
            probabilities[i] = totalProb;
        }

        int count =0;
        float random = 0;

        while(count < 2){
            random = Configuration.instance.randomNumber.nextFloat();
            for (int i = 0; i < population.length; i++) {
                if(probabilities[i] <= random){
                    if (i != population.length-1  && probabilities[i+1] > random) { //i != 9  && probabilities[i+1] > random
                        parents[count] = population[i];
                        count++;
                        break;
                    } //here was  i == 9 && probabilities[i] > random && probabilities[i-1] <= random
                    else if ( i == population.length-1 && probabilities[i] > random && probabilities[i-1] <= random) { //check this why is i==9?
                        parents[count] = population[i];
                        count++;
                        break;
                    }
                }
            }
        }
        return parents;
    }
}
