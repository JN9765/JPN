require(tidyr)
require(dplyr)
require(ggplot2)
setwd("~/dv_finalproject_rabinbhattarai/01 Data")
#setwd("C:/Users/Rabin Bhattarai/Desktop/Data Visualization/DV_FinalProject3/01 Data")
file_path <- "austin_salaries.csv"

salaries <- read.csv(file_path,stringsAsFactors = FALSE)
#names(salaries)
#View(salaries)
df <- rename(salaries, first_name = First,last_name = Last)
#names(df)
#View(df)


# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}


str(df)

str(salaries)
#Dimensions 




measures <- c('Length.of.Service.w.City','Length.of.Service.in.Job','Job.Hrs.Pay','Age','Hourly.Rate','Annual.Salary','Emp.ID','Staffing.Level')
#measures <- NA # Do this if there are no measures.

dimensions <- setdiff(names(df), measures)
dimensions

#Here we removed uneccessary characters from our dimensions. We also reformatted the date data to a more suitable form for data analysis

if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    if(d == "Effective.Date") df[d] <- as.Date(salaries$Effective.Date,"%m/%d/%Y")
    else
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}




# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    if (d == "Effective.Date") sql <- paste(sql,paste(d,"date,\n"))
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

