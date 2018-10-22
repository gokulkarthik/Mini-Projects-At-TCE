library(twitteR)
library(ROAuth)
library(httr)
library(plyr)

# Set API Keys
api_key <- "gwv8yky6RdsAl49OtLyydMEZp"
api_secret <- "J53HGXQOhEnhVBhpCvDsR53HL3ZFpcvyhHsOne2shQ4I5gjEbZ"
access_token <- "4000808534-XDSNIBHCLhvakF9Wcq1UyIQUj7zloQublEB3XZB"
access_token_secret <- "4Vvzn8UAkvcfdUhlgNN3SZRUEliHZGEhp7rgpZnkWMWaU"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


tweets <- searchTwitter("@soothsayer80", n=500) # tweets
tweetsDF <- twListToDF(tweets) # more info about tweets.
tweets_ = tweetsDF['text']

#1. Finding the Top reviewer
count_df = count(tweetsDF, 'screenName')
freq_ = count_df[['freq']]
count_df = count_df[order(-freq_), ]
top_reviewer = count_df[1, 1]


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

# Creating the Bag of Words model
# dtm = DocumentTermMatrix(corpus)
# dtm = removeSparseTerms(dtm, 0.999)
# 
# freq <- colSums(as.matrix(dtm))
# length(freq)
# 
# #create sort order (descending)
# ord <- order(freq,decreasing=TRUE)
# 
# #inspect most frequently occurring terms
# freq[ord[1:20]]
# 
# #inspect least frequently occurring terms
# freq[ord[-1:-20]]   

dtmr <-DocumentTermMatrix(corpus, control=list(wordLengths=c(3, 20),
                                             bounds = list(global = c(3,27))))


freqr <- colSums(as.matrix(dtmr))
#length should be total number of terms
length(freqr)

#create sort order (asc)
ordr <- order(freqr,decreasing=TRUE)
#inspect most frequently occurring terms
freqr[ordr[1:20]]

#inspect least frequently occurring terms
freqr[tail(ordr)]

findFreqTerms(dtmr,lowfreq=10)


#histogram
wf=data.frame(term=names(freqr),occurrences=freqr)
library(ggplot2)
p <- ggplot(subset(wf, freqr>3), aes(term, occurrences))
p <- p + geom_bar(stat='identity')
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

#wordcloud
library(wordcloud)
#setting the same seed each time ensures consistent look across clouds
set.seed(2)
#limit words by specifying min frequency
wordcloud(names(freqr),freqr,min.freq=70,colors=brewer.pal(6,'Dark2'))

findAssocs(dtmr,'birla',0.1)
findAssocs(dtmr,'exid',0.1)
#findAssocs(dtmr, comp ,0.1)

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
