############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/server.R
##
##  Description: Server function for concentration versus time plots
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
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
#############################################################################
#############################################################################

updateSelectInput(session, "datatoUseconc1", choices = data.versions.names)
updateSelectInput(session, "datatoUseconc2", choices = data.versions.names)



output$concvtimeplot1 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUseconc1]]
  if(!length(plot.data) | is.null(plot.data))return(sampleplot())
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$depvar3, input$colvar3) %in% c("--",names(plot.data)))) {
      updateGraphStatus2()
      plot.data$.dv <- as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm <- as.numeric(plot.data[[input$indepvar]])
      plot.data$.id <- as.numeric(plot.data[[input$idvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %ifnon% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$depvar3]])
      plot.data$.none <- "x"

      # global plot out
      data = plot.data %>% filter(not.na(.dv) & .dv > 0)
      gplotout <- ggplot(data, aes(.tm, .dv, color = .colv))   +
        guides(color = guide_legend(ncol = input$ncollegend))+
        labs(x = input$labelx, y = input$labely, color = "")+
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))


      # if color variable is specified
      if (input$colvar3 == "--" | input$cgraphtype %in% c(1,4,7,8)) {
        gplotout <- gplotout + scale_color_manual(values = rep("black",length(unique(data$.id)))) +
          theme(legend.position = "none")
      }

      # if spaghetti is specified
      if (input$cgraphtype %in% c(1,4,7)) {
        gplotout <- gplotout + geom_point() + geom_line()
      }

      # if scatter is specified
      if (input$cgraphtype %in% c(2,5,8)) {
        gplotout <- gplotout + geom_point()
      }

      # if summary is specified
      if (input$cgraphtype %in% c(3,6)) {
        gplotout <- gplotout + geom_line()
      }

      # facet if it is specified
      if (input$cgraphtype %in% 4:6) {
        gplotout <- gplotout +facet_wrap(. ~ .ttr, ncol = input$graphcolnum)
      }

      # inidividual if it is specified
      if (input$cgraphtype %in% 7:8) {
        gplotout <- gplotout +facet_wrap(. ~ .id, ncol = input$graphcolnum)
      }

      # add semi log if it is specified
      if (input$loglinear == "Semi-Log") {
        gplotout <- gplotout + scale_y_log10()
      }

      gplotout

    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})


output$concvtimeplot2 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUseconc2]]
  if(!length(plot.data) | is.null(plot.data))return(sampleplot())
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar2, input$depvar3, input$colvar3) %in% c("--",names(plot.data)))) {
      updateGraphStatus2()
      plot.data$.dv <- as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm <- as.numeric(plot.data[[input$indepvar2]])
      plot.data$.id <- as.numeric(plot.data[[input$idvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %ifnon% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$depvar3]])
      plot.data$.none <- "x"

      # global plot out
      data = plot.data %>% filter(not.na(.dv) & .dv > 0)
      gplotout <- ggplot(data, aes(.tm, .dv, color = .colv))   +
        guides(color = guide_legend(ncol = input$ncollegend))+
        labs(x = input$labelx, y = input$labely, color = "")+
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))


      # if color variable is specified
      if (input$colvar3 == "--" | input$cgraphtype %in% c(1,4,7,8)) {
        gplotout <- gplotout + scale_color_manual(values = rep("black",length(unique(data$.id)))) +
          theme(legend.position = "none")
      }

      # if spaghetti is specified
      if (input$cgraphtype %in% c(1,4,7)) {
        gplotout <- gplotout + geom_point() + geom_line()
      }

      # if scatter is specified
      if (input$cgraphtype %in% c(2,5,8)) {
        gplotout <- gplotout + geom_point()
      }

      # if summary is specified
      if (input$cgraphtype %in% c(3,6)) {
        gplotout <- gplotout + geom_line()
      }

      # facet if it is specified
      if (input$cgraphtype %in% 4:6) {
        gplotout <- gplotout +facet_wrap(. ~ .ttr, ncol = input$graphcolnum)
      }

      # inidividual if it is specified
      if (input$cgraphtype %in% 7:8) {
        gplotout <- gplotout +facet_wrap(. ~ .id, ncol = input$graphcolnum)
      }

      # add semi log if it is specified
      if (input$loglinear == "Semi-Log") {
        gplotout <- gplotout + scale_y_log10()
      }

      gplotout

    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})
