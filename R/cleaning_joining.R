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
surveys = read_xlsx("./data/SMM SurveysAug2019.xlsx", guess_max = 3000)


survey_loc = read_csv("./data/locs.csv")

#Checking out key columns to make sure things align
unique(surveys$Site)
unique(survey_loc$site)

#Cleaning up mismatches
to_clean = c("Big Sycamore Cyn Point Mugu SP", 
             "Castro Crest Backbone Motorway", 
             "Cheseboro Cyn Sulphur Springs and Modelo Trail", 
             "Deer Creek Rd", 
             "Deer Creek Rd.", 
             "Deervale Place", 
             "King Gillette Ranch Inspiration Point Trail", 
             "Mishe Mokwe",
             "Nicholas Flat", 
             "Red Rock Canyon", 
             "Rocky Oaks Park", 
             "Rustic Canyon", 
             "Solstice Canyon Rising Sun Trail", 
             "Trailer Cyn", 
             "Deer Creek Road."
             )

replacement = c("Big Sycamore Cyn",
                "Castro Crest", 
                "Cheseboro Cyn", 
                "Deer Creek Road", 
                "Deer Creek Road", 
                "Deervale Pl", 
                "King Gillette", 
                "Mishe Mokwa", 
                "Nich Flat", 
                "Red Rock Cyn", 
                "Rocky Oaks", 
                "Rustic Cyn", 
                "Solstice Cyn Terrace", 
                "Trailer Canyon", 
                "Deer Creek Road"
                )
length(to_clean) == length(replacement)

clean_sites = function(to_clean = NULL, replacement = NULL, df = NULL) {
  for(i in 1:length(to_clean)) {
    df$Site = str_replace(df$Site, to_clean[i], 
                           replacement[i])
    
  }
  return(df)
}

test = clean_sites(to_clean = to_clean, replacement = replacement, df = surveys)

#Checking
length(unique(test$Site))
length(unique(survey_loc$site))

unique(test$Site) == unique(survey_loc$site)
unique(test$Site)
unique(survey_loc$site)

surveys_clean = clean_sites(to_clean = to_clean, replacement = replacement, df = surveys)

#Cleaning and getting stuff in the right format - for some reason dates aren't parsing correctly
surveys_joined = surveys_clean %>%
  mutate(date_time = ymd(paste(Year, Month, Day, sep= "-"))) %>%
  rename(start_time = `Start Time (PST 24 hr)`, end_time = `End Time (PST 24 hr)`) %>%
  left_join(survey_loc, by = c("Site" = "site"))

write_csv(surveys_joined, "./data/survey_data_master.csv")
