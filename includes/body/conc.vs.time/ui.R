############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/conc.vs.time/ui.R
##
##  Description: User interface for main body section
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# plot panels
body.panel.right.plot.conc <- card.pro(
  title = "Concentration vs. Time",
  icon = icon("chart-simple"),
  collapsed = FALSE,
  header.bg = "blueLight",
  xtra.header.content = textOutput("reportgraphstatus"),
  div(id="reportgraphstatus2",
      tags$blockquote(style="color:blue","Tabs: DV.vs.TSFD (concentration versus time since first dose) and DV.vs.TSLD (concentration versus time since last dose)")
      ),
  tabs = list(
    tabEntry(
      "DV.vs.TSFD",
      selectInput("datatoUseconc1", "Data version to use:", choices = data.versions.names),
      plotOutput("concvtimeplot1", height = 500)
    ),
    tabEntry("DV.vs.TSLD",
             selectInput("datatoUseconc2", "Data version to use:", choices = data.versions.names),
             plotOutput("concvtimeplot2", height = 500))
  ),
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
    textInput("labely", "Y-label", "Concentration (μg/ml)", width = "95%"),
    textInput("labelx", "X-label (TSFD tab)", "Time after first dose (hrs)", width = "95%"),
    textInput("labelx2", "X-label (TSLD tab)", "Time after last dose (hrs)", width = "95%"),
    selectInput("graphfont", "Font type", choices = c(
      "Times", "Verdana", "Arial", "Courier", "Comic Sans MS"
    ), selected = "Arial", width = "90%"),
    sliderInput("fontxytitle",
      "Font-size text",
      min = 1,
      max = 50,
      value = 12
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
    selectInput('legendposition','Legend position',choices = c('bottom','top','left','right','none'), width = "90%"),
    numericInput('ncollegend','Number of legend columns', value = 5, width = "90%"),
    "For downloads:",
    numericInput("downimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("downimgw", "Image width (px)", 2500, width = "90%"),
    numericInput("downimgh", "Image height (px)", 2000, width = "90%"),
    numericInput("downimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("concvtimedownloadimg", "Download plot", icon = icon("image"))
  ),
  footer = list(
    downloadButton("concvtimedownloadimg", "Download plot file (png)", icon = icon("image")),
    downloadButton("concvtimedownloadimg2", "Download plot object (ggplot)", icon = icon("image")),
    downloadButton("cdownloadimg2", "Download code", icon = icon("code"))
  )
)
