#Splitting by time period and mapping
#Keaton Wilson
#keatonwilson@me.com
# 2019-09-12

# packages
library(tidyverse)
library(ggmap)
library(maps)

#google key
register_google("AIzaSyDyAqUc4o9p_DOBSF_JOXH5c_JXPqoU4Yw")

# reading in data
data = read_csv("./data/gbif_butterfly_occs.csv")

# base map all records
bounds = c(-121, 31, -113, 36)
m = get_map(bounds)

ggmap(m) +
  geom_point(data = data, aes(x = longitude, y = latitude), alpha = 0.4)

# split by time period 
data %>%
  filter(year < 2000) %>%
  summarize(n = n())

# t1
ggmap(m) +
  geom_point(data = data %>%
               filter(year < 2000), 
             aes(x = longitude, y = latitude), alpha = 0.4)

# t2
ggmap(m) +
  geom_point(data = data %>%
               filter(year > 1999), 
             aes(x = longitude, y = latitude), alpha = 0.4)
