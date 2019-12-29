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
library(scales)
library(reshape2)

# read in data

expense <- read_rds("expense.rds")
comp <- read_rds("comp.rds")
eff <- read_rds("efficiency.rds")
top3 <- read_rds("top3.rds")
top10 <- read_rds("top10.rds")
eff_tsal <- read_rds("eff_tsal.rds")
eff_ratio <- read_rds("eff_ratio.rds")
eff_adv <- read_rds("eff_adv.rds")
eff_frpm <- read_rds("eff_frpm.rds")
eff_addtl <- read_rds("eff_addtl.rds")
select_eff <- read_rds("select_eff.rds")
highest_growth <- read_rds("highest_growth.rds")
largest <- read_rds("largest.rds")
display35 <- read_rds("display35.rds")







# Define UI for application that draws a histogram

ui <- navbarPage("Measuring District Effectiveness in CA Schools",
   
   tabPanel("Explore College Readiness by School District",
            
            fluidPage(
              
              # Application title
              
              titlePanel("School District Stats"),
              
              
              mainPanel(
                
                selectInput("sdistrict", 
                            "Please select a CA school district to view.",
                            select_eff$District),
                br(),
                br(),


                DTOutput("comparisonTable"),

                br(),
                br(),
                br(),
                br(),
                br(),
                br(),



                plotOutput("bigPlotTable")

                # br()
              )
            )
   ),
   
   tabPanel("Most Efficient",
            fluidPage(
              titlePanel("10 Most Efficient School Districts"),
              mainPanel(
                DTOutput("effTable")
              )
            )
            
   ),
   tabPanel("Spending and Performance",
            fluidPage(
              titlePanel("Spending & Performance: Not Always Correlated"),
              mainPanel(
                "In both graphs shown below (ranked in order of top spending and top performance respectively), there are clearly districts that underperform given their per pupil
                spend, as well as overperform given their spend.",
            
                br(),
                br(),
                br(),
                plotOutput("spendPlot"),
                br(),
                br(),
                br(),
                plotOutput("perfPlot")
              )
              
            )
    ),
   
   tabPanel("Deep Dive - Most Efficient Schools",
            fluidPage(
              titlePanel("Top 3 Schools - Other School Characteristics"),
              mainPanel(
                "Literature on school efficiency done by Melvin and Sharma suggests that efficient schools can be defined by the ratio of students/administrators.
                This provides an alternative definition than the spending efficiency that I am exploring by examining spending and performance outcomes. However, I 
                wanted to see if these two measures of efficiency are correlated at all. Melvin and Sharma poses additional correlative factors for efficiency such as
                percent of low income students and percent of teachers with advanced degrees, which are among the factors examined here.",
                br(),
                br(),
                selectInput("col", 
                            "Please select a characteristic to view.",
                            c("Teacher Salary", "Admin", "Teacher Education", "Teacher Experience", "Free & Reduced Lunch")),
                br(),
                br(),
                
                plotOutput("deepDive")
                # br(),
                # br(),
                # br(),
                # plotOutput("perfPlot")
              )
              
            )
   ),
              
  
  
  tabPanel("About",
           fluidPage(
             titlePanel("About This Project"),
             mainPanel(
               "Much of recent scholarship and political debate regarding education has focused on money and outcomes, as well as efficiency of this spending.
               This project was created to explore some of those trends and correlations. I have aggregated data across different sources 
               from the California Department of Education, as well as Transparent California. Data for  ACT and AP scores is a 4 year average
               from 2015-2018, while SAT data is an average from 2015-2016. Per pupil spending is also an average across four years. 
               All other data for school district demographics are from the 2017 school year.",
               
               br(),
               br(),
               
               "This project was created by Jefferey Huang (jeffereyhuang[at]gmail.com). The code can be found at https://github.com/jeffereyhuang/ca-school-district-efficiency.",
               
               br(),
               br(),
               
               "Special thanks to both the CA Department of Education and Transparent CA for aggregating and publishing—this project would not be possible without your help. Additionally, 
               thank you to Data is Plural for pointing me to this dataset. Additional thanks to Preceptor David Kane as well as Albert Rivero and Jacob Brown, for giving me
               the tools to carry out this project."
             )
           )
           
  )
              
              
)

# page 1: Search School District - 
# page 2: Top Performers, Top Spenders
# page 3: Most Efficient School Districts Table
# page 4: Deep Dive into Efficiency Stats
# teaching statistics, free and reduced lunch rates, spend, comp, part, rank





