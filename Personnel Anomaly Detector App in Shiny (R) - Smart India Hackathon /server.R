library(shiny)
library(plotrix)

shinyServer(
  function(input, output) {
    
    #Global
    pres <- c()
    abs <- c()
    
    atten <- reactive({
      
    })
    
    datasetInput <- reactive({
      inFile <- input$file1
      if (is.null(inFile))
        return(NULL)
      #df <- df[ , 2:5]
      read.csv(inFile$datapath, header = input$header, stringsAsFactors = F)
    })
    
    #sample Data
    
    
    # output$dw1 <- downloadHandler(
    #   filename = function() {
    #     paste("SampleData-", Sys.Date(), ".csv", sep="")
    #   },
    #   content = function(file) {
    #     write.csv(read.csv("Docs/RFID_1_Small.csv", stringsAsFactors = F), file)
    #   }
    # )
    
      
    
    #Raw Data
    output$content1 <- renderTable({
      df <- datasetInput()
      #df <- df[ , 2:5]
    })
    
    #Prepared Data
    modify <- function(df) {
      
      nrow <- dim(df)[1]
      
      #Modifing chr to date format - 2nd column
      i <- 1
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      while(i <= nrow) {
        df$SWIPE_DATE[i] <- as.Date(df$SWIPE_DATE[i], "%d-%m-%y") - firstDay + 1
        i <- i + 1
      }
      names(df)[2] <- "SWIPE_DAY" #Renaming
      
      i <- 1
      while(i <= nrow) {
        if(substr(df$TIME_OF_SWIPE[i], 11, 11) == ':') {
          df$TIME_OF_SWIPE[i] = as.numeric(substr(df$TIME_OF_SWIPE[i], 10, 10)) * 60 + as.numeric(substr(df$TIME_OF_SWIPE[i], 12, 13))
          
        }  else {
          df$TIME_OF_SWIPE[i] = as.numeric(substr(df$TIME_OF_SWIPE[i], 10, 11)) * 60 + as.numeric(substr(df$TIME_OF_SWIPE[i], 13, 14))
        }
        i <- i + 1
      }
      names(df)[3] <- "SWIPE_TIME_MIN"
      return(df)
    }
    
    output$content2 <- renderTable({
      df <- datasetInput()
      #df <- df[ , 2:5]
      if (is.null(df))
        return(NULL)
      modify(df)
    })
    
    #Outliers
    output$plot0 <- renderPlot({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      df[[3]] <- as.integer(df[[3]])
      boxplot(df[df[[4]] == "IN",3 ], df[df[[4]] == "OUT",3 ], names = c("IN", "OUT"), ylab = "Time in Minutes")
    })
    
    output$text1 <- renderPrint({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      dfIN <- df[df[[4]] == "IN", ]
      dfIN[[3]] <- as.integer(dfIN[[3]])
      IQR1 <- IQR(dfIN[[3]])
      print(dfIN[dfIN[[3]] >= median(dfIN[[3]]) + 1.5*IQR1, 1])
    })
    
    findlc <- reactive({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      dfIN <- df[df[[4]] == "IN", ]
      dfIN[[3]] <- as.integer(dfIN[[3]])
      IQR1 <- IQR(dfIN[[3]])
      lc <- dfIN[dfIN[[3]] >= median(dfIN[[3]]) + 1.5*IQR1, 1]
      return(lc)
    })

    output$d1 <- downloadHandler(
      filename = function() {
        paste("LateComers-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(findlc(), file)
      }
    )
    
    output$plot1 <- renderPlot({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      plot(df[df[[4]] == "IN",3 ], ylab = "Time in Minutes")
    })
    
    output$text2 <- renderPrint({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      dfOUT <- df[df[[4]] == "OUT", ]
      dfOUT[[3]] <- as.integer(dfOUT[[3]])
      IQR2 <- IQR(dfOUT[[3]])
      print(dfOUT[dfOUT[[3]] <= median(dfOUT[[3]]) - 1.5*IQR2, 1])
    })

    findeg <- reactive({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      dfOUT <- df[df[[4]] == "OUT", ]
      dfOUT[[3]] <- as.integer(dfOUT[[3]])
      IQR2 <- IQR(dfOUT[[3]])
      return(dfOUT[dfOUT[[3]] >= median(dfOUT[[3]]) - 1.5*IQR2, 1])
    })

    output$d2 <- downloadHandler(
      filename = function() {
        paste("Early Goers-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(findeg(), file)
      }
    )
    
    output$plot2 <- renderPlot({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
      df <- modify(df)
      #specific dates
      dr1 <- as.Date(input$dateRange1[1]) - firstDay + 1
      dr2 <- as.Date(input$dateRange1[2]) - firstDay + 1
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      plot(df[df[[4]] == "OUT" ,3 ], ylab = "Time in Minutes")
    })
    
    #Defaulters
    output$text3 <- renderPrint({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      df[[1]] <- as.factor(df[[1]])
      #specific dates
      df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
      dr1 <- input$dateRange1[1]
      dr2 <- input$dateRange1[2]
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      #Checking Defaulters - Method 3
      ids <- levels(df$EMP_NO)
      inTimeDef <- c()
      for(j in ids) {
        inCount <- 0
        outCount <- 0
        for(i in 1:dim(df)[1]) {
          if(df[i, 1] == j &  df[i, 4] == "IN") 
            inCount = inCount + 1
          else if(df[i, 1] == j &  df[i, 4] == "OUT")
            outCount = outCount + 1
        }
        if(inCount < outCount) {
          inTimeDef <- c(inTimeDef, j)
        }
      }
      print(inTimeDef)
    })
    
    output$text4 <- renderPrint({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      df[[1]] <- as.factor(df[[1]])
      #specific dates
      df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
      dr1 <- input$dateRange1[1]
      dr2 <- input$dateRange1[2]
      df <- df[df[[2]] >= dr1 & df[[2]] <= dr2, ]
      ids <- levels(df[[1]])
      outTimeDef <- c()
      for(j in ids) {
        inCount <- 0
        outCount <- 0
        for(i in 1:dim(df)[1]) {
          if(df[i, 1] == j &  df[i, 4] == "IN") 
            inCount = inCount + 1
          else if(df[i, 1] == j &  df[i, 4] == "OUT")
            outCount = outCount + 1
        }
        if(inCount > outCount) {
          outTimeDef <- c(outTimeDef, j)
        }
      }
      print(outTimeDef)
    })
    
    #Attendance
    output$pie1 <- renderPlot({
      rawData <- read.csv("Docs/RFID_1.csv")
      empNo <- levels(as.factor(rawData[[1]]))
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      df[[1]] <- as.factor(df[[1]])
      #specific dates
      df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
      dt1 <- as.Date(input$date1)
      df <- df[df[[2]] == dt1, ]
      df[[1]] <- factor(df[[1]])
      preLen <- length(levels(as.factor(df[[1]])))
      absLen <- length(levels(as.factor(empNo))) - preLen
      
      
      slices <- c(preLen, absLen)
      piepercent<- round(100*slices/sum(slices), 1)
      #pie3D(slices, labels = piepercent, col = rainbow(length(slices)))
      dd <- input$date1
      dd <- as.Date(dd, format = "%d-%m-%y")
      pie3D(slices, labels = piepercent, col = rainbow(length(slices)),main = dd)
      legend("topright", c("Present", "Absent"), cex = 0.8,
             fill = rainbow(length(slices)))
    })
    
    output$text5 <- renderPrint({
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      df[[1]] <- as.factor(df[[1]])
      atten()
      #specific dates
      df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
      dt1 <- as.Date(input$date1)
      df <- df[df[[2]] == dt1, ]
      df[[1]] <- factor(df[[1]])
      empNoSub <- levels(df[[1]])
      pres <- empNoSub
      print(pres)
      #abs <- setdiff(empNo, empNoSub)
    })
    
    output$text6 <- renderPrint({
      rawData <- read.csv("Docs/RFID_1.csv")
      empNo <- levels(as.factor(rawData[[1]]))
      
      df <- datasetInput()
      if (is.null(df))
        return(NULL)
      #df <- df[ , 2:5]
      df[[1]] <- as.factor(df[[1]])
      atten()
      #specific dates
      df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
      dt1 <- as.Date(input$date1)
      df <- df[df[[2]] == dt1, ]
      df[[1]] <- factor(df[[1]])
      empNoSub <- levels(df[[1]])
      abs = setdiff(empNo, empNoSub)
      print(abs)
    })
  
  }
)
