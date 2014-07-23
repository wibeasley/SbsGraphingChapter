<!-- rmarkdown v1 -->

<!-- Specify the report's official name, goal & description. -->
# Graphs for the First Section of the SBS Chapter
**Report Description**: {{Put a description here, once we know more about it.}}



<!-- Point knitr to the underlying code file so it knows where to look for the chunks. -->


<!-- Load the packages.  Suppress the output when loading packages. --> 


<!-- Load any Global Functions declared in the R file.  Suppress the output. --> 


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. --> 


<!-- Load the dataset.   -->


<!-- Tweak the dataset.   -->


A typical first place to start is graph points by different shape and line dashes to save funds if the anticipated journal charges extra for color, so the graph will be reproducible if someone prints grayscale copies of their presentation slides.  These might be relevant as the manuscript comes together, but we believe it is premature.  Instead of being concerned with future possible constraints, be concerned with how to understand the patterns yourself the best you can. The result is typically resembles this.  This particular graph may have an interesting structure, but who can tell?

![plot of chunk OverplottedGrayscale](FigureRmd/OverplottedGrayscale.png) 

At this point, we believe it's best to finese the visual elements so that the underlying trends may become noticeable.  However, too frequently the researcher immediately chooses to eliminate much of the complexity (and potential richness) of the dataset and displays on the means of the time and group, or (hopefully) both simultaneously.  {Maybe include one more graph with error bars.}

![plot of chunk Oversimplified](FigureRmd/Oversimplified1.png) ![plot of chunk Oversimplified](FigureRmd/Oversimplified2.png) 

We advocate that instead of immediately simplifying as in the prevoius thre graphs, the researcher stowe their dainty umbrella and get into their full-length wetsuit to explore for emerging trends.  Returning to the initial line graph, we'll ignore the grayscale contraints (at least at this stage) and consider every sensible dimension to explore this potentially multivariate dataset.

Because the lines are thick and opaque, it's difficult to determine what the yellow lines look like underneath the purple.  Consequently, we'll lighten the lines by narrowing them, and decreasing it's opacity (which is specified by the color's "alpha" channel in most types of software).  Next, we'll choose a palette whose colors are balanced, so the faint peach is not overwhelmed by the dark red. (Footnote: This is not a straw-man; the peach/red color scheme has been repeated used by a group of adult male statisticians.  This palette also includes lime green and bright pink.)  The resulting graph reveals that the Tx subjects apparently are not monolithic; at Time 3, some appear to go high, while others dip and then recover.  

![plot of chunk BackToSubjects](FigureRmd/BackToSubjects1.png) ![plot of chunk BackToSubjects](FigureRmd/BackToSubjects2.png) ![plot of chunk BackToSubjects](FigureRmd/BackToSubjects3.png) 

After introspection and investigation, we sift through some collected variables and find a subject's eye color interacts with the Tx protocol, but not the control protocol.

Notice this intra-group trend are impossible to detect with graphical methods that summarize across subjects.  A "spaghetti plot" like this is an important tool in the social and behavioral sciences where inter-individual differences frequently hold considerable explanatory power.  Likewise, running most confirmatory modeling approaches (like a repeated measures ANOVA or a multi-level model) is very unlikely to have suggested the pattern.  This single pattern (among many possible patterns) is fairly detectable using an appropriate graph, but would have required experiementing with several covariates and polynomial terms.

![plot of chunk TwoGroupInteraction](FigureRmd/TwoGroupInteraction.png) 

Regardless if confirmatory analyses are later run, we usually overlay the data with some type of model or smoother.  One benefit is that the model might usefully indicate trends that would be difficult to detect.  Another benefit revealing discrepancies between your model and data, and possibly suggesting superior alternatives.  In the first graph below, regular linear regressions are fit for each group across time; it inadequately describes the large dipping and recovery of 'TxBrown' group.  Nonlinear summaries such as loess and GAM are easily overlayed in `ggplot2`  In the second graph, loess curves trace each group over time, and appear to capture the relevant features.

![plot of chunk OverlayModel](FigureRmd/OverlayModel1.png) ![plot of chunk OverlayModel](FigureRmd/OverlayModel2.png) 

After we're satisfied that the important features are revealed, we tidy the graph to further enunciate the patterns and remove or deemphasize the unnecessary elements.  First, the differences between the control groups appear inconsequential, and we believe we can present a more coherent case to readers if 'ControlGreen' and 'ControlBrown' were reunited.  Second, the loess standard errors are so tight that we feel the mean model prediction is unnecessary, and the error bands are sufficient descriptive.  Third, we remove the "Year" and "Group" labels because we feel they are self-explanatory, especially given their values (e.g., 2011-2015); this removes unnecessary words and space in the margin, which can be dedicated to the data.  Fourth, similar motivations suggest removing the legend from the right margin (which allows the plotting area to widen) and moving it into some unused space in the panel.  Finally, the margin text is lightened, so that it competes less from the data (see "data-to-ink" ratio discussed below).

![plot of chunk Tidy](FigureRmd/Tidy1.png) ![plot of chunk Tidy](FigureRmd/Tidy2.png) 

We conclude this section by applying these tweaks to the previous peach and red bar graph, and see what can be redeemed.  Even though a bar graph could not have detected the intra-group differences, after the trend and variables were identified with the spaghetti plot, possibly it is acceptable to summarize to outsiders.  After looking at this figure, we still believe the bar graph is inferior for two primary reasons.  The first reason is that the group trends require more effort to understand.  For instance, the dip and recovery of TxBrown takes effort to notice when it's mixed among the other bars; however the same trend is instantly recognizable in the line graph.  Furthermore, accurately determining simple patterns are much more difficult; the almost perfectly constant growth of the green and purple groups is detectable in the line graph, but muddled in the bar graph.

The second reason demonstrates how GDA can complement CDA.  This (data+model) line graph allows readers to decide for themselves if the model resembles the observed data.  The reader can see how most subjects follow their group's longitudinal nonlinear trend (unlike the linear model a few graphs ago).  Judging discrepancies like this are almost impossible with the bar graph, even if it includes error bars.

Not only is the grapher not being transparent, they're reducing the opportunity for the reader to make their own judgement and gain insight that migth not have occurred to them. {Joe, do you want to say anything about inductive progress?}

![plot of chunk TweakBar](FigureRmd/TweakBar.png) 

## --Session Info--

```
Report created by wibeasley at Wed 23 Jul 2014 01:57:01 AM EDT, -0400
```

```
R version 3.1.1 (2014-07-10)
Platform: x86_64-pc-linux-gnu (64-bit)

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8   
 [6] LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] grid      stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_1.0.0      mgcv_1.8-1         nlme_3.1-117       gridExtra_0.9.1    RColorBrewer_1.0-5 scales_0.2.4       plyr_1.8.1        
[8] knitr_1.6         

loaded via a namespace (and not attached):
 [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.5   formatR_0.10     gtable_0.1.2     labeling_0.2     lattice_0.20-29  MASS_7.3-33     
 [9] Matrix_1.1-4     munsell_0.4.2    proto_0.3-10     Rcpp_0.11.2      reshape2_1.4     stringr_0.6.2    tools_3.1.1     
```
