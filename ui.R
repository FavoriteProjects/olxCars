library(tidyverse)
library(shiny)
library(shinydashboard)
library(shinyWidgets)

dashboardPage(
    dashboardHeader(title = "olx Used Car Price Estimator"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(fluidRow(
        box(title = "Brand", 
            width = 3,
            solidHeader = T, 
            selectInput(inputId = 'brand',
                        label = NULL,
                        choices = 'Hyundai',
                        selected = 'Hyundai')
            ),
        
        box(title = "Model", 
            width = 3,
            solidHeader = T, 
            selectInput(inputId = 'model',
                        label = NULL,
                        choices = 'i10',
                        selected = 'i10')
            ),
        
        box(title = "Year", 
            width = 3,
            solidHeader = T, 
            selectInput(inputId = 'year',
                        label = NULL,
                        choices = 2007:2019,
                        selected = 2010)
            ),
        
        box(title = "Mileage", 
            width = 3,
            solidHeader = T, 
            numericRangeInput(inputId = "mileage", 
                              label = NULL,
                              value = c(1000, 200000), 
                              separator = ' to ')
            )
        ),
        
        fluidRow(
            valueBoxOutput(outputId = 'medianSelected', width = 3),
            valueBoxOutput(outputId = 'meanSelected', width = 3),
            valueBoxOutput(outputId = 'medianAll', width = 3),
            valueBoxOutput(outputId = 'meanAll', width = 3)
        )
    )
)