############################################################################
############################################################################
##  Document Path: includes/footer/server.R
##
##  Description: server for footer
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# when cookie is clicked
observeEvent(input$closecookiesform,{
  shinyjs::runjs("document.querySelectorAll('.page-footer').forEach(element => element.remove())")
})
