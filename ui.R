# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = light,
  
  # Application title
  titlePanel("Founder-Call 2023: Bewertungen"),
  
  # Sidebar: put Input Elements here
  sidebarLayout(
    sidebarPanel( 
      helpText(
        "Klicken Sie auf die 'Update'-Button, um die Daten zu aktualisieren."
      ),
      br(),
      actionButton(
        inputId = "update_data",
        label="Update"
      )
      
    ),
    
    # Panel to show all your outputs inside
    # Each of the *Output functions require a single argument: 
    # a character string that Shiny will use as the name of your reactive element. 
    # Your users will not see this name.
    # It is the name that connects output element in the UI and the
    # object that you want to display and that is calculated in the server.R
    # Possible outputs are:
    # dataTableOutput: DataTable
    # htmlOutput:	raw HTML
    # imageOutput:	image
    # plotOutput:	plot
    # tableOutpu:t	table
    # textOutput:	text
    # uiOutput:	raw HTML
    # verbatimTextOutput:	text
    mainPanel(
      tabsetPanel(
        tabPanel("Rangfolge der Bewertungen",
                 h3("Rangfolge"),
                 dataTableOutput("ranglist"),
                 br(),
                 h3("Grafik der Rangliste"),
                 plotOutput("barplot_all", height="500px")
        ),
        tabPanel("Aufschlüsselung nach Bewertungskriterium",
                 h3("Bewertungen nach Kriterium"),
                 dataTableOutput("pointlist_all"),
                 br(),
                 h3("Grafik der Bewertungen nach Kriterium"),
                 plotOutput("pointplot_all", height="750px")
        )
      )
    )
    
  )
)
