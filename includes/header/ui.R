header.main = titlePanel(tags$div(
  tags$img(src="logo.jpg")," ",
  "Exploratory Data Analysis for Drug AFR",
  tags$div(class = "hidden-mobile hidden-tablet pull-right",
             actionButton("aboutproject", "", icon = icon("question")))
), windowTitle = "Exploratory Data Analysis")
