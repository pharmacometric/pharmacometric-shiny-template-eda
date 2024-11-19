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

body.model.info <- card.pro(
  title = "Guide for using EDA app", width = 12,
  header.bg = "red",
  removebtn = FALSE,
  colorbtn = FALSE,
  expandbtn = FALSE,
  editbtn = FALSE,
  collapsed = TRUE,
  shadow = FALSE,
  shiny::includeMarkdown(file.path(this.path, "model_information.md"))
)
