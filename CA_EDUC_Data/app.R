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

expense <- read_rds("expense.rds")
part <- read_rds("part.rds")
comp <- read_rds("comp.rds")
eff <- read_rds("efficiency.rds")


# Define UI for application that draws a histogram
ui <- navbarPage("CA HS Education Stats",
   
  
   # Application title
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
  tabPanel("Most Efficient",
           fluidPage(
             titlePanel("Top Performers with the Lowest Spending"),
             mainPanel(
               tableOutput("effTable")
             )
           )
           
  )
              
              
)




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
   
   output$effTable <- renderTable({
      eff
       
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

