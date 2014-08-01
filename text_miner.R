"
Greg Kinman - B48856
Freescale Semiconductor, Inc.

text_miner.R

Mines web-scraped text.
"

library(tm)
library(igraph)

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
    my_stopwords <- c(stopwords("english"), "can", "will", "just", "much", "use")
    text_corpus <- tm_map(text_corpus, removeWords, my_stopwords)
    
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
            this_freq <- freq
            break
        }
    }
    
    # Removes search query words, since we want related words only.
    no_words <- c("freescale", "i.mx", "imx", "kinetis", "qoriq", "riotboard", "riot", "board")
    related_terms <- vector(mode = "character", length=0)
    for (word_1 in frequent_terms) {
        allowed = TRUE
        for (word_2 in no_words) {
            if (word_1 == word_2) {
                allowed = FALSE
            }
        }
        if (allowed == TRUE) {
            related_terms <- c(related_terms, word_1)
        }
    }
    print(sentiment)
    print(":")
    print(related_terms)
    
    # Bar plots of most frequent terms:
    
    frequencies <- rowSums(as.matrix(text_tdm))
    frequencies <- subset(frequencies, frequencies>=this_freq)
    barplot(frequencies, las=2, horiz=TRUE)
    
    # Finds word associations for the product families.
    
    print(findAssocs(text_tdm, "freescale", 0.4))
    print(findAssocs(text_tdm, "kinetis", 0.4))
    print(findAssocs(text_tdm, "riotboard", 0.4))
    print(findAssocs(text_tdm, "imx", 0.4))
    
    # Clustering:
    
    tdm_2 <- removeSparseTerms(text_tdm, sparse=0.95)
    mat <- as.matrix(tdm_2)
    dist_mat <- dist(scale(mat))
    fit <- hclust(dist_mat, method="ward.D")
    plot(fit)
    rect.hclust(fit, k=8)
    groups <- cutree(fit, k=8)
    
    # Network analysis (need to figure out how to make this a graph only on a subset of the nodes):
    
    #text_tdm <- as.matrix(text_tdm)
    #text_tdm[text_tdm>=1] <- 1
    #text_tdm <- as.matrix(text_tdm) %*% as.matrix(t(text_tdm))
    #g <- graph.adjacency(text_tdm, weighted=TRUE, mode="undirected")
    #g <- simplify(g)
    #V(g)$label <- V(g)$name
    #V(g)$degree <- degree(g)
    #set.seed(3952)
    #layout1 <- layout.fruchterman.reingold(g)
    #plot(g, layout=layout1)
    
}

main()
