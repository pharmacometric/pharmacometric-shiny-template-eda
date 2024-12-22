############################################################################
############################################################################
##  Document Path: includes/body/hist.distr/server.R
##
##  Description: Server function for concentration versus time plots
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# set data versions to use for plotting
for(xi in c("datatoUsehist1","datatoUsehist2","datatoUsehist3","datatoUsehist4"))
updateSelectInput(session,xi, choices = data.versions.names)


output$histcatvar1 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUsehist1]]
  if (!length(plot.data) | is.null(plot.data) | input$wtvar == "") {
    return(sampleplot())
  }
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--", names(plot.data)))) {

      plot.data$.wt <- as.numeric(plot.data[[input$wtvar]])
      plot.data$.sx <- as.numeric(plot.data[[input$sexvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$cfacetvar]])

      plot.data <- plot.data %>% filter(not.empty(.wt))
      data_vline <- plot.data %>%
        group_by(.sx) %>%
        summarise(grpmn = mean(.wt),grpmd = median(.wt))

      gplotout <- ggplot(plot.data, aes(x = .wt, fill = .sx, color = .sx)) +
        geom_histogram(aes(y = after_stat(density)), position = "identity", alpha = 0.5, bins = 40) +
        geom_density(stat = "density", position = "identity", alpha = 0.6) +
        geom_vline(
          data = data_vline, aes(xintercept = grpmn),
          linetype = "dashed", linewidth = 0.5
        )+
        geom_vline(
          data = data_vline, aes(xintercept = grpmd),
          linetype = "dotted", linewidth = 0.5
        )


      # facet if it is specified
      if (input$histgraphtype %in% 3:4) {
        gplotout <- gplotout + facet_wrap(. ~ .ttr, ncol = input$histgraphcolnum)
      }

      # color selected if it is specified
      if (input$histgraphtype %in% c(2, 4)) {
        resp.color.hist()
        gplotout <- gplotout + aes(color = .colv)
      }

      gplotout <- gplotout +
        labs(x = input$histlabelx, y = input$histlabely, fill = "", color = "", caption = "Dashed and dotted lines denote mean and median of body weights, respectively.") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(
          text = element_text(family = input$histgraphfont),
          axis.text = element_text(
            size = input$histfontxyticks,
            family = input$histgraphfont
          ),
          axis.title = element_text(size = input$histfontxytitle, family = input$histgraphfont),
          strip.text = element_text(size = input$histfontxystrip, family = input$histgraphfont),
          legend.position = input$histlegendposition,
          legend.text = element_text(family = input$histgraphfont),
          legend.title = element_text(family = input$histgraphfont),
          title = element_text(family = input$histgraphfont),
          plot.caption = element_text(vjust = 4, size = 10, face = "bold")
        )

      GLOBAL$histwtplot1 <- gplotout # for exports of ggplot object
      gplotout
    } else {
      updateGraphStatus3("Histogram distribution plot cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})



# Age plots

output$histcatvar2 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUsehist2]]
  if (!length(plot.data) | is.null(plot.data) | input$agevar == "") {
    return(sampleplot())
  }
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--", names(plot.data)))) {

      plot.data$.age <- as.numeric(plot.data[[input$agevar]])
      plot.data$.sx <- as.numeric(plot.data[[input$sexvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$cfacetvar]])

      plot.data <- plot.data %>% filter(not.empty(.age))
      data_vline <- plot.data %>%
        group_by(.sx) %>%
        summarise(grpmn = mean(.age),grpmd = median(.age))

      gplotout <- ggplot(plot.data, aes(x = .age, fill = .sx, color = .sx)) +
        geom_histogram(aes(y = after_stat(density)), position = "identity", alpha = 0.5, bins = 40) +
        geom_density(stat = "density", position = "identity", alpha = 0.6) +
        geom_vline(
          data = data_vline, aes(xintercept = grpmn),
          linetype = "dashed", linewidth = 0.5
        )+
        geom_vline(
          data = data_vline, aes(xintercept = grpmd),
          linetype = "dotted", linewidth = 0.5
        )


      # facet if it is specified
      if (input$histgraphtype %in% 3:4) {
        gplotout <- gplotout + facet_wrap(. ~ .ttr, ncol = input$histgraphcolnum)
      }

      # color selected if it is specified
      if (input$histgraphtype %in% c(2, 4)) {
        resp.color.hist()
        gplotout <- gplotout + aes(color = .colv)
      }

      gplotout <- gplotout +
        labs(x = input$histlabelx2, y = input$histlabely, fill = "", color = "", caption = "Dashed and dotted lines denote mean and median of body weights, respectively.") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(
          text = element_text(family = input$histgraphfont),
          axis.text = element_text(
            size = input$histfontxyticks,
            family = input$histgraphfont
          ),
          axis.title = element_text(size = input$histfontxytitle, family = input$histgraphfont),
          strip.text = element_text(size = input$histfontxystrip, family = input$histgraphfont),
          legend.position = input$histlegendposition,
          legend.text = element_text(family = input$histgraphfont),
          legend.title = element_text(family = input$histgraphfont),
          title = element_text(family = input$histgraphfont),
          plot.caption = element_text(vjust = 4, size = 10, face = "bold")
        )

      GLOBAL$histageplot2 <- gplotout # for exports of ggplot object
      gplotout
    } else {
      updateGraphStatus3("Histogram distribution plot cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})



# BMI plots

output$histcatvar3 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUsehist3]]
  if (!length(plot.data) | is.null(plot.data) | input$bmivar == "") {
    return(sampleplot())
  }
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--", names(plot.data)))) {

      plot.data$.bmi <- as.numeric(plot.data[[input$bmivar]])
      plot.data$.sx <- as.numeric(plot.data[[input$sexvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$cfacetvar]])

      plot.data <- plot.data %>% filter(not.empty(.bmi))
      data_vline <- plot.data %>%
        group_by(.sx) %>%
        summarise(grpmn = mean(.bmi),grpmd = median(.bmi))

      gplotout <- ggplot(plot.data, aes(x = .bmi, fill = .sx, color = .sx)) +
        geom_histogram(aes(y = after_stat(density)), position = "identity", alpha = 0.5, bins = 40) +
        geom_density(stat = "density", position = "identity", alpha = 0.6) +
        geom_vline(
          data = data_vline, aes(xintercept = grpmn),
          linetype = "dashed", linewidth = 0.5
        )+
        geom_vline(
          data = data_vline, aes(xintercept = grpmd),
          linetype = "dotted", linewidth = 0.5
        )


      # facet if it is specified
      if (input$histgraphtype %in% 3:4) {
        gplotout <- gplotout + facet_wrap(. ~ .ttr, ncol = input$histgraphcolnum)
      }

      # color selected if it is specified
      if (input$histgraphtype %in% c(2, 4)) {
        resp.color.hist()
        gplotout <- gplotout + aes(color = .colv)
      }

      gplotout <- gplotout +
        labs(x = input$histlabelx2, y = input$histlabely, fill = "", color = "", caption = "Dashed and dotted lines denote mean and median of body weights, respectively.") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(
          text = element_text(family = input$histgraphfont),
          axis.text = element_text(
            size = input$histfontxyticks,
            family = input$histgraphfont
          ),
          axis.title = element_text(size = input$histfontxytitle, family = input$histgraphfont),
          strip.text = element_text(size = input$histfontxystrip, family = input$histgraphfont),
          legend.position = input$histlegendposition,
          legend.text = element_text(family = input$histgraphfont),
          legend.title = element_text(family = input$histgraphfont),
          title = element_text(family = input$histgraphfont),
          plot.caption = element_text(vjust = 4, size = 10, face = "bold")
        )

      GLOBAL$histageplot2 <- gplotout # for exports of ggplot object
      gplotout
    } else {
      updateGraphStatus3("Histogram distribution plot cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})


# BSA plots

output$histcatvar4 <- renderPlot({
  plot.data <- GLOBAL$data.versions[[input$datatoUsehist4]]
  if (!length(plot.data) | is.null(plot.data) | input$bsavar == "") {
    return(sampleplot())
  }
  if (nrow(plot.data)) {
    if (all(c(input$depvar1, input$indepvar, input$cfacetvar, input$colvar3) %in% c("--", names(plot.data)))) {

      plot.data$.bsa <- as.numeric(plot.data[[input$bsavar]])
      plot.data$.sx <- as.numeric(plot.data[[input$sexvar]])
      plot.data$.colv <- as.factor(plot.data[[input$colvar3]]) %or% as.factor(plot.data$.id)
      plot.data$.ttr <- as.factor(plot.data[[input$cfacetvar]])

      plot.data <- plot.data %>% filter(not.empty(.bsa))
      data_vline <- plot.data %>%
        group_by(.sx) %>%
        summarise(grpmn = mean(.bsa),grpmd = median(.bsa))

      gplotout <- ggplot(plot.data, aes(x = .bsa, fill = .sx, color = .sx)) +
        geom_histogram(aes(y = after_stat(density)), position = "identity", alpha = 0.5, bins = 40) +
        geom_density(stat = "density", position = "identity", alpha = 0.6) +
        geom_vline(
          data = data_vline, aes(xintercept = grpmn),
          linetype = "dashed", linewidth = 0.5
        )+
        geom_vline(
          data = data_vline, aes(xintercept = grpmd),
          linetype = "dotted", linewidth = 0.5
        )


      # facet if it is specified
      if (input$histgraphtype %in% 3:4) {
        gplotout <- gplotout + facet_wrap(. ~ .ttr, ncol = input$histgraphcolnum)
      }

      # color selected if it is specified
      if (input$histgraphtype %in% c(2, 4)) {
        resp.color.hist()
        gplotout <- gplotout + aes(color = .colv)
      }

      gplotout <- gplotout +
        labs(x = input$histlabelx2, y = input$histlabely, fill = "", color = "", caption = "Dashed and dotted lines denote mean and median of body weights, respectively.") +
        theme_bw() +
        styler00 +
        styler03 +
        theme(
          text = element_text(family = input$histgraphfont),
          axis.text = element_text(
            size = input$histfontxyticks,
            family = input$histgraphfont
          ),
          axis.title = element_text(size = input$histfontxytitle, family = input$histgraphfont),
          strip.text = element_text(size = input$histfontxystrip, family = input$histgraphfont),
          legend.position = input$histlegendposition,
          legend.text = element_text(family = input$histgraphfont),
          legend.title = element_text(family = input$histgraphfont),
          title = element_text(family = input$histgraphfont),
          plot.caption = element_text(vjust = 4, size = 10, face = "bold")
        )

      GLOBAL$histageplot2 <- gplotout # for exports of ggplot object
      gplotout
    } else {
      updateGraphStatus3("Histogram distribution plot cannot be created because the variable names selected do not exist in the new dataset. Consider setting the correct variable names in the <b>Variable Matching</b> tab in the left panel.")
    }
  } else {
    sampleplot()
  }
})
resp.color.hist <- reactive({
  updateGraphStatus3(paste0('<blockquote style="color:red">Plots generated and colored by ',input$colvar3,'. To change this, use the <b>Variable Matching</b> tab.</blockquote>'))
})
