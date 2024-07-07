# Daniel Redwine
# 7 July 2024

# Correlates of vagrancy in coastal bird species in response to tropical systems
# Instructions for hurricane data: https://michaelminn.net/tutorials/r-hurricanes/index.html
# NHC data https://www.nhc.noaa.gov/data/#hurdat

# Clear environment
rm(list = ls())

# Load Libraries
library(tidyverse)
library(zoo)

# Load the dataset
all_hurricane_data <- read.csv("data/all_hurricane_data.txt", header=F, as.is=T)

# Name the columns
names(all_hurricane_data) = c("DATE", "TIME_UTC", "POINT_TYPE", "STATUS", 
               "LATITUDE", "LONGITUDE", "WINDSPEED_KT", "PRESURE_MB", 
               "NE_34KT", "SE_34KT", "NW_34_KT", "SW_34_KT",
               "NE_50KT", "SE_50KT", "NW_50_KT", "SW_50_KT",
               "NE_64KT", "SE_64KT", "NW_64_KT", "SW_64_KT")


all_hurricane_data = cbind(HID = NA, HNAME = NA, all_hurricane_data)

all_hurricane_data$HID = ifelse(grepl("AL|EP|CP", all_hurricane_data$DATE),
                                all_hurricane_data$DATE, NA)

all_hurricane_data$HNAME = ifelse(grepl("AL|EP|CP", all_hurricane_data$DATE), 
                                  all_hurricane_data$TIME_UTC, NA)

all_hurricane_data$HID = na.locf(all_hurricane_data$HID)

all_hurricane_data$HNAME = na.locf(all_hurricane_data$HNAME)

all_hurricane_data = all_hurricane_data[!grepl("AL|EP|CP", all_hurricane_data$DATE), ]

all_hurricane_data$LATITUDE = trimws(all_hurricane_data$LATITUDE)

all_hurricane_data$LONGITUDE = trimws(all_hurricane_data$LONGITUDE)

all_hurricane_data$LATITUDE = ifelse(grepl("S", all_hurricane_data$LATITUDE), paste0("-", all_hurricane_data$LATITUDE), all_hurricane_data$LATITUDE)

all_hurricane_data$LONGITUDE = ifelse(grepl("W", all_hurricane_data$LONGITUDE), paste0("-", all_hurricane_data$LONGITUDE), all_hurricane_data$LONGITUDE)

all_hurricane_data$LATITUDE = as.numeric(sub("N|S", "", all_hurricane_data$LATITUDE))

all_hurricane_data$LONGITUDE = as.numeric(sub("E|W", "", all_hurricane_data$LONGITUDE))

all_hurricane_data$STATUS = trimws(all_hurricane_data$STATUS)

all_hurricane_data$DECADE = paste0(substr(all_hurricane_data$DATE, 1, 3), "0")