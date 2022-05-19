import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.time.LocalDateTime;

public class Report {
    private String filename;
    private boolean append = false;

    public Report(String filename) {
        this.filename = "../Assignment_SA/outputs/" + filename + ".txt";

    }

    public Report(String filename, boolean append) {
        this.filename = "../Assignment_SA/outputs/" + filename + ".txt";
        this.append = append;
    }

    public void writeToFile(String text) throws IOException {

        FileWriter writer = new FileWriter(filename, true);
        PrintWriter print = new PrintWriter(writer);

        print.printf("'%s' %n", text);
        print.close();

    }

    public void heading(String config, String text) throws IOException {
        FileWriter writer = new FileWriter(filename, append);
        PrintWriter print = new PrintWriter(writer);

        print.println("Evaluation  |  " + LocalDateTime.now().getYear() + "-" + LocalDateTime.now().getMonth() + "-"
                + LocalDateTime.now().getDayOfMonth() + " " + LocalDateTime.now().getHour() + ":"
                + LocalDateTime.now().getMinute());
        print.printf("Configuration:   %s %n", config);
        print.printf("                 %s%n", text);
        print.println("===============================================================================================");
        print.printf("Temperature      bweight     bvalue      squality    knapsack%n");
        print.println("-----------------------------------------------------------------------------------------------");
        print.close();
    }

    public void Statistics(String text) throws IOException {
        FileWriter writer = new FileWriter(filename, true);
        PrintWriter print = new PrintWriter(writer);

        print.println("-----------------------------------------------------------------------------------------------");
        print.println("[Statistics]");
        print.printf("Runtime          %s%n", text);
        print.close();
    }
}
