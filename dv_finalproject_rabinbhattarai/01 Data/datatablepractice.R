require(DT)

setwd("~/Practice")

file_path <- "AustinCrime.csv"

atxCrime <- read.csv(file_path,stringsAsFactors = FALSE)
aggAssault <- subset(atxCrime, Crime.Type == 'AGG ASSAULT')
View(aggAssault)

datatable(aggAssault,options = list(pageLength = 5))
