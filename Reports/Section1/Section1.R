#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

############################
## @knitr LoadPackages
require(ggplot2, quietly=TRUE)
require(plyr, quietly=TRUE)
# require(reshape2, quietly=TRUE)

############################
## @knitr DeclareGlobalFunctions
osdhCentralCountyID <- 99
dateReportWindowStartForReferralInclusive <- as.Date("2007-01-01")
dateReportWindowStopForReferralExclusive <- as.Date("2012-11-30") 
reportingPeriodInYears <- (lubridate::as.period(dateReportWindowStopForReferralExclusive - dateReportWindowStartForReferralInclusive ))@year

pathCachedDataset <- "./PhiFreeDatasetsCache/C1/C1CountyMonth.rds"
pathReportDirectory <-  file.path(getwd(), "OsdhReports/C1ActivityAapc")
fileNameModel <- file.path(pathReportDirectory,"AapcTry.txt")
# fileNameModel <- file.path(pathReportDirectory, "AapcTryMinimal.txt")
pathBugsTempWorkingDirectory <- NULL #"./OsdhReports/C1ActivityAapc/BugsTemp" #Set this to a non NULL to peek inside

chainCount <- 4
iterationCount <- 1000 #The number used for estimate (ie, it doesn't include burn-in)
burninCount <- iterationCount / 2 #This quantity affects the adapation length (and hense time duration) of `jags.model`.

############################
## @knitr LoadDS
if( !file.exists(pathCachedDataset) ) stop(paste0("The file '", pathDirectoryCode, "' could not be found.  Check the path.  For this to work correctly, the 'MReporting.Rproj' needed to be opend in RStudio.  Otherwise the working directory would not be set correctly."))
ds <- readRDS(pathCachedDataset)
rm(pathCachedDataset)

############################
## @knitr TweakDS
ds <- ds[ds$CountyID != osdhCentralCountyID, ]
ds <- ds[dateReportWindowStartForReferralInclusive <= ds$Month & ds$Month < dateReportWindowStopForReferralExclusive, ]
ds$MonthsElapsed <- round(difftime(ds$Month, min(ds$Month, na.rm=T), units="days")/(365.25/12))

############################
## @knitr PrepareMcmc
ds$CountyIDF <- factor(ds$CountyID)
ds$CountyIDShifted <- as.numeric(ds$CountyIDF)
countyCount <- length(unique(ds$CountyIDShifted))
countInCounty <- ds$EnrollCount
proportionInCounty <- ds$EnrollPerNeed 

if( sum(proportionInCounty>1, na.rm=T) ) stop("There is at least one county with a proportion above 1.0.")

dataList <- list(
  recordCount = nrow(ds)
  , countInCounty = countInCounty
#   , proportionInCounty = ds$EnrollPerNeed
  , countyCount = countyCount
  , countyIDShifted = ds$CountyIDShifted
  , infantNeed = ds$InfantCount
  , monthsElapsed = ds$MonthsElapsed  
) # str(dataList)

# head(cbind(ds$EnrollCount, ds$InfantCount), 20)

inits <- function() { list(
  mu_b0 = rnorm(n=1, sd=10 ) # mean=mean(dv, na.rm=T), sd=4*sd(dv, na.rm=T))
#   mu_b0 = runif(n=1, min=min(countInCounty, na.rm=T), max=max(countInCounty, na.rm=T))
#   , b1 = rnorm(1)
#   , lambda = rnorm(countyCount)
)}
parametersToTrack <- c(
  "mu_b0"
  , "sigma_b0"
  , "b0"
  , "p0"
  , "b1"
)
parametersToGraph <- c(
  "mu_b0"
  , "sigma_b0"
#   , "b0"
  , "b1"
)

# curve(plogis(x), from=-5, to=5)
# curve(qlogis(x), from=0, to=1)
############################
## @knitr RunBugs
#CAUTION, THIS MODEL TAKES QUITE AWHILE TO CONVERGE; RUN THIS ONLY IF YOU WISH TO RECREATE/OVERWRITE PREVIOUSLY SAVED RESULTS

# startTime1 <- Sys.time()
# resultsBugs <- bugs(
#   data=dataList, inits=inits, parameters.to.save=parametersToTrack,
#   n.chains=chainCount, n.iter=iterationCount, n.burnin=burninCount,
#   model.file=fileNameModel, working.directory=pathBugsTempWorkingDirectory,
#   debug=T)
# 
# (bugsElapsed <- Sys.time() - startTime1)
# print(resultsBugs, digits=4)
# 
# # ARBCovlist[[1]] <- map.sim
# save(list=c("resultsBugs"), file=file.path(pathReportDirectory, "resultsBugs.RData"))

############################
## @knitr RunJags
#CAUTION, THIS MODEL TAKES QUITE AWHILE TO CONVERGE, RUN THIS ONLY IF YOU WISH TO RECREATE/OVERWRITE PREVIOUSLY SAVED RESULTS
rjags::load.module("dic") # load a few useful modules (JAGS is modular in design): https://sites.google.com/site/autocatalysis/bayesian-methods-using-jags

startTime1 <- Sys.time()
modelJags <- jags.model(file=fileNameModel, data=dataList, inits=inits, n.chains=chainCount, n.adapt=burninCount)

# (dicJags <- dic.samples(modelJags, n.iter=iterationCount) )
chainsJags <- coda.samples(modelJags, variable.names=parametersToTrack, n.iter=iterationCount)
(jagsElapsed <- Sys.time() - startTime1)

ggResults <- ggmcmc::ggs(chainsJags)
# save(list=c("modelJags", "dicJags", "chainsJags", "ggResults"), file=file.path(pathReportDirectory, "resultsJags.RData"))
save(list=c("modelJags", "chainsJags", "ggResults"), file=file.path(pathReportDirectory, "resultsJags.RData"))
(condensed <- summary(chainsJags))

cat("R-Hat:\n")
gelman.diag(chainsJags, autoburnin=FALSE) #This is R-hat; the burnin period is manually specified above, so turn off the auto argument. 

cat("Effective Size:\n")
effectiveSize(chainsJags)

############################
## @knitr GraphJagsSelect
ggs_density(ggResults, family=paste(parametersToGraph, collapse="|")) + theme(legend.position=c(1, 1), legend.justification=c(1,1)) 
ggs_traceplot(ggResults, family=paste(parametersToGraph, collapse="|")) + theme(legend.position=c(0, 0), legend.justification=c(0,0)) 
ggs_running(ggResults, family=paste(parametersToGraph, collapse="|")) 
ggs_compare_partial(ggResults, family=paste(parametersToGraph, collapse="|"))
ggs_crosscorrelation(ggResults, family=paste(parametersToGraph, collapse="|"))

############################
## @knitr GraphJagsAll
ggs_Rhat(ggResults) 
ggs_geweke(ggResults)
ggs_caterpillar(ggResults)
ggs_crosscorrelation(ggResults) #Graph all the parameters first

# ggs_rocplot(ggResults, outcome = dv)
# Another feature of caterpillar plots is the possibility to plot two different models, and be able to easily compare between them. A list of two ggs() objects must be provided.
# ggs_caterpillar(list(A = ggs(s), B = ggs(s, par_labels = P)))

############################
## @knitr DisplayModels
cat(readLines(fileNameModel), sep="\n")
