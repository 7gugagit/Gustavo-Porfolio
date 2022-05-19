This is my favorite project I have ever worked on, it is in the area of Metaheuristics, and the goal was to answer the famous
Knapsack Problem using different Metaheuristics Algorithms. I solved the problem and wrote reports for 3 algorithms -
Genetic Algorithm (GA), Particle Swarm Optimization (PSO), Simulated Annealing (SA).

Metaheuristics is my favorite section of AI and I would love to make it a goal in my carreer. 

Instructions for the project:

Hi! I did the assignment in three different IntelliJ Projects. The projects are called Assignment_GA, Assignment_SA,
and Assignment_PSO. 

The .java files are under:
GA: (Assignment_GA\src\)
SA: (Assignment_SA\src\)
PSO:(Assignment_PSO\src\)

To run them on the command line, go into the respective project folder, and run the Application class from the terminal.
GA: (Assignment_GA\out\production\Assignment) - main class is called App
SA: (Assignment_SA\out\production\Assignment) - main class is called App
PSO:(Assignment_PSO\out\production\Assignment) - main class is called Application (sorry for inconsistency)

to run it you can use: 
java App configuration [ga/sa/pso]_default_##.json  	//this will only run one configuration
	 (Application) - for PSO
or
java Application search_best_configuration				//this will run all the configurations and find the best one
	 (Application) - for PSO
	 
if the terminal does not work, please load the projects into IntelliJ and run the main App/Application for the project.
Then the program will ask the user to input a number corresponding to the configuration you want to run,
or if you want to search_best_configuration then enter the number 999.

Each configuration has a textfile under Assignment_X\outputs, which has the information of the run. Using 
search_best_configuration will create a textfile for each configuration.

The json configurations and the csv knapsack are under the folder data.

**Notes:
-For the genetic algorithm, my computer could not handle very big populations it would freeze and not finish the
run, so I used 10000 iterations with a population of 300. The textfiles under data have the output for that
configuration. Most of the configurations found a better answer than the 977, but I think if the population was
larger all of them would have worked.

-There were a few configurations and numbers I was not sure about so I used what I found online (such as an okay
tournament size for parent selection in GA being 5), there were a few others as well.


