#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

############################
## @knitr LoadPackages
require(plyr, quietly=TRUE)
require(ggplot2, quietly=TRUE)

############################
## @knitr DeclareGlobals
pathOutput <- "./Data/Derived/Longitudinal1.csv"

subjectsPerGroupV2Count <- 50
timePoints <- 1:5
groups <- c("ControlGreen", "ControlBrown", "TxGreen", "TxBrown")

intercept <- 8
timeOffsets <- c(0, 1, 2, 3, 4)
timeTxGreenOffsets <- c(0, 1, 2.4, 3, 4)
timeTxBrownOffsets <- c(1, -1, -4, -1, 7)
timeControlBrownOffsets <- c(0, 0, 0, -.5, -1)
timeVariances <- c(2, 1.5, 1, 1.3, 1)

############################
## @knitr LoadData

############################
## @knitr TweakData

############################
## @knitr Generate
set.seed(63) #To keep numbers & graphs consistent across generations
ds <- base::expand.grid(GroupV2=groups, TimePoint=timePoints, SubjectIndex=seq_len(subjectsPerGroupV2Count), stringsAsFactors=TRUE)
ds$SubjectTag <- sprintf("%s-%03d", ds$GroupV2, ds$SubjectIndex) #This is a unique identifier

ds <- ds[order(ds$SubjectTag, ds$TimePoint), ]
ds$Group <- plyr::revalue(ds$GroupV2, replace=c("ControlGreen"="Control", "ControlBrown"="Control", "TxGreen"="Tx", "TxBrown"="Tx"))
ds$GroupV3 <- plyr::revalue(ds$GroupV2, replace=c("ControlGreen"="Control", "ControlBrown"="Control"))
ds$TxGreen <- (ds$GroupV2 == "TxGreen")
ds$TxBrown <- (ds$GroupV2 == "TxBrown")
ds$ControlBrownOffsets <- (ds$GroupV2 == "ControlBrown")
ds$YHat <- intercept + 
  timeOffsets[ds$TimePoint] + 
  (timeTxGreenOffsets[ds$TimePoint]*ds$TxGreen) + 
  (timeTxBrownOffsets[ds$TimePoint]*ds$TxBrown) +
  (timeControlBrownOffsets[ds$TimePoint]*ds$ControlBrownOffsets)

ds$Y <- rnorm(n=nrow(ds), mean=ds$YHat, sd=timeVariances[ds$TimePoint])
ds$Year <- 2010 + ds$TimePoint

write.csv(ds, file=pathOutput, row.names=F)

ds <- ds[sample(nrow(ds),replace=FALSE), ]
ggplot(ds, aes(x=TimePoint, y=Y, color=Group, group=SubjectTag)) +
  geom_line()

ggplot(ds, aes(x=TimePoint, y=Y, color=GroupV2, group=SubjectTag)) +
  geom_line()
