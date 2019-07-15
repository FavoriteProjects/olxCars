library(jsonlite)
library(tidyverse)

# Save the JSON url in `jsonUrl`
# To find the JSON url navigate to the category needed to scrape and open developer setting in chrome
# Select Network tab, the select XHR to find all the jsons transferred from the server
# In the url, string 'p=1' suggests page 1
jsonUrl <- "https://www.olx.in/api/relevance/search?category=84&facet_limit=100&location=2001159&location_facet_limit=10&make=hyundai&model=hyundai-i10&page=1"

# Read json from the url using read_json
p1_Data <- read_json(jsonUrl, simplifyVector = T)

# Check total ads on the page
totalAds <- p1_Data$metadata$total_ads

# Create and empty dataframe to save data in columnar format for each listing
df <- data.frame(id = factor(),
                 main_info = character(),
                 description = character(),
                 display_date = character(),
                 price = integer(),
                 stringsAsFactors=FALSE
                 )

for (i in 1:ceiling(totalAds/20)) {
    jsonUrl_pageWise <- paste0('https://www.olx.in/api/relevance/search?category=84&facet_limit=100&location=2001159&location_facet_limit=10&make=hyundai&model=hyundai-i10&page=', i)
    
    jsonData <- read_json(jsonUrl_pageWise, simplifyVector = T)
    
    id <- jsonData$data$id
    main_info <- jsonData$data$main_info
    description <- jsonData$data$description
    display_date <- jsonData$data$display_date
    price <- jsonData$data$price$value$raw
    
    df_temp <- data.frame(id, main_info, description, display_date, price, stringsAsFactors=FALSE)
    
    df <- bind_rows(df, df_temp)
    
    Sys.sleep(0.5)
}

df <- df %>%
    distinct() %>%
    separate(col = main_info, into = c('year', 'mileage'), sep = ' - ') %>%
    mutate(year = as.numeric(str_replace(year, '"', '')),
           mileage = as.numeric(str_replace(str_replace_all(mileage, ',', ''), ' km', '')))

df %>%
    ggplot(aes(x = as.factor(year), y = mileage)) +
        geom_boxplot()

df %>%
    filter(year == 2010) %>%
    ggplot(aes(x = as.factor(year), y = mileage)) +
    geom_boxplot()

df %>%
    ggplot(aes(x = price)) +
    geom_histogram()

max(df$price)

df %>%
    filter(price < 1000000) %>%
    ggplot(aes(x = price)) +
    geom_histogram()

df %>%
    filter(price < 1000000,
           mileage < 200000) %>%
    ggplot(aes(x = as.factor(year), y = mileage)) +
    geom_boxplot()

df %>%
    filter(price < 1000000,
           price >= 100000,
           mileage < 200000) %>%
    mutate(priceBand = case_when(
        price <= 200000 ~ '1 to 2 lac',
        price <= 250000 ~ '2 to 2.5 lac',
        price <= 300000 ~ '2.5 to 3 lac',
        price <= 350000 ~ '3 to 3.5 lac',
        price <= 400000 ~ '3.5 to 4 lac',
        price > 400000 ~ '4 lac & Above'
    )) %>%
    ggplot(aes(x = priceBand, y = mileage)) +
    geom_boxplot()

df %>%
    filter(price < 1000000,
           price >= 100000,
           mileage < 200000) %>%
    ggplot(aes(x = price, y = year, size = mileage)) +
        geom_point(alpha = 0.2)

df %>%
    filter(price < 1000000,
           price >= 100000,
           mileage < 200000) %>%
    ggplot(aes(x = as.factor(year), y = price)) +
    geom_violin(aes(fill = year))

df %>%
    filter(price < 1000000,
           price >= 100000,
           mileage < 200000) %>%
    ggplot(aes(x = mileage, y = year, size = price)) +
    geom_point(alpha = 0.2)
