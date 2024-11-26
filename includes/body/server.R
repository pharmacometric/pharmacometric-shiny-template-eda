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

output$tracksimulations <- renderText({
  if(!nrow(GLOBAL$data.versions$original)){
    "No data updates have been made."
  }else{
    list(input$subsetting1,input$subsetting2,input$popsize1)
    "Dataset created. Click 'Generate Data Versions' if data is updated."
  }
})

observeEvent(input$runsimbutton,{
  disableSims()
  #Sys.sleep(2)
  GLOBAL$start.sim <- TRUE
})

output$summaryrestbl = renderDT(
  data01() %>% select(Group,ID,time,WT,Dose,cmt,ii,addl), options = list(lengthChange = FALSE)#,dom = 't'
)

output$rawrestbl = renderDT(
  summary01(), options = list(lengthChange = FALSE), filter = list(position = "top")
)



observe({
  varnames = names(originalData())
  updateSelectInput(session,"depvar1", choices = varnames, selected =  "DV")
  updateSelectInput(session,"depvar2", choices = varnames, selected =  "TIME")
  updateSelectInput(session,"depvar3", choices = varnames, selected =  "TRT")
  updateSelectInput(session,"depvar4", choices = varnames, selected =  "DOSE")
  updateSelectInput(session,"depvar5", choices = varnames, selected =  "WT")
  updateSelectInput(session,"depvar6", choices = varnames, selected =  "FLAG")
  updateSelectInput(session,"colvar3", choices = varnames, selected =  "ID")
})





