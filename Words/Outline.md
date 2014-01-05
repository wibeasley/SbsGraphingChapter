Abstract
================================================================
GDA isn't a tool appropriate for just some types of behavioral research questions.  We argue that it should be integrated into almost every step of a project, from the initial exploration of observed data after the first few subjects, to the final presentation of a project's insights.

Exploration
================================================================

### Benefits of Eager Exploration
 1. Produce insights not possible with myopic CFA.
 1. Verify the CFA assumptions are reasonable (eg, homogeneity of variance).
 1. Due diligence that the data collection didn't produce substantial artifacts.  When grants require hundreds of hours of data collection and tens of thousands of federal dollars (and usually and order of magnitude more), some might argue that it's the researcher's obligation to thoroughly check for unexpected patterns.
 
 
### Exploration Workflow
Your workflow should allow exploration of many different arrangements and perspectives quickly.  It's important to move quickly because it's easier to compare the variations in your memory, and there are always competing demands on your research time.  
 1. *Flexibility*: As the exploration progresses, it should be almost effortless to swap variables, and translate between different types of graphs (eg, starting with a univariate scatterplot and advancing to a two-dimensional contour plot with facets){Insert a figure}.  With `ggplot2`, this typically requires inserting two lines of code and modifying a third. {Insert a code snippet}.  The brilliance of Wilkinson's Grammar is that the underlying structure taps into the commonalities bla bla bla. With many other libraries, you'd discard your `Histogram` code, and need to start over with a `ContourPlot`.   
 1. *Cohesion at a single time point*: Behavioral research commonly has datasets with more than 10 variables.  We advocate that all of the univariate patterns be explored, and many of the bivariate and trivariate relationships be graphed at least once.  However with just 10 variables, 175 graphs are required to cover the trivariate space ((10 1) + (10 2) + (10 3) = 175).  With a modest 20 variables, the count accelerates to 1,350.  Even if the entire trivariate space isn't covered, it's safe to say that most modestly-sized research projects should produce at least 100 graphs.  R's literate programming tools (notably Sweave and knitr) handle this well, and can combine hundreds of graphs in a single pdf or html document.  It's easy to provide context by including prose in between the graphs.  This is huge improvement over managing dozens of loose png files, even if only one or two project members need to see them.
 1. *Cohesion over time*: Something is wrong if you produce your graphs only once.  Things will inevitably need to be revised, either because you're monitoring the patterns while data are being collected, or you choose to subset the sample or transform some variable after the initial exploration.  Many have found source code repositories to be an ideal for change management.  It also allows multiple members of you research team to contribute in parallel, without the clumsiness of emailing file versions or ad-hoc versioning on a shared file server.  Many free version-control services are available, and GitHub is currently the most popular (cite two C&H RR books)
 1. *Tied to a data manipulation program*:  Many times an productive graphical exploration depends on the data manipulation more than the visualization code.


Presentation
================================================================

Interactivity
================================================================

Resolution
================================================================

References
================================================================

Will's GDA World View
================================================================
I had been very comfortable in my graphics reality, which was split into two (oversimplified) worlds.  The first used a Cleveland/Tukey-inspired approach where the researcher tenaciously attacks a dataset from as many angles and facets that are feasible in a given time.  Most of these graphs are intended for the internal research team, and will not be viewed by unfamiliar audiences.  

The second world used a Tufte-inspired approach where the researcher tries to communicate novel and complex relationships with only a handful of crafted graphs.  Not everything should not be an elegant Tufte graph appropriate for a wide audience; it would take too much time away from other important activities, such as Cleveland activities.

The 2012 election coverage (eg, http://elections.nytimes.com/2012/results/president/scenarios) exposed me to a third world --where interactive graphics didn’t require sophisticated audiences.  Until then, I’d valued interactive graphics mostly from the Cleveland perspective.  I hadn’t appreciated how effectively they could communicate concepts and relationships.  I’d like to learn how your experts see the fit between these types of media and the types of audiences.  A secondary goal is to learn more about ideal interactive visualizations (if you had a week to develop one very public display), and learn more about less important interactive visualizations (if you had 8 hours to develop multiple displays).
