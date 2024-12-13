############################################################################
############################################################################
##  Document Path: ~/GitHub/pharmacometric-shiny-template-eda/includes/body/hist.distr/ui.R
##
##  Description: User interface for histogram of WT and Age plots
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# plot panels
body.panel.right.plot.hist = card.pro(
  title = "Histograms of WT and AGE",
  icon = icon("chart-simple"),
  collapsed = 1L,
  header.bg = "yellow",
  xtra.header.content = textOutput("reportgraphstatus"),
  div(
    id = "reporthiststatus2",
    tags$blockquote(style = "color:blue", "Tabs: Histograms of body weight distribution & age distribution by color variable")
  ),
  tabs = list(
    tabEntry(
      "Body Weight",
      selectInput("datatoUsehist1", "Data version to use:", choices = c()),
      plotOutput("histcatvar1", height = 450)
    ),
    tabEntry(
      "Age",
      selectInput("datatoUsehist2", "Data version to use:", choices = c()),
      plotOutput("histcatvar2", height = 450)
    )
  ),
  sidebar = div(
    tags$label("Graph settings"),
    selectInput("histgraphtype", "Graph type", choices = c(
      "overall - no color" = 1,
      "overall - with color" = 2,
      "facet - no color" = 3,
      "facet - with color" = 4
    ), width = "90%"),
    conditionalPanel(
      condition = "input.histgraphtype == 3 | input.histgraphtype == 6",
      selectInput("histgraphsummtype", "Statistic", choices = c(
        "Mean" = 1, "Mean ± SD" = 2, "Mean ± SEM" = 3, "Median" = 4, "Median ± 90% PI" = 5, "Median ± 95% PI" = 6
      ), selected = "Median ± 90% PI", width = "90%")
    ),
    conditionalPanel(
      condition = "input.histgraphtype == 4 |input.histgraphtype == 5 |input.histgraphtype == 6 |input.histgraphtype == 7 | input.cgraphtype == 8",
      numericInput("histgraphcolnum", "Facet column number", value = 4, width = "90%")
    ),
    textInput("histlabely", "Y-label", "Density", width = "95%"),
    textInput("histlabelx", "X-label (WT tab)", "Weight(kg)", width = "95%"),
    textInput("histlabelx2", "X-label (AGE tab)", "Age (yrs)", width = "95%"),
    selectInput("histlegendposition", "Legend position", choices = c("bottom", "top", "left", "right", "none"), width = "90%"),
    numericInput("histncollegend", "Number of legend columns", value = 5, width = "90%"),
    selectInput("histgraphfont", "Font type", choices = font.family, selected = "Arial", width = "90%"),
    sliderInput("histfontxytitle",
                "Font-size text",
                min = 1,
                max = 50,
                value = 12
    ),
    sliderInput("histfontxyticks",
                "Font-size ticks",
                min = 1,
                max = 50,
                value = 12
    ),
    sliderInput("histfontxystrip",
                "Font-size strip",
                min = 1,
                max = 50,
                value = 12
    ),
    "For downloads:",
    numericInput("histdownimgdpi", "Image dpi", 300, width = "90%"),
    numericInput("histdownimgw", "Image width (px)", 2500, width = "90%"),
    numericInput("histdownimgh", "Image height (px)", 1700, width = "90%"),
    numericInput("histdownimgs", "Image scale", 1, width = "90%"),
    br(),
    downloadButton("histtimedownloadimg", "Download plot", icon = icon("image"), class="downloadbtns")
  ),
  footer = list(
    downloadButton("histtimedownloadimg", "Download plot file (png)", icon = icon("image")),
    downloadButton("histtimedownloadimg2", "Download plot object (ggplot)", icon = icon("image"), class="downloadbtns2"),
    downloadButton("hdownloadhistt2", "Download plot code (R)", icon = icon("code"), class="downloadbtns")
  )
)

