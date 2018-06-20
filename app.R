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
      height = 600,
      width = 600,
      align = "center"
    ),
    h4("Credits:")
  )),
  navbarMenu(
    "Search",
    tabPanel("Schools", "SCHOOLS"),
    tabPanel("Cities", "CITIES"),
    tabPanel("Districts", 'DISTRICTS'),
    tabPanel("States", 'STATES'),
    tabPanel("People", "PEOPLE")
  ),
  tabPanel("Info", "INFORMATION"),
  tabPanel(textOutput("log_text"), inline = TRUE, "LOGIN"),
  inverse = true,
  collapsible = TRUE

)
# p('123')

# Run the app ----
shinyApp(ui = ui, server = server)
