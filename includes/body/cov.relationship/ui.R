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
body.panel.right.plot.cov <- card.pro(
  title = "Covariate Relationship",
  icon = icon("chart-simple"),
  header.bg = "blueDark",
  collapsed = TRUE,
  xtra.header.content = textOutput("reportgraphstatus2"),
  selectInput("dataUseV1","Data version to use:", choices = data.versions.names),
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

