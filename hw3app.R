

library(shiny)
library(tidyverse)
setwd("/home/tokramm/biostat-203b-2022-winter/hw3/mimiciv_shiny")
mimic <- read_rds("mimic_ICU_cohort.rds")


#mimic <- mimic %>%
 # rename(Creatinine = Lab50912, Potassium = Lab50971, Sodium = Lab50983, 
 #        Chloride = Lab50902, Bicarbonate = Lab50882, Hematocrit = Lab51221,
 #        WBC = Lab51301, Glucose = Lab50931, Magnesium = Lab50960,
 #        Calcium = Lab50893, Heart_Rate = Lab220045, Mean_niBP =  Lab220181,
 #        Systolic_niBP = Lab220179, Body_temp_F = Lab223761,
 #        Respiratory_rate = Lab220210)
mimic$ethnicity <- as.factor(mimic$ethnicity)
mimic$insurance <- as.factor(mimic$insurance)
mimic$marital_status <- as.factor(mimic$marital_status)





ui <- fluidPage(
  

  titlePanel("Mimic ICU Cohort Data Visualization"),
  

  sidebarLayout(
    

    sidebarPanel(
      

      selectInput(inputId = "variable",
                  label = "Select Ethnicity:", 
                  choices = levels(mimic$ethnicity)),
      
      selectInput(inputId = "variable1",
                  label = "Select Measure:", 
                  choices = c("Creatinine", 
                              "Bicarbonate", "Calcium", "Potassium", "Sodium", 
                              "Chloride", "Hematocrit", "WBC", "Glucose", 
                              "Magnesium", "Calcium", "Heart_Rate", "Mean_niBP",
                              "Systolic_niBP", "Body_temp_F", 
                              "Respiratory_rate")),
    ),
    

    mainPanel(
      label = "Summary Statistics",
      dataTableOutput("table1"),
      dataTableOutput("table2"),
      plotOutput("plot1"),
      plotOutput("plot2")
      
    )
  )
)



server <- function(input, output) {
  data2 <- mimic
  data2$ethnicity <- factor(data2$ethnicity, 
                            labels = c("Am. Ind.", "Asian", "Black", "Hisp", 
                                       "Other", "Un. Obt.", "Unkwn", "White"))
  
  data2$age_cat <- cut(data2$anchor_age, breaks = c(18, 35, 55, 70, 91))
  
  plot_form1 <- reactive({
    paste(input$variable1, "~ethnicity")
  })
  
  plot_form2 <- reactive({
    paste(input$variable1, "~age_cat")
  })
  
  
  output$table1 = renderDataTable({
    data1 <- mimic[which(mimic$ethnicity == input$variable), ]
    summary(data1[,c(41:50, 56:60)], na.rm = TRUE)
  })
  
  output$table2 = renderDataTable({
    data1 <- mimic[which(mimic$ethnicity == input$variable), ]
    summary(data1[,c(15,17,63)], na.rm = TRUE)
  })
  
  output$plot1 = renderPlot({
    boxplot(as.formula(plot_form1()),
            data = data2,
            col = "#75CDCD", pch = 19)
  })
  
  output$plot2 = renderPlot({
    boxplot(as.formula(plot_form2()),
            data = data2,
            col = "#75CDCD", pch = 19)
  })
  
}


shinyApp(ui, server)

