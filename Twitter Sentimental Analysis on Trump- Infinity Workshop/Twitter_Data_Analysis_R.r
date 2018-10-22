
# Importing Packages
library(twitteR)
library(ROAuth)
library(httr)
library(plyr)

# Set API Keys
api_key <- "P1bCSdgmTZrjB3eCMgMp22uCb"
api_secret <- "3rL9aHkvl0BFwulgkjllXX3yuEEb01mdVRb93ktkpUIC8vusD1"
access_token <- "4000808534-X8YvgRsJgQHgEYpt6HXZAczvGOj4lbBrwPbbIae"
access_token_secret <- "Oetn4nCsNCJGVckGHixM3gU2nzSi79VmLSbq41dHJ2JzF"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


tweets <- searchTwitter("Trump", n=1000) # tweets
#print(tweets)
tweetsDF <- twListToDF(tweets) # more info about tweets.
#Writing Data Frame to a csv file
write.csv(tweetsDF, "tweets_info_r.csv")
tweets_ = tweetsDF['text']

#print(tweets_)

sorted_tweets = tweetsDF[c('text', 'favoriteCount', 'retweetCount')]
sorted_tweets['total'] = tweetsDF['favoriteCount'] + tweetsDF['retweetCount'] 
sorted_tweets = sorted_tweets[c('text', 'total')]
total_ = sorted_tweets[['total']]
sorted_tweets = sorted_tweets[order(-total_), ]

famous_tweets = c()

already_present = function(t){
    for(tweet in famous_tweets){
        if(tweet == t){
            return(TRUE)
        }
    }
    return(FALSE)
}

cnt = 0
for(tweet in sorted_tweets[[1]]){
    if(already_present(tweet) == FALSE){
        famous_tweets = c(famous_tweets, tweet)
        cnt = cnt + 1
        #print(cnt)
        if(cnt == 10){
            break
        }
    }
}

print(famous_tweets)

library(tm)
library(SnowballC)
library(stringr)

usableText = str_replace_all(sorted_tweets$text,"[^[:graph:]]", " ") 
corpus = VCorpus(VectorSource(usableText))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords())
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

#print(length(corpus))
for(i in 1:length(corpus)){
    #print(corpus[[i]]$content)
}


dtmr <-DocumentTermMatrix(corpus, control=list(wordLengths=c(4, 20),
                                               bounds = list(global = c(3,27))))
f1 <- c()
f2 <- c()

freqr <- colSums(as.matrix(dtmr))
#length should be total number of terms
print(paste0("Length : ", length(freqr)))

#create sort order (asc)
ordr <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
f1 <- freqr[ordr[1:20]]
print('Most Frequent Terms :')
print(f1)

#inspect least frequently occurring terms
f2 <- freqr[tail(ordr)]
print('Less Frequent Terms :')
print(f2)

print("Word used in more than 10 tweets : ")
findFreqTerms(dtmr,lowfreq=10)


library(ggplot2)
options(jupyter.plot_mimetypes = 'image/png')
wf=data.frame(term=names(freqr),occurrences=freqr)
p <- ggplot(subset(wf, freqr>15), aes(term, occurrences))
p <- p + geom_bar(stat='identity')
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
print(p)

pos = readLines("positive_words.txt")
neg = readLines("negative_words.txt")
review_txt = sapply(tweets, function(x) x$getText())

nd = c(length(review_txt), length(review_txt))

score.sentiment = function(sentences, pos.words, neg.words, .progress='none') {
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

print(paste0("Final Score : ", global_score))

#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(3)
#limit words by specifying min frequency
wcl=wordcloud(names(freqr),freqr, min.freq=30,colors=brewer.pal(6,'Dark2'))
print(wcl)
