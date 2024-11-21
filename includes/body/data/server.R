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
