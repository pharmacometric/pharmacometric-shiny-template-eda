#########################################################################################
#########################################################################################
##
##  Document Path: global.R
##
##  R version: 4.2.0 (2022-04-22)
##
##  Program purpose: Global library loads, prep environment and load libs
##
#########################################################################################
#########################################################################################



# clear console, set dir, load libs and load files
quickcode::clean(source = c("utils.R"), clearPkgs = 1L)

# load libraries
libs = c("shiny","shinyjs","rhandsontable","DT","flextable","nlme","markdown","tibble","card.pro","dplyr","ggplot2","magrittr","mrgsolve","quickcode","patchwork","table1","r2resize","rlang","grid","ggthemes")
lapply(libs, function(l)library(l,character.only=1L))

# add all individual utils
for (ui_each in c(
  "includes/header",
  "includes/body",
  "includes/footer"
)) {
  this.path = ui_each
  source(file.path(ui_each,"libs.R"), local = T)
}


# declare the global reactive values holder
GLOBAL= reactiveValues()
GLOBAL$lastsim = NULL
GLOBAL$start.sim = FALSE
seed.val = 67772
GLOBAL$objects = NULL
GLOBAL$data.orig.filename = NULL
GLOBAL$data.versions = list("original" = data.frame(),"dataV2" = data.frame(),"dataV3" = data.frame())
data.versions.names = c("original","dataV2","dataV3")
