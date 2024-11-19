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

# include all files required for simulations

for(e in list.files(file.path(this.path,"sim/"), pattern = ".R$"))
  source(file.path(this.path,"sim", e), local = TRUE)



# other outputs and event listeners for the body section

output$tracksimulations <- renderText({
  if(is.null(GLOBAL$lastsim)){
    "No data updates have been made."
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

output$rhstable1 <- renderDT(
  regimenDT, options = list(lengthChange = FALSE), filter = list(position = "top")
)





