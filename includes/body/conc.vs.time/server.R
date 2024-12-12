############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/server.R
##
##  Description: Server function for concentration versus time plots
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
##
##  Plot types(input$cgraphtype)
##  "overall - spaghetti plot" = 1,
##  "overall - scatter plot" = 2,
##  "overall - summarised" = 3,
##  "facet - spaghetti plot" = 4,
##  "facet - scatter plot" = 5,
##  "facet - summarised" = 6,
##  "individual - spaghetti plot" = 7,
##  "individual - scatter plot" = 8
##
##
##  Statistic (input$graphsummtype)
##  "Mean" = 1,
##  "Mean ± SD" = 2,
##  "Mean ± SEM" = 3,
##  "Median" = 4,
##  "Median ± 90% PI" = 5,
##  "Median ± 95% PI" = 6
##
#############################################################################
#############################################################################

# set data versions to use for plotting
updateSelectInput(session, "datatoUseconc1", choices = data.versions.names)
updateSelectInput(session, "datatoUseconc2", choices = data.versions.names)







# Time after first dose plot
output$concvtimeplot1 = renderPlot({
  plot.data = GLOBAL$data.versions[[input$datatoUseconc1]]
  if(!length(plot.data) | is.null(plot.data))return(sampleplot())
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--",names(plot.data)))) {
      updateGraphStatus2()
      plot.data$.dv = as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm = as.numeric(plot.data[[input$indepvar]])
      plot.data$.id = as.numeric(plot.data[[input$idvar]])
      plot.data$.colv = as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr = as.factor(plot.data[[input$cfacetvar]])
      plot.data$.summ = as.factor(plot.data[[input$summby]])


      # get data type based on selection
      datatoplot0 = plot.data %>% filter(not.na(.dv) & .dv > 0)
      datatoplot = datatoplot0
      if (input$cgraphtype == 3)
        datatoplot = data_summarised_overall(datatoplot)
      if (input$cgraphtype == 6)
        datatoplot = data_summarised_overall(datatoplot)

      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% 1:3)
        datatoplot = datatoplot %>% rename(.dv = dv_mean)

      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% 4:6)
        datatoplot = datatoplot %>% rename(.dv = dv_med)


      # global plot out
      gplotout = ggplot(datatoplot, aes(.tm, .dv, color = .colv))   +
        guides(color = guide_legend(ncol = input$ncollegend))+
        labs(x = input$labelx, y = input$labely, color = "")+
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))

      # add scatter if plotting median or mean alone
      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% c(1,4))
        gplotout = gplotout + geom_point(data = datatoplot0, aes(color = .summ)) #+


      # add ribbon if plotting med +/- confident interval

      # if color variable is specified
      if (input$colvar3 == "--" | input$cgraphtype %in% c(1,4,7,8)) {
        gplotout = gplotout + scale_color_manual(values = rep("black",length(unique(datatoplot$.id)))) +
          theme(legend.position = "none")
      }

      # if spaghetti is specified
      if (input$cgraphtype %in% c(1,4,7)) {
        gplotout = gplotout + geom_point() + geom_line()
      }

      # if scatter is specified
      if (input$cgraphtype %in% c(2,5,8)) {
        gplotout = gplotout + geom_point()
      }

      # if summary is specified
      if (input$cgraphtype %in% c(3,6)) {
        gplotout = gplotout + geom_line(aes(color=.summ))
      }

      # if median/mean with intervals specified
      if(input$graphsummtype %in% c(2,3,5,6)){
        gplotout = gplotout + geom_point(aes(color=.summ))
      }
      if(input$graphsummtype == 2){
        gplotout = gplotout +
          geom_errorbar(aes(ymin=.dv-sd, ymax=.dv+sd, color = .summ), position=position_dodge(0.05))
      }
      if(input$graphsummtype == 3){
        gplotout = gplotout +
          geom_errorbar(aes(ymin=.dv-sem, ymax=.dv+sem, color = .summ), position=position_dodge(0.05))
      }
      if(input$graphsummtype == 5){
        gplotout = gplotout +
          geom_ribbon(aes(ymin=q05, ymax=q95, color = .summ, fill = .summ), alpha=0.1, linetype = "dotted")+ guides(fill = 'none')
      }
      if(input$graphsummtype == 6){
        gplotout = gplotout +
          geom_ribbon(aes(ymin=q025, ymax=q975, color = .summ, fill = .summ), alpha=0.1, linetype = "dotted")+ guides(fill = 'none')
      }

      # facet if it is specified
      if (input$cgraphtype %in% 4:5) {
        gplotout = gplotout +facet_wrap(. ~ .ttr, ncol = input$graphcolnum)
      }
      if (input$cgraphtype == 6) {
        gplotout = gplotout +facet_wrap(. ~ .summ, ncol = input$graphcolnum)
      }

      # inidividual if it is specified
      if (input$cgraphtype %in% 7:8) {
        gplotout = gplotout +facet_wrap(. ~ .id, ncol = input$graphcolnum)
      }

      # add semi log if it is specified
      if (input$loglinear == "semi-log") {
        gplotout = gplotout + scale_y_log10()
      }

      GLOBAL$concvtimeplot1 = gplotout # for exports of ggplot object
      gplotout

    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})

