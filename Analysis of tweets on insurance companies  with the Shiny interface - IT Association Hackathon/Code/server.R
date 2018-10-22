library(shiny)
library(twitteR)
library(ROAuth)
library(httr)
library(plyr)
library(rsconnect)
#rsconnect::deployApp('')


shinyServer(
  
  function(input,output)
  {
    
    output$rev <-renderText(paste("<b><center><h3>1.",top_reviewer,"</h3></center></b>"))
    output$no <-renderText(paste("<b><center><h3>No of tweets : ",no_tweet,"</h3></center></b>"))
    output$rev1 <-renderText(paste("<b><center><h3>2.",top_reviewer1,"</h3></center></b>"))
    output$no1 <-renderText(paste("<b><center><h3>No of tweets : ",no_tweet1,"</h3></center></b>"))
    output$rev2 <-renderText(paste("<b><center><h3>3.",top_reviewer2,"</h3></center></b>"))
    output$no2 <-renderText(paste("<b><center><h3>No of tweets : ",no_tweet2,"</h3></center></b>"))
    ip <- reactive({
      ip1 <- input$agency
    })
    seqs=""
    for(i in 1:nrow(tweetsDF))
    {
      seqs = as.character(corpus[[i]]) 
    
    
    myvalues <- reactiveValues()
    myvalues$dlist <- c(isolate(myvalues$dlist),seqs)
    
    }
    output$glo <-renderText(
      {
        paste("The goodneess score between 0(Very poor) and 100(Excellent)",global_score)
      }
    )
    output$fr1 <- renderPrint(
      {f1}
    )
    output$fr2 <- renderPrint(
      {f2}
    )
    output$ploto1 <-renderPlot(
      {
        plot1
      }
    )
    output$wc <-renderPlot(
      {
        wcl
      }
    )
    output$b1 <-renderPrint(
      {
        a1
      }
    )
    output$b2 <-renderPrint(
      {
        a2
      }
    )
    output$b3 <-renderPrint(
      {
        a3
      }
    )
    output$b4 <-renderPrint(
      {
        a4
      }
    )
    output$b5 <-renderPrint(
      {
        a5
      }
    )
    output$raw <- renderTable(
      {
        tweetsDF
      }
    )
    output$help <- renderTable(
      {
        mhr_1
      }
    )
      
    
  }
)

# Set API Keys
api_key <- "p1rXnT0VsILG2Pk0cV4wzNFPn"
api_secret <- "VVJiSz5eRYSNs4p2snFYNZWUsymKh6U1RDyBwfFOxodxUEAlUC"
access_token <- "4000808534-XDSNIBHCLhvakF9Wcq1UyIQUj7zloQublEB3XZB"
access_token_secret <- "4Vvzn8UAkvcfdUhlgNN3SZRUEliHZGEhp7rgpZnkWMWaU"

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


tweets <- searchTwitter("insurance", n=100) # tweets
tweetsDF <- twListToDF(tweets) # more info about twee1s.
tweets_ = tweetsDF['text']

#1. Finding the Top reviewer
count_df = count(tweetsDF, 'screenName')
freq_ = count_df[['freq']]
count_df = count_df[order(-freq_), ]
top_reviewer = count_df[1, 1]
no_tweet = count_df[1, 2]
top_reviewer1 = count_df[2, 1]
no_tweet1 = count_df[2, 2]
top_reviewer2 = count_df[3, 1]
no_tweet2 = count_df[3, 2]



#2. Most helpful reviews
mhr = tweetsDF[c('text', 'favoriteCount', 'retweetCount')]
mhr['total'] = tweetsDF['favoriteCount'] + tweetsDF['retweetCount'] 
mhr = mhr[c('text', 'total')]
total_ = mhr[['total']]
mhr = mhr[order(-total_), ]
mhr_1 = mhr[1:10, 1]

library(tm)
library(SnowballC)
corpus = VCorpus(VectorSource(mhr$text))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

# # Creating the Bag of Words model
# dtm = DocumentTermMatrix(corpus)
# dtm = removeSparseTerms(dtm, 0.999)
# dataset = as.data.frame(as.matrix(dtm))
# dataset$totalCount = mhr$total

