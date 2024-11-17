output$downloadimg2 <- downloadHandler(
  filename = function() {
    paste0('app1-res-image-', Sys.Date(), '.png')
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


output$downloadtable1 <- downloadHandler(
  filename = function() {
    paste0('app1-res-summ-all-', Sys.Date(), '.csv')
  },
  content = function(con) {
    write.csv(summary02(), con)
  }
)


# download individual summaries
output$downloadtable1 <- downloadHandler(
  filename = function() {
    paste0('app1-res-summ-indv-', Sys.Date(), '.csv')
  },
  content = function(con) {
    write.csv(summary01(), con)
  }
)


# download regimen used for sims
output$downloadtable3 <- downloadHandler(
  filename = function() {
    paste0('app1-res-regimen-', Sys.Date(), '.csv')
  },
  content = function(con) {
    write.csv(data01(), con)
  }
)


# download individual summaries
output$downloadtable4 <- downloadHandler(
  filename = function() {
    paste0('app1-raw_sims_res-', Sys.Date(), '.csv')
  },
  content = function(con) {
    write.csv(GLOBAL$lastsim, con)
  }
)
