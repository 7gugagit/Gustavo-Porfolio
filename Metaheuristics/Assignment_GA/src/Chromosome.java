import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Chromosome implements Comparable<Chromosome> {
    private int fitness;
    private int[] gene; //binary knapsack representation

    public Chromosome(int[] gene){
    this.gene = gene;
    this.fitness = calcFitness(gene);
    }

    public static Chromosome generateRandom() {
        //generate random MT betweem 1-150, if item is not null add to knapsack. Make null after adding.
        //keep weight under 822
        int weight = 0;
        Item[] listItems = new Item[Configuration.instance.items.length];
        System.arraycopy(Configuration.instance.items, 0, listItems, 0, Configuration.instance.items.length);

        int[] randomList = new int[listItems.length];
        for (int i = 0; i < randomList.length; i++){
            randomList[i] = 0;
        }

        int random = 0;
        int count = 0;
        boolean complete = true;

        while(complete) { //runs until the bag has reached 822 or the next item will make it go over 822
            random = Configuration.instance.randomNumber.nextInt(0, 149);

            if (listItems[random].getItemNum() !=  0) {

                if ((weight + listItems[random].getWeight()) <= Configuration.instance.MAX_CAPACITY) {
                    randomList[random] = 1;
                    weight += listItems[random].getWeight();
                    listItems[random] = new Item(0,0,0);

                    count++;
                }
                else { //breaks if bag + item > 822 or == 822
                    complete = false;
                }

            }
        }
        return new Chromosome(randomList);
    }

    public static int calcFitness(int[] gene){ //total value of the knapsack

        Item[] fitnessList = binToPerm(gene);
        int value = 0;
        int weight = 0;

        for (Item x : fitnessList) {
            weight += x.getWeight();
            value += x.getValue();
        }
        if (weight > Configuration.instance.MAX_CAPACITY)
        {
            value = 0;
        }
        return value;
    }

    public Chromosome[] onePointCrossOver(Chromosome parent){ //#4
        int[] child1 = new int[gene.length];
        int[] child2 = new int[gene.length];

        int pivot = Configuration.instance.randomNumber.nextInt(gene.length);

        System.arraycopy(gene, 0, child1, 0, pivot);
        System.arraycopy(parent.getGene(), pivot, child1, pivot, child1.length - pivot);
        System.arraycopy(parent.getGene(), 0, child2, 0, pivot);
        System.arraycopy(gene, pivot, child2, pivot, child2.length - pivot);

        Chromosome[] crossed = new Chromosome[]{new Chromosome(child1), new Chromosome(child2)};
        return crossed;
    }

    public Chromosome[] twoPointCrossOver(Chromosome parent){
        int[] child1 = new int[gene.length];
        int[] child2 = new int[gene.length];

        int pivot = Configuration.instance.randomNumber.nextInt(0, (gene.length));
        int pivot2 = Configuration.instance.randomNumber.nextInt(0, (gene.length));
        if (pivot > pivot2) {
            int temp = pivot2;
            pivot2 = pivot;
            pivot = temp;
        }

        int diff = Math.abs(pivot2-pivot);

        System.arraycopy(gene, 0, child1, 0, pivot);
        System.arraycopy(parent.getGene(), pivot, child1, pivot, diff);
        System.arraycopy(gene, pivot2, child1, pivot2, child1.length - (pivot2));
        System.arraycopy(parent.getGene(), 0, child2, 0, pivot);
        System.arraycopy(gene, pivot, child2, pivot, diff);
        System.arraycopy(parent.getGene(), pivot2, child2, pivot2, child2.length - (pivot2));

        Chromosome[] crossed = new Chromosome[]{new Chromosome(child1), new Chromosome(child2)};
        return crossed;
    }

    public Chromosome bitFlipMutate(){
        int num = Configuration.instance.randomNumber.nextInt(gene.length);
        int[] newGene = new int[gene.length];

        System.arraycopy(gene, 0, newGene, 0, gene.length);

        if (newGene[num] == 1) {
            newGene[num] = 0;
        }
        else {
            newGene[num] = 1;
        }
        Chromosome mutated = new Chromosome(newGene);
        return mutated;
    }

    public Chromosome exchangeMut (){ //#4
        int num1 = Configuration.instance.randomNumber.nextInt(gene.length);
        int num2 = Configuration.instance.randomNumber.nextInt(gene.length);

        int[] newGene = new int[gene.length];
        System.arraycopy(gene, 0, newGene, 0, gene.length);

        newGene[num1] = gene[num2];
        newGene[num2] = gene[num1];

        Chromosome mutated = new Chromosome(newGene);

        return mutated;
    }

    public Chromosome inversionMut(){
        int num = Configuration.instance.randomNumber.nextInt(0, gene.length);
        int num2 = Configuration.instance.randomNumber.nextInt(0, gene.length);

        if (num > num2) {
            int temp = num2;
            num2 = num;
            num = temp;
        }
        int diff = Math.abs(num2 - num);

        int[] newGene = new int[gene.length];
        int[] reverse = new int[diff+1];
        System.arraycopy(gene, 0, newGene, 0, gene.length);
        System.arraycopy(gene, num, reverse, 0, diff);

        for(int i = 0; i < reverse.length/2; i++)
        {
            int temp = reverse[i];
            reverse[i] = reverse[reverse.length - i - 1];
            reverse[reverse.length - i - 1] = temp;
        }

        int count =0;
        for (int i = num; i < num2 ; i++) {
            newGene[i] = reverse[count];
            count++;
        }
        Chromosome mutated = new Chromosome(newGene);
        return mutated;
    }

    public Chromosome insertionMut (){
        int num = Configuration.instance.randomNumber.nextInt(0, gene.length/2);
        int num2 = Configuration.instance.randomNumber.nextInt(0, gene.length/2);

        if (num > num2) {
            int temp = num2;
            num2 = num;
            num = temp;
        }

        int diff = Math.abs(num2 - num);

        int[] newGene = new int[gene.length];
        System.arraycopy(gene, 0, newGene, 0, gene.length);

        List<Integer> list1 = new ArrayList<Integer>();
        for (int x : newGene) {
            list1.add(x);
        }

        int insert = list1.get(num2);
        list1.remove(num2);
        list1.add(num, insert);

        int count = 0;
        for(int x : list1) {
            newGene[count] = x;
            count++;
        }


        Chromosome mutated = new Chromosome(newGene);

    return mutated;
    }

    public Chromosome displacementMut(){
        int num = Configuration.instance.randomNumber.nextInt(0, gene.length);
        int num2 = Configuration.instance.randomNumber.nextInt(0, gene.length);

        if (num > num2) {
            int temp = num2;
            num2 = num;
            num = temp;
        }

        int diff = Math.abs(num2 - num);
        int maxPos = (gene.length - (diff));

        int posDis = Configuration.instance.randomNumber.nextInt(0, maxPos);
        int sum = 0;
        int[] newGene = new int[gene.length];
        System.arraycopy(gene, 0, newGene, 0, gene.length);

        List<Integer> list1 = new ArrayList<Integer>();

        for (int x : newGene) {
            list1.add(x);
        }


        int[] displace = new int[diff];
        int count = 0;
        for (int i = num; i < num2; i++) {
            displace[count] = list1.get(i);
            count++;
        }

        for (int i = num; i < num2; i++) {
            list1.remove(num);
        }

        count =displace.length-1;

        for (int i = posDis; i < posDis+diff; i++) {
            list1.add(maxPos, displace[count]);
            count--;
        }

        count = 0;
        for (int x: list1) {
            newGene[count] = x;
            count++;
        }

        Chromosome mutated = new Chromosome(newGene);
        return mutated;
    }

    public static Item[] binToPerm(int[] binaryNum){ //takes binary representation of a knapsack and returns a list of items
        Item[] listDefault = new Item[Configuration.instance.items.length];
        System.arraycopy(Configuration.instance.items, 0, listDefault, 0, Configuration.instance.items.length);
        Item[] permList = new Item[binaryNum.length];

        for (int i = 0; i <permList.length ; i++) {
            permList[i] = new Item(0,0,0);
        }
        for(int i = 0; i < binaryNum.length; i++){
            if (binaryNum[i]==1){
                permList[i] = listDefault[i];
            }
        }
        return permList;
    }

    public int compareTo(Chromosome chromosome) {

        if (this.fitness < chromosome.fitness) {
            return 1;
        }

        if (this.fitness > chromosome.fitness) {
            return -1;
        }

        return 0;
    }

    public boolean equals(Object o) {
        if (!(o instanceof Chromosome)) {
            return false;
        }

        Chromosome chromosome = (Chromosome) o;

        return (gene.equals(chromosome.gene)) && (fitness == chromosome.fitness);
    }

    public int[] getGene(){
        return gene;
    }

    public int getWeight(){
         Item[] temp = binToPerm(gene);
         int kgs = 0;
         for (Item x : temp) {
             kgs += x.getWeight();
         }
         return kgs;
    }

    public String getGeneString(){
        String temp = "";
        for (int x : gene){
            temp += x;
        }
        return temp;
    }

    public int getFitness(){
        return fitness;
    }
}
