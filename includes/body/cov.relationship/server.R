############################################################################
############################################################################
##  Document Path: includes/body/cov.relationship/server.R
##
##  Description: Server function for demographic table
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
############################################################################
############################################################################


# set data versions to use for plotting
updateSelectInput(session, "datatoUseconcv1", choices = data.versions.names)
updateSelectInput(session, "datatoUseconcv2", choices = data.versions.names)



output$corrcovplots1 = renderPlot({
  my_data <- mtcars[, c(1,3,4,5,6,7)]
  chart.Correlation(my_data, histogram=TRUE, pch=19)
})