# Time after last dose plot
output$concvtimeplot2 = renderPlot({
  plot.data = GLOBAL$data.versions[[input$datatoUseconc2]]
  if(!length(plot.data) | is.null(plot.data))return(sampleplot())
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar2, input$cfacetvar, input$colvar3) %in% c("--",names(plot.data)))) {
      updateGraphStatus2()
      plot.data$.dv = as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm = as.numeric(plot.data[[input$indepvar2]])
      plot.data$.id = as.numeric(plot.data[[input$idvar]])
      plot.data$.colv = as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr = as.factor(plot.data[[input$cfacetvar]])
      plot.data$.summ = as.factor(plot.data[[input$summby]])


      # get data type based on selection
      datatoplot0 = plot.data %>% filter(not.na(.dv) & .dv > 0)
      datatoplot = datatoplot0
      if (input$cgraphtype == 3)
        datatoplot = data_summarised_overall(datatoplot)
      if (input$cgraphtype == 6)
        datatoplot = data_summarised_facet(datatoplot)

      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% 1:3)
        datatoplot = datatoplot %>% rename(.dv = dv_mean)

      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% 4:6)
        datatoplot = datatoplot %>% rename(.dv = dv_med)


      # global plot out
      gplotout = ggplot(datatoplot, aes(.tm, .dv, color = .colv))   +
        guides(color = guide_legend(ncol = input$ncollegend))+
        labs(x = input$labelx, y = input$labely, color = "")+
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))

      # add scatter if plotting median or mean alone
      if(input$cgraphtype %in% c(3,6) & input$graphsummtype %in% c(1,4))
        gplotout = gplotout + geom_point(data = datatoplot0) #+
      #scale_color_manual(values = rep("black",length(unique(datatoplot0$.id)))) +
      #theme(legend.position = "none")


      # add ribbon if plotting med +/- confident interval

      # if color variable is specified
      if (input$colvar3 == "--" | input$cgraphtype %in% c(1,4,7,8)) {
        gplotout = gplotout + scale_color_manual(values = rep("black",length(unique(datatoplot$.id)))) +
          theme(legend.position = "none")
      }

      # if spaghetti is specified
      if (input$cgraphtype %in% c(1,4,7)) {
        gplotout = gplotout + geom_point() + geom_line()
      }

      # if scatter is specified
      if (input$cgraphtype %in% c(2,5,8)) {
        gplotout = gplotout + geom_point()
      }

      # if summary is specified
      if (input$cgraphtype %in% c(3,6)) {
        gplotout = gplotout + geom_line()
      }

      # if median/mean with intervals specified
      if(input$graphsummtype %in% c(2,3,5,6)){
        gplotout = gplotout + geom_point(aes(color=.summ))
      }
      if(input$graphsummtype == 2){
        gplotout = gplotout +
          geom_errorbar(aes(ymin=.dv-sd, ymax=.dv+sd, color = .summ), position=position_dodge(0.05))
      }
      if(input$graphsummtype == 3){
        gplotout = gplotout +
          geom_errorbar(aes(ymin=.dv-sem, ymax=.dv+sem, color = .summ), position=position_dodge(0.05))
      }
      if(input$graphsummtype == 5){
        gplotout = gplotout +
          geom_ribbon(aes(ymin=q05, ymax=q95, color = .summ, fill = .summ), alpha=0.1, linetype = "dotted")+ guides(fill = 'none')
      }
      if(input$graphsummtype == 6){
        gplotout = gplotout +
          geom_ribbon(aes(ymin=q025, ymax=q975, color = .summ, fill = .summ), alpha=0.1, linetype = "dotted")+ guides(fill = 'none')
      }

      # facet if it is specified
      if (input$cgraphtype %in% 4:5) {
        gplotout = gplotout +facet_wrap(. ~ .ttr, ncol = input$graphcolnum)
      }
      if (input$cgraphtype %in% c(3,6)) {
        gplotout = gplotout +facet_wrap(. ~ .summ, ncol = input$graphcolnum)
      }

      # inidividual if it is specified
      if (input$cgraphtype %in% 7:8) {
        gplotout = gplotout +facet_wrap(. ~ .id, ncol = input$graphcolnum)
      }

      # add semi log if it is specified
      if (input$loglinear == "semi-log") {
        gplotout = gplotout + scale_y_log10()
      }

      GLOBAL$concvtimeplot2 = gplotout # for exports of ggplot object
      gplotout

    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})
