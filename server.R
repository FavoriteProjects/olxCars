df <- read_csv("cars.csv")
server <- function(input, output, session){
    df_yr_fltrd <- reactive({
        df %>%
            filter(year == input$year)
    })
    
    mean_prc_yr_fltrd <- reactive({
        round(mean(df_yr_fltrd()$price, na.rm = T), 0)
    })
    
    mean_prc_yr_all <- reactive({
        round(mean(df$price, na.rm = T), 0)
    })
    
    median_prc_yr_fltrd <- reactive({
        round(median(df_yr_fltrd()$price, na.rm = T), 0)
    })
    
    median_prc_yr_all <- reactive({
        round(median(df$price, na.rm = T), 0)
    })
    
    output$medianSelected <- renderValueBox({
        valueBox(value = median_prc_yr_fltrd(), 
                 subtitle = paste0(input$year, ' Median Price'), 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$meanSelected <- renderValueBox({
        valueBox(value = mean_prc_yr_fltrd(), 
                 subtitle = paste0(input$year, ' Mean Price'), 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$medianAll <- renderValueBox({
        valueBox(value = median_prc_yr_all(), 
                 subtitle = 'Overall Median Price', 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$meanAll <- renderValueBox({
        valueBox(value = mean_prc_yr_all(), 
                 subtitle = 'Overall Mean Price', 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
}