library(shiny)

ui <- fluidPage(
  titlePanel("Exploratory Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Seattle Crime Trends from 1975-2018"),
      p("Authors:"),
      p("Maya Odenheim (mayaoden@uw.edu)"),
      p("Reagan Ince (rince@uw.edu)"),
      p("Eda Gokdogan (egokdoga@uw.edu)"),
      p("Thu Rain Htet (thu97@uw.edu)"),
      p("Date: Spring 2024"),
      
      h4("Abstract"),
      p("Our primary purpose within this project is to examine and process data that addresses the rates and nature of crime within Seattle. We are interested in examining the occurrence and type of crime, as well as larger trends that exist over time. This is critical to examine larger trends that occur over time and inform measures to remedy the source and structural inquiries that contribute to crime."),
      
      h4("Keywords"),
      p("Keywords: crime reports within Seattle, crime offense, crime categories and description, police department information, crime date and time information"),
      
      h4("Proposal"),
      p("1. Introduction ..."), # Add your introduction content here
      p("2. Related Work ..."), # Add your related work content here
      p("3. The Dataset ..."), # Add your dataset content here
      p("4. Implications ..."), # Add your implications content here
      p("5. Limitations & Challenges ...") # Add your limitations & challenges content here
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary Information", verbatimTextOutput("summaryInfo")),
        tabPanel("Table", tableOutput("summaryTable")),
        tabPanel("Chart 1", plotOutput("chart1")),
        tabPanel("Chart 2", plotOutput("chart2")),
        tabPanel("Chart 3", plotOutput("chart3"))
      )
    )
  )
)
