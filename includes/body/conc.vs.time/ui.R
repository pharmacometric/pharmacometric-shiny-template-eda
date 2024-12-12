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

#for(u in indexed(libs))message(u$key,"-",u$val)
# for exporting code
GLOBAL$code.convtm.tpl = paste0(this.path,"/code.tpl")
GLOBAL$code.convtm.libs.glue = paste0('c("',paste(libs[c(10,11,12,20,19)], collapse = '","'),'")')


# plot panels
body.panel.right.plot.conc = card.pro(
  title = "Concentration vs. Time",
  icon = icon("chart-simple"),
  collapsed = FALSE,
  header.bg = "white",
  xtra.header.content = textOutput("reportgraphstatus"),
  div(
    id = "reportgraphstatus2",
    tags$blockquote(style = "color:blue", "Tabs: DV.vs.TSFD (concentration versus time since first dose) and DV.vs.TSLD (concentration versus time since last dose)")
  ),
  tabs = list(
    tabEntry(
      "DV.vs.TSFD",
      selectInput("datatoUseconc1", "Data version to use:", choices = c()),
      plotOutput("concvtimeplot1", height = 500)
    ),
    tabEntry(
      "DV.vs.TSLD",
      selectInput("datatoUseconc2", "Data version to use:", choices = c()),
      plotOutput("concvtimeplot2", height = 500)
    )
  ),
  sidebar = div(
    tags$label("Graph settings"),
    selectInput("cgraphtype", "Graph type", choices = c(
      "overall - spaghetti plot" = 1,
      "overall - scatter plot" = 2,
      "overall - summarised" = 3,
      "facet - spaghetti plot" = 4,
      "facet - scatter plot" = 5,
      "facet - summarised" = 6,
      "individual - spaghetti plot" = 7,
      "individual - scatter plot" = 8
    ), selected = "Facet by Group", width = "90%"),
    conditionalPanel(
      condition = "input.cgraphtype == 3 | input.cgraphtype == 6",
      selectInput("graphsummtype", "Statistic", choices = c(
        "Mean" = 1, "Mean ± SD" = 2, "Mean ± SEM" = 3, "Median" = 4, "Median ± 90% PI" = 5, "Median ± 95% PI" = 6
      ), selected = "Median ± 90% PI", width = "90%")
    ),
    conditionalPanel(
      condition = "input.cgraphtype == 4 |input.cgraphtype == 5 |input.cgraphtype == 6 |input.cgraphtype == 7 | input.cgraphtype == 8",
      numericInput("graphcolnum", "Facet column number", value = 4, width = "90%")
    ),
    selectInput("loglinear", "semi-log or linear", choices = c(
      "linear", "semi-log"
    ), width = "90%"),
    textInput("labely", "Y-label", "Concentration (ug/ml)", width = "95%"),
    textInput("labelx", "X-label (TSFD tab)", "Time after first dose (hrs)", width = "95%"),
    textInput("labelx2", "X-label (TSLD tab)", "Time after last dose (hrs)", width = "95%"),
    selectInput("legendposition", "Legend position", choices = c("bottom", "top", "left", "right", "none"), width = "90%"),
    numericInput("ncollegend", "Number of legend columns", value = 5, width = "90%"),
    selectInput("graphfont", "Font type", choices = font.family, selected = "Arial", width = "90%"),
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
    "For downloads:",
    numericInput("downimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("downimgw", "Image width (px)", 2500, width = "90%"),
    numericInput("downimgh", "Image height (px)", 1700, width = "90%"),
    numericInput("downimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("concvtimedownloadimg", "Download plot", icon = icon("image"), class="downloadbtns")
  ),
  footer = list(
    downloadButton("concvtimedownloadimg", "Download plot file (png)", icon = icon("image")),
    downloadButton("concvtimedownloadimg2", "Download plot object (ggplot)", icon = icon("image"), class="downloadbtns2"),
    downloadButton("cdownloadconcvt2", "Download plot code (R)", icon = icon("code"), class="downloadbtns")
  )
)
