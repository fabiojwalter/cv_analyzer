source("util.R")
library(tools)
library(dplyr)

#file <- "Resume - Fabio SantAna - Senior Software Engineer - Fabio SantAna.docx"
file <- "Resume - Fabio SantAna - Senior Software Engineer - Fabio SantAna.pdf"

defaultPath <- file.path("data/raw", file)

# Script protection
if (!file.exists(defaultPath)) {
  stop(str_glue('File: {defaultPath} does not exists! >>> ENDING Script'))
}

# Determines file extenstion and apply the correct extraction method
switch (
  file_ext(defaultPath),
  docx = myCorpus <- readMyDocxx(defaultPath),
  pdf = myCorpus <- readMyPDF(defaultPath)
)

# Cleaning text
myCorpus <- remapText(myCorpus)

# Creating an DataFrame
df <- corpusToDataFrame(myCorpus) %>%
  mutate(file = file) %>%
  mutate(createdAt = Sys.time())

# Saving results
outFileName <- outFile(file)
write_excel_csv2(df, str_glue("data/output/{outFileName}"))


# --------------------------
## PLOT
## install.packages("wordcloud")
## install.packages("RColorBrewer")
## library(wordcloud)
## library(RColorBrewer)
# set.seed(1234) # for reproducibility
# wordcloud(
#   words = df$word,
#   freq = df$freq,
#   min.freq = 1,
#   max.words = 200,
#   random.order = FALSE,
#   rot.per = 0.35,
#   colors = brewer.pal(8, "Dark2")
# )
#
# # bar chart
# par(mar = c(10, 4, 4, 4))
# myBar <- barplot(
#   df[1:10, ]$freq,
#   las = 2,
#   names.arg = df[1:10, ]$word,
#   col = brewer.pal(10, "RdBu"),
#   main = "Most frequent words",
#   ylab = "Word frequencies",
#   ylim = c(0, max(df$freq) + 1)
# )
# text(myBar, df[1:10, ]$freq + 0.4 , df[1:10, ]$freq, cex = 1)
#
# # treemap
## install.packages("treemap")
# library(treemap)
treemap(
  df[1:100,],
  index = "word",
  vSize = "freq",
  vColor = "freq",
  type = "value",
  palette = "RdBu"
)
