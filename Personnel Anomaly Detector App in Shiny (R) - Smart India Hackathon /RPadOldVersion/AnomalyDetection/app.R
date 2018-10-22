#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Personnel Anomaly Detector"),
   
   # Sidebar with file input 
   sidebarLayout(
     sidebarPanel(
       fileInput("file1", "Choose CSV File",
                 accept = c(
                   "text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")
       ),
       tags$hr(),
       checkboxInput("header", "Header", TRUE)
     ),
     mainPanel(
       textOutput("struct"),
       tableOutput("contents")
     )
      
      
   )
))


server <- function(input, output) {
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read.csv(inFile$datapath, header = input$header)
    
  })
  #output$struct <- str(inFile$datapath)
}


# Run the application 
shinyApp(ui = ui, server = server)

