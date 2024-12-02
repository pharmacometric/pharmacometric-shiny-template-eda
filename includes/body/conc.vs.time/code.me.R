############################################################################
############################################################################
##  Document Path: code.R
##
##  Author: W.H
##
##  Date: 2024-12-01
##
##  Title: Concentration vs. Time
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
###  SECTION:
#############################################################################

{LIBRARIES}

{CONSOLECLEAR}


#############################################################################
###  SECTION: Data, relevant paths and functions
#############################################################################

edaData = {DATAFILE}
edaDataV1 = {DATAFILEV2}
edaDataV2 = {DATAFILEV3}
storePath = {STORAGEPATH}
ggplotTheme = {GGPLTHEME}
depVar = {DVVAR}
timeVar = {TYMEVAR}
colorVar = {COLOURVAR}
treatVar = {TRTVAR}


#############################################################################
###  SECTION: Create concentration vs time plot
#############################################################################

plot.data <- GLOBAL$data.versions[[input$datatoUseconc1]]
if (!length(plot.data) | is.null(plot.data)) {
  return(sampleplot())
}
if (nrow(plot.data)) {
  if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--", names(plot.data)))) {
    updateGraphStatus2()
    plot.data$.dv <- as.numeric(plot.data[[input$depvar1]])
    plot.data$.tm <- as.numeric(plot.data[[input$indepvar]])
    plot.data$.id <- as.numeric(plot.data[[input$idvar]])
    plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %ifnon% as.factor(plot.data$.id)
    plot.data$.ttr <- as.factor(plot.data[[input$cfacetvar]])
    plot.data$.none <- "x"


    # get data type based on selection
    datatoplot0 <- plot.data %>% filter(not.na(.dv) & .dv > 0)
    datatoplot <- datatoplot0
    if (input$cgraphtype == 3) {
      datatoplot <- data_summarised_overall(datatoplot)
    }
    if (input$cgraphtype == 6) {
      datatoplot <- data_summarised_facet(datatoplot)
    }

    if (input$cgraphtype %in% c(3, 6) & input$graphsummtype %in% 1:3) {
      datatoplot <- datatoplot %>% rename(.dv = dv_mean)
    }

    if (input$cgraphtype %in% c(3, 6) & input$graphsummtype %in% 4:6) {
      datatoplot <- datatoplot %>% rename(.dv = dv_med)
    }


    # global plot out
    gplotout <- ggplot(datatoplot, aes(.tm, .dv, color = .colv)) +
      guides(color = guide_legend(ncol = input$ncollegend)) +
      labs(x = input$labelx, y = input$labely, color = "") +
      theme_bw() +
      styler00 +
      styler03 +
      theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))

    # add scatter if plotting median or mean alone
    if (input$cgraphtype %in% c(3, 6) & input$graphsummtype %in% c(1, 4)) {
      gplotout <- gplotout + geom_point(data = datatoplot0)
    } #+
    # scale_color_manual(values = rep("black",length(unique(datatoplot0$.id)))) +
    # theme(legend.position = "none")


    # add ribbon if plotting med +/- confident interval

    # if color variable is specified
    if (input$colvar3 == "--" | input$cgraphtype %in% c(1, 4, 7, 8)) {
      gplotout <- gplotout + scale_color_manual(values = rep("black", length(unique(datatoplot$.id)))) +
        theme(legend.position = "none")
    }

    # if spaghetti is specified
    if (input$cgraphtype %in% c(1, 4, 7)) {
      gplotout <- gplotout + geom_point() + geom_line()
    }

    # if scatter is specified
    if (input$cgraphtype %in% c(2, 5, 8)) {
      gplotout <- gplotout + geom_point()
    }

    # if summary is specified
    if (input$cgraphtype %in% c(3, 6)) {
      gplotout <- gplotout + geom_line()
    }

    # facet if it is specified
    if (input$cgraphtype %in% 4:6) {
      gplotout <- gplotout + facet_wrap(. ~ .ttr, ncol = input$graphcolnum)
    }

    # inidividual if it is specified
    if (input$cgraphtype %in% 7:8) {
      gplotout <- gplotout + facet_wrap(. ~ .id, ncol = input$graphcolnum)
    }

    # add semi log if it is specified
    if (input$loglinear == "Semi-Log") {
      gplotout <- gplotout + scale_y_log10()
    }

    print(gplotout)
    ggsave(fAddDate(storePath,"/eda_conc_vs_time_v1.png"))
  }

}


#############################################################################
###  SECTION: Print session information and clear environmet
#############################################################################

sessionInfo()
clean(clearPkgs = 1)
