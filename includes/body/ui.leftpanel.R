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
  "Data upload, subsetting and variable declarations",
  tabs = list(
    tabEntry(
      "Main",
      radioButtons(
        "checkGroupradio1",
        "Dataset for EDA",
        choices = list("Example dataset" = 1, "User dataset" = 2),
        selected = 1
      ),
      conditionalPanel(
        condition = "input.checkGroupradio1 == 2",
        fileInput("fileupd","Upload data",width = "100%")
      )
      ,tags$hr(),
      tags$b("Various versions of the datasets will be created for exploration. (1)Original dataset, (2) dataV2, (3) dataV3. You may modify the subset for the data version below."),
      textAreaInput("subsetting1", "Subset dataV2","DV != NULL",width = "100%"),
      textAreaInput("subsetting2", "Subset dataV3","EVID == 1",width = "100%"),
      actionButton("rundatabutton", "Update data version", icon = icon("running"))
    ),
    tabEntry("Variable Matching",
             selectInput("depvar", "Dependent variable", choices = "DV",width = "100%"),
             selectInput("depvar", "Independent variable", choices = "TIME",width = "100%"),
             selectInput("depvar", "Treatment variable", choices = "TRT",width = "100%"),
             selectInput("depvar", "Dose variable", choices = "DOSE",width = "100%"),
             selectInput("depvar", "Body weight variable", choices = "WT",width = "100%"),
             selectInput("depvar", "Flag variable", choices = "FLAG",width = "100%"),
             )
  ),
  footer = textOutput("tracksimulations")
)







# assemble left panel
body.panel.left <- primePanel(
  width = 4,
  body.panel.left.setup
)

