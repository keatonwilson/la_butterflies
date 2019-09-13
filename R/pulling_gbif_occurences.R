# Data exploration
# Keaton Wilson
# keatonwilson@me.com
# 2019-09-11

# packages
library(tidyverse)
library(spocc)
source("./R/get_clean_obs_function.R")

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
split_names = str_split(names, pattern = " ", simplify = TRUE)

#Bounding box for search
lat_range = c(34, 34.5)
lon_range = c(-119.25, -118)
bounds = c(-120, 33, -116, 35.5)

#Custom function
get_butts = function(names, bounds) {
  big_list = list()
  
  for (i in 1:length(names)){
    temp_occ = occ(geometry = bounds, query = names[i], from = c("gbif", "inat"), 
                   limit = 10000)
    big_list[i] = temp_occ
  }
  return(big_list)
}

occs = get_butts(names = names, bounds = bounds)


occs_mod = lapply(occs, '[[', 2)
occs_mod = lapply(occs_mod, '[[', 1)
occs_df = bind_rows(occs_mod)

occs_df_small = occs_df %>%
  dplyr::select(name = scientificName, longitude, 
         latitude, date = eventDate, 
         country = country, state = stateProvince) %>%
  drop_na()

occs_df_unique = occs_df_small %>%
  distinct(longitude, latitude, name, .keep_all=TRUE)
# checking for duplicates

write_csv(occs_df_unique, path = "./data/gbif_inat_butterfly_occs.csv")
