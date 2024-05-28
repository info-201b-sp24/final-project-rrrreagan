library(shiny)
library(dplyr)
library(tidyr)

crime_data <- read.csv("Crime_Data.csv")

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
    # Read crime data from a CSV file
    crime_data <- read.csv("Crime_Data.csv")
    
    # Calculate total number of each type of crime and total crimes committed
    crime_counts <- crime_data %>% count(Primary.Offense.Description)
    total_crimes_committed <- sum(crime_counts$n)
    
    # Precinct with the highest reported number of crimes
    precinct_max_crime <- crime_data %>% 
      count(Precinct) %>% 
      filter(n == max(n))
    
    # Most frequent subcategory of crime
    most_frequent_subcategory <- crime_data %>% 
      count(Crime.Subcategory) %>% 
      filter(n == max(n))
    
    # Most frequent primary offense
    most_frequent_primary_offense <- crime_data %>% 
      count(Primary.Offense.Description) %>% 
      filter(n == max(n))
    
    # Hour period with the most reports of crime
    hour_with_most_reports <- crime_data %>%
      mutate(Hour = format(as.POSIXct(Occurred.Time, format="%H:%M:%S"), "%H")) %>%
      count(Hour) %>%
      filter(n == max(n)) %>%
      mutate(Hour_with_Most_Reports_of_Crime = paste(Hour, ":00-", Hour, ":59", sep=""))
    
    # Print summary information
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
}


library(shiny)
library(dplyr)
library(ggplot2)
library(sf)
library(gridExtra)
library(grid)

# Load and prepare the data
seattle_crime_dataset <- read.csv("Crime_data.csv")
seattle_crime_dataset$Occurred.Date <- as.Date(seattle_crime_dataset$Occurred.Date, format = "%m/%d/%Y")

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
data_pre_2008 <- prepare_data(seattle_crime_dataset, c("1975-01-01", "2008-01-01"), "beat_shapefiles/Seattle_Police_Department_Pre_2008_Beats_WM_-403823685701893637/Pre2008_Beats_WM.shp")
data_2008_2015 <- prepare_data(seattle_crime_dataset, c("2008-01-01", "2015-01-01"), "beat_shapefiles/Beats_2008_to_2015_-7708752543149594113/Beats_2008_2015_WM.shp")
data_2015_2017 <- prepare_data(seattle_crime_dataset, c("2015-01-01", "2017-01-01"), "beat_shapefiles/Seattle_Police_Department_Beats_2015_to_2017_-6117309976598584571/Beats_2015_2017_WM.shp")
data_post_2017 <- prepare_data(seattle_crime_dataset, c("2017-01-01", "2018-01-01"), "beat_shapefiles/Current_Beats_6794773331836576823/Beats_WM.shp")

# Define server logic
server <- function(input, output) {
  
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
  
  output$crimePlot <- renderPlot({
    grid.newpage()
    grid.draw(plot_data())
  })
}