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

  title = "Covariate Correlation Plots & Tables",
  header.bg = "blueLight",
  icon = icon("chart-simple"),
  editbtn = 1L,
  collapsed = 1L,
  div(
    id = "reptcorrcstatus1",
    tags$blockquote(style = "color:blue", "Tabs: Continuous refers to the correlation of continuous variables and Categorical refers to the categorical covariates comparison")
  ),
  tabs = list(
    tabEntry(
      "Continuous",
      column(width=4,class ="p-0",selectInput("datatoUseconcv1", "Data version to use:", choices = c())),
      column(width=8,class ="p-0",selectInput("corrcectouse","Variables to use", choices = c(), multiple = 1L, width = "100%")),
      plotOutput("corrcovplots1", height = 600)

    ),
    tabEntry(
      "Categorical",
      r2resize::splitCard(
        tableOutput("corrccrfgtbl"),
        tags$code('Code for the table ...'),
        position = "vertical",
        left.width = "90%"
      )

    )
  ),
  sidebar = div(
    tags$label("Table settings"),
    selectInput("corrcdemgraphtype", "Graph type", choices = c(
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
    downloadButton("corrcwnloadtable1", "Download summaries", icon = icon("download"), width = "90%"),
    br(), br(),
    downloadButton("corrcwnloadtable2", "Download individuals", icon = icon("download"), width = "90%"),
    br(), br(),
    downloadButton("corrcwnloadtable3", "Download regimen", icon = icon("download"), width = "90%"),
    br(), br(),
    "Download raw output from simulation",
    downloadButton("corrcwnloadtable4", "Download raw result", icon = icon("download"), width = "90%")
  ),
  footer = list(
    downloadButton("vtabdownloadimg", "Download plot file (ggplot)", icon = icon("image")),
    downloadButton("vtabtimedownloadimg2", "Download plot object (table1)", icon = icon("image"), class="downloadbtns2"),
    downloadButton("vtabndloadconcvt2", "Download plot code (R)", icon = icon("code"), class="downloadbtns")
  )
)

