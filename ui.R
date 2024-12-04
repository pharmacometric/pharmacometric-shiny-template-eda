############################################################################
############################################################################
##
##  NO NEED TO ALTER THIS PAGE
##
##  Document: ui.R
##
##  Description: Assemble all UI elements from the "includes" folder
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################



# include all required UI files for head, body and footer
for (ui_each in c(
  "includes/header",
  "includes/body",
  "includes/footer"
)) {
  this.files = list.files(ui_each,
    pattern = "^ui\\.",
    full.names = 1L,
    recursive = 1L
  )
  for (uifile in this.files) {
    this.path = dirname(uifile)
    source(uifile, local = T)
  }
}




# create the main UI for the app
ui = fluidPage(
  useShinyjs(),
  use.cardpro(theme = "a"),
  header.main,
  body.main,
  footer.main
)
