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



output$corrcovplots1 = renderPlot({
  covrel.data = GLOBAL$data.versions[[input$datatoUseconcv1]]
  if(covrel.data == NULL){
    my_data <- mtcars[, c(1,3,4,5,6,7)]
  chart.Correlation(my_data, histogram=TRUE, pch=19)
  }

  if(nrow(covrel.data) & all(input$corrcectouse %in% names(covrel.data))){
    varsr = input$corrcectouse
    covrel.data2 = covrel.data %>% filter(!duplicated(ID)) %>% select(all_of(varsr))
    chart.Correlation(covrel.data2, histogram=TRUE, pch=19)
  }

})
