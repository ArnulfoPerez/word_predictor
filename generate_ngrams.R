
library(dplyr)
library(quanteda)
library(data.table)

twitterFile <-"final/en_US/en_US.twitter.txt"
blogFile <- "final/en_US/en_US.blogs.txt"
newsFile <- "final/en_US/en_US.news.txt"

tweet.con <- file(twitterFile, open = "rb")
tweet.vector <- readLines(tweet.con, encoding = "UTF-8")
tweet.count <- length(tweet.vector)
close(tweet.con)

blog.con <- file(blogFile, open = "rb")
blog.vector <- readLines(blog.con, encoding = "UTF-8")
blog.count <- length(blog.vector)
close(blog.con)

news.con <- file(newsFile, open = "rb")
news.vector <- readLines(news.con, encoding = "UTF-8")
news.count <- length(news.vector)
close(news.con)

set.seed(12345)

fraction <- 0.01
trim_threshold <- 3

tweet.subset <- sample(tweet.vector, size = tweet.count * fraction, replace = FALSE)
blog.subset <- sample(blog.vector, size = blog.count * fraction, replace = FALSE)
news.subset <- sample(news.vector, size = news.count * fraction, replace = FALSE)

all.corpus = corpus(c(tweet.subset,blog.subset,news.subset))

doc.tokens <- tokens(all.corpus)
doc.tokens <- tokens(doc.tokens, remove_punct = TRUE,
                     remove_numbers = TRUE,
                     split_hyphens = TRUE,
                     remove_symbols = TRUE,
                     remove_url = TRUE)
doc.tokens <- tokens_tolower(doc.tokens)
unigrams <- dfm_trim(dfm(doc.tokens),min_termfreq = trim_threshold)
bigrams <- dfm_trim(dfm(tokens_ngrams(doc.tokens, n = 2)),min_termfreq = trim_threshold)
trigrams <- dfm_trim(dfm(tokens_ngrams(doc.tokens, n = 3)),min_termfreq = trim_threshold)

# Create named vectors with counts of words 
sums_1 <- colSums(unigrams)
sums_2 <- colSums(bigrams)
sums_3 <- colSums(trigrams)

# Create data tables with individual words as columns
unigrams <- data.table(word_1 = names(sums_1), count = sums_1)

bigrams <- data.table(
  word_1 = sapply(strsplit(names(sums_2), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sums_2), "_", fixed = TRUE), '[[', 2),
  count = sums_2)

trigrams <- data.table(
  word_1 = sapply(strsplit(names(sums_3), "_", fixed = TRUE), '[[', 1),
  word_2 = sapply(strsplit(names(sums_3), "_", fixed = TRUE), '[[', 2),
  word_3 = sapply(strsplit(names(sums_3), "_", fixed = TRUE), '[[', 3),
  count = sums_3)

setkey(unigrams, word_1)
setkey(bigrams, word_1, word_2)
setkey(trigrams, word_1, word_2, word_3)
saveRDS(unigrams, "Next_word_predictor/www/unigrams.RData")
saveRDS(bigrams, "Next_word_predictor/www/bigrams.RData")
saveRDS(trigrams, "Next_word_predictor/www/trigrams.RData")
