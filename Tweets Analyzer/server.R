#http://rpubs.com/gokulkartthikk/networkD3_A
#http://rpubs.com/gokulkartthikk/networkD3_B

#server
library(shiny)
library(plotrix)
library(tm)
library(SnowballC)
library(ggplot2)
library(plyr)
library(wordcloud)
library(stringr)
library(stringi)
#setting the same seed each time ensures consistent look across clouds
set.seed(3)

Sys.setlocale('LC_ALL','C')

shinyServer(
  function(input, output) {
    
    output$tweeter_1 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>1.",top_tweeter_1_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>1.",top_tweeter_1_B,"</h3></center></b>")
      }
    })
    output$no_1 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_1_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_1_B,"</h3></center></b>")
      }
    })
    output$tweeter_2 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>2.",top_tweeter_2_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>2.",top_tweeter_2_B,"</h3></center></b>")
      }
    })
    output$no_2 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_2_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_2_B,"</h3></center></b>")
      }
    })
    output$tweeter_3 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>3.",top_tweeter_3_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>3.",top_tweeter_3_B,"</h3></center></b>")
      }
    })
    output$no_3 <-renderText({
      if(input$topic == "dp"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_3_A,"</h3></center></b>")
      } else if(input$topic == "mr"){
        paste("<b><center><h3>No. of tweets: ",no_tweet_3_B,"</h3></center></b>")
      }
    })
    
    
    #1. Raw Data
    output$table1 <- renderTable({
      if(input$topic == "dp"){
        tweetsDF_A[1:20,]
      } else if(input$topic == "mr"){
        tweetsDF_B[1:20,]
      }
    })
    
    #2. Frequent Words
    output$vtext1 <- renderPrint({
      if(input$topic == "dp"){
        f1_A
      } else if(input$topic == "mr"){
        f1_B
      }
    })
    
    # Frequency Plot
    output$plot1 <-renderPlot({
      if(input$topic == "dp"){
        plot1_A
      } else if(input$topic == "mr"){
        plot1_B
      }
    })
    
    #3. Top 10 #tags
    output$table2 <- renderTable({
      if(input$topic == "dp"){
        tags_freq_A[1:10, ]
      } else if(input$topic == "mr"){
        tags_freq_B[1:10, ]
      }
    })
    
    #4. Distributions
    output$dist1 <- renderPlot({
      if(input$topic == "dp"){
        bar <- ggplot(tweetsDF_A, aes(x=factor(1), fill=factor(isRetweet))) + geom_bar(width=1)
      } else if(input$topic == "mr"){
        bar <- ggplot(tweetsDF_B, aes(x=factor(1), fill=factor(isRetweet))) + geom_bar(width=1)
      }
      pie <- bar + coord_polar(theta='y')
      pie <- pie + labs(title="Pie Chart: Original vs Retweeted Tweets")
      pie
    })
    
    output$dist2 <- renderPlot({
      if(input$topic == "dp"){
        ggplot(data=tweetsDF_A[tweetsDF_A$isRetweet == "FALSE", ], aes(tweetsDF_A[tweetsDF_A$isRetweet == "FALSE", ]$favoriteCount) )+
          geom_histogram(breaks=seq(0,50, by=2), color="red", aes(fill=..count..))+
          labs(title="Histogram: Distribution of favorite counts on original tweets", x="Favorite Count")
      } else if(input$topic == "mr"){
        ggplot(data=tweetsDF_B[tweetsDF_B$isRetweet == "FALSE", ], aes(tweetsDF_B[tweetsDF_B$isRetweet == "FALSE", ]$favoriteCount) )+
          geom_histogram(breaks=seq(0,50, by=2), color="red", aes(fill=..count..))+
            labs(title="Histogram: Distribution of favorite counts on original tweets", x="Favorite Count")
      }
    })
    
    output$dist3 <- renderPlot({
      if(input$topic == "dp"){
        bar <- ggplot(type_A, aes(x=factor(1), fill=factor(type))) + geom_bar(width=1)
      } else if(input$topic == "mr"){
        bar <- ggplot(type_B, aes(x=factor(1), fill=factor(type))) + geom_bar(width=1)
      }
      pie <- bar + coord_polar(theta='y')
      pie <- pie + labs(title="Pie Chart: Types of tweets")
      pie
    })
    
  
    #5. Popular Tweets
    output$popular <- renderTable({
      if(input$topic == "dp"){
        mpt_1_A
      } else if(input$topic == "mr"){
        mpt_1_B
      }
    })
    
    #6. Word Cloud
    output$plot2 <-renderPlot({
      if(input$topic == "dp"){
        wordcloud(names(freqr_A),freqr_A, min.freq=3, max.words=100, colors=brewer.pal(8,'Dark2'))
      } else if(input$topic == "mr"){
        wordcloud(names(freqr_B),freqr_B, min.freq=3, max.words=100, colors=brewer.pal(8,'Dark2'))
      }
    })
    
    #7.Geo
    output$geoplot <-renderUI({
      if(input$topic == "dp"){
        HTML('<iframe width="900" height="800" frameborder="0" scrolling="no" src="//plot.ly/~gokulkarthikk/4.embed"></iframe>')
      } else if(input$topic == "mr"){
        HTML('<iframe width="900" height="800" frameborder="0" scrolling="no" src="//plot.ly/~gokulkarthikk/7.embed"></iframe>')
      }
    })
    
    #8. social network
    output$socnet <-renderUI({
      if(input$topic == "dp"){
        HTML('<h3>Click <a href="http://rpubs.com/gokulkartthikk/networkD3_B">this link</a> to view the interactive graph</h3>')
      } else if(input$topic == "mr"){
        HTML('<h3>Click <a href="http://rpubs.com/gokulkartthikk/networkD3_B">this link</a> to view the interactive graph</h3>')
      }
    })
    
    output$table3 <- renderTable({
      if(input$topic == "dp"){
        sorted_degrees_A
      } else if(input$topic == "mr"){
        sorted_degrees_B
      }
    })
    
    
    
  }
)



