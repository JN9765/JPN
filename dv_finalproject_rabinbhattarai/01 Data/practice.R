library(shinydashboard)
require(shinydashboard)
require(shiny)
require("jsonlite")
require("RCurl")
require('ggplot2')
require(leaflet)


diffethnic <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select distinct ethnicity from austin_salaries where ethnicity is not null"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765', PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
diffethnic$ETHNICITY <- as.character(diffethnic$ETHNICITY)

ui <- dashboardPage(
  dashboardHeader(title = 'Austin Crime/Salary Data'),
  dashboardSidebar(
    sidebarMenu(
     
      menuItem('DT of Salaries', tabName = 'DTable', icon = icon('th')))),
      
  
  dashboardBody(
    tabItems(
      
      tabItem(
        tabName = 'DTable',
        actionButton(inputId = 'create', 'Generate Data Table'),
        selectInput(inputId = 'selectrace','Select Ethnicity',choices = diffethnic$ETHNICITY ),
        dataTableOutput('tbl'),
        plotOutput('plot1')
        
      )
      
        
      )))


server <- function(output,input){

ethinicChoice <- reactive({input$selectrace})
EthnicityDT <- eventReactive(input$create, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
                                                                                      "select last_name, first_name, gender, age, department_name, title, Hourly_Rate,Annual_Salary from austin_salaries where ethnicity = \'"e"\'"')), 
                                                                       httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_jn9765',
                                                                                    PASS='orcl_jn9765', MODE='native_mode', MODEL='model', returnDimensions = 'False', 
                                                                                    returnFor = 'JSON', e = ethinicChoice()), verbose = TRUE))
)})

output$tbl <- renderDataTable(
  EthnicityDT(),options = list(pageLength = 5, rownames = FALSE)
)
output$plot1 <- renderPlot({
  ethnics = EthnicityDT()[,c('HOURLY_RATE','ANNUAL_SALARY')]
  s = input$tbl_rows_current
  plot(ethnics,pch = 21)
  
  if (length(s)){
    points(ethnics[s, , drop = FALSE], pch = 19, cex = 20)
    
    
  }
})
}

shinyApp(ui,server)