library(shiny)
library(dplyr)

# SummaryInfo function definition
summary_info <- function() {
  # Read crime data from a CSV file
  crime_data <- read.csv("crime_data.csv")
  
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
  
  # Prepare summary information as a list
  summary_list <- list(
    total_number_of_crime_types = nrow(crime_counts),
    total_number_of_crimes_committed = total_crimes_committed,
    precinct_with_highest_crime_count = precinct_max_crime$Precinct,
    most_frequent_subcategory_of_crime = most_frequent_subcategory$Crime.Subcategory,
    most_frequent_primary_offense = most_frequent_primary_offense$Primary.Offense.Description,
    hour_with_most_reports_of_crime = hour_with_most_reports$Hour_with_Most_Reports_of_Crime
  )
  
  return(summary_list)
}

# Calculate overall crime rate function
calculate_overall_crime_rate <- function(data) {
  data %>%
    group_by(Year) %>%
    summarise(Overall_Crime_Count = n()) %>%
    arrange(Year)
}

# Summary table after 2011 function
summary_table_after_2011 <- function(data) {
  data %>%
    mutate(Year = as.numeric(format(as.Date(Occurred.Date, format = "%m/%d/%Y"), "%Y"))) %>%
    filter(Year >= 2011) %>%
    group_by(Year) %>%
    summarise(Overall_Crime_Count = n()) %>%
    arrange(Year)
}

# Server function
server <- function(input, output) {
  # Outputs
  output$summaryInfo <- renderPrint({
    info <- summary_info() # Call the function defined in SummaryInfo.R
    cat("Total Number of Crime Types:", info$total_number_of_crime_types, "\n\n")
    cat("Total Number of Crimes Committed:", info$total_number_of_crimes_committed, "\n\n")
    cat("Precinct with the Highest Crime Count:", info$precinct_with_highest_crime_count, "\n\n")
    cat("Most Frequent Subcategory of Crime:", info$most_frequent_subcategory_of_crime, "\n\n")
    cat("Most Frequent Primary Offense:", info$most_frequent_primary_offense, "\n\n")
    cat("Hour with Most Reports of Crime:", info$hour_with_most_reports_of_crime, "\n")
  })
  
  output$summaryTable <- renderTable({
    summary_table_after_2011(crime_data) # Assuming summary_table_after_2011() is defined in SummaryInfo.R
  })
}