findType <- function(tweet){
  hlinks = str_extract_all(tweet, "https://t.co\\S+")
  length_of_links = 0
  for(link in hlinks){
    length_of_links = length_of_links + str_length(link)
  }
  if(length(length_of_links) == 0) {
    "TEXT"
  } else {
    tweet = gsub("https://t.co\\S+", "", tweet)
    tweet = gsub("#\\S+", "", tweet)
    tweet = gsub("@\\S+", "", tweet)
    tweet = gsub(" ", "", tweet)
    if(str_length(stri_enc_toutf8(tweet)) == 0){
      "IMAGE/LINK"
    } else {
      "TEXT + IMAGE/LINK"
    }
  } 
}

tweetsDF_A = read.csv("delhi_pollution_tweets.csv")
tweets_A = tweetsDF_A['text']

#1. Finding the Top tweeter
count_df_A =  data.frame(sort(table(tweetsDF_A$screenName), decreasing = T))
top_tweeter_1_A = as.character(count_df_A[1, 1])
no_tweet_1_A = count_df_A[1, 2]
top_tweeter_2_A = as.character(count_df_A[2, 1])
no_tweet_2_A = count_df_A[2, 2]
top_tweeter_3_A = as.character(count_df_A[3, 1])
no_tweet_3_A = count_df_A[3, 2]

print(1.1)
#3. Word Bag
corpus_A = VCorpus(VectorSource(tweets_A))
corpus_A = tm_map(corpus_A, content_transformer(tolower))
corpus_A = tm_map(corpus_A, removeNumbers)
corpus_A = tm_map(corpus_A, removePunctuation)
corpus_A = tm_map(corpus_A, removeWords, stopwords())
corpus_A = tm_map(corpus_A, stemDocument)
corpus_A = tm_map(corpus_A, stripWhitespace)

dtmr_A <-DocumentTermMatrix(corpus_A, control=list(wordLengths=c(3, 20)))
f1_A <- c()
print(1.2)
freqr_A <- colSums(as.matrix(dtmr_A))
#length should be total number of terms
length(freqr_A)

#create sort order (asc)
ordr_A <- order(freqr_A,decreasing=TRUE)
#inspect most frequently occurring terms
f1_A <- freqr_A[ordr_A[1:10]]

# Plot
wf_A=data.frame(term=names(f1_A),occurrences=f1_A)
library(ggplot2)
p_A <- ggplot(subset(wf_A, f1_A>20), aes(term, occurrences))
p_A <- p_A + geom_bar(stat='identity')
p_A <- p_A + theme(axis.text.x=element_text(angle=45, hjust=1))
plot1_A=p_A
print(4)
#------------------------------------------------------------------------------

#6.SocNet
sorted_degrees_A = read.csv("popular_users_A.csv")
print(5)
#------------------------------------------------------------------------------

