############################################################################
############################################################################
##  Document Path: includes/body/data/ui.R
##
##  Description: User interface for data sections
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


# regimen setup panel
body.panel.right.table.rawdata = card.pro(
  title = "Dataset working copy",
  icon = icon("book"),
  header.bg = "greenDark",
  removebtn = 0L,
  colorbtn = 0L,
  expandbtn = 0L,
  editbtn = 0L,
  collapsed = 0L,
  sortable = 0L,


  tabs = list(
    tabEntry("Data Stats",tableOutput("subj1summary")),
    tabEntry("Data Summary",verbatimTextOutput("rhstable1summary")),
    tabEntry("All Individuals",DTOutput("rhstable1"))
  ),
  footer = list(
    selectInput("datatoUseV1","Data version to use:", choices = data.versions.names),"Legend: Group - AGE - Age, WT - Body weight, CONC/DV - concentration, TIME/TSFD,TSLD - Time")
)
