public class Solution implements Comparable<Solution> {
    private int[] solution = new int[Configuration.instance.items.length];
    private int fitness;
    private int weight;

    public Solution() {

        for (int i = 0; i < Configuration.instance.items.length; i++) {
            solution[i] = 0;
        }
        this.fitness = calcFitness(solution);
        this.weight = howHeavy(solution);
    }

    public Solution(int[] solution) {
        this.solution = solution;
        this.fitness = calcFitness(solution);
        this.weight = howHeavy(solution);
    }

    public static Solution generateRandom() {
        //generate random MersenneTwister betweem 1-150, if item is not null add to knapsack. Make null after adding.
        //keep weight under 822
        int weight = 0;
        Item[] listItems = new Item[Configuration.instance.items.length];
        System.arraycopy(Configuration.instance.items, 0, listItems, 0, Configuration.instance.items.length);

        int[] randomList = new int[listItems.length];
        for (int i = 0; i < randomList.length; i++) {
            randomList[i] = 0;
        }

        int random = 0;
        int count = 0;
        boolean complete = true;

        while (complete) { //runs until the bag has reached 822 or the next item will make it go over 822
            random = Configuration.instance.randomNumber.nextInt(0, 149);

            if (listItems[random].getItemNum() != 0) {

                if ((weight + listItems[random].getWeight()) <= Configuration.instance.MAX_CAPACITY) {
                    randomList[random] = 1;
                    weight += listItems[random].getWeight();
                    listItems[random] = new Item(0, 0, 0);
                    count++;
                } else { //breaks if bag + item > 822 or == 822
                    complete = false;
                }
            }
        }
        return new Solution(randomList);
    }


    public int[] getSolution() {
        return solution;
    }

    public int getFitness() {
        return fitness;
    }


    public int getWeight() {
        return weight;
    }


    public Solution flipBit(int num) {
        int[] newGene = new int[solution.length];
        System.arraycopy(solution, 0, newGene, 0, solution.length);

        if (newGene[num] == 1) {
            newGene[num] = 0;
        } else {
            newGene[num] = 1;
        }
        if (calcFitness(newGene) > 0) {
            return new Solution(newGene);
        }
        while (calcFitness(newGene) == 0) { //fitness is 0 is sack is over 822, make it so it flips 1s to 0s until its under 822 again
            int random = Configuration.instance.randomNumber.nextInt(150);
            if (newGene[random] == 1) {
                newGene[random] = 0;
            }
        }
        return new Solution(newGene);
    }

    public int calcFitness(int[] solution) { //fitness is the value of the knapsack

        Item[] fitnessList = binToPerm(solution);
        int value = 0;
        int weight = 0;

        for (Item x : fitnessList) {
            weight += x.getWeight();
            value += x.getValue();
        }
        if (weight > Configuration.instance.MAX_CAPACITY) {
            value = 0;
        }


        return value;
    }

    public int howHeavy(int[] solution) {
        Item[] temp = binToPerm(solution);
        int kgs = 0;
        for (Item x : temp) {
            kgs += x.getWeight();
        }
        return kgs;
    }

    public Item[] binToPerm(int[] binaryNum) { //takes binary representation and turn it into an Item list
        Item[] listDefault = new Item[Configuration.instance.items.length];
        System.arraycopy(Configuration.instance.items, 0, listDefault, 0, Configuration.instance.items.length);

        Item[] permList = new Item[binaryNum.length];
        for (int i = 0; i < permList.length; i++) {
            permList[i] = new Item(0, 0, 0);
        }
        for (int i = 0; i < binaryNum.length; i++) {
            if (binaryNum[i] == 1) {
                permList[i] = listDefault[i];
            }
        }
        return permList;
    }

    public int compareTo(Solution solution) {
        if (this.fitness < solution.fitness) {
            return 1;
        }
        if (this.fitness > solution.fitness) {
            return -1;
        }

        return 0;
    }

    public boolean equals(Object o) {
        if (!(o instanceof Solution)) {
            return false;
        }

        Solution sol = (Solution) o;
        return (sol.equals(sol.solution)) && (fitness == sol.fitness);
    }

    public String toString() {
        String temp = "";
        for (int x : solution) {
            temp += x;
        }
        return temp;
    }

}
