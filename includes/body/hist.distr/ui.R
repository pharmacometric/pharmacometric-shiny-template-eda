############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/hist.distr/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# plot panels
body.panel.right.plot.hist = card.pro(
  title = "Histogram",
  icon = icon("chart-simple"),
  collapsed = 1L,
  header.bg = "yellow",
  xtra.header.content = textOutput("reportgraphstatus"),
  plotOutput("covdistPlot", height = 600),
  sidebar = div(
    tags$label("Graph settings"),
    selectInput("covgraphtype", "Graph type", choices = c(
      "Combined", "Combined_group", "Facet by ID", "Facet by Group", "Facet by Dose"
    ), selected = "Facet by Group", width = "90%"),
    conditionalPanel(
      condition = "input.covgraphtype == 'Combined' | input.covgraphtype == 'Combined_group' | input.covgraphtype == 'Facet by Group'",
      selectInput("covgraphtype2", "Statistic", choices = c(
        "Mean", "Mean ± SD", "Mean ± SEM", "Median", "Median ± 90% PI", "Median ± 95% PI"
      ), selected = "Median ± 90% PI", width = "90%")
    ),
    selectInput("covloglinear", "semi-log or linear", choices = c(
      "Linear", "semi-log"
    ), width = "90%"),
    textInput("covlabely", "Y-label", "Predicted Concentration (μg/ml)", width = "95%"),
    textInput("covlabelx", "X-label", "Time after first dose (days)", width = "95%"),
    selectInput("covgraphfont", "Font type", choices = c(
      "Times", "Verdana", "Arial", "Courier", "Comic Sans MS"
    ), selected = "covArial", width = "90%"),
    sliderInput("covfontxytitle",
                "Font-size title",
                min = 1,
                max = 50,
                value = 14
    ),
    sliderInput("covfontxyticks",
                "Font-size ticks",
                min = 1,
                max = 50,
                value = 12
    ),
    sliderInput("covfontxystrip",
                "Font-size strip",
                min = 1,
                max = 50,
                value = 12
    ),
    "For downloads:",
    numericInput("covdownimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("covdownimgw", "Image width (px)", 2200, width = "90%"),
    numericInput("covdownimgh", "Image height (px)", 1200, width = "90%"),
    numericInput("covdownimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("covdownloadimg2", "Download plot", icon = icon("image"))
  )
)

