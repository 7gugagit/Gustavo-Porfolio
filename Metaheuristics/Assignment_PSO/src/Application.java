import org.json.simple.JSONObject;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class Application {
    public static void main(String[] args) {


        Application application = new Application();

        int allConfigs = 26;
        String config = "";
        int step = 1;
        int jsonMake = 0;
        if (args.length > 0) {
            if (args[0].equalsIgnoreCase("search_best_configuration")) { //allows commandline arguments
                allConfigs = 26; //if this is 26 then runs through every configuration
                jsonMake = 1000;
            } else { // for configuration pso_default##
                System.out.println(args[1].substring(17, 19));
                config = args[1].substring(17, 19);
                allConfigs = Integer.parseInt(config) + 1;
                step = allConfigs - 1;
            }
        } else { //if not using terminal or no arguments entered then user is asked for input
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter configuration number: (enter 999 for search_best_configuration)");
            allConfigs = sc.nextInt() + 1;
            step = allConfigs - 1;
            if (allConfigs == 1000) {
                allConfigs = 26;
                jsonMake = 1000;
                step = 1;
            }
        }

        int bestConfiguration = 0;
        int bestValue = 0;
        try {
            for (int i = step; i < allConfigs; i++) {
                long runtimeStart = System.currentTimeMillis();
                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(i));
                Report report = new Report(json.getConfiguration(), false);

                Swarm swarm = new Swarm(json); //starts the swam andd gives it the configuration

                report.heading(json.getConfiguration(), "PSO  |  #" + Configuration.instance.maximumNumberOfIterations
                        + "  |  # of Particles: " + json.getNumber_particles() + "  |  Velocity Range: " + json.getMinimum_velocity() + "  -  " + json.getMaximum_velocity()
                        + "  |  Inertia: " + json.getInertia() + "  |  c1: " + json.getC1() +
                        " c2: " + json.getC2());
                int currentValue;

                currentValue = swarm.execute(); //swarm returns a best value after it is done

                if (currentValue > bestValue) {
                    bestValue = currentValue;
                    bestConfiguration = i; //best particle is chosen each time a better one is found, and saves the configuration number
                }
                System.out.println("config: " + i + " best: " + bestValue);


                report.Statistics((System.currentTimeMillis() - runtimeStart) + "ms");

                for (String x : swarm.getConverge()) {
                    report.writeToFile(x);
                }
            }
            if (jsonMake == 1000) { //only makes json best config file if search_best is called.
                System.out.println("Best configuration is: " + bestConfiguration);

                JSONreader json = new JSONreader(Configuration.instance.jsonFormat.format(bestConfiguration));

                JSONObject jsonObject = new JSONObject();

                jsonObject.put("minimum_velocity", json.getMinimum_velocity());
                jsonObject.put("maximum_velocity", json.getMaximum_velocity());
                jsonObject.put("inertia", json.getInertia());
                jsonObject.put("configuration", json.getConfiguration());
                jsonObject.put("number_particles", json.getNumber_particles());
                jsonObject.put("c1", json.getC1());
                jsonObject.put("c2", json.getC2());
                try {
                    FileWriter file = new FileWriter("../Assignment_PSO/outputs/pso_best.json");
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
