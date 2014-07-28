#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

############################
## @knitr LoadPackages
require(plyr, quietly=TRUE)
require(scales, quietly=TRUE)
require(RColorBrewer, quietly=TRUE)
require(grid, quietly=TRUE)
require(gridExtra, quietly=TRUE)
# require(mgcv, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(lme4, quietly=TRUE)
require(arm, quietly=TRUE)

############################
## @knitr DeclareGlobals
pathInput <- "./Data/Derived/Longitudinal1.csv"

badDefaultSize <- 20
annotateCornerX <- 2014.9
#palette1Dark <- RColorBrewer::brewer.pal(n=6, name="Set1")[c(6,4)]; names(palette1Dark) <- c("Tx", "Control")
palette1Dark <- c("#F6B443", "#AF0000"); names(palette1Dark) <- c("Tx", "Control")
palette1Light <- adjustcolor(palette1Dark, alpha.f=.2); names(palette1Light) <- c("Tx", "Control")

palette2Dark <- RColorBrewer::brewer.pal(n=3, name="Set1")[2:1]; names(palette2Dark) <- c("Tx", "Control")
palette2Light <- adjustcolor(palette2Dark, alpha.f=.2); names(palette2Light) <- c("Tx", "Control")

palette3Dark <- RColorBrewer::brewer.pal(n=4, name="Dark2")[c(1,2,4,3)]; names(palette3Dark) <- c("TxGreen", "TxBrown", "ControlGreen", "ControlBrown")
palette3Light <- adjustcolor(palette3Dark, alpha.f=.4); names(palette3Light) <- c("TxGreen", "TxBrown", "ControlGreen", "ControlBrown")

palette4Dark <- RColorBrewer::brewer.pal(n=4, name="Dark2"); names(palette4Dark) <- c("TxGreen", "TxBrown", "Control")
palette4Light <- adjustcolor(palette4Dark, alpha.f=.4); names(palette4Light) <- c("TxGreen", "TxBrown", "Control")

reportTheme <- theme_bw() +
  theme(legend.text=element_text(color="gray40")) +
  theme(axis.text = element_text(colour="gray40")) +
  theme(axis.title = element_text(colour="gray40")) +
  theme(axis.ticks.length = grid::unit(0, "cm")) +
  theme(panel.border = element_rect(colour="gray80"))

############################
## @knitr LoadData
ds <- read.csv(pathInput, stringsAsFactors=F)

############################
## @knitr TweakData
yRange <- c(.5, max(ds$Y, na.rm=T)*1.04) #This forces a common y range when we add and remove elements later in the section.
ds$TimePointSq <- ds$TimePoint^2
ds$TimePointF <- factor(ds$TimePoint, ordered=F)
ds$SubjectTag <- factor(ds$SubjectTag)

############################
## @knitr OverplottedGrayscale
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, shape=Group, linetype=Group)) +
#   geom_point() +
  geom_line(size=2) +
  scale_linetype_manual(values=c("F1","11")) +
  theme_bw(base_size=badDefaultSize) +
  guides(linetype=guide_legend(keywidth=2))

############################
## @knitr Oversimplified
grid.arrange(
  ggplot(ds, aes(x=Year, y=Y)) +
    geom_bar(stat="summary", fun.y="mean", color=NA) +
    theme_bw(base_size=badDefaultSize),
  ggplot(ds, aes(x=Group, y=Y, fill=Group)) +
    geom_bar(stat="summary", fun.y="mean", color=NA) +
    scale_fill_manual(values=palette1Dark) +
    theme_bw(base_size=badDefaultSize) +
    theme(legend.position="none")
    # layout=grid.layout(ncol=2, widths=grid::unit(c(2,1), units=c("null", "null")))
)

ggplot(ds, aes(x=Year, y=Y, fill=Group)) +
  geom_bar(stat="summary", fun.y="mean", position="dodge", color=NA) +
  scale_fill_manual(values=palette1Dark) +
  theme_bw(base_size=badDefaultSize)

# ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
#   geom_boxplot(aes(group=c(Year))) +
#   scale_color_manual(values=palette1Dark) +
#   scale_fill_manual(values=palette1Light) +
#   reportTheme

