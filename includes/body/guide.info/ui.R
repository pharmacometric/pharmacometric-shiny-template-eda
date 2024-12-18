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

body.model.info = card.pro(
  title = "Guide for using the exploratory data analysis app", width = 12,
  header.bg = "redLight",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = FALSE,
  collapsed = 1L,
  shadow = FALSE,
  shiny::includeMarkdown(file.path(this.path, "model_information.md"))
)
