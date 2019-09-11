# Data exploration
# Keaton Wilson
# keatonwilson@me.com
# 2019-09-11

# packages
library(tidyverse)
library(spocc)

# reading in data
data = read_csv("./data/survey_data_master.csv")

#Getting names ready to feed into stuff below
unique(data$Species)
to_remove = c("Pontia", "skipper", "acmon/lupini", 
              "SKIPPER", "Euphilotes", "Erynnis sp", 
              "Lycaenid")

filtered_data = data %>%
  drop_na(Species) %>%
  filter(!(Species %in% to_remove))

names = unique(filtered_data$Species)

#pulling occurence records

#Bounding box for search
lat_range = c(34, 34.5)
lon_range = c(-119.25, -118)

bounds = c(-120, 33, -116, 35.5)

#Custom function
butt_obs = function(names){
  df = data.frame()
  for (i in 1:length(names)){
    sub = occ(geometry = bounds, query = names[i], from = "gbif", limit = 100000, has_coords=TRUE, 
              gbifopts=list(continent='north_america'))
    df = bind_rows(df, sub$gbif$data[[1]] %>%
                     mutate(true_name = names[i]))
  }
  return(df)
}

occs = butt_obs(names = names)
occs = occs %>%
  select(name, longitude, latitude, key, family, genus, species, stateProvince, 
         year, month, day, eventDate, countryCode, county, true_name) %>%
  as_tibble()

write_csv(occs, path = "./data/gbif_butterfly_occs.csv")