# pre-process tweets recieved from twitter. pre-processing tasks include
# conbersion to lowercase, removal of punctuation, numbers and stop-words
# and stemming the document
# input: 
#       vc_tweets - a Corpus object containing tweets as documents
# returns: 
#       a Corpus object after performing above mentioned pre-processing tasks
#

dtmr <-DocumentTermMatrix(corpus, control=list(wordLengths=c(4, 20),
                                               bounds = list(global = c(3,27))))
f1 <- c()
f2 <- c()

freqr <- colSums(as.matrix(dtmr))
#length should be total number of terms
length(freqr)

#create sort order (asc)
ordr <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
f1 <- freqr[ordr[1:20]]

#inspect least frequently occurring terms
f2 <- freqr[tail(ordr)]

findFreqTerms(dtmr,lowfreq=10)



wf=data.frame(term=names(freqr),occurrences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr>3), aes(term, occurrences))
p <- p + geom_bar(stat='identity')
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
plot1=p

#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(3)
#limit words by specifying min frequency
wcl=wordcloud(names(freqr),freqr, min.freq=3,colors=brewer.pal(6,'Dark2'))

a1 <-c()
a2<-c()
a3<-c()
a4<-c()
a5<-c()
# dataset = as.data.frame(as.matrix(dtm))
# dataset$totalCount = mhr$total
a1=findAssocs(dtmr,'premium',0.1)
a2=findAssocs(dtmr,'invest',0.1)
a3=findAssocs(dtmr,'servic',0.1)
a4=findAssocs(dtmr,'health',0.1)
a5=findAssocs(dtmr,'benefit',0.1)

#Score Generation
library(stringr)       #for string processing
pos = readLines("positive_words.txt")
neg = readLines("negative_words.txt")
review_txt = sapply(tweets, function(x) x$getText())

nd = c(length(review_txt), length(review_txt))

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  # Parameters
  # sentences: vector of text to score
  # pos.words: vector of words of postive sentiment
  # neg.words: vector of words of negative sentiment
  # .progress: passed to laply() to control of progress bar
  
  # create simple array of scores with laply
  scores = laply(sentences,
                 function(sentence, pos.words, neg.words)
                 {
                   # remove punctuation
                   sentence = gsub("[[:punct:]]", "", sentence)
                   # remove control characters
                   sentence = gsub("[[:cntrl:]]", "", sentence)
                   # remove digits?
                   sentence = gsub('\\d+', '', sentence)
                   
                   # define error handling function when trying tolower
                   tryTolower = function(x)
                   {
                     # create missing value
                     y = NA
                     # tryCatch error
                     try_error = tryCatch(tolower(x), error=function(e) e)
                     # if not an error
                     if (!inherits(try_error, "error"))
                       y = tolower(x)
                     # result
                     return(y)
                   }
                   # use tryTolower with sapply 
                   sentence = sapply(sentence, tryTolower)
                   
                   # split sentence into words with str_split (stringr package)
                   word.list = str_split(sentence, "\\s+")
                   words = unlist(word.list)
                   
                   # compare words to the dictionaries of positive & negative terms
                   pos.matches = match(words, pos.words)
                   neg.matches = match(words, neg.words)
                   
                   # get the position of the matched term or NA
                   # we just want a TRUE/FALSE
                   pos.matches = !is.na(pos.matches)
                   neg.matches = !is.na(neg.matches)
                   
                   # final score
                   score = sum(pos.matches) - sum(neg.matches)
                   return(score)
                 }, pos.words, neg.words, .progress=.progress )
  # data frame with scores for each sentence
  scores.df = data.frame(text=sentences, score=scores)
  return(scores.df)
  
}

scores = score.sentiment(review_txt, pos, neg, .progress='text')

scores$very.pos = as.numeric(scores$score >= 1)
scores$very.neg = as.numeric(scores$score <= -1)

numpos = sum(scores$very.pos)
numneg = sum(scores$very.neg)

global_score = round( 100 * numpos / (numpos + numneg) )



#dataset = as.data.frame(as.matrix(dtm))
#dataset$totalCount = mhr$total

