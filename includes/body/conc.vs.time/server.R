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
  if(nrow(plot.data)){

    plot.data$.dv = as.numeric(plot.data[[input$depvar1]])
    plot.data$.tm = as.numeric(plot.data[[input$depvar2]])
    plot.data$.colv = as.factor(plot.data[[input$colvar3]])
    plot.data$.ttr = as.factor(plot.data[[input$depvar3]])

    ggplot(data = plot.data %>% filter(not.na(.dv)),aes(.tm,.dv,color = .colv)) +
      geom_point() +
      geom_line() +
      theme_bw() +
      facet_wrap(.~.ttr)+
      labs(x = input$labelx, y = input$labely, color = "")+
      styler0
  }else{
  plot(1:100,
       1:100,
       xlab = "sample x",
       type = "l",
       ylab = "sample y"
  )
  text(50, 50, "Click 'Start simulation' to run simulations and display results", cex = 1.2, pos = 3, col = "red")
}
})



