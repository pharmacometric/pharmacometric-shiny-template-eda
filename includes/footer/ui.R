############################################################################
############################################################################
##  Document Path: includes/footer/ui.R
##
##  Description: UI for footer
##
##  R Version: R version 4.4.1 (2024-06-14 ucrt)
##
#############################################################################
#############################################################################



# include footer UI if needed

footer.main <- footerPanel(div(
  "We use cookies to enhance the functionality of this shiny app, enabling you to seamlessly interact with features such as input-driven graph and table creation, as well as code analysis based on your uploaded files. These cookies help us optimize your experience by understanding site performance, adapting content to your preferences and location, and providing more relevant and personalized outputs. For further details, please review our Privacy Policy and Cookie Policy.",
  br(),actionButton("closecookiesform","Accept all cookies", class="pull-right"), hr(),class="padding-10")
  , bg.col = "#333333" )
