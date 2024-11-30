############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/server.R
##
##  Description: Server function for concentration versus time plots
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

output$concvtimeplot1 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUseconc1]]
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$depvar3, input$colvar3) %in% names(plot.data))) {
      updateGraphStatus2()
      plot.data$.dv <- as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm <- as.numeric(plot.data[[input$indepvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]])
      plot.data$.ttr <- as.factor(plot.data[[input$depvar3]])

      gplotout <- ggplot(data = plot.data %>% filter(not.na(.dv) & .dv > 0), aes(.tm, .dv, color = .colv)) +
        geom_point() +
        geom_line() +
        facet_wrap(. ~ .ttr) +
        guides(color = guide_legend(ncol = input$ncollegend)) +
        labs(x = input$labelx, y = input$labely, color = "") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))

      if (input$loglinear == "Semi-Log") {
        gplotout + scale_y_log10()
      } else {
        gplotout
      }
    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})


output$concvtimeplot2 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUseconc2]]
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar2, input$depvar3, input$colvar3) %in% names(plot.data))) {
      updateGraphStatus2()
      plot.data$.dv <- as.numeric(plot.data[[input$depvar1]])
      plot.data$.tm <- as.numeric(plot.data[[input$indepvar2]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]])
      plot.data$.ttr <- as.factor(plot.data[[input$depvar3]])

      gplotout <- ggplot(data = plot.data %>% filter(not.na(.dv) & .dv > 0), aes(.tm, .dv, color = .colv)) +
        geom_point() +
        geom_line() +
        facet_wrap(. ~ .ttr) +
        guides(color = guide_legend(ncol = input$ncollegend)) +
        labs(x = input$labelx2, y = input$labely, color = "") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(text = element_text(family = input$graphfont), axis.text = element_text(size = input$fontxyticks, family = input$graphfont), axis.title = element_text(size = input$fontxytitle, family = input$graphfont), strip.text = element_text(size = input$fontxystrip, family = input$graphfont), legend.position = input$legendposition, legend.text = element_text(family = input$graphfont), legend.title = element_text(family = input$graphfont), title = element_text(family = input$graphfont))

      if (input$loglinear == "Semi-Log") {
        gplotout + scale_y_log10()
      } else {
        gplotout
      }
    } else {
      updateGraphStatus2("Plots cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})

