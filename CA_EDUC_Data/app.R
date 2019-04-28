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
library(gt)
library(ggthemes)

# expense <- read_rds("expense")
# part <- read_rds("part")
# comp <- read_rds("comp")

# ACT download data
act18 <- read_xls("act18.xls") %>% 
  clean_names() %>% 
  mutate_at(9:14, as.integer) %>% 
  select(-year)
act17 <- read_xls("act17.xls") %>% 
  clean_names() %>% 
  mutate_at(9:14, as.integer)
act16 <- read_xls("act16.xls") %>% 
  clean_names() %>% 
  mutate_at(6:11, as.integer)
act15 <- read_xls("act15.xls") %>% 
  clean_names() %>% 
  mutate_at(6:11, as.integer) %>% 
  select(-year)


expense18 <- read_xlsx("expense18.xlsx",
                       skip = 10) %>% 
  mutate(CDS = as.character(CDS)) %>% 
  clean_names()
expense17 <- read_xlsx("expense17.xlsx",
                       skip = 8) %>% 
  clean_names()
expense16 <- read_xls("expense16.xls", 
                      skip = 7) %>% 
  clean_names
expense15 <- read_xls("expense15.xls",
                      skip = 7) %>% 
  clean_names() %>% 
  rename(edp_365 = expenditures_edp_365) 

full_act <- bind_rows(act15, act16, act17, act18, .id="year") %>% 
  drop_na(sname) %>% 
  mutate(comp = (avg_scr_eng + avg_scr_math + avg_scr_read + avg_scr_sci)/4, score = comp * num_tst_takr) %>% 
  mutate(test_per = num_tst_takr / enroll12) %>% 
  select(1:8, comp, score, test_per, -rtype)

# district ranks
act_med <- full_act %>% 
  drop_na(test_per, comp) %>% 
  group_by(dname) %>% 
  summarize(test_per = mean(num_tst_takr)/mean(enroll12), avg_comp = sum(score)/sum(num_tst_takr)) %>%
  ungroup() %>% 
  mutate(part_rank = ntile(test_per, 100), comp_rank = ntile(avg_comp, 100))

# full_ap <- bind_rows(ap15, ap16, ap17, ap18, .id="year") %>% 
#   drop_na(sname) %>% 
#   mutate(total = num_scr)
#   select(1:8, -rtype, )
#   view()


full_expense <- bind_rows(expense15, expense16, expense17, expense18, .id="yea r") %>% 
  filter(! district %in% c("Statewide", "Statewide Totals")) %>% 
  group_by(district) %>% 
  summarize(d_spend = sum(edp_365)) %>% 
  mutate(expense_rank = ntile(d_spend, 100)) 

district <- act_med %>% 
  inner_join(full_expense, by=c("dname" = "district"))


expense <- district %>% 
  arrange(desc(expense_rank)) %>% 
  head(10)

part <- district %>% 
  arrange(desc(part_rank)) %>% 
  head(10)

comp <- district %>% 
  arrange(desc(comp_rank)) %>% 
  head(10)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("CA Education Data"),
   
   # Sidebar with a slider input for number of bins 
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )


# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      ggplot(expense, aes(x=dname,y=comp_rank)) +
      geom_bar(stat="identity") + 
      coord_flip() +
      theme_economist() +
      labs(title="Top 10 Highest Spending Districts - ACT Performance", y="Percentile Rank for ACT Scores",x=NULL)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

