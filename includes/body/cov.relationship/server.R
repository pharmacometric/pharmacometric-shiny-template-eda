############################################################################
############################################################################
##  Document Path: includes/body/cov.relationship/server.R
##
##  Description: Server function for covariate relationship
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
############################################################################
############################################################################


# set data versions to use for plotting
updateSelectInput(session, "datatoUseconcv1", choices = data.versions.names)
updateSelectInput(session, "datatoUseconcv2", choices = data.versions.names)



output$corrcovplots1 <- renderPlot({
  covrel.data <- GLOBAL$data.versions[[input$datatoUseconcv1]]
  usedd <<- covrel.data
  if (is.null(covrel.data)) {
    return("Awaiting data and covariate selection")
  }

  if (nrow(covrel.data) & all(input$corrcectouse %in% names(covrel.data))) {
    varsr <- input$corrcectouse
    covrel.data2 <- covrel.data %>%
      filter(!duplicated(ID)) %>%
      select(all_of(varsr))

    ggpairs(covrel.data2) +
      theme_bw() +
      styler00 + styler01 +
      styler03
  }
})



output$corrcovplots2 <- renderPlot({
  covrel.data <- GLOBAL$data.versions[[input$datatoUseconcv2]]
  if (is.null(covrel.data)) {
    return("Awaiting data and covariate selection")
  }

  if (nrow(covrel.data) & all(input$corrcectouse2 %in% names(covrel.data))) {
    varsr <- input$corrcectouse2
    covrel.data2 <- covrel.data %>%
      filter(!duplicated(ID)) # %>%select(all_of(varsr))

    pl1 <- ggplot(data = usedd)
    allplt <- lapply(varsr, function(o) {
      pl1 + aes_string(x = o, y = input$corrcectoby2) +
        geom_boxplot(outlier.shape = NA) +
        geom_jitter(width = 0.2, alpha = 0.1) +
        labs(y = input$labelycovcorr) +
        theme_bw() +
        styler00 + styler01 +
        styler03 + theme(
          legend.position = input$legendpositioncovcorr,
          axis.text = element_text(size = 14)
        )
    })

    patchwork::wrap_plots(allplt, ncol = input$ncollegendcovcorr)
  }
})
