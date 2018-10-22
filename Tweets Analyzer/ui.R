#ui
library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  #theme = shinytheme("darkly"),
  shinythemes::themeSelector(),
  # Application title
  titlePanel("Tweets Analyser"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      selectInput("topic","Select any topic",c("Delhi Pollution"="dp","Mumbai Rains"="mr")),
      tags$hr(),
      #1
      h3("Top Tweeters"),
      htmlOutput("tweeter_1"),
      htmlOutput("no_1"),
      htmlOutput("tweeter_2"),
      htmlOutput("no_2"),
      htmlOutput("tweeter_3"),
      htmlOutput("no_3"),
      tags$hr(),
      width = 3
    ),
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  #1
                  tabPanel("Raw Data",
                           h3("Sample data of 20 rows"),
                           tableOutput("table1")
                  ),
                  #2
                  tabPanel("Popular Words",
                           h3("High Frequency Words"),verbatimTextOutput("vtext1"),
                           tags$hr(),
                           plotOutput("plot1")
                           
                  ),
                  #3
                  tabPanel("Top #tags", tableOutput("table2")),
                  #4
                  tabPanel("Distributions",
                           plotOutput("dist1"),
                           tags$hr(),
                           plotOutput("dist2"),
                           tags$hr(),
                           plotOutput("dist3"),
                           tags$hr()
                  ),
                  #5
                  tabPanel("Popular Tweets", tableOutput("popular")),
                  #6
                  tabPanel("Word Cloud",plotOutput("plot2")), 
                  #7
                  tabPanel("Geo View", uiOutput("geoplot")),
                  #8
                  tabPanel("Social Network", 
                           uiOutput("socnet"),
                           tags$hr(),
                           h3("Popular Users"),
                           h5("- Users with high indegree"),
                           tableOutput("table3")
                  )
      )
    )
  )
))

