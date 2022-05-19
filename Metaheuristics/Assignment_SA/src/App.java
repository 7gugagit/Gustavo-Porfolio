import org.json.simple.JSONObject;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class App {
    public static void main(String[] args) {
        App application = new App();

        int allConfigs = 26;
        String config = "";
        int step = 1;
        int jsonMake = 0;
        if (args.length > 0) { //this takes in the commandline arguments
            if (args[0].equalsIgnoreCase("search_best_configuration")) { //making allConfigs = 26 makes it run through all the json configurations
                allConfigs = 26;
                jsonMake = 1000;
            } else {
                System.out.println(args[1].substring(17, 19));
                config = args[1].substring(17, 19);
                allConfigs = Integer.parseInt(config) + 1;
                step = allConfigs - 1;
            }
        } else { //if not running on terminal or no arguments are given, user is asked to type in configuration
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter configuration number: (enter 999 for search_best_configuration)");
            allConfigs = sc.nextInt() + 1;
            step = allConfigs - 1;
            if (allConfigs == 1000) {
                allConfigs = 26;
                step = 1;
                jsonMake = 1000;
            }
        }
        int bestConfiguration = 0;
        int bestValue = 0;

        try { //to use report to write to txtfile
            for (int i = step; i < allConfigs; i++) { //runs for the number of configurations existing or for one config
                long runtimeStart = System.currentTimeMillis();
                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(i));
                String configNum = json.getConfiguration();
                double initial_temp = json.getInitialTemperature();
                double cooling_rate = json.getCoolingRate();
                Report report = new Report(json.getConfiguration(), false);

                report.heading(json.getConfiguration(), "SA  |  Initial Temperature: " + initial_temp
                        + "  |  Cooling Rate: " + cooling_rate);

                SimulatedAnnealing sa = new SimulatedAnnealing(json); //starts SA and gives in configuration

                int currentBest = 0;
                currentBest = sa.execute(); //returns the best value afte executing.
                if (currentBest > bestValue) { //compares each iterations best value to the overall best to keep the best one
                    bestValue = currentBest;
                    bestConfiguration = i;
                }


                report.Statistics((System.currentTimeMillis() - runtimeStart) + "ms");

            }
            if (jsonMake == 1000) { //this is to make sure it only generates the best config file if search_best is called
                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(bestConfiguration));

                JSONObject jsonObject = new JSONObject();

                jsonObject.put("initial_temperature", json.getInitialTemperature());
                jsonObject.put("configuration", json.getConfiguration());
                jsonObject.put("cooling_rate", json.getCoolingRate());

                try {
                    FileWriter file = new FileWriter("../Assignment_SA/outputs/sa_best.json");
                    file.write(jsonObject.toJSONString());
                    file.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                System.out.println("JSON file created: " + jsonObject);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
