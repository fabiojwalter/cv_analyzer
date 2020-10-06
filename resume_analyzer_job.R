print("> Starting CV Analyzer by Fabio Walter <")
print(date())

source("util.R")
library(tools)
library(dplyr)

print(".Listing files")
filesList <- list.files("data/raw", pattern = "(.docx|.pdf)$")

for (file in filesList) {
  print(str_glue("Processing file: {file}"))
  processFile(str_glue("data/raw/{file}"))
}
cat("Process end")

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
# install.packages("treemap")
# library(treemap)
# jpeg("my_plot.jpeg", quality = 90, width = 1300)
# treemap(
#   df[1:100,],
#   index = "word",
#   vSize = "freq",
#   vColor = "freq",
#   type = "value",
#   palette = "RdBu"
# )
# dev.off()
