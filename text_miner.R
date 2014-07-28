"
Greg Kinman - B48856
Freescale Semiconductor, Inc.

text_miner.R

Mines web-scraped text.
"

library(tm)
library(ggplot2)
library(wordcloud)

main <- function() {
    
    "
    Driver function for text processing.
    "
    
    test_data <- processor("value_3.csv")
    
    elicitor(test_data)
    
}

processor <- function(csv_filename) {
    
    "
    Stems and removes stopwords from the text of the first column of a .csv file.
    
    Input:
    1. csv_filename:    a string: the name of the .csv file that contains the data
    
    Output:
    1. final_data:      a data frame: a data frame containing the processed text data and its metadata
    "
    
    # Loads the file data into a data frame.
    test_data <- read.csv(csv_filename)
    
    # Pulls just the text column (the leftmost column) into a corpus.
    test_text <- test_data[,1]
    text_corpus <- Corpus(DataframeSource(data.frame(test_text)))
    
    # Cleans up the text.
    text_corpus <- tm_map(text_corpus, tolower)
    text_corpus <- tm_map(text_corpus, removePunctuation)
    text_corpus <- tm_map(text_corpus, removeNumbers)
    removeURL <- function(x) gsub("http:[[:alnum:]]*", "", x)
    text_corpus <- tm_map(text_corpus, removeURL)
    text_corpus <- tm_map(text_corpus, removeWords, stopwords("english"))
    
    # Stems and re-completes the text.
    text_corpus_copy <- text_corpus
    text_corpus <- tm_map(text_corpus, stemDocument)
    text_corpus <- tm_map(text_corpus, stemCompletion, dictionary=text_corpus_copy)
    
    # Replaces the leftmost column in the original data frame with the processed text.
    metadata <- test_data[,-1]
    Snippets <- t(as.data.frame(text_corpus))
    final_data <- data.frame(Snippets, metadata)
    
    return(final_data)
    
}

elicitor <- function(text_data) {
    
    "
    DOCSTRING
    "
    
    # Finds frequent terms.
    text_snippets <- text_data$Snippets
    text_corpus <- Corpus(DataframeSource(data.frame(text_snippets)))
    text_tdm <- TermDocumentMatrix(text_corpus)
    frequent_terms <- findFreqTerms(text_tdm, lowfreq = 5)
    print(frequent_terms)
    
}

main()
