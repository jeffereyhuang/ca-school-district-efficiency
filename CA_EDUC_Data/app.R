#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(readxl)
library(janitor)
library(gt)
library(ggthemes)
library(DT)

# read in data

expense <- read_rds("expense.rds")
part <- read_rds("part.rds")
comp <- read_rds("comp.rds")
eff <- read_rds("efficiency.rds")


# Define UI for application that draws a histogram

ui <- navbarPage("CA HS Education Stats",
   
  
   # different tabs
   
   tabPanel("Most Efficient",
            fluidPage(
              titlePanel("20 Most Efficient School Districts"),
              mainPanel(
                DTOutput("effTable")
              )
            )
            
   ),
   tabPanel("Top Spenders",
            fluidPage(
              titlePanel("ACT Performance - Percentile Rank"),
              mainPanel(
                plotOutput("spendPlot")
              )
              
            )
    ),
              
              
  tabPanel("Top Performers",
           fluidPage(
             titlePanel("Per Pupil Spending of Top Performing Districs"),
             mainPanel(
               plotOutput("perfPlot")
             )
           )
          
  ),

  tabPanel("Top Participation",
           fluidPage(
             titlePanel("Performance of Top Participation Districts"),
             mainPanel(
               plotOutput("partPlot")
             )
           )
           
  ),
  
  tabPanel("About",
           fluidPage(
             titlePanel("About This Project"),
             mainPanel(
               "Much of recent scholarship and political debate regarding education has focused on money and outcomes.
               This project was created to explore some of those trends. I have aggregated data across different sources 
               from the California Department of Education, as well as Transparent California.",
               
               br(),
               br(),
               
               "This project was created by Jefferey Huang (jeffereyhuang[at]gmail.com). The code can be found at https://github.com/jeffereyhuang/california-county-education-data.",
               
               br(),
               br(),
               
               "Special thanks to both the CA Department of Education and Transparent CA for aggregating and publishing—this project would not be possible without your help. Additionally, 
               thank you to Data is Plural for pointing me to this dataset."
             )
           )
           
  )
              
              
)

# page 1: horizontal bar chart of diff characteristics
# page 2: search school statistics
# page 3: deep dives into edge cases
# page 4: efficiency stats




# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$spendPlot <- renderPlot({
      ggplot(expense, aes(x=dname,y=comp_rank)) +
      geom_bar(stat="identity") + 
      coord_flip() +
      theme_economist() +
      labs(title="Top 10 Highest Spending Districts - ACT Performance", y="Percentile Rank for ACT Scores",x=NULL)
   })
   
   output$perfPlot <- renderPlot({
     ggplot(comp, aes(x=dname, y=expense_rank)) +
       geom_bar(stat="identity") +
       coord_flip() + 
       theme_economist() +
       labs(title="Per Pupil Spending of Top 10 Highest Performing Districts", y="Percentile Rank in Spending", x=NULL)
     
   })
   
   output$partPlot <- renderPlot({
     ggplot(part, aes(x=dname, y=comp_rank)) +
       geom_bar(stat="identity") +
       coord_flip() + 
       theme_economist() +
       labs(title="Composition Score Percentile Rank of Districts with Highest ACT Participation", y="Percentile Rank in ACT Composite Score", x=NULL)
     
   })
   
   output$effTable <- renderDT({
      datatable(eff,
                class="display",
                options=list(dom="t")) %>%
                formatRound(c(1:8), 1)

     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