##################
## @knitr BackToSubjects
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(data=ds[ds$Group=="Tx", ], size=2, color=palette1Dark[1]) +
  geom_line(data=ds[ds$Group=="Control", ], size=2, color=palette1Dark[2]) +
  #   scale_color_manual(values=c("ZControl"="blue", "Tx"="red")) +
  theme_bw()

ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(data=ds[ds$Group=="Tx", ], alpha=.2, color=palette1Dark[1]) +
  geom_line(data=ds[ds$Group=="Control", ], alpha=.2, color=palette1Dark[2]) +
  theme_bw()

ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(alpha=.2) +
  scale_color_manual(values=palette2Dark) +
  theme_bw() +
  guides(colour=guide_legend(override.aes=list(size=3, alpha=1)))

##################
## @knitr TwoGroupInteraction
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.2) +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw() +
  guides(colour=guide_legend(override.aes=list(size=3, alpha=1)))

##################
## @knitr OverlayModel
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.2) +
  geom_smooth(aes(group=GroupV2), method="lm", size=2, linetype="D3") +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw()

ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.2) +
  geom_smooth(aes(group=GroupV2), method="loess", size=2, linetype="D3") +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw()

# ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
#   geom_line(alpha=.4) +
#   geom_smooth(aes(group=GroupV2), method="gam", formula=y~s(x, k=4), size=3, linetype="D3") +
#   scale_color_manual(values=palette3Dark) +
#   scale_fill_manual(values=palette3Light) +
#   theme_bw()

##################
## @knitr Tidy
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
  geom_line(alpha=.3) +
  geom_smooth(aes(group=GroupV3), method="loess", size=2, linetype="D3") +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  theme_bw() +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1))

#TODO: arrange the legend to correspond roughly with the graph's order (ie, green, purple, & brown).
#TODO: spell out 'TxGreen' and 'TxBrown' in the legend.
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
  geom_line(alpha=.2) +
  geom_smooth(aes(group=GroupV3), method="loess", size=0, alpha=.5) +
  annotate("text", x=annotateCornerX, y=-Inf, label="(Our preferred color version)", vjust=-.5, hjust=1, color="gray40") +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(colour=guide_legend(override.aes=list(size=3, alpha=.7))) +
  labs(x=NULL, y="Response", color=NULL, fill=NULL)

##################
## @knitr TweakBar
ggplot(ds, aes(x=Year, y=Y, color=GroupV3, fill=GroupV3)) +
  geom_bar(stat="summary", fun.y="mean", position="dodge") +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  coord_cartesian(ylim=c(0, 22)) +
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  labs(x=NULL, y="Response", color=NULL, fill=NULL)

# dsSummarized <- plyr::ddply(ds, .variables=c("Year", "GroupV3"), summarize,
#                             Mean = mean(Y, na.rm=T),
#                             SE = sd(Y, na.rm=T) / sqrt(sum(!is.na(Y))),
#                             Lower = Mean - SE,
#                             Upper = Mean + SE
# )
# 
# ggplot(dsSummarized, aes(x=Year, y=Mean, ymin=Lower, ymax=Upper, color=GroupV3, fill=GroupV3)) +
#   geom_bar(stat="summary", fun.y="mean", position="dodge") +
#   geom_errorbar(position="dodge") +
#   scale_color_manual(values=palette4Dark) +
#   scale_fill_manual(values=palette4Light) +
#   coord_cartesian(ylim=c(0, 22)) +
#   reportTheme +
#   theme(legend.position=c(.5, 1), legend.justification=c(.5, 1)) +
#   labs(x="Time", y="Response", color=NULL, fill=NULL)

