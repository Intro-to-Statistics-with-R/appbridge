library(tidyverse)
library(shiny)

mod_glimpse_data_ui <- function(id) {
  ns <- NS(id)
  tagList(
    radioButtons(NS(id, "glimpse"),
                 "What information about the dataset would you like?",
                 choices = c(
                   "Just show me the whole thing!" = "raw",
                   "Show me the first five rows only." = "head",
                   "Show me the last five rows only." = "tail",
                   "Show me a list of the variables and their types." = "glimpse",
                   "Calculate some summaries for each variable." = "summary"

                 )),
    verbatimTextOutput(NS(id, "glimpse_code")),
    textOutput(NS(id, "glimpse_result"))
  )
}

#' glimpse_data Server Functions
#'
#' @noRd
#' @export
mod_glimpse_data_server <- function(id, titanic){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$glimpse_code <- renderPrint(switch(
      input$glimpse,
      raw = "titanic",
      head = "head(titanic, 5)",
      tail = "tail(titanic, 5)",
      glimpse = "glimpse(titanic)",
      summary = "summary(titanic)"
    ))

    output$glimpse_result <- renderPrint({
      glimpse(titanic)
      #eval(parse(text = input$glimpse_code))
    })
  })
}


#summarize_data_app <- function() {

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
#}
