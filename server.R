library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(sf)
library(gridExtra)
library(grid)
library(lubridate)
library(plotly)
library(reshape2)

library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
library(plotly)
library(sf)
library(gridExtra)
library(grid)

# Load the data
crime_data <- read.csv("Crime_Data.csv")

# Convert date columns to Date format
crime_data$Occurred.Date <- as.Date(crime_data$Occurred.Date, format = "%m/%d/%Y")
crime_data$Reported.Date <- as.Date(crime_data$Reported.Date, format = "%m/%d/%Y")

# Summary table calculation
summary_table <- crime_data %>%
  mutate(Year = as.integer(format(as.Date(Occurred.Date, "%m/%d/%Y"), "%Y"))) %>%
  count(Year, Primary.Offense.Description) %>%
  pivot_wider(names_from = Primary.Offense.Description, values_from = n, values_fill = 0) %>%
  mutate(
    Overall_Crime_Count = rowSums(across(where(is.numeric)))
  ) %>%
  select(Year, Overall_Crime_Count, everything()) %>%
  rename_all(~gsub("\\.", " ", .)) %>%
  select(Year, Overall_Crime_Count, everything()) %>%
  select(1:2, order(colnames(.))) 

# Summary table after 2011 function
summary_table_after_2011 <- function(data) {
  data %>%
    mutate(Year = as.integer(format(as.Date(Occurred.Date, format = "%m/%d/%Y"), "%Y"))) %>%
    filter(Year >= 2011) %>%
    group_by(Year) %>%
    summarise(Overall_Crime_Count = n()) %>%
    arrange(Year)
}

# Function to prepare data
prepare_data <- function(dataset, date_range, shapefile) {
  dataset %>%
    filter(Occurred.Date >= date_range[1] & Occurred.Date < date_range[2]) %>%
    group_by(Beat) %>%
    summarise(total_crimes = n()) %>%
    mutate(prop_crimes = total_crimes / sum(total_crimes)) %>%
    inner_join(st_read(shapefile, quiet = TRUE), by = c('Beat' = 'beat'))
}

# Prepare datasets
data_pre_2008 <- prepare_data(crime_data, c("1975-01-01", "2008-01-01"), "beat_shapefiles/Seattle_Police_Department_Pre_2008_Beats_WM_-403823685701893637/Pre2008_Beats_WM.shp")
data_2008_2015 <- prepare_data(crime_data, c("2008-01-01", "2015-01-01"), "beat_shapefiles/Beats_2008_to_2015_-7708752543149594113/Beats_2008_2015_WM.shp")
data_2015_2017 <- prepare_data(crime_data, c("2015-01-01", "2017-01-01"), "beat_shapefiles/Seattle_Police_Department_Beats_2015_to_2017_-6117309976598584571/Beats_2015_2017_WM.shp")
data_post_2017 <- prepare_data(crime_data, c("2017-01-01", "2018-01-01"), "beat_shapefiles/Current_Beats_6794773331836576823/Beats_WM.shp")

