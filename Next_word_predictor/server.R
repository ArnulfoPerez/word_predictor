#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(quanteda)
library(data.table)

unigrams <- readRDS("./www/unigrams.RData")
bigrams <- readRDS("./www/bigrams.RData")
trigrams <- readRDS("./www/trigrams.RData")
setkey(unigrams, word_1)
setkey(bigrams, word_1, word_2)
setkey(trigrams, word_1, word_2, word_3)


# function to return highly probable next word given two successive words
triWords <- function(w1, w2, n = 5) {
    pwords <- trigrams[.(w1, w2)][order(-count)]
    if (any(is.na(pwords)))
        return(biWords(w2, n))
    if (nrow(pwords) > n)
        return(pwords[1:n, word_3])
    count <- nrow(pwords)
    bwords <- biWords(w2, n)[1:(n - count)]
    return(unique(c(pwords[, word_3], bwords)))
}

# function to return highly probable next word given a word
biWords <- function(w1, n = 5) {
    pwords <- bigrams[w1][order(-count)]
    if (any(is.na(pwords)))
        return(uniWords(n))
    if (nrow(pwords) > n)
        return(pwords[1:n, word_2])
    count <- nrow(pwords)
    unWords <- uniWords(n)[1:(n - count)]
    return(unique(c(pwords[, word_2], unWords)))
}

#function to return random words
uniWords <- function(n = 5) {  
    return(sample(unigrams[, word_1], size = n))
}


# The prediction function
getWords <- function(str,n=5){
    require(quanteda)
    
    tokens <-tokens_tolower(tokens(str, remove_punct = TRUE,
                                   remove_numbers = TRUE,
                                   split_hyphens = TRUE,
                                   remove_symbols = TRUE,
                                   remove_url = TRUE))
    tokens <- rev(rev(tokens[[1]])[1:2])
    words <- triWords(tokens[1], tokens[2], n)
    return(words)
}

shinyServer(function(input, output) {
    # reactive controls
    observe({
        prediction <- getWords(input$userInput,input$n)
        output$prediction1 <- reactive({paste(prediction, collapse = " ")})
    })
})

