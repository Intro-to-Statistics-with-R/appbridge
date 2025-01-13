library(tidyverse)
library(shiny)

summarize_data_app <- function() {

  ui <- fluidPage(
    mod_glimpse_data_ui("dat1")
  )
  server <- function(input, output, session) {

    titanic = read.csv('https://raw.githubusercontent.com/kbodwin/ShinyLabs/master/Datasets/titanic.csv')

    titanic <- titanic |> mutate(
      Survived = factor(Survived)
    )

    titanic <- titanic |> mutate(
      Family.Aboard = Siblings.Spouses.Aboard + Parents.Children.Aboard,
      Passenger.Class = factor(Pclass,
                               levels = c(1,2,3),
                               labels = c("First", "Second", "Third"))
    )

    mod_glimpse_data_server("dat1", titanic)
  }
  shinyApp(ui, server)
}
