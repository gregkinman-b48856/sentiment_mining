"
Messing around with twitteR and tm.
"

library(twitteR)
library(tm)

test <- read.csv("test_text.csv")

load("rdmTweets.RData")

df <- do.call("rbind", lapply(rdmTweets, as.data.frame))

myCorpus <- Corpus(VectorSource(df$text))

myCorpus <- tm_map(myCorpus, tolower)
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
myCorpus <- tm_map(myCorpus, removeWords)

myCorpusCopy <- myCorpus
myCorpus <- tm_map(myCorpus, stemDocument)

myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=myCorpusCopy)

miningCases <- tm_map(myCorpusCopy, grep, pattern="\\<mining")
minerCases <- tm_map(myCorpusCopy, grep, pattern="\\<miners")
myCorpus <- tm_map(myCorpus, gsub, pattern="miners", replacement="mining")
