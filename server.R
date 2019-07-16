df <- read_csv("cars.csv")
server <- function(input, output, session){
    df_yr_fltrd <- reactive({
        df %>%
            filter(year == input$year,
                   mileage >= input$mileage[1],
                   mileage <= input$mileage[2])
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
        valueBox(value = round(median_prc_yr_fltrd()/100000, 2), 
                 subtitle = paste0(input$year, ' Median Price(lacs)'), 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$meanSelected <- renderValueBox({
        valueBox(value = round(mean_prc_yr_fltrd()/100000, 2), 
                 subtitle = paste0(input$year, ' Mean Price(lacs)'), 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$medianAll <- renderValueBox({
        valueBox(value = round(median_prc_yr_all()/100000, 2), 
                 subtitle = 'Overall Median Price(lacs)', 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$meanAll <- renderValueBox({
        valueBox(value = round(mean_prc_yr_all()/100000, 2), 
                 subtitle = 'Overall Mean Price in lacs', 
                 icon = icon('rupee-sign'), 
                 color = 'purple', 
                 width = 3
        )
    })
    
    output$priceDist <- renderPlotly({
        plot_ly(df_yr_fltrd(), 
                x = ~price, 
                type = 'histogram') %>%
            layout(xaxis = list(title = "Price"),
                   yaxis = list(title = "Frequency",
                                zeroline = F)
            )
    })
    
    output$boxPlot <- renderPlotly({
        plot_ly(df, 
                x = ~as.factor(year), 
                y = ~price, 
                split = ~as.factor(year),
                type = 'violin', 
                box = list(visible = T), 
                meanline = list(visible = T)) %>%
            layout(xaxis = list(title = "Year"),
                   yaxis = list(title = "Car Price",
                                zeroline = F)
                   )
            })
}