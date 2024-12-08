############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/demo.table/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


body.panel.right.table.demo = card.pro(

  title = "Tables",
  header.bg = "blueLight",
  icon = icon("table"),
  editbtn = 1L,
  collapsed = 1L,
  sliderInput("selectedrangesumm",
              "Select treatment time (days) range for summary",
              value = c(0, 30 * 7), min = 0, max = 30 * 7,
              width = "90%"
  ),
  tabs = list(
    tabEntry(
      "Demographic table",
      r2resize::splitCard(
        tableOutput("summaryexptbl"),
        tags$code('Code for the table ...'),
        position = "vertical"
      )

    ),
    tabEntry(
      "Sampling table",
      DTOutput("rawrestbl")
    ),
    tabEntry(
      "Other tables",
      DTOutput("summaryrestbl")
    )
  ),
  sidebar = div(
    tags$label("Table outputs"),
    hr(),
    downloadButton("downloadtable1", "Download summaries", icon = icon("download"), width = "90%"),
    br(), br(),
    downloadButton("downloadtable2", "Download individuals", icon = icon("download"), width = "90%"),
    br(), br(),
    downloadButton("downloadtable3", "Download regimen", icon = icon("download"), width = "90%"),
    br(), br(),
    "Download raw output from simulation",
    downloadButton("downloadtable4", "Download raw result", icon = icon("download"), width = "90%")
  )
)






