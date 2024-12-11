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
output$concvtimedownloadimg <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-img.png")
  },
  content = function(con) {
    ggsave(
      con,
      dpi = input$downimgdpi,
      width = input$downimgw,
      height = input$downimgh,
      scale = input$downimgs,
      units = "px"
    )
  }
)

# download c vs t data
output$concvtimedownloadimg2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-obj.data")
  },
  content = function(con) {
    figx <- last_plot()
    save(figx, file = con)
  }
)


# download c vs t code
output$cdownloadconcvt2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-tsfd-code.R.zip")
  },
  content = function(con) {
    # get template
    codetempl <- readLines(print(GLOBAL$code.convtsfd.tpl))

    # graph type
    GRAPHTYPE1 = "dv-tsfd"
    GRAPHTYPE2 = "all-line"

    # walk through replacements
    apply(subset(code_download_checks_df), 1, function(g) {
      #print(g)
      switch(g["rpl"],
        "0" = {
          codetempl <<- gsub(g["srh"], g["with"], codetempl)
        },
        "1" = {
          codetempl <<- gsub(g["srh"], input[[g["with"]]], codetempl)
        },
        "2" = {
          eval(parse(text = paste0(".clogic=input$",g['with']," %in% ",g['with2'])))
          if(.clogic) codetempl <<- gsub(g['srh'],"",codetempl)
          else codetempl <<- codetempl[!grepl(g['srh'], codetempl)]
        },
        "4" = {
          if (not.empty(g["with2"])) {
            codetempl <<- gsub(g["srh"], GLOBAL[[g["with"]]][[input[[g["with2"]]]]], codetempl)
          } else {
            codetempl <<- gsub(g["srh"], GLOBAL[[g["with"]]], codetempl)
          }
        },
        "3" = {
          codetempl <<- gsub(g['srh'],get(g['with']),codetempl)
        }
      )
    })


    dirn = tempdir()
    #unlink(dirn, recursive = TRUE)
    write.csv(GLOBAL$data.versions[[input$datatoUseconc1]],file.path(dirn,GLOBAL$data.orig.filename))
    writeLines(codetempl,file.path(dirn,"code.R"))
    files2zip <- list.files(dirn, full.names = TRUE,pattern = ".R|.csv")
    zip(zipfile = con, files = files2zip)
  }
)




output$downloadtable1 <- downloadHandler(
  filename = function() {
    fAddDate("app1-res-summ-all.csv")
  },
  content = function(con) {
    write.csv(summary02(), con)
  }
)


# download individual summaries
output$downloadtable1 <- downloadHandler(
  filename = function() {
    paste0("app1-res-summ-indv-", Sys.Date(), ".csv")
  },
  content = function(con) {
    write.csv(summary01(), con)
  }
)


# download regimen used for sims
output$downloadtable3 <- downloadHandler(
  filename = function() {
    fAddDate("app1-res-regimen.csv")
  },
  content = function(con) {
    write.csv(data01(), con)
  }
)


# download individual summaries
output$downloadtable4 <- downloadHandler(
  filename = function() {
    fAddDate("app1-raw_tab_res.csv")
  },
  content = function(con) {
    write.csv(GLOBAL$lastsim, con)
  }
)
