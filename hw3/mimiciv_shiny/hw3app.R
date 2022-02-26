#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui1 <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server1 <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}




library(tidyverse)
setwd("/home/tokramm/biostat-203b-2022-winter/hw3/mimiciv_shiny")
mimic <- read_rds("mimic_icu_cohort.rds")




mimic <- mimic %>% 
  group_by(subject_id) %>% 
  distinct(subject_id, .keep_all = TRUE)

mimic <- mimic %>%
  rename(Creatinine = Lab50912, Potassium = Lab50971, Sodium = Lab50983, 
         Chloride = Lab50902, Bicarbonate = Lab50882, Hematocrit = Lab51221,
         WBC = Lab51301, Glucose = Lab50931, Magnesium = Lab50960,
         Calcium = Lab50893, Heart_Rate = Lab220045, Mean_niBP =  Lab220181,
         Systolic_niBP = Lab220179, Body_temp_F = Lab223761,
         Respiratory_rate = Lab220210)
mimic$ethnicity <- as.factor(mimic$ethnicity)







# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Lab Measurements by Ethnicity"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "variable",
                  label = "Select Ethnicity:", 
                  choices = levels(mimic$ethnicity)),
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      label = "Summary Statistics",
      dataTableOutput("table1")
      
    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  
  output$table1 = renderDataTable({
    data1 <- mimic[which(mimic$ethnicity == input$variable), ]
    summary(data1[,c(41:50, 56:60)], na.rm = TRUE)
  })
  
}

shinyApp(ui, server)


shinyApp(ui = ui1, server = server1)
