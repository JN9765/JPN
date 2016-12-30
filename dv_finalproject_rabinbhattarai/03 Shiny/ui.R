library(shinydashboard)
require(shinydashboard)
require(shiny)
require("jsonlite")
require("RCurl")
require('ggplot2')
require(leaflet)
require(ggmap)
require(qmap)
require(DT)
#TOMORROW ADD FACET GRAPHS OF WOMEN VS MEN BASED ON ANNUAL SALARY (FROM SECOND TO LAST PROJECT)
#ADD HEAT MAP OF CRIMES // AND ADD JOINED GRAPH DATA

zz <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select distinct zip_code from austincrime14 where zip_code is not null"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765', PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
zzz <- zz$ZIP_CODE

diffethnic <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select distinct ethnicity from austin_salaries where ethnicity is not null"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765', PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
diffethnic$ETHNICITY <- as.character(diffethnic$ETHNICITY)
str(diffethnic)


coords <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select latitude, longitude from austincrime where crime_type = \'RAPE\'"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765', PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
str(coords)
vec <- c(coords$LATITUDE)
vec1 <- c(coords$LONGITUDE)



crimes <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select distinct crime_type,count(crime_type) from austincrime group by crime_type having(count(crime_type) >1) order by crime_type"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765', PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
crimes$CRIME_TYPE <- as.character(crimes$CRIME_TYPE)



ui <- dashboardPage(
  dashboardHeader(title = 'Austin Crime/Salary Data'),
  dashboardSidebar(
    sidebarMenu(
      menuItem('Women: Higher Annual Salary', tabName = 'women', icon = icon('th')),
      menuItem('Men: Higher Annual Salary', tabName = 'men', icon = icon('th')),
      menuItem('Age and Life dedicated', tabName = 'life', icon = icon('th')),
      menuItem('Heat Map of Crime', tabName = 'heat', icon = icon('th')),
      menuItem('Bin location of Crimes', tabName = 'bins', icon = icon('th')),
      menuItem('Interactive Map of Crime', tabName = 'crime', icon = icon('th')),
      menuItem('Crime Data (14-16)', tabName = 'joined', icon = icon('th')),
      menuItem('DT of Salaries', tabName = 'DTable', icon = icon('th')),
      menuItem('Visualizations', tabName = 'EthnicStats', icon = icon('th')))),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = 'women',
        fluidRow(column(6,
                        h4('Departments where Women earn a higher average annual salary than Men'),
                        actionButton(inputId = 'clicks', label = 'Produce Visualization'))
        ),
        column(6,offset = 0,
               plotOutput('plot1',height = 450, width = 850))
      ),
      
      
      tabItem(
        tabName = 'men',
        fluidRow(column(6,
                        h4('Departments where Men earn a higher average annual salary than Women'),
                        actionButton(inputId = 'clicks1',label = 'Produce Visualization'))),
        column(6,offset = 0,
               plotOutput('plot2', height = 550, width = 900))
      ),
      tabItem(
        tabName = 'life',
        fluidRow(
          column(6,offset = 0,plotOutput("plot5", height = 550, width = 550)),
          column(6,plotOutput("plot6", height = 550, width = 550)),
          column(6,
                 h4('Length of Service in the City of Austin graphed vs Age and vs Percentage of Life dedicated'),
                 actionButton(inputId = 'clicks5', label = 'Produce Graph'))
          
          
          
          
        )
      ),
      
      
      tabItem(
        tabName = 'heat',
        selectInput(inputId = 'crimetype','Select Crime', choices = crimes$CRIME_TYPE),
        actionButton(inputId = 'clickk','Generate Heat map'),
        plotOutput('heatmap'),
        dataTableOutput('tblll')
        
      ),
      tabItem(
        tabName = 'bins',
        selectInput(inputId = 'crimetypes','Select Crime', choices = crimes$CRIME_TYPE),
        actionButton(inputId = 'clickks','Generate bin map'),
        plotOutput('binmap'),
        dataTableOutput('table')
        
      ),
      tabItem(
        tabName = 'crime',
        leafletOutput('map'),
        selectInput(inputId = 'select','Select Crime',choices = crimes$CRIME_TYPE),
        actionButton(inputId = 'click','Generate locations of Crime')
        
      ),
      tabItem(
        tabName = 'joined',
        actionButton(inputId = 'clickss','Generate Joined Data Table'),
        dataTableOutput('joinedTable'),
        plotOutput('zipcodeplot'),
        selectInput(inputId = 'z', 'Select Zip Code',choices = as.numeric(zzz)),
        actionButton(inputId = 'cl','Generate MAP'),
        leafletOutput('zipmap')
      ),
      tabItem(
        tabName = 'DTable',
        actionButton(inputId = 'create', 'Generate Data Table'),
        selectInput(inputId = 'selectrace','Select Ethnicity',choices = diffethnic$ETHNICITY ),
        dataTableOutput('tb'),
        plotOutput('plot11')
        
      ),
      tabItem(
        tabName = 'EthnicStats',
        actionButton(inputId = 'create1', 'Generate Visuals'),
        selectInput(inputId = 'selectrace1', 'Select Ethnicity', choices = diffethnic$ETHNICITY),
        plotOutput('plot')
        
      )
    )))