# Server function
server <- function(input, output) {
  
  # Outputs
  output$summaryTable <- renderTable({
    summary_table_after_2011(crime_data)
  })
  
  output$crimeSummaryTable <- renderTable({
    summary_table
  })
  
  # Summary Info
  output$summaryInfo <- renderPrint({
    crime_counts <- crime_data %>% count(Primary.Offense.Description)
    total_crimes_committed <- sum(crime_counts$n)
    
    precinct_max_crime <- crime_data %>% 
      count(Precinct) %>% 
      filter(n == max(n))
    
    most_frequent_subcategory <- crime_data %>% 
      count(Crime.Subcategory) %>% 
      filter(n == max(n))
    
    most_frequent_primary_offense <- crime_data %>% 
      count(Primary.Offense.Description) %>% 
      filter(n == max(n))
    
    hour_with_most_reports <- crime_data %>%
      mutate(Hour = format(as.POSIXct(Occurred.Time, format="%H:%M:%S"), "%H")) %>%
      count(Hour) %>%
      filter(n == max(n)) %>%
      mutate(Hour_with_Most_Reports_of_Crime = paste(Hour, ":00-", Hour, ":59", sep=""))
    
    cat("Total Number of Crime Types: ")
    cat(nrow(crime_counts), "\n\n")
    
    cat("Total Number of Crimes Committed: ")
    cat(total_crimes_committed, "\n\n")
    
    cat("Precinct with the Highest Crime Count: ")
    cat(precinct_max_crime$Precinct, "\n\n")
    
    cat("Most Frequent Subcategory of Crime: ")
    cat(most_frequent_subcategory$Crime.Subcategory, "\n\n")
    
    cat("Most Frequent Primary Offense: ")
    cat(most_frequent_primary_offense$Primary.Offense.Description, "\n\n")
    
    cat("Hour with Most Reports of Crime: ")
    cat(hour_with_most_reports$Hour_with_Most_Reports_of_Crime, "\n")
  })
  
  plot_data <- reactive({
    selected_years <- input$years
    plots <- list()
    
    if ("pre_2008" %in% selected_years) {
      plot_pre_2008 <- ggplot() +
        geom_sf(data = data_pre_2008, aes(geometry = geometry, fill = prop_crimes)) +
        scale_fill_gradient(name = "Proportion of Crimes", low = "lightblue", high = "darkblue") +  
        theme_void() + ggtitle("1975-2007") + theme(plot.title = element_text(hjust = 0.5))
      plots <- append(plots, list(plot_pre_2008))
    }
    
    if ("2008_2015" %in% selected_years) {
      plot_2008_2015 <- ggplot() +
        geom_sf(data = data_2008_2015, aes(geometry = geometry, fill = prop_crimes)) +
        scale_fill_gradient(name = "Proportion of Crimes", low = "lightblue", high = "darkblue") +  
        theme_void() + ggtitle("2008-2015") + theme(plot.title = element_text(hjust = 0.5))
      plots <- append(plots, list(plot_2008_2015))
    }
    
    if ("2015_2017" %in% selected_years) {
      plot_2015_2017 <- ggplot() +
        geom_sf(data = data_2015_2017, aes(geometry = geometry, fill = prop_crimes)) +
        scale_fill_gradient(name = "Proportion of Crimes", low = "lightblue", high = "darkblue") +  
        theme_void() + ggtitle("2015-2017") + theme(plot.title = element_text(hjust = 0.5))
      plots <- append(plots, list(plot_2015_2017))
    }
    
    if ("post_2017" %in% selected_years) {
      plot_post_2017 <- ggplot() +
        geom_sf(data = data_post_2017, aes(geometry = geometry, fill = prop_crimes)) +
        scale_fill_gradient(name = "Proportion of Crimes", low = "lightblue", high = "darkblue") +  
        theme_void() + ggtitle("2017-2018") + theme(plot.title = element_text(hjust = 0.5))
      plots <- append(plots, list(plot_post_2017))
    }
    
    combined_plots <- arrangeGrob(grobs = plots, ncol = 2)
    plot_title <- textGrob("Proportion of Crimes per Police Beat in Seattle", gp = gpar(fontface = "bold", fontsize = 15))
    final_plot <- arrangeGrob(combined_plots, top = plot_title)
    
    final_plot
  })
  
  output$chart1 <- renderPlot({
    grid.newpage()
    grid.draw(plot_data())
  })
  
  output$crimeTypeSelect <- renderUI({
    selectInput("crime_type", "Select Crime Type", 
                choices = c("All", unique(crime_data$Crime.Subcategory)), selected = "All")
  })
  
  filtered_data <- reactive({
    if (is.null(input$crime_type) || input$crime_type == "All") {
      return(crime_data)
    } else {
      return(crime_data %>%
               filter(Crime.Subcategory %in% input$crime_type))
    }
  })
  
  output$chart2 <- renderPlotly({
    data <- filtered_data()
    
    num_of_crimes_per_month <- data %>%
      mutate(month = format(Occurred.Date, "%b")) %>%
      group_by(month) %>%
      summarise(num_crimes = n()) %>%
      na.omit()
    
    num_of_crimes_reported_per_month <- data %>%
      mutate(month = format(Reported.Date, "%b")) %>%
      group_by(month) %>%
      summarise(num_reported_crimes = n()) %>%
      na.omit()
    
    combined_table <- left_join(num_of_crimes_per_month, num_of_crimes_reported_per_month, by = "month")
    
    fig <- plot_ly(combined_table, x = ~month, y = ~num_crimes, name = 'Committed Crimes', type = 'scatter', mode = 'lines+markers') 
    fig <- fig %>% add_trace(y = ~num_reported_crimes, name = 'Reported Crimes', mode = 'lines+markers')
    fig <- fig %>%
      layout(
        title = "Number of Committed and Reported Crimes per Month",
        xaxis = list(title = "Month"),
        yaxis = list(
          title = "Number of Crimes",
          tickformat = ",d"
        ),
        hovermode = "x unified"
      )
    
    fig
  })
  
  
   data_chart3 <- reactive({
    data <- filtered_data()
    data$Date <- as.Date(data$Occurred.Date)
    data$Month <- format(data$Date, "%m")
    data$Season <- ifelse(data$Month %in% c("12", "01", "02"), "Winter", 
                          ifelse(data$Month %in% c("03", "04", "05"), "Spring", 
                                 ifelse(data$Month %in% c("06", "07", "08"), "Summer", "Fall")))
    return(data)
  })
  
  output$chart3 <- renderPlotly({
    data <- data_chart3()
    crime_counts <- data %>%
      count(Season, Crime.Subcategory) %>%
      spread(Crime.Subcategory, n, fill = 0)
    
    melted_data <- melt(crime_counts, id.vars = "Season")
    
    fig <- plot_ly(melted_data, x = ~Season, y = ~variable, z = ~value, type = 'heatmap') %>%
      layout(
        title = "Crime Subcategories by Season",
        xaxis = list(title = "Season"),
        yaxis = list(title = "Crime Subcategory")
      )
    
    fig
  })
}



 