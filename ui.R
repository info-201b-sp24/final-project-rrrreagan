library(shiny)

ui <- fluidPage(
  tags$head(
    tags$style(
      HTML("
        h3:first-of-type {
          font-style: italic;
          font-weight: bold;
        }
        h3:not(:first-of-type) {
          font-style: italic;
        }
        h4 {
          font-style: italic;
        }
        .indented-section {
          padding-left: 20px; /* Adjust the value to change the indent */
        }
      ")
    )
  ),
  titlePanel("INFO 201: Final Project"),
  tabsetPanel(
    id = "tabs",
    tabPanel("Home", 
             h3("Welcome to our INFO 201 Final Project:"),
             h3("Exploring Crime Trends in Seattle from 1975-2018"),
             
             h4("Authors:"),
             # Initial information outside of the tabsetPanel
             div(class = "indented-section",
                 p("Reagan Ince (rince@uw.edu)"),
                 p("Maya Odenheim (mayaoden@uw.edu)"),
                 p("Eda Gokdogan (egokdoga@uw.edu)"),
                 p("Thu Rain Htet (thu97@uw.edu)"),
                 p("Date: Spring 2024")
             ),
             
             div(
               div(
                 h4("Abstract:"),
                 div(class = "indented-section",
                     p("Our primary purpose within this project is to examine and process data that addresses the rates and nature of crime within Seattle. We are interested in examining the occurrence and type of crime, as well as larger trends that exist over time. This is critical to examine larger trends that occur over time and inform measures to remedy the source and structural inquiries that contribute to crime.")
                 )
               )
             ),
             
             div(
               div(
                 h4("Keywords:"),
                 div(class = "indented-section",
                     p("Keywords: crime reports within Seattle, crime offense, crime categories and description, police department information, crime date and time information")
                 )
               )
             ),
             
             div(
               div(
                 h4("Proposal:"),
                 div(class = "indented-section",
                     p("1. Introduction ..."), # Add your introduction content here
                     p("2. Related Work ..."), # Add your related work content here
                     p("3. The Dataset ..."), # Add your dataset content here
                     p("4. Implications ..."), # Add your implications content here
                     p("5. Limitations & Challenges ...") # Add your limitations & challenges content here
                 )
               )
             )
    ),
    tabPanel("Summary Information", 
             h3("Five Sumarizing Values Surrounding Crime in Seattle"),
             p("Within the calculated values we found that the data revealed 
               specific trends regarding the occurrence of crime, and its trends 
               over time. Moreover, specifically within this, we were prompted
               by larger description statistics that could be used to encapsulate 
               trends present within the data. The total number of crime types, 
               highest crime precinct, most frequent subcategory, etc works to 
               provide transparency about many of the trends of crime in 
               Seattle. However it is critical to recognize this data presents
               bias in many of the ways it functions. From only representing 
               reported crimes, and neglecting to mention the nature and 
               circumstance surrounding crimes committed, this data is 
               incomplete."),
             verbatimTextOutput("summaryInfo"),
             style = "background-color: #f2f2f2;"
    ),
    tabPanel("Table", 
             tableOutput("summaryTable"),
             style = "background-color: #e6e6e6;"
    ),
    tabPanel("Chart 1", 
             plotOutput("chart1"),
             style = "background-color: #cccccc;"
    ),
    tabPanel("Chart 2", 
             plotOutput("chart2"),
             style = "background-color: #b3b3b3;"
    ),
    tabPanel("Chart 3", 
             plotOutput("chart3"),
             style = "background-color: #999999;"
    )
  )
)
