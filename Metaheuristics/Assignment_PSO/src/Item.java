import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Item {
    private int itemNum;
    private int weight;
    private int value;
    final String filename = "../Assignment_PSO/data/knapsack_instance.csv";
    private Item[] items = new Item[150];

    public Item() { //this class takes the 150 items from the knapsack.csv and makes them into objects and an arrary

    }

    public Item(int itemNum, int weight, int value) {
        this.itemNum = itemNum;
        this.weight = weight;
        this.value = value;
    }

    public Item[] populateKnap() {
        int count = 0;
        String[] temp = new String[3];
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(filename));
            String line = br.readLine();
            while ((line = br.readLine()) != null) {

                temp = line.split(";");
                items[count] = new Item(Integer.parseInt(temp[0]), Integer.parseInt(temp[1]), Integer.parseInt(temp[2]));
                count++;
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return items;
    }

    public int getItemNum() {
        return itemNum;
    }

    public int getWeight() {
        return weight;
    }

    public int getValue() {
        return value;
    }

    public void setToNull() {
        this.itemNum = 0;
        this.weight = 0;
        this.value = 0;
    }

    public String toString() {
        String temp = itemNum + " " + weight + " " + value;
        return temp;
    }
}
