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
body.panel.right.table.rawdata = card.pro(
  title = "Dataset working copy",
  icon = icon("book"),
  header.bg = "yellow",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = 1L,
  collapsed = FALSE,
  sortable = FALSE,
  selectInput("datatoUseV1","Data version to use:", choices = data.versions.names),

  tags$blockquote("Data Summary"),
  verbatimTextOutput("rhstable1summary"),
  tags$blockquote("Data Individuals"),
  DTOutput("rhstable1"),
  footer = "Legend: Group - AGE - Age, WT - Body weight, CONC/DV - concentration, TIME/TSFD,TSLD - Time"
)
