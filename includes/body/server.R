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
  updateSelectInput(session,"wtvar", choices = varnames, selected =  "WT")
  updateSelectInput(session,"agevar", choices = varnames, selected =  "AGE")
  updateSelectInput(session,"bsavar", choices = varnames, selected =  "BSA")
  updateSelectInput(session,"bmivar", choices = varnames, selected =  "BMI")
  updateSelectInput(session,"sexvar", choices = varnames, selected =  "SEXC")
  updateSelectInput(session,"summby", choices = varnames, selected =  "TRT")
  updateSelectInput(session,"colvar3", choices = varnames, selected =  "ID")
  updateSelectInput(session,"idvar", choices = varnames, selected =  "ID")
  updateSelectInput(session,"covariatestouse", choices = varnames, selected =  c("WT","AGE","CRCL","RENAL_FUNCTION","SEXC"))
  updateSelectInput(session,"corrcectouse", choices = varnames, selected =  c("WT","AGE","CRCL","BMI","BSA"))
  updateSelectInput(session,"corrcectouse2", choices = varnames, selected =  c("SEXC","RENAL_FUNCTION","TRT"))
  updateSelectInput(session,"corrcectoby2", choices = varnames, selected =  c("WT"))
})





