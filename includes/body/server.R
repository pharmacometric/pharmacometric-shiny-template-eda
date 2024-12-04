############################################################################
############################################################################
##  Document Path: includes/body/server.R
##
##  Description: Server function for body
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


# other outputs and event listeners for the body section

output$tracksimulations = renderText({
  if(!nrow(GLOBAL$data.versions$original)){
    "No data updates have been made."
  }else{
    list(input$subsetting1,input$subsetting2,input$popsize1)
    "Dataset created. Click 'Generate Data Versions' if data is updated."
  }
})


output$summaryrestbl = renderDT(
  data01() %>% select(Group,ID,time,WT,Dose,cmt,ii,addl), options = list(lengthChange = FALSE)#,dom = 't'
)

output$rawrestbl = renderDT(
  summary01(), options = list(lengthChange = FALSE), filter = list(position = "top")
)



observe({
  varnames = names(GLOBAL$data.versions$original)
  updateSelectInput(session,"depvar1", choices = varnames, selected =  "DV")
  updateSelectInput(session,"indepvar", choices = varnames, selected =  "TIME")
  updateSelectInput(session,"indepvar2", choices = varnames, selected =  "TSLD")
  updateSelectInput(session,"cfacetvar", choices = varnames, selected =  "TRT")
  updateSelectInput(session,"depvar4", choices = varnames, selected =  "DOSE")
  updateSelectInput(session,"depvar5", choices = varnames, selected =  "WT")
  updateSelectInput(session,"summby", choices = varnames, selected =  "TRT")
  updateSelectInput(session,"colvar3", choices = c("--",varnames), selected =  "ID")
  updateSelectInput(session,"idvar", choices = varnames, selected =  "ID")
})





