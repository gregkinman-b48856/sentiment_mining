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
    
    ne <- processor("value_1.csv")
    nu <- processor("value_2.csv")
    po <- processor("value_3.csv")
    
    elicitor(ne, "Negative")
    elicitor(nu, "Neutral")
    elicitor(po, "Positive")
    
}

processor <- function(csv_filename) {
    
    "
    Stems and removes stopwords from the text of the first column of a .csv file.
    
    Input:
    1. csv_filename:    character: the name of the .csv file that contains the data
    
    Output:
    1. final_data:      data.frame: a data frame containing the processed text data and its metadata
    "
    
    # Loads the file data into a data frame.
    data <- read.csv(csv_filename)
    
    # Pulls just the text column (the leftmost column) into a corpus.
    text <- data[,1]
    text_corpus <- Corpus(DataframeSource(data.frame(text)))
    
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
    metadata <- data[,-1]
    Snippets <- t(as.data.frame(text_corpus))
    final_data <- data.frame(Snippets, metadata)
    
    return(final_data)
    
}

elicitor <- function(text_data, sentiment) {
    
    "
    Finds things out about the text data.

    Input:
    1. text_data:   data.frame: the text data
    2. sentiment:   character: the sentiment of the dataset given
    "
    
    text_snippets <- text_data$Snippets
    text_corpus <- Corpus(DataframeSource(data.frame(text_snippets)))
    text_tdm <- TermDocumentMatrix(text_corpus)
    
    # Finds most frequent terms.
    
    for (freq in seq(50, 5, -5)) {
        frequent_terms <- findFreqTerms(text_tdm, lowfreq = freq)
        if (length(frequent_terms) > 9) {
            break
        }
    }
    
    # Removes search query words, since we want related words only.
    no_words <- c("freescale", "i.mx", "imx", "kinetis", "qoriq", "riotboard", "riot", "board")
    related_terms <- vector(mode = "character", length=0)
    for (word_1 in frequent_terms) {
        allowed = T
        for (word_2 in no_words) {
            if (word_1 == word_2) {
                allowed = F
            }
        }
        if (allowed == T) {
            related_terms <- c(related_terms, word_1)
        }
    }
    print(related_terms)
    
    # Clustering:
    
    tdm_2 <- removeSparseTerms(text_tdm, sparse=0.95)
    mat <- as.matrix(tdm_2)
    dist_mat <- dist(scale(mat))
    fit <- hclust(dist_mat, method="ward.D")
    plot(fit)
    title(main="Word Clusters", sub=sentiment)
    rect.hclust(fit, k=8)
    groups <- cutree(fit, k=8)
    
}

main()
