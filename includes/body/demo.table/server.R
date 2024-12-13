############################################################################
############################################################################
##  Document Path: includes/body/demo.table/server.R
##
##  Description: Server function for demographic table
##
##  R Version: 4.4.1 (2024-06-14 ucrt)
############################################################################
############################################################################


# set data versions to use for plotting
updateSelectInput(session, "datatoUseconct1", choices = data.versions.names)
updateSelectInput(session, "datatoUseconct2", choices = data.versions.names)


output$demdescrtbl <- renderTable({
  tab.data = GLOBAL$data.versions[[input$datatoUseconct1]]
  datl = mtcars
  datl$trt = sample(c("CmpA","CmpB","CmpC"),nrow(datl), replace = 1L)
  vars.t = input$covariatestouse
  if(is.null(tab.data))return({
    table1(~ wt + qsec | trt, data=datl, footnote = "This is a sample table.")
  })
  if(nrow(tab.data) & length(vars.t) & input$cfacetvar %in% c(names(tab.data))){
    vars.u = paste(vars.t, collapse = " + ")
    eval(parse(text = paste0("tablend = table1(~ ",vars.u,"| ",input$cfacetvar,", data=tab.data)")))
    GLOBAL$demo.table.out = tablend
    tablend
  }else{
    resp.color.tbl()
  table1(~ wt + qsec | trt, data=datl, footnote = "This is a sample table.")
  }
})



resp.color.tbl <- reactive({
  updateGraphStatus4(paste0('<blockquote style="color:red">Below is a sample table. Generate Data Versions and set the Variable Matching variables to see table.</blockquote>'))
})
