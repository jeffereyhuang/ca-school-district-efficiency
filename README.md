# California School District Efficiency Data

Live results of this project can be found here: https://jeffereyhuang.shinyapps.io/ca-edu-spend-effects/.

## Introduction
Much of the recent debate around education is around the most effective, efficient models of education. In these discussions, spending and models of education are often stressed. One way to work within our current models of education is to increase efficiency; as such, I was interested in studying the efficiency of CA HS School districts.

All of the data wrangling and cleaning can be found in school_expenses.rmd and CA_EDUC_Data/app.r contains all the Shiny app code. 

## Theoretical Background & Approach
In this project, I analyze the spending of California HS School Districts and their correlation with performance outcomes on college-readiness tests (SAT, ACT, AP scores). I used a variety of test scores and averaged them across a couple years in order to mediate any discrepancies in student test-taking patterns from district to district. These were turned into percentile ranks to measure performance across tests.

In my evaluation, I also took participation rates into consideration; schools should be rewarded for encouraging their kids to take these tests, even if that means a drop in average test score. 

Using this model, I evaluate the merit of other scholars' work on correlates of school efficiency: evaluate additional district characteristics such as admin/student ratio, percent of low-income students—measured through the Free and Reduced Lunch programs (Melvin and Sharma, 2007)<a name="Melvin&Sharma">[1]</a>. 

## Creating the Efficiency Ranking
After merging all of the different datasets, I created an efficiency index to create a ranking of school districts based upon three factors: highest participation rates (percent of test takers/eligible students), highest average composite scores (average rankings across SAT, ACT, and AP scores), and lowest per-pupil spending (as defined by data from the CA Dept. of Education). 

These factors were all converted from raw data to percentile ranks, and combined together using the following ratio: participation rank (3/12), composite score rank (4/12),  expense rank (5/12).


## Data Sources
The data I use comes primarily from the CA Department of Education (https://www.cde.ca.gov/ds/) and additional teacher salaries data comes from Transparent California (https://transparentcalifornia.com/agencies/salaries/). 

<sup>[1](#Melvin&Sharma) Melvin II, Paul D. and Sharma, Subhash C., "Efficiency Analysis of K-12 Public Education in Illinois" (2007). Discussion Papers. Paper 62. http://opensiuc.lib.siu.edu/econ_dp/62 </sup>