##################
## @knitr ThinnedGrayscale
ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, linetype=GroupV3)) +
  geom_line(alpha=.2, color="gray40") +
  geom_smooth(aes(group=GroupV3), method="loess", color="gray10", alpha=.5) +
  annotate("text", x=annotateCornerX, y=-Inf, label="(Our preferred grayscale version)", vjust=-.5, hjust=1, color="gray40") +
  scale_linetype_manual(values=c("FF", "55", "22")) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(linetype=guide_legend(override.aes=list(alpha=.7), keywidth=5)) +
  labs(x=NULL, y="Response", linetype=NULL)

ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, linetype=GroupV3)) +
  geom_smooth(aes(group=GroupV3), method="loess", color="gray10", alpha=.5) +
  scale_linetype_manual(values=c("FF", "55", "22")) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(linetype=guide_legend(override.aes=list(alpha=.7), keywidth=5)) +
  labs(x=NULL, y="Response", linetype=NULL)

ggplot(ds, aes(x=Year, y=YAlternate, group=SubjectTag, linetype=GroupV3)) +
  geom_smooth(aes(group=GroupV3), method="loess", color="gray10", alpha=.5) +
  annotate("text", x=annotateCornerX, y=-Inf, label="(Alternate Data)", vjust=-.5, hjust=1, color="gray40") +
  scale_linetype_manual(values=c("FF", "55", "22")) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +  
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(linetype=guide_legend(override.aes=list(alpha=.7), keywidth=5)) +
  labs(x=NULL, y="Response", linetype=NULL)

ggplot(ds, aes(x=Year, y=YAlternate, group=SubjectTag, linetype=GroupV3)) +
  geom_line(alpha=.2, color="gray40") +
  geom_smooth(aes(group=GroupV3), method="loess", color="gray10", alpha=.5) +
  annotate("text", x=annotateCornerX, y=-Inf, label="(Alternate Data)", vjust=-.5, hjust=1, color="gray40") +
  scale_linetype_manual(values=c("FF", "55", "22")) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +  
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(linetype=guide_legend(override.aes=list(alpha=.7), keywidth=5)) +
  labs(x=NULL, y="Response", linetype=NULL)

ggplot(ds, aes(x=Year, y=YAlternate, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
  geom_line(alpha=.2) +
  geom_smooth(aes(group=GroupV3), method="loess", size=0, linetype="D3", alpha=.5) +
  annotate("text", x=annotateCornerX, y=-Inf, label="(Alternate Data)", vjust=-.5, hjust=1, color="gray40") +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +
  reportTheme +
  theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
  guides(colour=guide_legend(override.aes=list(size=3, alpha=.7))) +
  labs(x=NULL, y="Response", color=NULL, fill=NULL)

##################
## @knitr Mlm
# fitLinear <- lmer(Y ~ 1 + GroupV3*TimePoint + (1|SubjectTag), data=ds)
# summary(fitLinear)

fitQuadratic <- lmer(Y ~ 1 + GroupV3*TimePoint + GroupV3*TimePointSq + (1|SubjectTag), data=ds)
# summary(fitQuadratic)
arm::extractDIC(fitQuadratic)
stats::extractAIC(fitQuadratic)
arm::se.fixef(fitCategorical)

fitCategorical <- lmer(Y ~ 1 + GroupV3*TimePointF + (1|SubjectTag), data=ds)
# summary(fitCategorical)
stats::extractAIC(fitCategorical)
arm::se.fixef(fitCategorical)

dsPredict <- base::expand.grid(GroupV3=unique(ds$GroupV3), TimePoint=unique(ds$TimePoint))
dsPredict$TimePointSq <- dsPredict$TimePoint^2
dsPredict$YHat <- lme4:::predict.merMod(fitQuadratic, newdata=dsPredict, re.form=NA)

# p <- profile(fitCategorical)
# p$.par
# 
# lme4:::xyplot.thpr(p)
# lattice::xyplot(profile(fitQuadratic))

# dsForitified <- fortify.merMod(fitQuadratic)
# 
# 
# 
# ggplot(ds, aes(x=Year, y=Y, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
#   geom_line(alpha=.2) +
#   scale_color_manual(values=palette4Dark) +
#   scale_fill_manual(values=palette4Light) +
#   coord_cartesian(xlim=c(2011, 2015), ylim=yRange) +
#   reportTheme +
#   theme(legend.position=c(0, 1), legend.justification=c(0, 1)) +
#   guides(colour=guide_legend(override.aes=list(size=3, alpha=.7))) +
#   labs(x=NULL, y="Response", color=NULL, fill=NULL)
