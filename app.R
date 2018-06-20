# library(shiny)
# 
# # Define UI ----
# ui <- fluidPage(
# 
# 
#   
#   titlePanel("Debate SPYDER"),
#   
#   navlistPanel(
#     "Data",
#     tabPanel("Schools"),
#     tabPanel("Cities"),
#     tabPanel("Districts"),
#     tabPanel("States"),
#     tabPanel("People")
#     
#   )
# )
library(shiny)

# Define server logic ----
server <- function(input, output, session) {
  print(session)
}

ui <- fluidPage(
  titlePanel("Debate SPYDER"),
  navlistPanel(
    "Data",
    tabPanel("Schools"),
    tabPanel("Cities"),
    tabPanel("Districts"),
    tabPanel("States"),
    tabPanel("People"),
    mainPanel(
      h1("Welcome to",
         span("Debate SPYDER", style="color:red"),
         align = "center"),
      h3("A website dedicated to helping you",
         span("analyze" ,style="color:red"), "and", span("interpret", style="color:red"), "debate data",
         align = "center"),
      h6("If you know the opponent and know yourself, you need not fear the result of a hundred debate rounds. - Sun Tzu, modified", align = "center"),
      img(src="SPYDER.PNG", height = 600, width = 600, align="center"),
      h4("Credits:")
    )
  )
)
# p('123')

# Run the app ----
shinyApp(ui = ui, server = server)
