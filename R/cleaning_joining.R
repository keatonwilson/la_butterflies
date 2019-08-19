#Initial Data cleaning and combining
#Keaton Wilson
#keatonwilson@me.com
#2019-08-19
#

#packages
library(tidyverse)
library(readxl)
library(lubridate)

#data read in
surveys = read_xlsx("./data/SMM Surveys.xlsx", guess_max = 2000)
surveys = read_csv("./data/SMM Surveys.csv") %>%
  select(Year:Notes)

survey_loc = read_xlsx("./data/SMM LatLong UTM.xlsx")

#Cleaning and getting stuff in the right format
surveys %>%
  mutate(Date = mdy(Date)) %>%
  left_join(surveys_loc, by = ("Site", ""))
