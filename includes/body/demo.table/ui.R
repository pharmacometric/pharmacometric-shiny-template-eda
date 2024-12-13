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

  title = "Descriptive Summary Tables",
  header.bg = "blueLight",
  icon = icon("table"),
  editbtn = 1L,
  collapsed = 1L,
  div(
    id = "repttablstatus1",
    tags$blockquote(style = "color:blue", "Tabs: Demographic table descriptive summary table and others stratified by Stratify variable in Variable Matching tab")
  ),
  tabs = list(
    tabEntry(
      "Demographic table",
      column(width=4,class ="p-0",selectInput("datatoUseconct1", "Data version to use:", choices = c())),
      column(width=8,class ="p-0",selectInput("covariatestouse","Variables to use", choices = c(), multiple = 1L, width = "100%")),
      r2resize::splitCard(
        tableOutput("demdescrtbl"),
        tags$code('Code for the table ...'),
        position = "vertical",
        left.width = "90%"
      )

    ),
    tabEntry(
      "Other tables",
      DTOutput("othrsdescrtbl")
    )
  ),
  sidebar = div(
      tags$label("Table settings"),
      selectInput("tabdemgraphtype", "Graph type", choices = c(
        "overall " = 1,
        "stratify by treatment" = 2
      ), selected = "Facet by Group", width = "90%"),
      conditionalPanel(
        condition = "input.tabdemgraphtype == 3 | input.tabdemgraphtype == 6",
        selectInput("graphsummtype", "Statistic", choices = c(
          "Mean" = 1, "Mean ± SD" = 2, "Mean ± SEM" = 3, "Median" = 4, "Median ± 90% PI" = 5, "Median ± 95% PI" = 6
        ), selected = "Median ± 90% PI", width = "90%")
      ),
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
  ),
  footer = list(
    downloadButton("dtabdownloadimg", "Download table file (docx)", icon = icon("image")),
    downloadButton("dtabtimedownloadimg2", "Download table object (table1)", icon = icon("image"), class="downloadbtns2"),
    downloadButton("dtabndloadconcvt2", "Download table code (R)", icon = icon("code"), class="downloadbtns")
  )
)











