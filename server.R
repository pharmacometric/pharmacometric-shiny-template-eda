############################################################################
############################################################################
##
##  NO NEED TO ALTER THIS PAGE
##
##  Document: server.R
##
##  Description: Assemble all server functions from the "includes" folder
##
##  R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################


server = function(input, output, session) {

  # include all required server files for head, body and footer

  for (server_each in c(
    "includes/header",
    "includes/body",
    "includes/footer"
  )) {
    source.part(
      path = server_each,
      which = "server",
      input, output, session
    )
  }
}
