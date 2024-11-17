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


# load libraries
library(shiny)
library(shinyjs)
library(rhandsontable)
library(DT)
library(flextable)
library(nlme)
library(markdown)
library(card.pro)
library(dplyr)
library(ggplot2)
library(magrittr)
library(mrgsolve)
library(quickcode)
library(patchwork)
library(table1)

# clear console, set dir, load libs and load files
clean(source = c("utils.R"))



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
GLOBAL<- reactiveValues()
GLOBAL$lastsim <- NULL
GLOBAL$start.sim <- FALSE
seed.val <- 67772
