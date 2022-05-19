import java.text.DecimalFormat;

public enum Configuration {
    instance;

    public DecimalFormat decimalFormat = new DecimalFormat("000");
    public DecimalFormat tempFormat = new DecimalFormat(("00000"));
    public DecimalFormat percentFormat = new DecimalFormat("##0.00");

    public DecimalFormat jsonFormat = new DecimalFormat("00");

    public MersenneTwister randomNumber = new MersenneTwister(System.currentTimeMillis());

    private Item item = new Item();
    final Item[] items = item.populateKnap();

    public final int MAX_ITERATIONS = 1000;
    public final int MAX_CAPACITY = 822;
    public final int BEST_KNOWN = 977;
    public int minimum_coordinate = 0;
    public int maximum_coordinate = 150;
    public double minimum_temperature = 1;
}


