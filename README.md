# California School District Efficiency Data

Live results of this project can be found here: https://jeffereyhuang.shinyapps.io/ca-edu-spend-effects/.

## Introduction
Much of the recent debate around education is around the most effective, efficient models of education. In these discussions, spending and models of education are often stressed. One way to work within our current models of education is to increase efficiency; as such, I was interested in studying the efficiency of CA HS School districts.

All of the data wrangling and cleaning can be found in school_expenses.rmd and CA_EDUC_Data/app.r contains all the Shiny app code. 

**Theoretical Background**
In this project, I analyze the spending of California HS School Districts and their correlation with performance outcomes on college-readiness tests (SAT, ACT, AP scores) — which I use to define one model of efficiency. Using this model, I evaluate the merit of other scholars' work (Melvin and Sharma) on efficiency, and evaluate additional district characteristics such as admin/student ratio, percent of low-income students (measured through the Free and Reduced Lunch programs). 

## Data Sources
The data I use comes primarily from the CA Department of Education (https://www.cde.ca.gov/ds/) and additional teacher salaries data comes from Transparent California (https://transparentcalifornia.com/agencies/salaries/). 
