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

1. *Flexibility*: As the exploration progresses, it should be almost effortless to swap variables, and translate between different types of graphs (eg, starting 
with a univariate scatterplot and advancing to a two-dimensional contour plot with facets){Insert a figure}.  With `ggplot2`, this typically requires inserting two lines of code and modifying a third. {Insert a code snippet}.  The brilliance of Wilkinson's Grammar is that the underlying structure taps into the commonalities bla bla bla. With many other libraries, you'd discard your `Histogram` code, and need to start over with a `ContourPlot`.   

1. *Cohesion at a single time point*: Behavioral research commonly has datasets with more than 10 variables.  We advocate that all of the univariate patterns be explored, and many of the bivariate and trivariate relationships be graphed at least once.  However with just 10 variables, 175 graphs are required to cover the trivariate space ((10 1) + (10 2) + (10 3) = 175).  With a modest 20 variables, the count accelerates to 1,350.  Even if the entire trivariate space isn't covered, it's safe to say that most modestly-sized research projects should produce at least 100 graphs.  R's literate programming tools (notably Sweave and knitr) handle this well, and can combine hundreds of graphs in a single pdf or html document.  It's easy to provide context by including prose in between the graphs.  This is huge improvement over managing dozens of loose png files, even if only one or two project members need to see them.

1. *Cohesion over time*: Something is wrong if you produce your graphs only once.  Things will inevitably need to be revised, either because you're monitoring the patterns while data are being collected, or you choose to subset the sample or transform some variable after the initial exploration.  Many have found source code repositories to be an ideal for change management.  It also allows multiple members of you research team to contribute in parallel, without the clumsiness of emailing file versions or ad-hoc versioning on a shared file server.  Many free version-control services are available, and GitHub is currently the most popular (cite two C&H RR books)

1. *Tied to a data manipulation program*:  Many times a productive graphical exploration depends on the data manipulation more than the visualization code.

### Audience
A handful of members on your internal research team viewing hundreds of quickly-made graphs.  
 
Presentation
================================================================

### Audience
Hopefully hundreds of people viewing only a handful of graphs.  These graphs need to be well-crafting and well-chosen, so that the essential concepts and patterns are communicated quickly to readers who may initially only be interested in skimming your publication for relevance or innovation.

### Color (pasted from some internal notes/instructions Will wrote)
Learning a little about color will help you create better graphs. My two favorite approaches are [HCL](http://tristen.ca/hcl-picker) and [ColorBrewer](http://colorbrewer2.org/).  Fortunately ggplot2 supports both of them easily.  If you're familar with the ideas behind them, you can develop graphs quicker too, instead of relying on trial-and-error to get it correct.  Both approaches were developed independent of R, but have packages and lots of documentation about them. {added Feb 2012}
 * [HCL](http://tristen.ca/hcl-picker) represents color with the three components/dimensions of hue, chroma lightness.  It is implemented in the [colorspace](http://cran.r-project.org/web/packages/colorspace/) package. It has a good [vignette](http://cran.r-project.org/web/packages/colorspace/vignettes/hcl-colors.pdf) and [article](http://www.sciencedirect.com/science/article/pii/S0167947308005549).  A theoretical [article](http://mmir.doc.ic.ac.uk/mmir2005/CameraReadyMissaoui.pdf) on HCL is by Sarifuddin and Missaoui. {added Feb 2012}
 * [ColorBrewer](http://colorbrewer2.org/) has a good site that has explanations/references and lets you pick specific palettes.  It has a finite set of schemes, and doesn't have the mathematical foundation that HCL has.  But the color schemes have been refined by perceptual experiments.  It is implemented in the [RColorBrewer](http://cran.r-project.org/web/packages/RColorBrewer/) package. I typically use it instead of HCL for categorical variables when it doesn't matter if some categories have slightly more intense colors than other categories.  I like the webpage best, because it (1) quickly gives you an example map, (2) allows you to specify how many colors in the palette, and (3) gives the RGB values for each color.  Within R, a quick version of this can be seen by executing `RColorBrewer::display.brewer.all()`. {added Feb 2012}
 * [vis4.net](http://vis4.net/blog/posts/avoid-equidistant-hsv-colors/) has a good quick blog post on  that adds some more context. {added Feb 2012}


Interactivity
================================================================
Isn't just for the exploratory phase any more.  Graphing libraries that run natively in a user's browser (without any special plug in) have allowed widespread deployments to normal users (eg, NYTimes).  Currently most of these require experience in a programming language like JavaScript, which many readers of this encyclopedia don't have.  However the need and gap have been identified by many commercial and academic groups, who are trying to allow interactive graphs to be developed by researchers without programming experience.

Resolution
================================================================
As datasets become "big", many of the common graphical techniques no longer effectively reveal patterns.  What is appropriate for a sample of 40 lab participants will likely fail for 400,000 county residents. If the volume of data is slightly overwhelming, techniques like jittering and translucency can alleviate things.  Beyond that, it probably requires you to think about what is being plotted.  Instead of plotting the (x,y) for each observation, a different approach is required, where the plotting area is partitioned and a summary of each partition is plotted.  A contour plot is the simplest example, where the count of a partition is represented.  This can be generalized to other attributes besides count (Wickham, ~2013).

References
================================================================
* Cleveland
* Gandrud (2013)
* Tufte
* Wickham (2009)
* Wilkinson (2005)
* Xie (2013)

Miscellaneous Snippets
================================================================
* Maps are good.  Because readers are familiar with mapping conventions and the geography, much richer multivariate patterns can be absorbed than "statistical graphs".  It's a lot simpler and possibly more representative to show that X neighborhoods have Y outcomes, than it is to present a SEM showing that neighborhoods with median income of X1, median Race of X2, and median age of X3 have an outcome of Y; even politicians and policy makers can get it.  (Joe's point:) Additionally, maps immediately grab people attention, because they want to see how familiar neighborhoods/states/counties compare against each other.

Will's GDA World View
================================================================
I had been very comfortable in my graphics reality, which was split into two (oversimplified) worlds.  The first used a Cleveland/Tukey-inspired approach where the researcher tenaciously attacks a dataset from as many angles and facets that are feasible in a given time.  Most of these graphs are intended for the internal research team, and will not be viewed by unfamiliar audiences.  

The second world used a Tufte-inspired approach where the researcher tries to communicate novel and complex relationships with only a handful of crafted graphs.  Not everything should not be an elegant Tufte graph appropriate for a wide audience; it would take too much time away from other important activities, such as Cleveland activities.

The 2012 election coverage (eg, http://elections.nytimes.com/2012/results/president/scenarios) exposed me to a third world --where interactive graphics didn’t require sophisticated audiences.  Until then, I’d valued interactive graphics mostly from the Cleveland perspective.  I hadn’t appreciated how effectively they could communicate concepts and relationships.  I’d like to learn how your experts see the fit between these types of media and the types of audiences.  A secondary goal is to learn more about ideal interactive visualizations (if you had a week to develop one very public display), and learn more about less important interactive visualizations (if you had 8 hours to develop multiple displays).
