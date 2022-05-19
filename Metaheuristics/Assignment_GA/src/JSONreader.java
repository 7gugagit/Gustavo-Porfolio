import org.json.simple.parser.JSONParser;
import java.io.FileReader;
import java.util.Iterator;
import java.util.Map;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.*;

public class JSONreader {
    private String selection_method, configuration, crossover_method, mutation_method;
    private double mutation_ratio, crossover_ratio;
    private String filename = "../Assignment_GA/data/ga_default_";

// Java program to read JSON from a file
    public JSONreader(){
        this.filename = filename + "04.json";
        readFile();
    }
    public JSONreader(String configNum) {
        this.filename = filename + configNum +".json";
        readFile();
    }

    private void readFile(){
        try {
            Object obj = new JSONParser().parse(new FileReader(filename));

            JSONObject jo = (JSONObject) obj;

            this.selection_method = (String) jo.get("selection_method");
            this.configuration = (String) jo.get("configuration");
            this.crossover_method = (String) jo.get("crossover_method");
            this.mutation_method = (String) jo.get("mutation_method");
            System.out.println(selection_method);
            System.out.println(configuration);
            System.out.println(crossover_method);
            System.out.println(mutation_method);

            this.mutation_ratio = Double.parseDouble((String) jo.get("mutation_ratio"));
            this.crossover_ratio =  Double.parseDouble((String) jo.get("crossover_ratio"));
            System.out.println(mutation_ratio);
            System.out.println(crossover_ratio);
        }
        catch (Exception e) {
            e.printStackTrace();

    }

    }



    public String getSelectionMethod(){
        return selection_method;
    }
    public String getConfiguration(){
        return configuration;
    }
    public String getCrossoverMethod(){
        return crossover_method;
    }
    public String getMutationMethod(){
        return mutation_method;
    }
    public double getMutationRatio(){
        return mutation_ratio;
    }
    public double getCrossover_ratio(){
        return crossover_ratio;
    }

    public void setConfig(String config){
        this.filename = "../Assignment_GA/data/ga_default_" + config + ".json";
    }
}



