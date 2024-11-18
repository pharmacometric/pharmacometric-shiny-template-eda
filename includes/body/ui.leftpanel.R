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

# sims setup panel
body.panel.left.setup <- card.pro(

  title = "Data",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = TRUE,
  "This section allows initiation of the runs, edit of general parameters and monitoring of progress",
  tabs = list(
    tabEntry(
      "Main",
      numericInput("samplesize", "Number of participants (per arm)", 3, width = "100%"),
      numericInput("enddoseat", "Treatment duration (wks)", 30, width = "100%"),
      numericInput("samplingfrequency", "Sampling frequency (hr)", 1, width = "100%"),
      numericInput("simulationseed", "Simulation seed", 1320, width = "100%"),
      actionButton("runsimbutton", "Start simulation", icon = icon("running"))
    ),
    tabEntry("Parameters", uiOutput("mrgsolveparms"))
  ),
  footer = textOutput("tracksimulations")
)







# assemble left panel
body.panel.left <- primePanel(
  width = 4,
  body.panel.left.setup
)

