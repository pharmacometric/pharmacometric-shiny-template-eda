############################################################################
############################################################################
##  Document Path: includes/body/downloads.server.R
##
##  Description: All server outputs for downloads of images and scripts
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################

# download c vs t plot
output$concvtimedownloadimg = downloadHandler(
  filename = function() {
    fAddDate('app1-eda-concvs-img.png')
  },
  content = function(con) {
    ggsave(
      con,
      dpi = input$downimgdpi,
      width = input$downimgw,
      height = input$downimgh,
      scale = input$downimgs,
      units = 'px'
    )
  }
)

# download c vs t data
output$concvtimedownloadimg2 = downloadHandler(
  filename = function() {
    fAddDate('app1-eda-concvs-obj.data')
  },
  content = function(con) {
    figx = last_plot()
    save(figx, file = con)
  }
)


# download c vs t code
output$cdownloadconcvt2 = downloadHandler(
  filename = function() {
    fAddDate('app1-eda-concvs-tsfd-code.R')
  },
  content = function(con) {
    print(code.convtsfd.tpl)
    codetempl = readLines(code.convtsfd.tpl)
    codetempl = gsub("\\{SCRIPTDATA\\}",input[["datatoUseconc1"]],codetempl)
    writeLines(codetempl,con)
  }
)




output$downloadtable1 = downloadHandler(
  filename = function() {
    fAddDate('app1-res-summ-all.csv')
  },
  content = function(con) {
    write.csv(summary02(), con)
  }
)


# download individual summaries
output$downloadtable1 = downloadHandler(
  filename = function() {
    paste0('app1-res-summ-indv-', Sys.Date(), '.csv')
  },
  content = function(con) {
    write.csv(summary01(), con)
  }
)


# download regimen used for sims
output$downloadtable3 = downloadHandler(
  filename = function() {
    fAddDate('app1-res-regimen.csv')
  },
  content = function(con) {
    write.csv(data01(), con)
  }
)


# download individual summaries
output$downloadtable4 = downloadHandler(
  filename = function() {
    fAddDate('app1-raw_tab_res.csv')
  },
  content = function(con) {
    write.csv(GLOBAL$lastsim, con)
  }
)
