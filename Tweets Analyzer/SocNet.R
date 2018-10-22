library(stringr)

##_A
tweetsDF_A = read.csv("delhi_pollution_tweets.csv")

#nodes
tweetsDF_A$screenName = paste("@", tweetsDF_A$screenName, sep="")
nodes = as.vector(tweetsDF_A$screenName)

replies = as.vector(tweetsDF_A$replyToSN)
replies = na.omit(replies)
for(reply in replies){
  nodes = c(nodes, paste("@", reply, sep=""))
}


for(tweet in tweetsDF_A$text){
  mentions = str_extract_all(tweet, "@\\S+")
  for(mention in mentions){
    mention = gsub(":", "", mention)
    nodes = c(nodes, mention) 
  }
}

nodes = unique(nodes)


#links
source = c()
target = c()
type = c()

rows = function(x) lapply(seq_len(nrow(x)), function(i) lapply(x,"[",i))

tweetsDF_A = tweetsDF_A[, c('text', 'screenName', 'replyToSN')]
for(row in rows(tweetsDF_A)){
  # replied links
  if(!is.na(row$replyToSN)){
    source = c(source, row$screenName)
    target = c(target, as.character(paste("@", row$replyToSN, sep="")))
    type = c(type, "replied")
  }
  # retweeted links
  retweet_mention = str_extract(row$text, "RT \\S+")
  if(!is.na(retweet_mention)){
    source = c(source, row$screenName)
    target = c(target, substr(retweet_mention, start=4, stop=nchar(retweet_mention)-1))
    type = c(type, "retweeted")
  }
  # mentioned links
  tweet = as.character(row$text)
  if(substr(tweet, 1, 4) == "RT @"){
    tweet = substr(tweet, 5, nchar(tweet)) #To avoid retweet mentions
  }
  mentions = str_extract_all(tweet, "@\\S+")
  if(!identical(character(0), mentions[[1]])){
    for(mention in mentions[[1]]){
      source = c(source, row$screenName)
      target = c(target, mention)
      type = c(type, "mentioned")
    }
  }
}

write.csv(data.frame(nodes), "nodes_A.csv")
write.csv(data.frame(source, target, type), "links_A.csv")
  

#====================================================================================

##_B
tweetsDF_B = read.csv("mumbai_rain_tweets.csv")

#nodes
tweetsDF_B$screenName = paste("@", tweetsDF_B$screenName, sep="")
nodes = as.vector(tweetsDF_B$screenName)

replies = as.vector(tweetsDF_B$replyToSN)
replies = na.omit(replies)
for(reply in replies){
  nodes = c(nodes, paste("@", reply, sep=""))
}


for(tweet in tweetsDF_B$text){
  mentions = str_extract_all(tweet, "@\\S+")
  for(mention in mentions){
    mention = gsub(":", "", mention)
    nodes = c(nodes, mention) 
  }
}

nodes = unique(nodes)


#links
source = c()
target = c()
type = c()

rows = function(x) lapply(seq_len(nrow(x)), function(i) lapply(x,"[",i))

tweetsDF_B = tweetsDF_B[, c('text', 'screenName', 'replyToSN')]
for(row in rows(tweetsDF_B)){
  # replied links
  if(!is.na(row$replyToSN)){
    source = c(source, row$screenName)
    target = c(target, as.character(paste("@", row$replyToSN, sep="")))
    type = c(type, "replied")
  }
  # retweeted links
  retweet_mention = str_extract(row$text, "RT \\S+")
  if(!is.na(retweet_mention)){
    source = c(source, row$screenName)
    target = c(target, substr(retweet_mention, start=4, stop=nchar(retweet_mention)-1))
    type = c(type, "retweeted")
  }
  # mentioned links
  tweet = as.character(row$text)
  if(nchar(tweet) >= 4 && substr(tweet, 1, 4) == "RT @"){
    tweet = substr(tweet, 5, nchar(tweet)) #To avoid retweet mentions
  }
  mentions = str_extract_all(tweet, "@\\S+")
  if(!identical(character(0), mentions[[1]])){
    for(mention in mentions[[1]]){
      source = c(source, row$screenName)
      target = c(target, mention)
      type = c(type, "mentioned")
    }
  }
}

write.csv(data.frame(nodes), "nodes_B.csv")
write.csv(data.frame(source, target, type), "links_B.csv")

#==============================================================================

#Plots
library(networkD3)

links_A = read.csv("links_A.csv")
#Filter only the replies for sample plot
links_A = links_A[links_A$type == "replied",]
networkData_A <- data.frame(links_A$source, links_A$target)
simpleNetwork(networkData_A)

links_B = read.csv("links_B.csv")
#Filter only the replies for sample plot
links_B = links_B[links_B$type == "replied",]
networkData_B <- data.frame(links_B$source, links_B$target)
simpleNetwork(networkData_B)


#==============================================================================
#xlsx for creating graphs with onodo
library(dplyr)
library(xlsx)

nodes_A = read.csv("nodes_A.csv")
nodes_A$X = NULL
nodes_A = rename(nodes_A, Name=nodes)

links_A = read.csv("links_A.csv")
links_A$X = NULL
links_A = rename(links_A, Source=source, Type=type, Target=target)

write.xlsx(nodes_A, "network_data.xlsx", "Nodes", row.names = FALSE)
write.xlsx(links_A, "network_data.xlsx", "Relations", row.names = FALSE, append = TRUE)

#==============================================================================
# indegree
library(igraph)

links_A = read.csv("links_A.csv")
links_A$X = NULL
G_A = graph.data.frame(links_A, directed = TRUE)
degrees_A = degree(G_A, mode = "in")
sorted_degrees_A = data.frame(sort(degrees_A, decreasing = TRUE))
colnames(sorted_degrees_A) = c("Indegree")
sorted_degrees_A$Username = rownames(sorted_degrees_A)
sorted_degrees_A = sorted_degrees_A[, c(2,1)]
write.csv(sorted_degrees_A[1:20,], "popular_users_A.csv", row.names = FALSE)

links_B = read.csv("links_B.csv")
links_B$X = NULL
G_B = graph.data.frame(links_B, directed = TRUE)
degrees_B = degree(G_B, mode = "in")
sorted_degrees_B = data.frame(sort(degrees_B, decreasing = TRUE))
colnames(sorted_degrees_B) = c("Indegree")
sorted_degrees_B$Username = rownames(sorted_degrees_B)
sorted_degrees_B = sorted_degrees_B[, c(2,1)]
write.csv(sorted_degrees_B[1:20,], "popular_users_B.csv", row.names = FALSE)
#==============================================================================

# Geo Data
tweetsDF_A = read.csv("delhi_pollution_tweets.csv")
tweetsDF_A = tweetsDF_A[, c('screenName', 'latitude', 'longitude')]
tweetsDF_A = na.omit(tweetsDF_A)
write.csv(tweetsDF_A, "geo_data_A.csv")

tweetsDF_B = read.csv("mumbai_rain_tweets.csv")
tweetsDF_B = tweetsDF_B[, c('screenName', 'latitude', 'longitude')]
tweetsDF_B = na.omit(tweetsDF_B)
write.csv(tweetsDF_B, "geo_data_B.csv")

#==============================================================================

