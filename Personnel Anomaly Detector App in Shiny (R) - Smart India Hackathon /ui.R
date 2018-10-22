library(shiny)
library(shinythemes)

shinyUI(fluidPage(
  #theme = shinytheme("darkly"),
  shinythemes::themeSelector(),
  # Application title
  titlePanel("Personnel Anomaly Detector"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
      checkboxInput("header", "Header", TRUE),
      tags$hr(),
      code(" Data Range is applicable for the Outliers and the Defaulters tabs"),
      dateRangeInput("dateRange1", "Select the Date Range ", start = "2016-01-01", end = "2016-01-01", format = "dd-mm-yy"),
      #actionButton("act1", "Apply Date Range", icon("paper-plane"), 
      # style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
      hr(),
      code("The following Date Value is only applicable for the Attendance"),
      dateInput("date1", "Select the Date", "2016-01-08",format = "dd-mm-yy"),
      hr(),
      helpText("Download the sample RFID Data of BARC and UPLOAD to Experience! :)"),
      tags$a(href = "https://drive.google.com/open?id=0B7_FhE9zZlEaTm5Gc0R5Sml2VG8", "Download Sample Data Here!", target = "_blank")
      #downloadLink("dw1", "DOWNLOAD SAMPLE DATA")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Raw Data", tableOutput("content1")), 
                  tabPanel("Prepared Data", tableOutput("content2")),
                  tabPanel("Outliers",
                           h3("Box Plot of Outliers"),
                           plotOutput("plot0"),
                           h3("LATE COMERS"),
                           verbatimTextOutput("text1"), 
                           downloadButton("d1", "Late Comers File"),
                           plotOutput("plot1"), 
                           h3("EARLY GOERS"),
                           verbatimTextOutput("text2"),
                           downloadButton("d2", "Early Goers File"),
                           plotOutput("plot2")),
                  tabPanel("Defaulters",
                           h3("In Time Defaulters"),
                           verbatimTextOutput("text3"),
                           h3("Out Time Defaulters"),
                           verbatimTextOutput("text4")
                           ),
                  tabPanel("Attendance",
                           h2("Pie Chart(Attendance)"),
                           hr(),
                           plotOutput("pie1"),
                           h3("Presentees"),
                           verbatimTextOutput("text5"),
                           hr(),
                           h3("Absentees"),
                           verbatimTextOutput("text6"),
                           hr()
                           ),
                  tabPanel("Performance",
                           h3("Tab Under Construction <>......*_*"))
      )
      #tableOutput("contents")
    )
  )
))
