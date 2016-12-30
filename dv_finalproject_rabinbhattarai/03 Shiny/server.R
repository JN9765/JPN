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

server <- function(output,input){
  
  
  wdf <- eventReactive(input$clicks, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                "select department_name,gender, Round(avg(annual_salary)) as avg_salary from austin_salaries where department_name in (\'City Clerk\',\'Aviation\',\'Fleet Services\',\'Animal Services\',\'Austin Resource Recovery\',\'Austin Water Utility\',\'Aviation,City Clerk\',\'Fleet Services\',\'Health and Human Services\',\'Mayor and Council\',\'Office of Real Estate\',\'Wireless Communication Svcs\',\'Watershed Protection\') group by department_name, gender order by department_name"')), 
                                                                 httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                              PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                              returnFor = 'JSON'), verbose = TRUE))
                                                 
                                                 
  )})
  output$plot1 <- renderPlot({
    
    
    womenPlot <- ggplot(wdf(),aes(x = GENDER,y = AVG_SALARY, fill = GENDER)) + geom_bar(stat = 'identity') + facet_wrap(~DEPARTMENT_NAME) + geom_text(aes(label = AVG_SALARY),vjust = 2) + labs(x = 'Gender') + labs(y = 'AVG Annual Salary') + labs(title = 'Avg Annual Salary comparison between Men and Women')
    womenPlot 
    
    
    
  })
  
  
  mdf <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                 "select department_name,gender, Round(avg(annual_salary)) as avg_salary from austin_salaries where department_name not in (\'City Clerk\',\'Aviation\',\'Fleet Services\',\'Animal Services\',\'Austin Resource Recovery\',\'Austin Water Utility\',\'Aviation,City Clerk\',\'Fleet Services\',\'Health and Human Services\',\'Mayor and Council\',\'Office of Real Estate\',\'Wireless Communication Svcs\',\'Watershed Protection\') group by department_name, gender order by department_name"')), 
                                                                  httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                               PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                               returnFor = 'JSON'), verbose = TRUE))
                                                  
                                                  
  )})
  
  output$plot2 <- renderPlot({
    
    menPlot <- ggplot(mdf(),aes(x = GENDER,y = AVG_SALARY, fill = GENDER)) + geom_bar(stat = 'identity') + facet_wrap(~DEPARTMENT_NAME)  + geom_text(aes(label = AVG_SALARY),vjust =2) + labs(x = 'Gender') + labs(y = 'AVG Annual Salary') + labs(title = 'Avg Annual Salary comparison between Men and Women')
    menPlot 
    
    
    
  })
  
  lifedf <- eventReactive(input$clicks5, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                    "select AGE, LENGTH_OF_SERVICE_W_CITY, PERCENT_LIFE from AUSTIN_SALARIES"')), 
                                                                     httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                  PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                  returnFor = 'JSON'), verbose = TRUE))
                                                     
                                                     
  )}) 
  
  output$plot5 <- renderPlot({
    lifeplot1 <- ggplot(lifedf(), aes(x = LENGTH_OF_SERVICE_W_CITY, y = AGE)) +geom_point() + ggtitle(paste("Scatter Plot of Age versus Years Working for Austin")) + labs(x = "Length of Service with City") + labs(y= "Age") 
    lifeplot1 
    
  } )
  
  output$plot6 <- renderPlot({
    lifeplot2 <- ggplot(lifedf(), aes(x = LENGTH_OF_SERVICE_W_CITY, y = PERCENT_LIFE)) +geom_point() + ggtitle(paste("Scatter Plot of Age versus Percent of Life Working for Austin")) + labs(x = "Length of Service with City") + labs(y= "Percentage of Life")
    lifeplot2 
    
    
  } )
  
  
  joinedtab <- eventReactive(input$clickss, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                       "select * from austincrime14 INNER join AUSTINCRIME on (austincrime14.address = austincrime.address)"')), 
                                                                        httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                     PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                     returnFor = 'JSON'), verbose = TRUE))
                                                        
                                                        
  )})
  
  output$joinedTable <- renderDataTable(
    joinedtab(),options = list(pageLength = 10, rownames = FALSE)
    
    
  )
  
  
  joinedtabs <- eventReactive(input$clickss, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                        "select distinct zip_code, count(austincrime14.crime_type) as num_crime from austincrime14 INNER join AUSTINCRIME on (austincrime14.address = austincrime.ADDRESS) group by zip_code having zip_code != \'(null)\'"')), 
                                                                         httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                      PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                      returnFor = 'JSON'), verbose = TRUE))
                                                         
                                                         
  )})
  
  zcode <- reactive({input$z})
  joinedtabss <- eventReactive(input$cl, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                    "select * from austincrime14 INNER join AUSTINCRIME on (austincrime14.address = austincrime.address) where zip_code = "l""')), 
                                                                     httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                  PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                  returnFor = 'JSON',l = zcode()), verbose = TRUE))
                                                     
                                                     
  )})
  
  
  output$zipcodeplot <- renderPlot({
    
    zplot <- ggplot(joinedtabs(), aes(x = as.factor(ZIP_CODE), y = NUM_CRIME, fill = as.factor(ZIP_CODE))) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + labs(x = 'Zip Code') + labs(y = 'Number of Crimes')  + labs(fill = 'Zip Code') + geom_text(aes(label = NUM_CRIME),vjust =-1)
    zplot
    
  })
  
  
  output$zipmap <- renderLeaflet({
    leaflet(data = joinedtabss()) %>% addTiles() %>%
      addMarkers(lng=as.numeric(joinedtabss()$LONGITUDE) , lat=as.numeric(joinedtabss()$LATITUDE),popup = paste(joinedtabss()$CRIME_TYPE ,'(', joinedtabss()$DATE_OF_CRIME, ',', joinedtabss()$ADDRESS,')', joinedtabss()$CRIME_TYPE.1,'\n','(', joinedtabss()$DATE_OF_CRIME.1,',', joinedtabss()$ADDRESS,')'))
    
  })
  
  
  
  
  
  
  
  
  
  crimess <- reactive({input$crimetype})
  crimelocations <- eventReactive(input$clickk, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                           "select date_of_crime,crime_type,address,longitude,latitude from austincrime where crime_type = \'"d"\'"')), 
                                                                            httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                         PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                         returnFor = 'JSON', d = crimess()), verbose = TRUE))
                                                            
  )})
  
  output$heatmap <- renderPlot({
    
    AustinMaps <- qmap('Austin',zoom = 12)
    AustinMaps +
      stat_density2d(
        aes(x = LONGITUDE, y = LATITUDE, fill = CRIME_TYPE, alpha = CRIME_TYPE),
        size = .5, bins = 100, data = crimelocations(),
        geom = "polygon")
  })
  
  output$tblll <- renderDataTable(
    subset(crimelocations(),CRIME_TYPE == crimess()),options = list(pageLength = 5, rownames = FALSE)
  )
  
  
  
  crimesss <- reactive({input$crimetypes})
  crimelocationss <- eventReactive(input$clickks, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                             "select date_of_crime,crime_type,address,longitude,latitude from austincrime where crime_type = \'"d"\'"')), 
                                                                              httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                           PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                           returnFor = 'JSON', d = crimesss()), verbose = TRUE))
                                                              
  )})
  output$binmap <- renderPlot({
    
    AustinMap <- qmap("Austin", zoom = 12,legend = "topleft")
    AustinMap + 
      stat_bin2d(
        aes(x = LONGITUDE, y = LATITUDE, colour = CRIME_TYPE, fill = CRIME_TYPE),
        size = 2, bins = 100, alpha = 0.5, 
        data = crimelocationss())
  })
  
  output$table <- renderDataTable(
    subset(crimelocationss(),CRIME_TYPE == crimesss()),options = list(pageLength = 10, rownames = FALSE)
  )
  
  
  
  crimep <- reactive({input$select})
  crimelocation <- eventReactive(input$click, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                         "select DATE_OF_CRIME, address,longitude,latitude from austincrime where crime_type = \'"d"\'"')), 
                                                                          httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                       PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                       returnFor = 'JSON', d = crimep()), verbose = TRUE))
                                                          
  )})
  output$map <- renderLeaflet({
    
    leaflet(data = crimelocation()) %>% addTiles() %>%
      addMarkers(lng=as.numeric(crimelocation()$LONGITUDE) , lat=as.numeric(crimelocation()$LATITUDE),popup = paste(crimelocation()$ADDRESS ,'(', crimelocation()$DATE_OF_CRIME,')'))
    
  })
  ethinicChoice <- reactive({input$selectrace})
  EthnicityDT <- eventReactive(input$create, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                        "select last_name, first_name, gender, age, department_name, title, Hourly_Rate,Annual_Salary from austin_salaries where ethnicity = \'"e"\'"')), 
                                                                         httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                      PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                      returnFor = 'JSON', e = ethinicChoice()), verbose = TRUE))
  )})
  
  output$tb <- renderDataTable(
    EthnicityDT(),options = list(pageLength = 5, rownames = FALSE))
  
  output$plot11 <- renderPlot({
    eth = EthnicityDT()[,c('HOURLY_RATE','ANNUAL_SALARY')]
    s = input$tb_rows_current
    plot(eth,pch = 21, col = 'seashell4', xlab = 'Hourly Rate',ylab = 'Annual Salary')
    if (length(s)){
      points(eth[s, ,drop = FALSE], pch = 19, cex = 2, col = 3)
    }
    
    legend(
      'topright', c('Original data', 'Data on current page'),
      pch = c(21, 19), pt.cex = c(1, 2), col = c(1, 3),
      y.intersp = 2, bty = 'n'
    )
    
    
  })
  
  
  
  ethinicC <- reactive({input$selectrace1})
  EthnicityStat <- eventReactive(input$create1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                           "select hourly_rate,annual_salary,age from austin_salaries where ethnicity = \'"e"\'"')), 
                                                                            httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                         PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                         returnFor = 'JSON', e = ethinicC()), verbose = TRUE))
                                                            
  )})
  
  output$plot <- renderPlot({
    
    
    if (nrow(EthnicityStat()) < 1000){
      mysample <- EthnicityStat()[sample(1:nrow(EthnicityStat()), nrow(EthnicityStat()), replace=FALSE),]
      attach(mysample)
      par(mfrow =c(2,2))
      plot (mysample$HOURLY_RATE,mysample$ANNUAL_SALARY, main = 'scatterplot of hourly rate vs annual salary', xlab = 'Hourly Rate', ylab = 'Annual Salary', col = 'light blue')
      plot (mysample$AGE,mysample$ANNUAL_SALARY, main = 'Scatterplot of Age vs \n Annual Salary', xlab = 'Age', ylab = 'Annual Salary', col = 'blue')
      hist(mysample$ANNUAL_SALARY, main = 'Histogram of Annual salary',xlab = 'Annual Salary', ylab = 'Frequency', col = 'yellow')
      boxplot(mysample$HOURLY_RATE, main = 'Hourly Rate Boxplot',xlab = 'Ethnicity', ylab = 'Hourly Rate')
      
      
      
    }  
    
    else{
      mysample <- EthnicityStat()[sample(1:nrow(EthnicityStat()), 1000, replace=FALSE),]
      attach(mysample)
      par(mfrow =c(2,2))
      plot (mysample$HOURLY_RATE,mysample$ANNUAL_SALARY, main = 'scatterplot of hourly rate vs annual salary', xlab = 'Hourly Rate', ylab = 'Annual Salary', col = 'light blue')
      plot (mysample$AGE,mysample$ANNUAL_SALARY, main = 'Scatterplot of Age vs \n Annual Salary', xlab = 'Age', ylab = 'Annual Salary', col = 'blue')
      hist(mysample$ANNUAL_SALARY, main = 'Histogram of Annual salary', xlab = 'Annual Salary', ylab = 'Frequency', col = 'yellow')
      boxplot(mysample$HOURLY_RATE, main = 'Hourly Rate Boxplot',xlab = 'Ethnicity', ylab = 'Hourly Rate')
      
      
      
      
    }
    
    
    
    
  }
  
  )
  
  
  
}
