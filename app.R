library(shiny)
library(xtable)
source("nsda.R")
# Define server logic ----
server <- function(input, output, session) {
  logged_in <- FALSE
  output$login_errors <- renderText({
    "Login Please."
  })
  output$log_text <- renderText({
    "Login"
  })
  ## LOGIN ========================================================M
  observeEvent(input$login_btn, {
    #
    output$login_errors <- renderText({
      #
      "Loading..."                                                 #
    })                                                             #
    if (NSDAlogin(input$uname,
                  #
                  input$password,
                  #
                  concat('cookies/', session$token))) {
      #
      logged_in = TRUE                                             #
      output$log_text <- renderText({
        #
        if (logged_in) {
          #
          "Logout"
        } else {
          "Login"
        }
      })
      output$login_errors <- renderText({
        #
        "Logged In!"                                               #
      })                                                           #
    } else {
      #
      output$login_errors <- renderText({
        #
        "Login Failed!"                                            #
      })                                                           #
    }                                                              #
  })                                                               #
  ## /LOGIN =======================================================W
  
  observeEvent(input$individualsearchbutton, {
    x = NSDAMember(
      NSDASearch(
        input$individualsearch,
        cookies =  concat('cookies/', session$token)
      )[1, 1],
      concat('cookies/', session$token)
    )
    print(x)
    output$individuals <- renderTable(x)
  })
  observeEvent(input$competitionbtn, {
    ppl = as.list(strsplit(input$competitionsearch, "\\n")[[1]])
    final = data.frame()
    for(i in 1:length(ppl)){
      peopleWithSameName =NSDASearch(ppl[[i]][1])
      for(j in 1:nrow(peopleWithSameName)){
        member = NSDAMember(peopleWithSameName[j, 'id'], cookies= "cookies/1")
        x = NSDAPoints(peopleWithSameName[j,1],cookies="cookies/1")
        
        new = c("threat level"=NSDAthreatScore(x = x, member = member))
        rbind(final, new)
      }
    }
    output$competition <- renderDataTable(final)
  })
}

ui <- navbarPage(
  id = "home",
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
      style = "font-size:25px"
    ),
    p(
      "If you know the opponent and know yourself, you need not fear the result of a hundred debate rounds. - Sun Tzu, modified",
      align = "center",
      style = "font-size:15px"
    ),
    img(src = "http://cdn.samyok.us/SPYDER.png",
        
        style = "display: block; margin-left: auto; margin-right: auto; width=100%"),
    h4("Credits:")
  )),
  navbarMenu(
    "Search",
    tabPanel(
      "Schools",
      textInput("schoolsearch", label = "School Search", placeholder = "Search here..."),
      actionButton("schoolsearchbutton", label = "Go"),
      tableOutput('schools')
    ),
    tabPanel(
      "Competition",
      selectInput(
        "competitionType",
        h3("Debate Type"),
        choices = list(
          "Lincoln-Douglas Debate" = 102,
          "Policy Debate" = 104,
          "Public Forum Debate" = 103
        ),
        selected = 103
      ),
      textAreaInput(
        "competitionsearch",
        label = "Competition Search",
        height = "300px",
        width = "900px"
      ),
      actionButton("competitionbtn", label = "Go"),
      dataTableOutput('competition')
      ),
      tabPanel(
        "Threats",
        textInput("threatsearch", h3("Name")),
        selectInput(
          "selectdebate",
          h3("Debate Type"),
          choices = list(
            "Lincoln-Douglas Debate" = 102,
            "Policy Debate" = 104,
            "Public Forum Debate" = 103
          ),
          selected = 103
        ),
        actionButton("threatsearchbutton", label = "Go")
      ),
      tabPanel(
        "Individuals",
        textInput("individualsearch", label = "Individual Search", placeholder = "Search here..."),
        actionButton("individualsearchbutton", label = "Go"),
        tableOutput('individuals')
      )
    ),
    tabPanel(
      "Info",
      h1("Information"),
      h2("Search"),
      h3(span("Schools", style = "color:#d00000")),
      p("View any school's details and statistics.", style = "font-size:20px"),
      h3(span("Competition", style = "color:#d00000")),
      p(
        "Copy and paste the list of your competitors to analyze all of their statistics at once, including state, district, school, and points.",
        style = "font-size:20px"
      ),
      h3(span("Individuals", style = "color:#d00000")),
      p(
        "Search for any individual and view details and statistics.",
        style = "font-size:20px"
      ),
      h2("Threat Algorithm"),
      p(
        "To view someone's threat rating, search up his/her name in the Threats page and specify the debate type.
        We can give a threat ranking in each of the three main types of debate: Lincoln-Douglas Debate, Policy Debate, and Public Forum Debate.",
        style = "font-size:20px"
      ),
      p(
        "Our threat algorithm incorporates statistics including but not limited to points in the debate category,
        number of years of participation, win/loss ratio, and number of Nationals points.",
        style = "font-size:20px"
      ),
      p(
        "Increasing your threat rating all comes down to putting more time, effort, and practice into debate.",
        style = "font-size:20px"
      ),
      p(
        "Keep in mind that this algorithm's output is not perfect.
        Just because your rating is higher or lower than another person does",
        strong("not"),
        "mean that you will definitely win or lose, respectively.
        This is because there is always an element of luck and chance in debate rounds, and our algorithm, like everything else, can not predict winners.
        The rating's purpose is to give you a rough estimate of your opponent's level and for entertainment.
        How seriously you take it is entirely up to you, just like how seriously you take NSDA points.",
        style = "font-size:20px"
      ),
      p(
        "Finally, never underestimate or overestimate your opponents. Good luck!",
        style = "font-size:20px"
      ),
      h2("Topics"),
      p(
        "In this page, we will list the current Big Questions, Lincoln-Douglas, Policy, and Public Forum resolutions when available.
        When the Nationals topics come out, we will also list the World Schools Debate resolutions.",
        style = "font-size:20px"
      ),
      h2("Login"),
      p(
        "Login using your National Speech and Debate Association credentials.
        We do not collect your login information.",
        style = "font-size:20px"
      )
    ),
    tabPanel(
      textOutput("log_text"),
      inline = TRUE,
      textInput("uname", "Username:"),
      passwordInput("password", "Password:"),
      actionButton("login_btn", "Go"),
      h3(textOutput("login_errors"), style = "color:red")
    ),
    inverse = TRUE,
    collapsible = TRUE,
    includeCSS("http://cdn.samyok.us/app.css")
      )
  options("shiny.port" = 8000)
  # Run the app ----
  shinyApp(ui = ui,
           server = server)
  