#A


#7. popular tweets
mpt_A = subset(tweetsDF_A, isRetweet == "FALSE")
mpt_A = mpt_A[c('text', 'favoriteCount', 'retweetCount')]
print(5.2)
mpt_A['total'] = mpt_A['favoriteCount'] + mpt_A['retweetCount'] 
mpt_A = mpt_A[c('text', 'total')]
total_A = mpt_A[['total']]
print(5.3)
mpt_A = mpt_A[order(-total_A), ]
print(5.4)
mpt_1_A = mpt_A[1:10, 1]
print(5.5)

# Top 10 #tags
hashtags_A = c()
for(tweet in tweets_A){
  tags = str_extract_all(tweet, "#\\S+")
  for(tag in tags){
    hashtags_A = c(hashtags_A, tag)
  }
}
tags_freq_A = data.frame(sort(table(hashtags_A), decreasing = T))

#type of tweets
type = c()
for(tweet in tweetsDF_A[tweetsDF_A$isRetweet == "FALSE", ]$text){
  type = c(type, findType(tweet))
}
type_A = as.data.frame(type)



print("==========================================================================")

tweetsDF_B = read.csv("mumbai_rain_tweets.csv")
tweets_B = tweetsDF_B['text']

#1. Finding the Top tweeter
count_df_B =  data.frame(sort(table(tweetsDF_B$screenName), decreasing = T))
top_tweeter_1_B = as.character(count_df_B[1, 1])
no_tweet_1_B = count_df_B[1, 2]
top_tweeter_2_B = as.character(count_df_B[2, 1])
no_tweet_2_B = count_df_B[2, 2]
top_tweeter_3_B =as.character(count_df_B[3, 1]) 
no_tweet_3_B = count_df_B[3, 2]

print(1.1)
#3. Word Bag
corpus_B = VCorpus(VectorSource(tweets_B))
corpus_B = tm_map(corpus_B, content_transformer(tolower))
corpus_B = tm_map(corpus_B, removeNumbers)
corpus_B = tm_map(corpus_B, removePunctuation)
corpus_B = tm_map(corpus_B, removeWords, stopwords())
corpus_B = tm_map(corpus_B, stemDocument)
corpus_B = tm_map(corpus_B, stripWhitespace)

dtmr_B <-DocumentTermMatrix(corpus_B, control=list(wordLengths=c(3, 20)))
f1_B <- c()
print(1.2)
freqr_B <- colSums(as.matrix(dtmr_B))
#length should be total number of terms
length(freqr_B)

#create sort order (asc)
ordr_B <- order(freqr_B,decreasing=TRUE)
#inspect most frequently occurring terms
f1_B <- freqr_B[ordr_B[1:30]]

#plot
wf_B=data.frame(term=names(f1_B),occurrences=f1_B)
library(ggplot2)
p_B <- ggplot(subset(wf_B, f1_B>20), aes(term, occurrences))
p_B <- p_B + geom_bar(stat='identity')
p_B <- p_B + theme(axis.text.x=element_text(angle=45, hjust=1))
plot1_B=p_B
print(4)
#------------------------------------------------------------------------------

#6.SocNet
sorted_degrees_B = read.csv("popular_users_B.csv")
print(5)
#------------------------------------------------------------------------------




#7. popular tweets
mpt_B = subset(tweetsDF_B, isRetweet == "FALSE")
mpt_B = mpt_B[c('text', 'favoriteCount', 'retweetCount')]
print(5.2)
mpt_B['total'] = mpt_B['favoriteCount'] + mpt_B['retweetCount'] 
mpt_B = mpt_B[c('text', 'total')]
total_B = mpt_B[['total']]
print(5.3)
mpt_B = mpt_B[order(-total_B), ]
print(5.4)
mpt_1_B = mpt_B[1:10, 1]
print(5.5)

# Top 10 #tags
hashtags_B = c()
for(tweet in tweets_B){
  tags = str_extract_all(tweet, "#\\S+")
  for(tag in tags){
    hashtags_B = c(hashtags_B, tag)
  }
}
tags_freq_B = data.frame(sort(table(hashtags_B), decreasing = T))

#Type of tweet
type = c()
for(tweet in tweetsDF_B[tweetsDF_B$isRetweet == "FALSE", ]$text){
  type = c(type, findType(tweet))
}
type_B = as.data.frame(type)