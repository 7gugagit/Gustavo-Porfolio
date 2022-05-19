import java.util.Vector;

public class Particle {
    private int[] position;
    private double[] velocity;
    private int[] bestPosition; //keeps the best knapsack particle has had and best value
    private JSONreader json;
    private double individualBestValue;
    private int weight;
    private double inertia;
    private double c1;
    private double c2;
    private double maximumVelocity;
    private double minimumVelocity;

    //private FunctionType function;
    public Particle(JSONreader json) {
        position = new int[Configuration.instance.KNAPSACK_SIZE];
        for (int i = 0; i < Configuration.instance.items.length; i++) {
            position[i] = 0;
        }
        this.individualBestValue = calcFitness();
        this.weight = howHeavy(position);

        this.json = json;
        maximumVelocity = json.getMaximum_velocity();
        minimumVelocity = json.getMinimum_velocity() * -1;
        inertia = json.getInertia();
        c1 = json.getC1();
        c2 = json.getC2();
    }

    public Particle(int[] position, JSONreader json) { //position array is binary representation of a knapsack
        velocity = new double[position.length];
        for (int i = 0; i < position.length; i++) {
            velocity[i] = 0;
        }
        this.bestPosition = position;
        this.position = position;
        this.individualBestValue = calcFitness();

        maximumVelocity = json.getMaximum_velocity();
        minimumVelocity = json.getMinimum_velocity() * -1;
        inertia = json.getInertia();
        c1 = json.getC1();
        c2 = json.getC2();
    }

    public double sigmoid(double v) { //sigmoid is a function i found online to update binary PSOs.
        double vele = Math.exp(-v);
        //System.out.println("vele: " + vele);
        double sigmoid = 1 / (1 + vele);
        return sigmoid; //this is compared to a random value then the position becomes a 1 or 0
    }

    public double velocity(int arrPos, double globalBestValue) { //updates velocity
        double r1 = Configuration.instance.randomGenerator.nextFloat();
        double r2 = Configuration.instance.randomGenerator.nextFloat();

        double v1 = inertia * velocity[arrPos] + c1 * r1 * (bestPosition[arrPos] - position[arrPos]);
        double v2 = c2 * r2 * (globalBestValue - position[arrPos]);
        double v = v1 + v2;
        this.velocity[arrPos] = v;

        return v;
    }

    public void setPosition(int arrPos) { //use velocity, sigmoid and random value to update it
        double random = Configuration.instance.randomGenerator.nextFloat();
        double sig = sigmoid(this.velocity[arrPos]);

        int[] temp = new int[position.length];
        System.arraycopy(position, 0, temp, 0, Configuration.instance.items.length);

        if (random < sig) { //update position in knapsack to 1 if sigmoid is bigger than random
            temp[arrPos] = 1;
        } else { // 0 if smaller
            temp[arrPos] = 0;
        }
        if (howHeavy(temp) <= 822) { //keeps the knapsack from going overweight
            position = temp;
        }

    }

    public int calcFitness() { //uses total value of the knapsack

        Item[] fitnessList = binToPerm(position);
        int value = 0;
        int weight = 0;

        for (Item x : fitnessList) {
            weight += x.getWeight();
            value += x.getValue();
        }
        if (weight > Configuration.instance.MAX_CAPACITY) {
            value = 0;
        }

        if (value > individualBestValue) {
            individualBestValue = value;
            bestPosition = position;
        }

        return value;
    }

    public int howHeavy(int[] position) {
        Item[] temp = binToPerm(position);
        int kgs = 0;
        for (Item x : temp) {
            kgs += x.getWeight();
        }
        return kgs;
    }

    public Item[] binToPerm(int[] binaryNum) { //turn the knapsack from a binary representation to a list of items
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

    public static Particle generateRandom(JSONreader json) {
        //generate random MT betweem 1-150, if item is not null add to knapsack. Make null after adding.
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
            random = Configuration.instance.randomGenerator.nextInt(0, 149);

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
        return new Particle(randomList, json);
    }

    public int[] getPosition() {
        return position;
    }

    public int getWeight() {
        int weight = howHeavy(position);
        return weight;
    }

    public int compareTo(Particle solution) {
        if (this.individualBestValue < solution.individualBestValue) {
            return 1;
        }
        if (this.individualBestValue > solution.individualBestValue) {
            return -1;
        }

        return 0;
    }

    public boolean equals(Object o) {
        if (!(o instanceof Particle)) {
            return false;
        }

        Particle sol = (Particle) o;
        return (sol.equals(sol.position)) && (individualBestValue == sol.individualBestValue);
    }

    public String toString() {
        String temp = "";
        for (int x : position) {
            temp += x;
        }
        return temp;
    }

}
