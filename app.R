if (interactive()) {
  ui <- fluidPage(
    textInput("password", "Username:"),
    passwordInput("password", "Password:"),
    actionButton("go", "Go"),
    verbatimTextOutput("value")
    
  )
  server <- function(input, output) {
    output$value <- renderText({
      req(input$go)
      isolate(input$password)
    })
  }
  shinyApp(ui, server)
}
# library(shiny)


library(shiny)

# Define server logic ----
server <- function(input, output, session) {
  logged_in <- FALSE
  output$log_text <- renderText({
    if (logged_in) {
      "Logout"
    } else {
      "Login"
    }
  })
}

ui <- navbarPage(
  "Debate SPYDER",
  tabPanel("Home", fillPage(
    h1("Welcome to",
       span("Debate SPYDER", style = "color:red"),
       align = "center"),
    h3(
      "A website dedicated to helping you",
      span("analyze" , style = "color:red"),
      "and",
      span("interpret", style = "color:red"),
      "debate data",
      align = "center"
    ),
    h6(
      "If you know the opponent and know yourself, you need not fear the result of a hundred debate rounds. - Sun Tzu, modified",
      align = "center"
    ),
    img(
      src = "SPYDER.PNG",
      style="display: block; margin-left: auto; margin-right: auto;"
    ),
    h4("Credits:")
  )),
  navbarMenu(
    "Search",
    tabPanel("Schools",
             textInput("schoolsearch", label = "School Search"),
             actionButton("schoolsearchbutton", label = "Go")
             ),
    tabPanel("Cities", 
             textInput("citysearch", label = "City Search"),
             actionButton("citysearchbutton", label = "Go")
             ),
    tabPanel("Districts", 
             textInput("districtsearch", label = "District Search"),
             actionButton("districtsearchbutton", label = "Go")
             ),
    tabPanel("States", 
             textInput("statesearch", label = "State Search"),
             actionButton("statesearchbutton", label = "Go")
             ),
    tabPanel("People", 
             textInput("peoplesearch", label = "People Search"),
             actionButton("peoplesearchbutton", label = "Go")
             )
  ),
  tabPanel("Info", "INFORMATION"),
  tabPanel(
    textOutput("log_text"),
    inline = TRUE,
    textInput("unames", "Username:"),
    passwordInput("password", "Password:"),
    actionButton("go", "Go"),
    verbatimTextOutput("value")
  ),
  inverse = TRUE,
  collapsible = TRUE
  
)
# p('123')

# Run the app ----
shinyApp(ui = ui, server = server
)
