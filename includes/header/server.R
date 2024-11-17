message(this.path)
observeEvent(input$aboutproject, {
  showModal(modalDialog(
    title = "About this app",
    "This data exploration app was created by William 2024. Use freely."
  ))
})
