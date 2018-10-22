list.files()
df <- read.csv("RFID_2.csv", stringsAsFactors = F)#Remove factors, else  we will unable to modify the values
print #view(df) to view
str(df) #Structure
dim(df) #dimension
length(df) #Number of  columns
print(names(df)) # column names
print(rownames(df)) # row names




#Modifing chr to date format - 2nd column
j <- 1
first_day <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
while(j <= dim(df)[1]) {
  df$SWIPE_DATE[j] <- as.Date(df$SWIPE_DATE[j], "%d-%m-%y") - first_day + 1
  j <- j + 1
}
#df$SWIPE_DATE <- factor(df$SWIPE_DATE)
#print(as.numeric(levels(df$SWIPE_DATE)))
#print(max(as.numeric(levels(df$SWIPE_DATE))))



#Modifying 3rd column - Time
#print(substr(df$TIME_OF_SWIPE[1], 1, 8))
#print(as.numeric(substr(df$TIME_OF_SWIPE[1], 10, 11)))
min1 <- as.numeric(substr(df$TIME_OF_SWIPE[1], 10, 11)) * 60 + as.numeric(substr(df$TIME_OF_SWIPE[1], 13, 14))
k <- 1
while(k <= dim(df)[1]) {
  df$TIME_OF_SWIPE[k] = as.numeric(substr(df$TIME_OF_SWIPE[k], 10, 11)) * 60 + as.numeric(substr(df$TIME_OF_SWIPE[k], 13, 14))
  k <- k + 1
}


#Pairing in and out
#dummy values
for(i in 1:dim(df)[1]) {
  df$OUT_TIME[i] <- 0
}
i <- 1
while(i < dim(df)[1]) {
  for(i in i:dim(df)[1]) {
    if(df$IN_OUT_STATUS[i] == 'IN') {
      id1 <- df$EMP_NO[i]
      x <- i
      break
    }
  }
  j <- i
  for(j in i+1:dim(df)[1]) {
    if(df$EMP_NO[j] == id1) {
      var1 <- as.numeric(df$TIME_OF_SWIPE[j])+((as.numeric(df$SWIPE_DATE[j])-as.numeric(df$SWIPE_DATE[i]))*1440)
      df$OUT_TIME[i] <- var1
      #print(var1)
      break
    }
    if(j == 65001) {
      break
    }
  }
  i <- i + 1
}


#Refining the IN-OUT Status Column - 4th column
# print(dim(df)[1])
# i <- 1
# while(i <= dim(df)[1]) {
#   if(df$IN_OUT_STATUS[i] == "IN") {
#     df$IN_OUT_STATUS[i] <- 1
#   } else {
#     df$IN_OUT_STATUS[i] <- 0
#   }
#   i = i + 1
# }
# df$IN_OUT_STATUS <- as.integer(df$IN_OUT_STATUS)
# df$IN_OUT_STATUS <- factor(df$IN_OUT_STATUS)


#creating new df
df$TIME_OF_SWIPE <- as.numeric(df$TIME_OF_SWIPE)
newdf <- df[df$IN_OUT_STATUS == "IN" & df$OUT_TIME != 0 & df$OUT_TIME > df$TIME_OF_SWIPE, ]
#Removing IN out status
newdf$IN_OUT_STATUS <- NULL
#Renaming Time of Swipe with in time
names(newdf)[3] <- "IN_TIME"

#changing char to numeric data type
newdf$IN_TIME <- as.numeric(newdf$IN_TIME)
newdf$SWIPE_DATE <- as.numeric(newdf$SWIPE_DATE)

#adding new col of total
newdf$TOTAL_TIME = newdf$OUT_TIME - newdf$IN_TIME


#Total time anomaly
newdf$TIME_ANOMALY <- 2
for(i in 1:dim(newdf)[1]) {
  if(newdf$TOTAL_TIME[i] >= 480) {
    newdf$TIME_ANOMALY[i] <- 1 
  } else {
    newdf$TIME_ANOMALY[i] <- 0  
  }
}



