originalData <- reactive({
  createSampleData(N = input$popsize1)
})

dataV2 <- reactive({
  tryCatch(eval(parse(text = paste0("subset(originalData(),",input$subsetting1,")"))),
           error = function(e) originalData()[1,])
})

dataV3 <- reactive({
  tryCatch(eval(parse(text = paste0("subset(originalData(),",input$subsetting2,")"))),
           error = function(e) originalData()[1,])
})


observeEvent(input$rundatabutton,{
  GLOBAL$data.versions <- list(
    "original" = originalData(),
    "dataV2" = dataV2(),
    "dataV3" = dataV3()
    )
})

output$rhstable1 <- renderDT(
  switch (input$datatoUseV1,
          "original"= GLOBAL$data.versions$original,
          "dataV2"=GLOBAL$data.versions$dataV2,
          "dataV3"=GLOBAL$data.versions$dataV3
  ),
  options = list(lengthChange = FALSE), filter = list(position = "top")
)





