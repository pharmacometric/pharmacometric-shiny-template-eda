originalData <- reactive({
  createSampleData(N = input$popsize1)
})

dataV2 <- reactive({
  eval(parse(text = paste0("subset(originalData(),",input$subsetting1,")")))
})

dataV3 <- reactive({
  eval(parse(text = paste0("subset(originalData(),",input$subsetting2,")")))
})


observeEvent(input$rundatabutton,{
  head(originalData())
  head(dataV3())
})

output$rhstable1 <- renderDT(
  switch (input$datatoUseV1,
          "original"= originalData(),"dataV2"=dataV2(),"dataV3"=dataV3()
  ),
  options = list(lengthChange = FALSE), filter = list(position = "top")
)
