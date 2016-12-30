require(tidyr)
require(dplyr)
require(ggplot2)

#setwd("C:/Users/Rabin Bhattarai/Desktop/Data Visualization/DV_FinalProject3/01 Data")
setwd("~/dv_finalproject_rabinbhattarai/01 Data")
file_path <- "AustinCrime.csv"

atxCrime <- read.csv(file_path,stringsAsFactors = FALSE)
names(atxCrime)
str(atxCrime)
View(atxCrime)
df <- rename(atxCrime, Crime_Type = Crime.Type, Incident_report_number = Incident.Report.Number)
str(df)




#View(restaurant_scores)

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}





View(df)
str(df)
#Dimensions 




measures <- c('LATITUDE','LONGITUDE')
#measures <- NA # Do this if there are no measures.

dimensions <- setdiff(names(df), measures)
dimensions
measures
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    if(d == "Date") df[d] <- as.Date(atxCrime$Date,"%m/%d/%Y")
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
    if (d == "Date") sql <- paste(sql,paste(d,"date,\n"))
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

