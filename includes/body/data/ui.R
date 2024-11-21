############################################################################
############################################################################
##  Document Path: includes/body/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


# regimen setup panel
body.panel.right.table.rawdata <- card.pro(
  title = "Raw data",
  icon = icon("book"),
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = TRUE,
  collapsed = FALSE,
  selectInput("datatoUseV1","Data version to use:", choices = data.versions.names),
  DTOutput("rhstable1"),
  # rhandsontable(regimenDT, width = "100%") %>%
  #   hot_context_menu(allowRowEdit = FALSE, allowColEdit = FALSE),

  footer = "Legend: Group - treatment group, Dose - dose in mg, Frequency - dosing frequency as integer, Additional - number of additional doses, Route - route of administration, F1 - bioavilability for the group"
)
