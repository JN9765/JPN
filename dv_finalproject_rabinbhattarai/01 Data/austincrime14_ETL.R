require(tidyr)
require(dplyr)
require(ggplot2)

#setwd("C:/Users/Rabin Bhattarai/Desktop/Data Visualization/DV_FinalProject3/01 Data")
setwd("~/dv_finalproject_rabinbhattarai/01 Data")
file_path <- "AustinCrime14.csv"

atxCrime14 <- read.csv(file_path,stringsAsFactors = FALSE)
names(atxCrime14)
str(atxCrime14)
View(atxCrime14)
df <- rename(atxCrime14, Crime_Type = GO.Highest.Offense.Desc ,Date_of_crime = GO.Report.Date,zip_code = GO.Location.Zip ,address = GO.Location)
str(df)





# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}





str(df)
#Dimensions 


measures <- c('GO.X.Coordinate','GO.Y.Coordinate')

#measures <- NA # Do this if there are no measures.

dimensions <- c('Date_of_crime','address','zip_code','Crime_Type')
dimensions
View(df)

if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    if(d == 'Date_of_crime') df[d] <- as.Date(atxCrime14$GO.Report.Date,"%m/%d/%Y")
    else
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}
View(df)

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# restaurant_scores["State"] <- data.frame(lapply(restaurant_scores["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

View(df)
write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    if (d == "Date_of_crime") sql <- paste(sql,paste(d,"date,\n"))
    else sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)

