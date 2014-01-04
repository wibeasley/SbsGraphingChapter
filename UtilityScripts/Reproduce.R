###################################
### Reproducible Research
###################################
# When executed by R, this file will manipulated the original data sources (Oklahoma vital statistics
# and US Census estimates) to produce a groomed dataset suitable for analysis and graphing.
# These derived datasets are then used in the graphs produced in the knitr report.

###
### Step 1: Verify the working directory has been set correctly.  Much of the code assumes the working directory is the repository's root directory.
###
if( base::basename(getwd()) != "SbsGraphingChapter" ) stop("The working directory should be set to the root of the package/repository.")

###
### Step 2: Install and update the packages used by this repository's code, if they're not already.
###
pathPackageDependencies <- "./UtilityScripts/PackageDependencies.R"
if( !file.exists(pathPackageDependencies) ) stop("The `PackageDependencies.R` file should be found in the `./UtilityScripts/` directory.")
base::source(file=pathPackageDependencies)

###
### Step 3: Clear memory from previous runs, and load the packages necessary for the `Reproduce.R` script.
###
rm(list=ls(all=TRUE))
require(base)
require(knitr)
require(markdown)
require(testit)

###
### Step 4: Manipulate the Raw datasets into something appropriate for the analyses.
###
# Assert that the working directory has been set properly initial datasets can be found.  The 
# testit::assert("The 10 census files from 199x should exist.", base::file.exists(base::paste0("./Datasets/Raw/STCH-icen199", 0:9, ".txt")))
# testit::assert("The 200x census file should exist.", base::file.exists("./Datasets/Raw/CO-EST00INT-AGESEX-5YR.csv"))

# Execute code that restructures the Census data
# base::source("./UtilityScripts/IsolateCensusPopsForGfr.R")

# Assert that the intermediate files exist (the two produced by `IsolateCensusPopsForGfr.R`)
# testit::assert("The yearly records should exist.", base::file.exists("./Datasets/Derived/CensusCountyYear.csv"))
# testit::assert("The monthly records should exist.", base::file.exists("./Datasets/Derived/CensusCountyMonth.csv"))

###
### Step 5: Build the reports
###
paths_report <- base::file.path("./Reports", c("Section1/Section1.Rmd"))
for( path_rmd in paths_report ) {
  path_md <- base::gsub(pattern=".Rmd$", replacement=".md", x=path_rmd)
  path_html <- base::gsub(pattern=".Rmd$", replacement=".html", x=path_rmd)
  knitr::knit(input=path_rmd, output=path_md)
  markdown::markdownToHTML(file=path_md, output=path_html)
}
