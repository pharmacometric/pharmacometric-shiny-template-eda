############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/cov.relationship/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# plot panels
body.panel.right.plot.cov = card.pro(
  title = "Covariate Relationship",
  icon = icon("chart-simple"),
  header.bg = "magenta",
  collapsed = 1L,
  xtra.header.content = textOutput("reportgraphstatus2"),
  selectInput("miscdataUseV1","Data version to use:", choices = data.versions.names),
  plotOutput("didistPlot", height = 600),
  sidebar = div(
    tags$label("Graph settings"),
    selectInput("digraphtype", "Graph type", choices = c(
      "Combined", "Combined_group", "Facet by ID", "Facet by Group", "Facet by Dose"
    ), selected = "Facet by Group", width = "90%"),
    conditionalPanel(
      condition = "input.digraphtype == 'Combined' | input.digraphtype == 'Combined_group' | input.digraphtype == 'Facet by Group'",
      selectInput("graphtype2", "Statistic", choices = c(
        "Mean", "Mean ± SD", "Mean ± SEM", "Median", "Median ± 90% PI", "Median ± 95% PI"
      ), selected = "Median ± 90% PI", width = "90%")
    ),
    selectInput("diloglinear", "semi-log or linear", choices = c(
      "Linear", "semi-log"
    ), width = "90%"),
    textInput("dilabely", "Y-label", "Predicted Concentration (μg/ml)", width = "95%"),
    textInput("dicovlabelx", "X-label", "Time after first dose (days)", width = "95%"),
    selectInput("digraphfont", "Font type", choices = c(
      "Times", "Verdana", "Arial", "Courier", "Comic Sans MS"
    ), selected = "Arial", width = "90%"),
    sliderInput("difontxytitle",
                "Font-size title",
                min = 1,
                max = 50,
                value = 14
    ),
    sliderInput("difontxyticks",
                "Font-size ticks",
                min = 1,
                max = 50,
                value = 12
    ),
    sliderInput("difontxystrip",
                "Font-size strip",
                min = 1,
                max = 50,
                value = 12
    ),
    "For downloads:",
    numericInput("didownimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("didownimgw", "Image width (px)", 2200, width = "90%"),
    numericInput("didownimgh", "Image height (px)", 1200, width = "90%"),
    numericInput("didownimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("didownloadimg2", "Download plot", icon = icon("image"))
  )
)

