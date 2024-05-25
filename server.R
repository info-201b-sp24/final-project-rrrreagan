library(shiny)

server <- function(input, output) {
  # Load external R scripts
  source("SummaryInfo.R", local = TRUE)
  source("SummaryTable.R", local = TRUE)
  source("Chart1_maya.R", local = TRUE)
  source("EdaChart2.R", local = TRUE)
  source("Thurainchart.R", local = TRUE)
  
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
    summary_table() # Assuming summary_table() is defined in SummaryTable.R
  })
  
  output$chart1 <- renderPlot({
    chart1() # Assuming chart1() is defined in Chart1_maya.R
  })
  
  output$chart2 <- renderPlot({
    eda_chart2() # Assuming eda_chart2() is defined in EdaChart2.R
  })
  
  output$chart3 <- renderPlot({
    thurain_chart() # Assuming thurain_chart() is defined in Thurainchart.R
  })
}
