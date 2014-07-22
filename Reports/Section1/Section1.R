#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

############################
## @knitr LoadPackages
require(plyr, quietly=TRUE)
require(scales, quietly=TRUE)
require(RColorBrewer, quietly=TRUE)
require(grid, quietly=TRUE)
require(gridExtra, quietly=TRUE)
require(ggplot2, quietly=TRUE)

############################
## @knitr DeclareGlobals
pathInput <- "./Data/Derived/Longitudinal1.csv"

badDefaultSize <- 20
palette1Dark <- RColorBrewer::brewer.pal(n=6, name="Set1")[c(6,4)]
palette1Light <- adjustcolor(palette1Dark, alpha.f=.2)

palette2Dark <- RColorBrewer::brewer.pal(n=3, name="Set1")[1:2]; names(palette2Dark) <- c("Tx", "Control")
palette2Light <- adjustcolor(palette2Dark, alpha.f=.2); names(palette2Light) <- c("Tx", "Control")

palette3Dark <- RColorBrewer::brewer.pal(n=4, name="Dark2")[c(1,2,4,3)]; names(palette3Dark) <- c("TxGreen", "TxBrown", "ControlGreen", "ControlBrown")
palette3Light <- adjustcolor(palette3Dark, alpha.f=.4); names(palette3Light) <- c("TxGreen", "TxBrown", "ControlGreen", "ControlBrown")

palette4Dark <- RColorBrewer::brewer.pal(n=4, name="Dark2"); names(palette4Dark) <- c("TxGreen", "TxBrown", "Control")
palette4Light <- adjustcolor(palette4Dark, alpha.f=.4); names(palette4Light) <- c("TxGreen", "TxBrown", "Control")

reportTheme <- theme_bw() +
  theme(legend.text=element_text(color="gray40")) +
  theme(axis.text = element_text(colour="gray40")) +
  theme(axis.title = element_text(colour="gray40")) +
  theme(panel.border = element_rect(colour="gray80")) +
  theme(axis.ticks = element_line(colour="gray80")) +
  theme(axis.ticks.length = grid::unit(0, "cm"))
############################
## @knitr LoadData
ds1 <- read.csv(pathInput, stringsAsFactors=F)
############################
## @knitr TweakData

############################
## @knitr OverplottedGrayscale
ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, shape=Group, linetype=Group)) +
  geom_point() +
  geom_line(size=2) +
  theme_bw(base_size=badDefaultSize)

############################
## @knitr Oversimplified
grid.arrange(
  ggplot(ds1, aes(x=TimePoint, y=Y)) +
    geom_bar(stat="summary", fun.y="mean", na.rm=T, color=NA) +
    theme_bw(base_size=badDefaultSize),
  ggplot(ds1, aes(x=Group, y=Y)) +
    geom_bar(stat="summary", fun.y="mean", na.rm=T, color=NA) +
    theme_bw(base_size=badDefaultSize)#,
    # layout=grid.layout(ncol=2, widths=grid::unit(c(2,1), units=c("null", "null")))
)

ggplot(ds1, aes(x=TimePoint, y=Y, fill=Group)) +
  geom_bar(stat="summary", fun.y="mean", position="dodge", na.rm=T, color=NA) +
  scale_fill_manual(values=palette1Light) +
  theme_bw(base_size=badDefaultSize)

# ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
#   geom_boxplot(aes(group=c(TimePoint))) +
#   scale_color_manual(values=palette1Dark) +
#   scale_fill_manual(values=palette1Light) +
#   reportTheme

##################
## @knitr BackToSubjects
ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(data=ds1[ds1$Group=="Tx", ], size=2, color=palette1Dark[1]) +
  geom_line(data=ds1[ds1$Group=="Control", ], size=2, color=palette1Dark[2]) +
  #   scale_color_manual(values=c("ZControl"="blue", "Tx"="red")) +
  theme_bw()

ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(data=ds1[ds1$Group=="Tx", ], alpha=.3, color=palette1Dark[1]) +
  geom_line(data=ds1[ds1$Group=="Control", ], alpha=.3, color=palette1Dark[2]) +
  theme_bw()

ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=Group, fill=Group)) +
  geom_line(alpha=.3) +
  scale_color_manual(values=palette2Dark) +
  theme_bw()

##################
## @knitr TwoGroupInteraction
ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.4) +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw()

##################
## @knitr OverlayModel
ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.4) +
  geom_smooth(aes(group=GroupV2), method="lm", size=3, size=3, linetype="D3") +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw()

ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV2, fill=GroupV2)) +
  geom_line(alpha=.4) +
  geom_smooth(aes(group=GroupV2), method="loess", size=3, linetype="D3") +
  scale_color_manual(values=palette3Dark) +
  scale_fill_manual(values=palette3Light) +
  theme_bw()

ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
  geom_line(alpha=.4) +
  geom_smooth(aes(group=GroupV3), method="loess", size=3, linetype="D3") +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  theme_bw() +
  theme(legend.position=c(.5, 1), legend.justification=c(.5, 1))

#TODO: arrange the legend to correspond roughly with the graph's order (ie, green, purple, & brown).
#TODO: spell out 'TxGreen' and 'TxBrown' in the legend.
ggplot(ds1, aes(x=TimePoint, y=Y, group=SubjectTag, color=GroupV3, fill=GroupV3)) +
  geom_line(alpha=.4) +
  geom_smooth(aes(group=GroupV3), method="loess", size=0, linetype="D3", alpha=.7) +
  scale_color_manual(values=palette4Dark) +
  scale_fill_manual(values=palette4Light) +
  reportTheme +
  theme(legend.position=c(.5, 1), legend.justification=c(.5, 1)) +
  labs(x="Time", y="Response", color=NULL, fill=NULL)



