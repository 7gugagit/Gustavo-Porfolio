import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.*;

public class JSONreader {
    private String configuration;
    private int initial_temperature;
    private double cooling_rate;
    private String filename = "../Assignment_SA/data/sa_default_";

    // Java program to read JSON from a file
    public JSONreader() {
        this.filename = filename + "07.json";
        readFile();
    }

    public JSONreader(String configNum) {
        this.filename = filename + configNum + ".json";
        readFile();
    }

    private void readFile() {
        try {
            Object obj = new JSONParser().parse(new FileReader(filename));

            JSONObject jo = (JSONObject) obj;

            this.configuration = (String) jo.get("configuration");
            System.out.println(configuration);

            this.initial_temperature = Integer.parseInt((String) jo.get("initial_temperature"));
            this.cooling_rate = Double.parseDouble((String) jo.get("cooling_rate"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getConfiguration() {
        return configuration;
    }

    public int getInitialTemperature() {
        return initial_temperature;
    }

    public double getCoolingRate() {
        return cooling_rate;
    }

}



