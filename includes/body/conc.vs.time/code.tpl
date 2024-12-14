################################################################################################
################################################################################################
##  Document Path: code.R
##
##  Author: W.H
##
##  Date: {TDATE}
##
##  Title: Concentration ({DVVAR}) vs. {TYMEVAR0} ({TYMEVAR})
##
##  Description: Generate exploratory plot for observed concentration over {TYMEVAR0}
##
##
##  Required Files: {DATAFILE}
##
##  Exported Files: eda_{GRAPHTYPE1}_{GRAPHTYPE2}_{GRAPHTYPE3}_conc_vs_time_v1*.png
##
##  Software: {RVERS}
##
#################################################################################################
#################################################################################################
###  SECTION: Clear environment and load libraries
#################################################################################################

quickcode::clean(setwd = "{STORAGEPATH}", clearPkgs = 1L) #clear environment, old code cleanup, set dir

libs = {LIBRARIES} #core libraries
invisible(lapply(libs, function(l)library(l,character.only=1L, quietly = 1L))) #import libraries

#################################################################################################
###  SECTION: Data, relevant paths and functions
#################################################################################################

edaData = read.csv(file = "{DATAFILE}",header = 1L)
storePath = "{STORAGEPATH}"
{LSUMMARISEPLOT}data_summarised_facet = function(dataa){
{LSUMMARISEPLOT}  dataa %>%
{LSUMMARISEPLOT}  group_by({FACETVAR}, {TYMEVAR}) %>%
{LSUMMARISEPLOT}    reframe(
{LSUMMARISEPLOT}      {COLORVAR} = unique({COLORVAR})[1],
{LSUMMARISEPLOT}      {LDVMEAN}{DVVAR} = mean({DVVAR}),
{LSUMMARISEPLOT}      {LDVMEDIAN}{DVVAR} = median({DVVAR}),
{LSUMMARISEPLOT}      {LDVMEAN}sd = sd({DVVAR}),
{LSUMMARISEPLOT}      {LDVMEAN}sem = sd({DVVAR})/sqrt(length(({DVVAR}))),
{LSUMMARISEPLOT}      {LDVMEDIAN}q95 = quantile({DVVAR},probs = 0.95),
{LSUMMARISEPLOT}      {LDVMEDIAN}q05 = quantile({DVVAR},probs = 0.05),
{LSUMMARISEPLOT}      {LDVMEDIAN}q975 = quantile({DVVAR},probs = 0.975),
{LSUMMARISEPLOT}      {LDVMEDIAN}q025 = quantile({DVVAR},probs = 0.025)
{LSUMMARISEPLOT} )
{LSUMMARISEPLOT}}

#################################################################################################
###  SECTION: Create concentration vs time plot
#################################################################################################

# Dataset for plot
plot.data = edaData %>% filter({CHOSENDATA})
dTPlot = dTPlot0 = plot.data %>%
filter(not.na({DVVAR}), {DVVAR} > 0, {DVVAR} != ".") %>%
{LNOTSUMMARISEPLOT}mutate({DVVAR} = as.numeric({DVVAR}),{COLORVAR} = as.factor({COLORVAR}))
{LSUMMARISEPLOT}mutate({DVVAR} = as.numeric({DVVAR}),{SUMMVAR} = as.factor({SUMMVAR}))
{LINDVPLOT}mutate({DVVAR} = as.numeric({DVVAR}),{IDVAR} = as.factor({IDVAR}))

# Declare color variable
{LNOTSUMMARISEPLOT}colorBy = "{COLORVAR}"
{LSUMMARISEPLOT}colorBy = "{SUMMVAR}"
{LINDVPLOT}colorBy = "{IDVAR}"

# ERROR handler to ensure data has rows
if (!nrow(plot.data)) stop("The plot data does not have data rows.")

