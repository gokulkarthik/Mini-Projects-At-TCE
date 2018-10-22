library(twitteR)
library(ROAuth)
library(httr)

# Set API Keys
api_key <- "58nYr8nYVNtEC8R4nO5iO0YZQ"
api_secret <- "LaVx6KrHREs2QIh3UBegX5Ck8GUBJNQfWq2q7cWPY8SPblEJAi"
access_token <- "4000808534-APSMYyDBlbM3bajyWDjBeQgCmprLkWAUVci9o9w"
access_token_secret <- "VMoZHiC3EX9lfixjneP1E05B9pAUKFH9cjZkzHUw7BmWl"

setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)



# Delhi Pollution Tweets
tweets_1 <- searchTwitter("#delhipollution", n=2000) 
tweets_2 <- searchTwitter("#airpollution", n=2000) 
tweets_3 <- searchTwitter("#smog", n=2000) 
tweets_4 <- searchTwitter("#MyRightToBreathe", n=2000) 
tweets_5 <- searchTwitter("#airpollution", n=2000) 

tweets_A_raw = c(tweets_1, tweets_2, tweets_3, tweets_4)

tweetsDF_A <- twListToDF(tweets_A_raw) # more info about twee1s.
tweetsDF_A$text = iconv(tweetsDF_A$text,"WINDOWS-1252","UTF-8")
tweetsDF_A = tweetsDF_A[!is.na(tweetsDF_A$text),]
write.csv(tweetsDF_A, "delhi_pollution_tweets.csv")


# Mumbai Rain Tweets
tweets_B_raw <- searchTwitter("mumbai+rains OR #mumbairains OR #mumbaiweather OR #mumbaisinks OR #cycloneokhi", n=10000, lang = "en")
tweetsDF_B <- twListToDF(tweets_B_raw) # more info about twee1s.
tweetsDF_B$text = iconv(tweetsDF_B$text,"WINDOWS-1252","UTF-8")
tweetsDF_B = tweetsDF_B[!is.na(tweetsDF_B$text),]
write.csv(tweetsDF_B, "mumbai_rain_tweets.csv")