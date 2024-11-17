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

# plot panels
body.panel.right.plots <- card.pro(
  title = "Plot graph",
  icon = icon("chart-simple"),
  header.bg = "yellow",
  xtra.header.content = textOutput("reportgraphstatus"),
  plotOutput("distPlot", height = 600),
  sidebar = div(
    tags$label("Graph settings"),
    selectInput("graphtype", "Graph type", choices = c(
      "Combined", "Combined_group", "Facet by ID", "Facet by Group", "Facet by Dose"
    ), selected = "Facet by Group", width = "90%"),
    conditionalPanel(
      condition = "input.graphtype == 'Combined' | input.graphtype == 'Combined_group' | input.graphtype == 'Facet by Group'",
      selectInput("graphtype2", "Statistic", choices = c(
        "Mean", "Mean ± SD", "Mean ± SEM", "Median", "Median ± 90% PI", "Median ± 95% PI"
      ), selected = "Median ± 90% PI", width = "90%")
    ),
    selectInput("loglinear", "Semi-log or linear", choices = c(
      "Linear", "Semi-Log"
    ), width = "90%"),
    textInput("labely", "Y-label", "Predicted Concentration (μg/ml)", width = "95%"),
    textInput("labelx", "X-label", "Time after first dose (days)", width = "95%"),
    selectInput("graphfont", "Font type", choices = c(
      "Times", "Verdana", "Arial", "Courier", "Comic Sans MS"
    ), selected = "Arial", width = "90%"),
    sliderInput("fontxytitle",
                "Font-size title",
                min = 1,
                max = 50,
                value = 14
    ),
    sliderInput("fontxyticks",
                "Font-size ticks",
                min = 1,
                max = 50,
                value = 12
    ),
    sliderInput("fontxystrip",
                "Font-size strip",
                min = 1,
                max = 50,
                value = 12
    ),
    "For downloads:",
    numericInput("downimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("downimgw", "Image width (px)", 2200, width = "90%"),
    numericInput("downimgh", "Image height (px)", 1200, width = "90%"),
    numericInput("downimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("downloadimg2", "Download plot", icon = icon("image"))
  )
)


# table panels
body.panel.right.tables <- card.pro(

  title = "Tables",
  header.bg = "blueLight",
  icon = icon("table"),
  editbtn = TRUE,
  sliderInput("selectedrangesumm",
              "Select treatment time (days) range for summary",
              value = c(0, 30 * 7), min = 0, max = 30 * 7,
              width = "90%"
  ),
  tabs = list(
    tabEntry(
      "Exposure summary",
      tableOutput("summaryexptbl")
    ),
    tabEntry(
      "Individual results",
      DTOutput("rawrestbl")
    ),
    tabEntry(
      "Individal regimen",
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






