list.files()
df <- read.csv("Docs/RFID_1_Small.csv", stringsAsFactors = F)#Remove factors, else  we will unable to modify the values
#print(df) #view(df) to view
str(df) #Structure
dim(df) #dimension
nrow <- dim(df)[1] #Number of rows
length(df) #Number of  columns
print(names(df)) # column names
#print(rownames(df)) # row names

df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
print(df[df[[2]] <= "2017-01-17" & df[[2]] >= "2016-01-04", ])
print()
#Modifing chr to date format - 2nd column
i <- 1
firstDay <- as.Date(df$SWIPE_DATE[1], "%d-%m-%y")
while(i <= nrow) {
  df$SWIPE_DATE[i] <- as.Date(df$SWIPE_DATE[i], "%d-%m-%y") - firstDay + 1
  i <- i + 1
}
names(df)[2] <- "SWIPE_DAY"#Renaming
df[[2]] <- as.integer(df[[2]])
#df$SWIPE_DATE <- factor(df$SWIPE_DATE)
#print(as.numeric(levels(df$SWIPE_DATE)))
#print(max(as.numeric(levels(df$SWIPE_DATE))))


#Modifying 3rd column - Time
#print(substr(df$TIME_OF_SWIPE[1], 1, 8))
#print(as.numeric(substr(df$TIME_OF_SWIPE[1], 10, 11)))
#min1 <- as.numeric(substr(df$TIME_OF_SWIPE[1], 10, 11)) * 60 + as.numeric(substr(df$TIME_OF_SWIPE[1], 13, 14))
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
df[[3]] <- as.integer(df[[3]])

summary(df[ df[[4]] == "OUT",3 ])
summary(df[ df[[4]] == "IN",3 ])
sd(df[ df[[4]] == "OUT",3 ])
sd(df[ df[[4]] == "IN",3 ])
plot(df[ df[[4]] == "OUT",3 ])
plot(df[ df[[4]] == "IN",3 ])
boxplot(df[df[[4]] == "IN",3 ], df[df[[4]] == "OUT",3 ], names = c("IN", "OUT"))

df
df[[1]] <- as.factor(df[[1]])
summary((df[[1]])
)


#Attendancs

rawData <- read.csv("Docs/RFID_1.csv")
empNo <- levels(as.factor(rawData[[1]]))
df <- read.csv("Docs/RFID_1_Small.csv")
if (is.null(df))
  return(NULL)
#df <- df[ , 2:5]
df[[1]] <- as.factor(df[[1]])
#specific dates
df[[2]] <- as.Date(df[[2]], "%d-%m-%y")
dt1 <- as.Date("2016-01-08")
df <- df[df[[2]] == dt1, ]
df[[1]] <- factor(df8[[1]])
preLen <- length(levels(as.factor(df[[1]])))
absLen <- length(levels(as.factor(empNo))) - preLen


slices <- c(preLen, absLen)
piepercent<- round(100*slices/sum(slices), 1)
#pie3D(slices, labels = piepercent, col = rainbow(length(slices)))

pie(slices, labels = piepercent, col = rainbow(length(slices)))
legend("topright", c("Present", "Absent"), cex = 0.8,
       fill = rainbow(length(slices)))
