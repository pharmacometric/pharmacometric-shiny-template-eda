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
        "Dataset for exploratory data analysis",
        choices = list("Example dataset" = 1, "User dataset" = 2),
        selected = 1
      ),
      conditionalPanel(
        condition = "input.checkGroupradio1 == 2",
        fileInput("fileupd","Upload data",width = "100%")
      ),
      conditionalPanel(
        condition = "input.checkGroupradio1 == 1",
        numericInput("popsize1", "Number subjects",10,width = "100%")
      )
      ,tags$hr(),
      tags$b("Various versions of the datasets will be created for exploration. (1)Original dataset, (2) dataV2, (3) dataV3. You may modify the subset for the data version below."),
      textAreaInput("subsetting1", "Subset dataV2",'RENAL_FUNCTION == "Normal"',width = "100%"),
      textAreaInput("subsetting2", "Subset dataV3","TRT == 'DrugA'",width = "100%"),
      actionButton("rundatabutton", "Generate Data Versions", icon = icon("running"))
    ),
    tabEntry("Variable Matching",
             selectInput("depvar1", "Dependent variable", choices = "DV",width = "100%"),
             selectInput("depvar2", "Independent variable", choices = "TIME",width = "100%"),
             selectInput("depvar3", "Treatment variable", choices = "TRT",width = "100%"),
             selectInput("colvar3", "Color by", choices = "ID",width = "100%"),
             selectInput("depvar4", "Dose variable", choices = "DOSE",width = "100%"),
             selectInput("depvar5", "Body weight variable", choices = "WT",width = "100%"),
             selectInput("depvar6", "Flag variable", choices = "FLAG",width = "100%"),
             )
  ),
  footer = textOutput("tracksimulations")
)







# assemble left panel
body.panel.left <- primePanel(
  width = 4,
  body.panel.left.setup
)

