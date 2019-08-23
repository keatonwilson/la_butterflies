#GPX tracking scripts
#Keaton Wilson
#keatonwilson@me.com
#2019-08-23

#packages
library(tidyverse)
library(rgdal)
library(ggmap)
library(mapr)
library(ggrepel)

register_google(key = "AIzaSyDyAqUc4o9p_DOBSF_JOXH5c_JXPqoU4Yw")

#reading in one to test
#Figuring out what layers there are

ogrListLayers("./data/gps files/Big Sycamore Cyn.gpx")
#Looks like it's in the "track_points" layer

#Single
raw.gpx = readOGR("./data/gps files/Big Sycamore Cyn.gpx", layer = "track_points")

#Multiple
pull_coords_from_gpx = function(path) {
  #Generating a list of filenames from the path argument
  files = list.files(path, full.names=TRUE)
  
  #initializing a list to pipe into
  points_list = list()
  
  #Iterating through every file
  for(i in 1:length(files)){
    raw.gpx = readOGR(files[i], layer = "track_points")
    points_list[[i]] = as_tibble(coordinates(raw.gpx)) %>%
      summarize(lat = mean(coords.x2),
                lon = mean(coords.x1)) %>%
      mutate(site = str_remove(list.files(path)[i], ".gpx"))
  }
  
  points_df = bind_rows(points_list)
  return(points_df)
}

locs = pull_coords_from_gpx(path = "./data/gps files/")

#Mapping to test
la_map = get_map(location = "Malibu", zoom = 10, maptype = "terrain-background")

ggmap(la_map) +
  geom_text_repel(data = locs, aes(x = lon, y = lat, label = site)) +
  geom_point(data = locs, aes(x = lon, y = lat))
