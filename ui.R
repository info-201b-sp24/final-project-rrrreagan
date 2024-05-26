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
  titlePanel(div(span("INFO 201:", style = "font-style: italic;"), " Final Project", style = "color: #313f69;")),
  style = "background-color: #e8edfc;",
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
                     p("1. Introduction ..."),
                     p("Within our project we intend to explore trends that exist within crime, particularly within Seattle. Through the exploration and synthesis of this data, we will draw connections between parameters including location, nature of crime, rates, and time. We will have an explicit focus on:"),
                     tags$ul(
                       tags$li("What crimes are the most common in different districts of Seattle?"),
                       tags$li("How does the difference between time reported and time of incident reflect policy changes throughout time?"),
                       tags$li("At what time do most crimes occur? Does this differ across different geographic areas?"),
                       tags$li("How do the rates of different types of crime committed change across time?")
                     ),
                     p("These questions were motivated by the nature of the data we are using, as well as a curiosity in exploring larger societal trends within crime. Throughout contemporary society, many populations and communities are disproportionately criminalized. This can be examined through the criminalization of poverty, immigration status, mental illness, and race, among other identities. By exploring current occurrences of crime, we can inform potential policy change, and work to inform larger perceptions of crime, and the structural nature of their origin."),
                     
                     p("For instance, many crimes originate as a result of survival or criminalization of a marginalized identity. For many immigrant communities, particularly undocumented people, they cannot obtain a driver's license. This then makes these communities especially vulnerable to targeting by law enforcement officers and felony charges. Communities of color are also targeted through vagrancy laws and other policies that defer to police discretion.")
                 )
               )
             )
    ),
    tabPanel("Summary Information", 
             h3("Five Summarizing Values Surrounding Crime in Seattle"),
             p("Within the calculated values we found that the data revealed specific trends regarding the occurrence of crime, and its trends over time. Moreover, specifically within this, we were prompted by larger description statistics that could be used to encapsulate trends present within the data. The total number of crime types, highest crime precinct, most frequent subcategory, etc works to provide transparency about many of the trends of crime in Seattle. However it is critical to recognize this data presents bias in many of the ways it functions. From only representing reported crimes, and neglecting to mention the nature and circumstance surrounding crimes committed, this data is incomplete."),
             verbatimTextOutput("summaryInfo")
    ),
    tabPanel("Table", 
             tableOutput("summaryTable"),
             tableOutput("crimeSummaryTable")
    ),
    tabPanel("Chart 1", 
             plotOutput("chart1")
    ),
    tabPanel("Chart 2", 
             plotOutput("chart2")
    ),
    tabPanel("Chart 3", 
             plotOutput("chart3")
    )
  )
)
