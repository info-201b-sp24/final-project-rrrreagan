# SummaryInfo.R
suppressPackageStartupMessages(library(dplyr))

summary_info <- function() {
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
