# Define server logic that 
# * observes inputs
# * based on changed input, decides which data and objects are affected and need to be recalculated/updated
# * performs all calculations
# * builds and updates the output objects in a list called output

setwd("~/work/bewertungen-founder-calls-2025")

server <- function(input, output, session) {
  # THEME RELATED STUFF -----------------------------------------------------
  
  # switch between light and dark mode
  # use observe if you want to perform an action
  # the code in observe is executed immediately when the used input/reactive objects change
  observe(session$setCurrentTheme(
    if (isTRUE(input$dark_mode)) dark else light
  ))

  # PROCESS INPUTS & DEFINE REACTIVE OBJECTS --------------------------------
  
  # REACTIVE EXPRESSIONS
  # use the reactive expression when you want to calculate a value
  # and the calculation is also consuming other reactive values/expressions (e.g. input, session)
  # using reactiveVal would lead to this error:
  # Can't access reactive value 'url_search' outside of reactive consumer.
  # ref: https://mastering-shiny.org/basic-reactivity.html
  # a reactive expression is like a function, so to access its value, you need to call it like a function
  
  # PERFORMANCE CONSIDERATION
  # don't put things in one reactive expression together that can change independently
  # example: we separate reading the data from redcap from filtering it or changing it according to input
  # in that way, the expensive data access from redcap is performed only once
  # and not repeated with any changes of input elements
  
  # REACTIVE VALUES
  # reactiveVal: define one reactive value
  # reactiveValues: define a list of reactive values similar to the list-like object "input"
  
  #1) Download and process the data ####
  data <- import_redcap_bewertungen(env.deploy)
  processed_data <- process_data_bewertungen(data)
  
  #2) Create a reactive dataframe, that can be updated whenever a button is pressed ####
  #Create the reactive object
  data_react <- reactiveValues(
    processed_data = processed_data,
    results = process_results(processed_data),
    results_detail = process_results_by_criterion(processed_data)
  )
  #Update the data when the button is pressed
  observeEvent(input$update_data, {
    temp <- import_redcap_bewertungen(env.deploy)
    temp <- process_data_bewertungen(temp)
    data_react$processed_data <- temp
    data_react$results <- process_results(temp)
    results_detail = process_results_by_criterion(temp)
  })
  
  #3) Make the output objects for the app ####
  #First create the output datatable
  output$ranglist <- renderDataTable(data_react$results)
  
  #Second, create a barplot with the scores of all the contestants
  output$barplot_all <- renderPlot(create_barplot(data_react$results))
  
  #Third generate a table by evaluation criterion
  output$pointlist_all <- renderDataTable(data_react$results_detail)
  
  #Fourth, a figure with the scores by criterion
  output$pointplot_all <- renderPlot(create_barplot_criteria(data_react$results_detail))
}
