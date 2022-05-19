import java.text.DecimalFormat;

public enum Configuration {
    instance;


    DecimalFormat decimalFormat = new DecimalFormat("000000");
    DecimalFormat jsonFormat = new DecimalFormat("00");
    DecimalFormat percentFormat = new DecimalFormat(".00");
    MersenneTwister randomGenerator = new MersenneTwister();

    private Item item = new Item();
    final Item[] items = item.populateKnap();

    public final int MAX_CAPACITY = 822;
    public final int BEST_KNOWN = 977;
    public final int KNAPSACK_SIZE = 150;


    public int maximumNumberOfIterations = 100;

}
