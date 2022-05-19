import java.text.DecimalFormat;

public enum Configuration {
    instance;

    DecimalFormat decimalFormat = new DecimalFormat("000000");
    DecimalFormat jsonFormat = new DecimalFormat("00");

    final int MAX_CAPACITY = 822;
    final int MAX_ITERATIONS = 10000;
    final int POPULATION = 300;
    final double bestKnown = 977;

    private Item item = new Item();
    final Item[] items = item.populateKnap();

    MersenneTwister randomNumber = new MersenneTwister(System.currentTimeMillis());

    double elitismRatio = 0.1;

}
