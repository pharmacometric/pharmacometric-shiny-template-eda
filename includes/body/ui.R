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

body.main <- moveable(
  body.model.info, # model infor panel # ui.part1.R
  body.panel.left, # sims setup panel # ui.part2.R
  body.panel.right # sims output panel # ui.part3.R
)
