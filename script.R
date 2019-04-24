library(tidyverse)
library(readxl)


sat18 <- read_xls("sat18.xls")
sat17 <- read_xls("sat17.xls")
sat16 <- read_xls("sat16.xls")
sat15 <- read_xls("sat15.xls")

full_sat <- bind_rows(sat18, sat17, sat16, sat15, .id="year")

act18 <- read_xls("act18.xls")
act17 <- read_xls("act17.xls")
act16 <- read_xls("act16.xls")
act15 <- read_xls("act15.xls") %>% 
  mutate(Enroll12 )

full_act <- bind_rows(act18, act17, act16, act15, .id="year")

ap18 <- read_xls("ap18.xls")
ap17 <- read_xls("ap17.xls")
ap16 <- read_xls("ap16.xls")
ap15 <- read_xls("ap15.xls")

expense18 <- read_xlsx("expense18.xlsx")
expense17 <- read_xlsx("expense17.xlsx")
expense16 <- read_xls("expense16.xls")
expense15 <- read_xls("expense15.xls")