# Define server logic required to draw a graphs
server <- function(input, output) {
   
   output$spendPlot <- renderPlot({
      expense %>% mutate(dname = fct_reorder(dname, d_spend)) %>% 
      
      ggplot(aes(x=dname,y=act_comp_rank)) +
      geom_bar(stat="identity") + 
      coord_flip() +
      theme_economist() +
      ylim(0,100) +
      labs(title="Top 10 Highest Spending Districts - ACT Performance", y="Percentile Rank for ACT Scores",x=NULL)
   })
   
   output$`35_comparisonTable` <- renderDT({
      display35 %>% 
         datatable(rownames=FALSE,
         class="display",
         options=list(dom="t")) %>% 
      formatRound(c(2:4), 2)
   })
   
   output$comparisonTable <- renderDT({
     eff %>% filter(District %in% c(input$sdistrict, "Average Values")) %>% 
     select(District, `Per Pupil Spend`, `Avg. SAT Composite Score`, `Avg. ACT Composite Score`, `Avg. AP Score`) %>% 
     datatable(rownames=FALSE,
               class="display",
               options=list(dom="t")) %>%
       formatRound(c(3), 0) %>% 
       formatRound(c(4:5), 1) %>% 
       formatCurrency("Per Pupil Spend", "$", digits = 0)
       
     
   })
   
   output$bigPlotTable <- renderPlot({
     eff_corr <- eff %>% select(enrollment, District, admin_ratio_per100, mast_per, doc_per) %>% 
       mutate(admin_ratio_per100 = 10* admin_ratio_per100,
              mast_per = 100 * mast_per,
              doc_per = 100 * doc_per) %>% 
       rename(`Enrollment`=enrollment,
              `Admin to Student Ratio (per 1,000)` = admin_ratio_per100,
              `Percent of Teachers with Masters'` = mast_per,
              `Percent of Teachers with Doctorates'` = doc_per
              )
  
     eff_corr %>% filter(District %in% c(input$sdistrict, "Average Values")) %>% 
     melt(id.vars='District') %>% 
       
     ggplot(aes(x=District,y=value, fill=District), show.legend=FALSE) +
       geom_bar(stat="identity", width = 0.5) +
       facet_wrap(~variable, scales="free") +
       theme_economist() +
       theme(legend.position="none") + 
       labs(title="Efficiency Correlates",x=NULL, y=NULL)
   })
   
   output$perfPlot <- renderPlot({
     comp %>% mutate(dname = fct_reorder(dname, act_avg_comp)) %>% 
                     
     ggplot(aes(x=dname, y=expense_rank)) +
       geom_bar(stat="identity") +
       coord_flip() + 
       theme_economist() +
       ylim(0,100) +
       labs(title="Per Pupil Spending of Top 10 Highest Performing Districts", y="Percentile Rank in Spending", x=NULL)
     
   })
   
   output$effTable <- renderDT({
     top10 %>% select(District, "Composite Percentile Rank", "Participation Percentile Rank", "Spend Percentile Rank", "Efficiency Index") %>% 
      datatable(
                rownames=FALSE,
                class="display",
                options=list(dom="t")) %>%
                formatRound(c(1:8), 1)
   }) 

   output$deepDive <- renderPlot({
     if(input$col == "Teacher Salary") {
       ggplot(eff_tsal, aes(x=variable,y=value, fill=District)) +
         geom_bar(stat="identity", position="dodge") + 
         theme_economist() +
         scale_y_continuous(labels = dollar, breaks = c(30000, 60000, 90000, 120000)) +
         labs(title="Teacher Salaries", y="Salary",x=NULL) + 
         theme(legend.title=element_blank(), legend.position = "bottom")
     }
     else if(input$col == "Admin") {
       ggplot(eff_ratio, aes(x=variable,y=value, fill=District)) +
         geom_bar(stat="identity", position="dodge") + 
         theme_economist() +
         scale_y_continuous(breaks = c(0, 3, 6, 9, 12)) +
         labs(title="Administrative Ratios - Students and Teachers", y="Admin",x=NULL) +
         theme(legend.title=element_blank(), legend.position = "bottom")
       
     }
     else if(input$col == "Teacher Experience") {
       ggplot(eff_addtl, aes(x=variable,y=value, fill=District)) +
         geom_bar(stat="identity", position="dodge") + 
         theme_economist() +
         labs(title="Teacher Experience", y="Years",x=NULL) +
         theme(legend.title=element_blank(), legend.position = "bottom")
       
     }
     else if(input$col == "Teacher Education") {
       eff
       ggplot(eff_adv, aes(x=variable,y=value, fill=District)) +
         geom_bar(stat="identity", position="dodge") + 
         theme_economist() +
         scale_y_continuous(labels=percent) +
         labs(title="Teacher Education", y="Percent",x=NULL) +
         theme(legend.title=element_blank(), legend.position = "bottom")
       
     }
     else if(input$col == "Free & Reduced Lunch") {
       ggplot(eff_frpm, aes(x=variable,y=value, fill=District)) +
         geom_bar(stat="identity", position="dodge") + 
         theme_economist() +
         scale_y_continuous(labels= percent) +
         labs(title="Percent of Students on Free and Reduced Lunch", y="Percent",x=NULL) +
         theme(legend.title=element_blank(), legend.position = "bottom")
       
     }
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

