############################################################################
############################################################################
##  Document Path: code.R
##
##  Author: W.H
##
##  Date: {SCRIPTDATA}
##
##  Title: Concentration({DVVAR}) vs. Time ({TYMEVAR})
##
##  Description: Generate exploratory plot for observed concentration over
##               time
##
##  Required Files:
##
##  Exported Files: eda_conc_vs_time_v1.png
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################
###  SECTION: Clear environment and load libraries
#############################################################################

quickcode::clean(clearPkgs = 1L) #refresh console, clear environment

{LIBRARIES}
lapply(libs, function(l)library(l,character.only=1L)) #import libraries

#############################################################################
###  SECTION: Data, relevant paths and functions
#############################################################################

edaData = {DATAFILE}
edaDataV1 = {DATAFILEV2}
edaDataV2 = {DATAFILEV3}
storePath = {STORAGEPATH}
data_summarised_facet = function(dataa){
  dataa %>% filter(not.na({DVVAR})) %>% group_by({FACETVAR}, {TYMEVAR}) %>%
    reframe(
      {COLORVAR} = unique({COLORVAR})[1],
      dv_mean = mean({DVVAR}),
      dv_med = median({DVVAR}),
      sd = sd({DVVAR}),
      sem = sd({DVVAR})/sqrt(length(({DVVAR}))),
      q95 = quantile({DVVAR},probs = 0.95),
      q05 = quantile({DVVAR},probs = 0.05),
      q975 = quantile({DVVAR},probs = 0.975),
      q025 = quantile({DVVAR},probs = 0.025))
}

#############################################################################
###  SECTION: Create concentration vs time plot
#############################################################################

plot.data = {CHOSENDATA}
dTPlot = dTPlot0 = plot.data %>% filter(not.na({DVVAR}) & {DVVAR} > 0)

# ERROR handler to ensure data has rows
if (!nrow(plot.data)) stop("The plot data does not have data rows.")

{SUMMARISEPLOT}# Data summarized or unsummarized
{SUMMARISEPLOT}  dTPlot = data_summarised_facet(dTPlot)
# Plot final data
gplotout = ggplot(data = dTPlot, aes(x = {TYMEVAR}, y = {DVVAR}, color = {COLORVAR}))
+ guides(color = guide_legend(ncol = {LEGENDCOLNUM}))
+ labs(x = {ILABELX}, y = {ILABELY}, color = "")
{LMEANMEDIANALONE}  + geom_point(data = dTPlot0)
{LREMOVECOLORVAR}  + scale_color_manual(values = rep("black", length(unique(dTPlot${IDVAR})))) + theme(legend.position = "none")
{LSPAGHETTIPLOT}  + geom_point() + geom_line()
{LSCATTERPLOT}  + geom_point()
{LSUMMARYPLOT}  + geom_line()
{LNOTMEANMEDIANALONE}  + geom_point(aes(color=FACETCOLNUM))
{LFACETPLOT}  + facet_wrap(. ~ {FACETVAR}, ncol = {FACETCOLNUM})
{LSUMMARYPLOTA}  +geom_errorbar(aes(ymin={DVVAR}-sd, ymax={DVVAR}+sd, color = {FACETVAR}), position=position_dodge(0.05)) #sd error bars
{LSUMMARYPLOTB}  +geom_errorbar(aes(ymin={DVVAR}-sd, ymax={DVVAR}+sd, color = {FACETVAR}), position=position_dodge(0.05)) #sem error bars
{LSUMMARYPLOTC}  + geom_ribbon(aes(ymin=q05, ymax=q95, color = {FACETVAR}, fill = {FACETVAR}), alpha=0.1, linetype = "dotted")+ guides(fill = 'none') #ribbon for 90%CI
{LSUMMARYPLOTD}  + geom_ribbon(aes(ymin=q025, ymax=q975, color = {FACETVAR}, fill = {FACETVAR}), alpha=0.1, linetype = "dotted")+ guides(fill = 'none') #ribbon for 95%CI
{LSEMILOGPLOT}  + scale_y_log10()
+ theme_bw()
+ styler03
+ theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.y = element_text(face = "bold", vjust = 2),
        axis.title.x = element_text(vjust = -0.2),
        panel.background = element_rect(colour = "#333333"),
        plot.background = element_rect(colour = NA),
        panel.border = element_rect(colour = NA),
        axis.title = element_text(face = "bold", size = rel(1)),
        axis.line.x = element_line(colour = "black"),
        axis.line.y = element_line(colour = "black"),
        text = element_text(family = {TEXTFONT}),
        axis.text = element_text(size = {FONTTICKSIZE}, family = {TEXTFONT}),
        axis.title = element_text(size = {FONTXYSIZE}, family = {TEXTFONT}),
        strip.text = element_text(face = "bold", size = {FONTSTRIPSIZE}, family = {TEXTFONT}),
        plot.margin = unit(c(10, 5, 5, 5), "mm"),
        strip.background = element_rect(colour = "#000000", fill = "#f3f3f3", linewidth = rel(1.6)),
        legend.position = {LEGENDPOS},
        legend.text = element_text(family = {TEXTFONT}),
        legend.title = element_text(family = {TEXTFONT}),
        title = element_text(family = {TEXTFONT}))
# Print plot
print(gplotout)
# Save printed plot
ggsave(fAddDate(storePath, "/eda_{GRAPHTYPE1}{GRAPHTYPE2}{GRAPHTYPE3}_conc_time_v1.png"), width = {IMAGEWIDTH}, height = {IMAGEHEIGHT}, dpi = 300, units = "px")





#############################################################################
###  SECTION: Print session information and clear environment
#############################################################################

sessionInfo()
clean(clearPkgs = 1)
