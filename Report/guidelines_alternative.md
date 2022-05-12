# Alternative report: the Smocks


Here is an ambitious project. Create an evolutionary simulator as follows.
There are 15 individuals of a race called "Smock". These individuals sit
next to each other in one row. Each individual has (initially) an arm of
length 2. Each smock starts with 100 hit points. Each turn all smocks loose
some hit points (the amount they loose depends on the parameter which can
be set up).

A fly comes in flying at a random spot at height 4. The individual that
sits directly beneath the fly tries to catch it. However,
as initially all individuals start with an arm of length 2, they can't. The
fly then lowers its flight, randomly moving to the right or to the left.
Sooner or later one of the individuals catches the fly.

The simulation has two parameters:

 * mutation rate (how likely a smock is to mutate when reproducing)
 * probability that the fly, when lowering its flight, will move
   horizontally (this is the selective pressure: higher probability favors
   smocks with longer arms) 

However, if you have another idea how to create a simple evolutionary
simulator, go ahead with it. It doesn't even have to be original, as long
as the code is yours and yours only.

Also, there is absolutely no need to create animations or interactive
visualisations. The simulation mostly produces *data* which you can then
visualize on a plot.

## Marking

The report will make out 30% of the total mark; you will get 0-30 points
depending on its completeness and (very rough) correctness.

 * 5 points for free because this project is much harder
 * 3 points for creativity (whatever I decide to view as such), because
   we need more creativity also in bioinformatics. This may be, but is not
   limited to
   * language
   * additional analyses
   * nice graphics
   * good questions
   * making me laugh
   * originality in approaching the task
 * 13 points for the coding, including:
   * whether the code was *roughly* correct 
   * whether I was able to run the code
   * whether simulation worked as described in the report
   * whether the programmer used good coding practices (comments,
     indendation and such)
   * I will not, however, judge the code quality, maturity, or even
     bugs
 *  9 points for report structure, Rmarkdown, bibliography etc.

I am not expecting a scientific paper and I am not expecting you to waste
too much your time on that. So long as I know that you know what you're
doing and that you are able to create an Rmarkdown document, I am happy to
give you 27 points (for the extra 3, you need to get inventive).
