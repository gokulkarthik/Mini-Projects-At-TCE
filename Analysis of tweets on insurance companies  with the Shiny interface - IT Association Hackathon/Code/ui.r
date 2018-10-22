library("shiny")
library("shinythemes")

shinyUI(
  
  fluidPage(
    shinythemes::themeSelector(),
    titlePanel(title = "Soothsayer"),
    sidebarLayout(
      
      sidebarPanel(
        
        selectInput("country","Select your country",c("India","Pakisthan","China"),selected = "India"),
        selectInput("agency","Select Insurance Agency",c("LIC","Star","Birla","Kotak","Exide"),selected=NULL),
        tags$hr(),
        h3("Top Reveiwers award!!!"),
        tags$img(src='cup1.jpg',width=350,height=150),
       htmlOutput("rev"),
        htmlOutput("no"),

       htmlOutput("rev1"),
       htmlOutput("no1"),
       htmlOutput("rev2"),
       htmlOutput("no2"),
        tags$hr()
      ),
      
      mainPanel(
        
        tabsetPanel(type = "tabs", 
                    tabPanel("Raw Tweets",tableOutput("raw")), 
                    
                    tabPanel("Word bag",
                             h3("high frequency words"),verbatimTextOutput("fr1"),
                             tags$hr(),
                             tags$br(),
                             h3("low frequency words"),verbatimTextOutput("fr2")
                             ),
                   tabPanel("Word cloud",img(src="Rplot.png"),
                            textOutput("glo")
                            ),
                    tabPanel("Chart",plotOutput("ploto1")),
                   tabPanel("Word Association",
                            h3("Word Association of the most frequent word..."),
                            h4("Premium"),
                            verbatimTextOutput("b1"),
                   h4("Invest"),
                   verbatimTextOutput("b2"),
        h4("Service"),
        verbatimTextOutput("b3"),
      h4("Health"),
      verbatimTextOutput("b4"),
    h4("Benefit"),
    verbatimTextOutput("b5")),
                   
                   tabPanel("Helpful Tweets",tableOutput("help"))
                    
        )
      )
    )
    
  )
  
  
)