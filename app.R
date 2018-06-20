
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
    h1(span("Debate SPYDER", style = "color:#d00000"),
       align = "center"),
    p(
      "A website dedicated to helping you",
      span("analyze" , style = "color:#d00000 "),
      "and",
      span("interpret", style = "color:#d00000"),
      "debate data",
      align = "center",
      style="font-size:25px"
    ),
    p(
      "If you know the opponent and know yourself, you need not fear the result of a hundred debate rounds. - Sun Tzu, modified",
      align = "center",
      style="font-size:15px"
    ),
    img(
      src = "https://cdn.samyok.us/SPYDER.png",

      style="display: block; margin-left: auto; margin-right: auto; width=100%"

    ),
    h4("Credits:")
  )),
  navbarMenu(
    "Search",
    tabPanel("Schools",
             textInput("schoolsearch", label = "School Search"),
             actionButton("schoolsearchbutton", label = "Go")
    ),
    tabPanel("Competition", 
             textInput("competitionsearch", label = "Competition Search"),
             actionButton("competitionsearchbutton", label = "Go")
    ),
    tabPanel("Individuals", 
             textInput("individualsearch", label = "Individual Search"),
             actionButton("individualsearchbutton", label = "Go")
    )
  ),
  tabPanel("Info",
           h1("Information"),

           h3(span("Schools", style="color:red")),
           p("View any school's details and statistics.", style="font-size:20px" ),
           h3(span("Competition", style="color:red")), 
           p("Copy and paste the list of your competitors to analyze all of their statistics at once, including state, district, school, and points.",  style="font-size:20px" ),
           h3(span("Individuals", style = "color:red")),
           p("Search for any individual and view details and statistics.",  style="font-size:20px")
           ),
  tabPanel(
    textOutput("log_text"),
    inline = TRUE,
    textInput("unames", "Username:"),
    passwordInput("password", "Password:"),
    actionButton("go", "Go"),
    verbatimTextOutput("value")
  ),
  inverse = TRUE,
  collapsible = TRUE,
  includeCSS("app.css")
)

# Run the app ----
shinyApp(ui = ui, server = server
)
