library(pacman)
pacman::p_load(textreadr, magrittr)
pacman::p_load_gh("trinker/pathr")

library(pdftools)
library(tidyverse)
library(tm)
library(SnowballC)
library(tools)
library(dplyr)

#'
#'
remapText <- function(corpus) {
  print(".Cleaning text: Start")
  removeColon <- function(x) {
    gsub(",", "", x)
  }

  removeDot <- function(x){
    gsub("\\.", "", x)
  }

  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, content_transformer(removeColon))
  corpus <- tm_map(corpus, content_transformer(removeDot))
  corpus <-
    tm_map(
      corpus,
      removePunctuation,
      preserve_intra_word_dashes = TRUE,
      preserve_intra_word_contractions = TRUE
    )
  corpus <- tm_map(corpus, removeWords, stopwords("portuguese"))  # Remove stopwords
  corpus <- tm_map(corpus, removeWords, stopwords("english"))  # Remove stopwords
  myCorpus <- tm_map(myCorpus, stemDocument, language = "english")  # Stem words
  corpus <- tm_map(corpus, stripWhitespace)  # Stem words
  print(".Cleaning text: End")
  return(corpus)
}

#'
#'
corpusToDataFrame <- function(localCorpus) {
  dtm <- TermDocumentMatrix(localCorpus)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m), decreasing = TRUE)
  return(data.frame(word = names(v), freq = v))
}

#' Read the text content from a DOCX file
#'
#' @param defaultPath path to DOCX file
#' @return An object \code{VCorpus}
#' @examples
#' readMyDocx(file.path("data/raw", file.docx))
readMyDocx <- function(defaultPath) {
  myCorpus <- VCorpus(VectorSource(read_docx(defaultPath)))
  return(myCorpus)
}

#'
#'
readMyPDF <- function(defaultPath) {
  myCorpus <- VCorpus(URISource(defaultPath, mode = ""),
                      readerControl = list(reader = readPDF(engine = "pdftools")))
  return(myCorpus)
}

#'
#'
outFile <- function(file) {
  outFile <- file %>%
    str_replace_all("[:punct:]", "_") %>%
    str_replace_all("[:blank:]", "_") %>%
    str_to_lower %>% str_glue(".csv")
  return(outFile)
}

#'
#'
#'
processFile <- function(defaultPath) {
  print(".Processing: Begin")
  # Script protection
  if (!file.exists(defaultPath)) {
    stop(str_glue('File: {defaultPath} does not exists! >>> ENDING Script'))
  }

  # Determines file extenstion and apply the correct extraction method
  switch (
    file_ext(defaultPath),
    docx = myCorpus <<- readMyDocx(defaultPath),
    pdf = myCorpus <<- readMyPDF(defaultPath)
  )

  # Cleaning text
  myCorpus <- remapText(myCorpus)

  # Creating an DataFrame
  df <- corpusToDataFrame(myCorpus) %>%
    mutate(file = file) %>%
    mutate(createdAt = Sys.time())
  print(".Processing: End")

  print(".Saving result: Start")
  # Saving results
  outFileName <- outFile(file)
  write_excel_csv2(df, str_glue("data/csv/{outFileName}"))
  print(".Saving result: End")
}