{LSUMMARISEPLOT}# Summarize data based on {SUMMVAR}
{LSUMMARISEPLOT}dTPlot = data_summarised_facet(dTPlot)
# Plot final data
gplotout = ggplot(data = dTPlot, aes(x = {TYMEVAR}, y = {DVVAR})) +
aes_string(color = colorBy) +
guides(color = guide_legend(ncol = {LEGENDCOLNUM})) +
labs(x = "{ILABELX}", y = "{ILABELY}", color = "") +
{LSUMMARISEPLOT}{LMEANMEDIANALONE}geom_point(data = dTPlot0) +
{LREMOVECOLORVAR}scale_color_manual(values = rep("black", length(unique(dTPlot${IDVAR})))) + theme(legend.position = "none") +
{LSPAGHETTIPLOT}geom_point() + geom_line() +
{LSCATTERPLOT}geom_point() +
{LSUMMARYPLOT}geom_line() +
{LNOTSUMMARISEPLOT}{LNOTMEANMEDIANALONE}geom_point(aes(color={COLORVAR})) +
{LSUMMARISEPLOT}{LNOTMEANMEDIANALONE}geom_point(aes(color={SUMMVAR})) +
{LNOTSUMMARISEPLOT}{LFACETPLOT}facet_wrap(. ~ {FACETVAR}, ncol = {FACETCOLNUM}) +
{LINDVPLOT}facet_wrap(. ~ {IDVAR}, ncol = {FACETCOLNUM}) +
{LSUMMARISEPLOT}{LFACETPLOTSUMM}facet_wrap(. ~ {SUMMVAR}, ncol = {FACETCOLNUM}) +
{LSUMMARYPLOTA}geom_errorbar(aes(ymin={DVVAR}-sd, ymax={DVVAR}+sd, color = {FACETVAR}), position=position_dodge(0.05)) + #sd error bars
{LSUMMARYPLOTB}geom_errorbar(aes(ymin={DVVAR}-sem, ymax={DVVAR}+sem, color = {FACETVAR}), position=position_dodge(0.05)) + #sem error bars
{LSUMMARYPLOTC}geom_ribbon(aes(ymin=q05, ymax=q95, color = {FACETVAR}, fill = {FACETVAR}), alpha=0.1, linetype = "dotted")+ guides(fill = "none") + #ribbon for 90%CI
{LSUMMARYPLOTD}geom_ribbon(aes(ymin=q025, ymax=q975, color = {FACETVAR}, fill = {FACETVAR}), alpha=0.1, linetype = "dotted")+ guides(fill = "none") + #ribbon for 95%CI
{LSEMILOGPLOT}scale_y_log10() + #make plot semi-log
theme_bw() + #initial theme set
theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.y = element_text(face = "bold", vjust = 2),
        axis.title.x = element_text(vjust = -0.2),
        panel.background = element_rect(colour = "#333333"),
        plot.background = element_rect(colour = NA),
        panel.border = element_rect(colour = NA),
        axis.line.x = element_line(colour = "black"),
        axis.line.y = element_line(colour = "black"),
        text = element_text(family = "{TEXTFONT}"),
        axis.text = element_text(size = {FONTTICKSIZE}, family = "{TEXTFONT}"),
        axis.title = element_text(face = "bold", size = {FONTXYSIZE}, family = "{TEXTFONT}"),
        strip.text = element_text(face = "bold", size = {FONTSTRIPSIZE}, family = "{TEXTFONT}"),
        plot.margin = unit(c(10, 5, 5, 5), "mm"),
        strip.background = element_rect(colour = "#000000", fill = "#f3f3f3", linewidth = rel(1.6)),
        {LNOTSPAGHETTIPLOT}legend.position = "{LEGENDPOS}",
        {LSPAGHETTIPLOT}legend.position = "none",
        legend.text = element_text(family = "{TEXTFONT}"),
        legend.title = element_text(family = "{TEXTFONT}"),
        title = element_text(family = "{TEXTFONT}"))
# Print plot
print(gplotout)
# Save printed plot
ggsave(fAddDate(storePath, "/eda_{GRAPHTYPE1}_{GRAPHTYPE2}_{GRAPHTYPE3}_conc_time_v1.png"), width = {IMAGEWIDTH}, height = {IMAGEHEIGHT}, dpi = {IMAGEDPI}, scale = {IMAGESCALE}, units = "px")



#################################################################################################
###  SECTION: Print session information and clear environment
#################################################################################################

sessionInfo()
clean(clearPkgs = 1L)
