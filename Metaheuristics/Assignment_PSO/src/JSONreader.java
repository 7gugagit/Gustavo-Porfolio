import org.json.simple.parser.JSONParser;

import java.io.FileReader;
import java.util.Iterator;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.*;

public class JSONreader {
    private String configuration;
    private double minimum_velocity, maximum_velocity, inertia, c1, c2;
    private int number_particles;
    private String filename = "../Assignment_PSO/data/pso_default_";

    // Java program to read JSON from a file
    public JSONreader() {
        this.filename = filename + "01.json";
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

            this.minimum_velocity = Double.parseDouble((String) jo.get("minimum_velocity"));
            this.maximum_velocity = Double.parseDouble((String) jo.get("maximum_velocity"));
            this.inertia = Double.parseDouble((String) jo.get("inertia"));
            this.c1 = Double.parseDouble((String) jo.get("c1"));
            this.c2 = Double.parseDouble((String) jo.get("c2"));

            this.number_particles = Integer.parseInt((String) jo.get("number_particles"));

        } catch (Exception e) {
            e.printStackTrace();

        }

    }

    public String getConfiguration() {
        return configuration;
    }

    public double getMinimum_velocity() {
        return minimum_velocity;
    }

    public double getMaximum_velocity() {
        return maximum_velocity;
    }

    public double getInertia() {
        return inertia;
    }

    public double getC1() {
        return c1;
    }

    public double getC2() {
        return c2;
    }

    public int getNumber_particles() {
        return number_particles;
    }

}



