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
  plot(1:100,
       1:100,
       xlab = "sample x",
       type = "l",
       ylab = "sample y"
  )
  text(50, 50, "Click 'Start simulation' to run simulations and display results", cex = 1.2, pos = 3, col = "red")
})
