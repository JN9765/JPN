require(ggmap)
require(ggplot2)
require(qmap)
geocode('Houston')
setwd("~/dv_finalproject_rabinbhattarai/01 Data")

file_path <- "AustinCrime.csv"

atxCrime <- read.csv(file_path,stringsAsFactors = FALSE)
View(atxCrime)
aggAssault <- subset(atxCrime, Crime.Type == 'DWI')
View(aggAssault)
Austin <- "Austin"


geocode('University of Texas at Austin')

theme_set(theme_bw(16))

AustinMap <- qmap("Austin", zoom = 12,legend = "topleft")
AustinMap
AustinMap + 
    geom_point(aes(x = LONGITUDE, y = LATITUDE, colour = Crime.Type, size = Crime.Type),
               data = aggAssault)

AustinMap + 
  stat_bin2d(
    aes(x = LONGITUDE, y = LATITUDE, colour = Crime.Type, fill = Crime.Type),
    size = 2, bins = 100, alpha = 0.5, 
    data = aggAssault)



atx <- get_map("Austin", zoom = 14)
atx
AustinMaps <- qmap('Austin',zoom = 12)
AustinMaps +
  stat_density2d(
    aes(x = LONGITUDE, y = LATITUDE, fill = Crime.Type,alpha = Crime.Type),
    size = .5, bins = 100, data = aggAssault,
    geom = "polygon")



