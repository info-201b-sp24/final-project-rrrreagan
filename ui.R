library(shiny)
library(shinyjs)

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
             ),
            h4("Date: Spring 2024"),
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
                     h5("1. Introduction ..."),
                     
                     p("Within our project we intend to explore trends that exist within crime, particularly within Seattle. Through the exploration and synthesis of this data, we will draw connections between parameters including location, nature of crime, rates, and time. We will have an explicit focus on:"),
                     tags$ul(
                       tags$li("What crimes are the most common in different districts of Seattle?"),
                       tags$li("How does the difference between time reported and time of incident reflect policy changes throughout time?"),
                       tags$li("At what time do most crimes occur? Does this differ across different geographic areas?"),
                       tags$li("How do the rates of different types of crime committed change across time?")
                     ),
                     p("These questions were motivated by the nature of the data we are using, as well as a curiosity in exploring larger societal trends within crime. Throughout contemporary society, many populations and communities are disproportionately criminalized. This can be examined through the criminalization of poverty, immigration status, mental illness, and race, among other identities. By exploring current occurrences of crime, we can inform potential policy change, and work to inform larger perceptions of crime, and the structural nature of their origin."),
                     
                     p("For instance, many crimes originate as a result of survival or criminalization of a marginalized identity. For many immigrant communities, particularly undocumented people, they cannot obtain a driver's license. This then makes these communities especially vulnerable to targeting by law enforcement officers and felony charges. Communities of color are also targeted through vagrancy laws and other policies that defer to police discretion."),
                 
                     h5("2. Related Work ..."),
                     
                     p(HTML("This project informs the data set of crime offenses in Seattle. By examining this dataset that contains crime reports for approximately 10 years, this project aims for understanding the unique factors such as crime categories, description, police department information and how it compares to the different geographic areas as well as race and immigration status. 

    <BR><BR>Our first research study focuses on the data report conducted by the Seattle Police Department. The data collected from SDP compares the distinct offense categories and offenses such as shoplifting, car prowl, burglary. It aims for the identification of prime offense descriptions. The identification of the crime helps us to determine the most common types of crimes by region. 

    <BR><BR>Furthermore, it expands the crime analysis in the changes across the time by focusing on the temporal trends throughout the years. FBI’s Uniform Crime Reporting provides an annual reporting of the crime offenses depending on seasonal variations as well as showing the crime categories based on seasonal changes. 

    <BR><BR>Apart from the crimes happening in various geographical areas and time that different crimes happened across years, our project delves into the immigrant communities in Seattle and the crime patterns in urban environments. The study conducted by Yuning and Altheimer focuses on the comparison between immigrant populations and native-born residents in Seattle. It highlights how immigrants can be victimized by the higher rate of crimes and how the role of employment opportunities and social services correlates with certain types of crimes besides their socioeconomic status. 

    <BR><BR>Studies have shown the distinct crime categories by region, provided information about how time changes have an impact on crime and observed social groups in order to examine the relationship between these groups and crimes in Seattle. This project aims to combine all the studies and identify the factors that contribute to the crime in Seattle.")),
 
    h5("3. The Data Set ..."),
                     
    p(HTML("The data was found on Kaggle at: https://www.kaggle.com/datasets/adoumtaiga/crime-data-set. The dataset was collected by Pimpler, who is described as a \"Data science expert using R\". Other collaborators include Adoum Taiga and Boris Mbobe who are both said to be data scientists at the Agiat Corporation and CLIVERS respectively. 

    <BR><BR>The specific methodology for how the data was collected or generated is not provided. Given that it covers crime reports in Seattle over a 10 year period, the data was likely obtained from the Seattle police Department’s incident reporting system. It may have been scraped from online public records, obtained through public records requests.

    <BR><BR>The purpose behind the collection and sharing of this data is not explicitly stated. Potential reasons could include making the data available for public research and analysis, demonstrating data science techniques, or drawing attention to crime patterns and trends in Seattle.

    <BR><BR>The dataset contains 481377 rows, with each row representing a crime report. There are 11 columns or features for each crime report, including details about the date, time, offense type, crime description, and location.

    <BR><BR>Ethical Considerations: Some key ethical questions to consider with this data:
    - The data provides fairly granular details about the location of crimes, down to the neighborhood level. This could potentially stigmatize certain areas as being high in crime. It's important to report on this data responsibly.
    - The data doesn't appear to include any personal information about victims or perpetrators, which is good for privacy. However, even de-identified crime data can sometimes be re-identified when combined with other datasets.
    - Since the data comes from police reports, it reflects reported crimes only. It may not fully capture crimes that are unreported, which could skew the data.
    - We don't know the exact conditions under which Pimpler obtained this government data. Was it truly public data? Was it shared with any restrictions or conditions?

    <BR><BR>There are several potential limitations and problems that should be considered when working with this Seattle crime dataset:

    <BR><BR>Underreporting of crime: One major issue is that this data only includes crimes that were reported to the police. Many crimes go unreported for a variety of reasons, such as fear of retaliation, distrust of police, shame, or a belief that police will not help. This underreporting is not uniformly distributed - certain types of crime like sexual assault and domestic violence tend to be underreported at higher rates. Underreporting can skew the data and make it seem like some crimes are less prevalent than they actually are.

    <BR><BR>Inconsistent categorization: With nearly half a million records spanning a decade, there are likely to be some inconsistencies in how crimes were categorized. The data includes a \"Primary Offense Description\" field, but it's unclear if every instance of a given crime type was always coded the same way. Changes in the Seattle PD's reporting practices, classification standards, or records management systems over the years could impact the reliability of crime categories for analyzing trends.

    <BR><BR>Limited location data: While the dataset does include location fields like beat, precinct and neighborhood, the specific format varies. Some list a block or intersection, others just a neighborhood. There is no structured geospatial data provided, which could make mapping and geographic analysis difficult. Any location-based insights would be fairly broad.

    <BR><BR>Lack of context and completeness: Police data provides a limited view of crime incidents. It doesn't include unreported crimes, and omits contextual factors about the people involved, circumstances, and outcomes after the initial report. It can't shed much light on the root causes of crime or the criminal justice process after an incident is reported.

    <BR><BR>Potential for biased policing: Crime report data can be skewed by enforcement practices. If police overpatrol certain areas or populations, or are more likely to document certain types of crimes, it will be overrepresented in the data relative to actual incidence. Biases and disparities in what crimes are reported and recorded can misrepresent the true crime landscape.

    <BR><BR>Lack of timeliness: This dataset was last updated in 2018, so it doesn't include the most recent years. Crime patterns can change quickly, so this data may not reflect the current situation, especially with the impact of the COVID-19 pandemic on crime rates. Real-time or frequently updated data would be more useful for understanding the present crime landscape.")),
                     br(),
                     h5("4. Implications ..."),
                     
                     p(HTML("Assuming our research questions are answered, the broader implications of our findings is having a better understanding of how crime in the Seattle area operates. 
    
    <BR><BR>For technologists, this improved understanding could potentially aid in the creation of predictive crime analytics tools that could optimize law enforcement resource allocation, as past crime patterns themselves would be better understood. Moreover, understanding crime patterns in Seattle could also help technologists and designers, alike, in creating crime prevention technologies tailored to local areas. 
    
    <BR><BR>Our analysis and the research question it addresses would also help inform the decision of policymakers, allowing them to pass legislation that allocates resources to those most in need, institute policies that address the needs of specific areas, and assess and propose modifications to current policies addressing crime based on their perceived impact on crime statistics. 
    
    <BR><BR>Ultimately, through the analysis of crime data, a better understanding of how crime functions in the Seattle area could occur, allowing for more efficient and targeted approaches to crime prevention and law enforcement to emerge.")),
                     
                     br(),
                     h5("5. Limitations & Challenges ..."),
                     p(HTML("Within our examination of crime within Seattle, potential issues we may encounter is not having enough recent data, so conclusions reflecting the current state of crime will be more difficult. Moreover, there might be gaps or inconsistencies within the data that we need to address.

    <BR><BR>We also need to acknowledge the biased nature of the data we are employing. Since crime reports only detail crimes that were known by police, and submitted, there are a large amount of crimes that go unreported. We also have to acknowledge potential mistakes within the data. Certain crimes may be overrepresented due to over policing certain neighborhoods, and others may be underrepresented due to a lack of trust between communities and law enforcement. 

    <BR><BR>Moreover, crime data, in and of itself, is not fully ‘objective’ given the complex historical context of crime, specifically its intersection with racism, as many criminal justice systems have a troubling history of racial bias, discrimination, and systemic inequity. This history also needs to be addressed in our analysis to ensure that we are not perpetuating harmful stereotypes and exacerbating existing injustices.

    <BR><BR>Furthermore, in drawing conclusions from our data, we have to consider the larger socioeconomic, legislative, and political conditions in the time it was committed. Failing to consider these important contexts will lead to misinterpretation in the data and flawed conclusions."))
                     
                     
                     
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
             sidebarLayout(
               sidebarPanel(
                 p("This chart visualizes the distribution of crime in Seattle across police beats over distinct time periods. The distinct periods reflect distinct police beats as during the time period which this dataset spans, 1975-2018, the police beats have been changed three times, resulting in a total of 4 distinct police beats. By doing so, the chart provides insights into how the proportion of crimes has changed across various beats over time, highlighting areas in Seattle that consistently experience higher proportions of crimes and may serve as potential crime hotspots. It also allows for cross-comparison between different time periods to identify significant changes in crime distribution that may be attributable to shifts in policing strategies, community interventions, or socio-economic changes."),
                 p("The color intensity on the map indicates the proportion of crimes relative to the total number of crimes in each police beat. Darker shades represent higher proportions of crimes."),
                 p("Use the checkboxes to select the time periods you want to compare."),
                 
                 checkboxGroupInput("years", "Select Time Periods:",
                                    choices = list("1975-2007" = "pre_2008",
                                                   "2008-2015" = "2008_2015",
                                                   "2015-2017" = "2015_2017",
                                                   "2017-2018" = "post_2017"),
                                    selected = c("pre_2008", "2008_2015", "2015_2017", "post_2017")),
               ),
               mainPanel(
                 plotOutput("crimePlot")
               )
             )
    ),
    
    tabPanel("Chart 2", 
             plotOutput("chart2")
    ),
    tabPanel("Chart 3", 
             plotOutput("chart3")
    )
  )
)
