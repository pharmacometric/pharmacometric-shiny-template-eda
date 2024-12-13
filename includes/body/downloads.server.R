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


#############################################################################
###  SECTION: Concentration verus time plots
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

# download c vs t ggplot object
output$concvtimedownloadimg2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-obj.data")
  },
  content = function(con) {
    tsfd_plot = GLOBAL$concvtimeplot1
    tsld_plot = GLOBAL$concvtimeplot2
    save(tsfd_plot,tsld_plot, file = con)
  }
)


# download c vs t code
output$cdownloadconcvt2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-tsfd-code.R.zip")
  },
  content = function(con) {
    # get template
    codetempl0 = readLines(print(GLOBAL$code.convtm.tpl))

    # directory to store all
    dirn = tempdir()
    lapply(list.files(dirn,full.names = T, recursive = T), function(i) unlink(i))
    #unlink(dirn, recursive = TRUE)

    GRAPHTYPE1 = switch(input$cgraphtype,
                        "1"="overall-line",
                        "2"="overall-scatter",
                        "3"="overall-summarized",
                        "4"=paste0("facet-line-",tolower(input$cfacetvar)),
                        "5"=paste0("facet-scatter-",tolower(input$cfacetvar)),
                        "6"=paste0("facet-summarise-",tolower(input$summby)),
                        "7"="indiv-line",
                        "8"="indiv-scatter")

    for(gtype in list(
      c("dv-tsfd","Time since first dose","with"),
      c("dv-tsld","Time since last dose","with2")
    )){
    # code string
    codetempl = codetempl0
    # graph type
    GRAPHTYPE2 = gtype[1]
    TYMEVAR0 = gtype[2]
    ITYPE = gtype[3]

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
        "5" = {
          codetempl <<- gsub(g["srh"], input[[g[ITYPE]]], codetempl)
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

    writeLines(codetempl,file.path(dirn,paste0("drugName_",GRAPHTYPE1,"_",GRAPHTYPE2,"_v1.R")))
    }



    write.csv(GLOBAL$data.versions[[input$datatoUseconc1]],file.path(dirn,GLOBAL$data.orig.filename), row.names = FALSE)

    files2zip <- list.files(dirn, full.names = TRUE,pattern = ".R|.csv")
    zip(zipfile = con, files = files2zip)
  }
)



#############################################################################
###  SECTION: Histogram of body weight and age plots
#############################################################################

# download hist plot
output$histtimedownloadimg <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-concvs-img.png")
  },
  content = function(con) {
    ggsave(
      con,
      plot=GLOBAL$histwtplot1,
      dpi = input$downimgdpi,
      width = input$downimgw,
      height = input$downimgh,
      scale = input$downimgs,
      units = "px"
    )
  }
)

# download hist ggplot object
output$histtimedownloadimg2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-eda-hist-obj.data")
  },
  content = function(con) {
    hist_wt_plot = GLOBAL$histwtplot1
    hist_age_plot = GLOBAL$histageplot2
    save(hist_wt_plot,hist_age_plot, file = con)
  }
)






#############################################################################
###  SECTION: Download demographic table
#############################################################################


output$dtabdownloadimg <- downloadHandler(
  filename = function() {
    fAddDate("app1-demog-summ-table-v1.docx")
  },
  content = function(con) {
    t1flex(GLOBAL$demo.table.out) %>% save_as_docx(path=con)
  }
)



output$dtabtimedownloadimg2 <- downloadHandler(
  filename = function() {
    fAddDate("app1-demog-summ-table-v1.data")
  },
  content = function(con) {
    demog_tbl = GLOBAL$demo.table.out
    save(demog_tbl, file = con)
  }
)
#############################################################################


































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
