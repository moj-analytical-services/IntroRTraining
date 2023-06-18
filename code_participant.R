# 1 Introduction to R -----------------------------------------------------

# 1.5 Command Console

x <- 3

x

x <- c(3, 2, 4)

# 1.6 Other windows and getting help

?mean

# 2. Processing Data ------------------------------------------------------

# 2.1 Setting up a working directory

# get working directory
getwd()

# set working directory manually, if the "IntroRTraining" repo hasn't been 
# cloned and an RStudio project is not used
setwd("~/IntroRTraining")

# 2.2 Packages

# renv restore (only needs running if you're cloning the repo for the first
# time)
# If you do not have the renv package, please install it by running
# install.packages("renv") in the console.
renv::restore()

# This the command to install/update a package using renv.
# If you are not using renv, e.g. if you are not on the AP, then the command is
# install.packages('tidyverse')
renv::install("tidyverse")

# RESTART, with the red button on the top right.

# This is the command to load a package. It is generally considered better
# not to load packages, but to call the package at the time the function is
# called. However, 'magrittr' is an exception (more on this below).

library('magrittr')
# If you get an error, it might be because of not restarting above.

help(package = dplyr)

# 2.3 Importing data

# From the updated Analytical Platform server
# Here the function s3_read is using the function read_csv to read the data it
# downloads
offenders <- botor::s3_read(
  uri = "s3://alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv",
  fun = readr::read_csv)

# If the csv file is in your working directory
offenders <- readr::read_csv(file = "Offenders_Chicago_Police_Dept_Main.csv")

# 2.4 Inspecting the dataset

View(offenders) # note the capital V!

str(offenders)

summary(offenders)

offenders[500,4]

offenders[c(500, 502),4]

offenders[500,1:5]

offenders$GENDER

# 2.5 Data classes

class(offenders$WEIGHT)

offenders$WEIGHT <- as.integer(offenders$WEIGHT)

offenders$WEIGHT <- as.numeric(offenders$WEIGHT) 

offenders$GENDER <- as.factor(offenders$GENDER)  

levels(offenders$GENDER)

offenders$GENDER <- relevel(offenders$GENDER, "MALE")

offenders$GENDER <- as.character(offenders$GENDER) 

# 3.	Data wrangling and ‘group by’ calculations -------------------------------

# 3.1 Select

?dplyr::select

offenders_anonymous <- dplyr::select(offenders, BIRTH_DATE, WEIGHT,
                                     PREV_CONVICTIONS)

offenders_anonymous <- offenders %>% 
  dplyr::select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS)

offenders_anonymous <- offenders %>% 
  dplyr::select(-LAST, -FIRST, -BLOCK)

# 3.2 Grouping and summarising data

regional_gender_average <- offenders %>% 
  dplyr::group_by(REGION, GENDER) %>%
  dplyr::summarise(Ave = mean(PREV_CONVICTIONS)) 

regional_gender_average <- offenders %>% 
  dplyr::group_by(REGION, GENDER) %>%
  dplyr::summarise(Ave = mean(PREV_CONVICTIONS), Count=n()) 

offenders %>% 
  dplyr::count(REGION, GENDER)

regional_gender_average %>% 
  dplyr::summarise(Count=n())

regional_gender_average %>% 
  dplyr::ungroup() %>% 
  dplyr::summarise(Count=n())

# 3.3 Filter

offenders %>% 
  dplyr::group_by(SENTENCE) %>% 
  dplyr::summarise(Count = n())

offenders %>% 
  dplyr::count(SENTENCE)

crt_order_average <- offenders %>% 
  dplyr::filter(SENTENCE == "Court_order" & AGE > 50) %>% 
  dplyr::group_by(REGION, GENDER) %>% 
  dplyr::summarise(Ave = mean(PREV_CONVICTIONS))

# 3.4 Rename

offenders_anonymous <- offenders %>%
  dplyr::select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  dplyr::rename(DoB = BIRTH_DATE) 

offenders_anonymous <- offenders %>%
  dplyr::select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  dplyr::rename(DoB = BIRTH_DATE, Num_prev_convictions = PREV_CONVICTIONS) 

# 3.5 Mutate

?mutate

offenders_anonymous <- offenders %>%
  dplyr::select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  dplyr::rename(DoB = BIRTH_DATE, Num_prev_convictions = PREV_CONVICTIONS) %>%
  dplyr::mutate(weight_kg = WEIGHT * 0.454)

# 3.6 If_else

offenders <- offenders %>% 
  dplyr::mutate(weight_under_170 = if_else(WEIGHT<170,1,0))

# Dates -------------------------------------------------------------------
# 4.1 Manipulating dates

library(lubridate)

lubridate::today()

offenders <- offenders %>% 
  dplyr::mutate(DoB_formatted = lubridate::mdy(BIRTH_DATE))

class(offenders$DoB_formatted)

offenders <- offenders %>% 
  dplyr::mutate(day = lubridate::day(DoB_formatted))

offenders <- offenders %>%
  dplyr::mutate(quarter = lubridate::quarter(DoB_formatted))

offenders <- offenders %>%
  dplyr::mutate(year = lubridate::year(DoB_formatted))

offenders <- offenders %>%
  dplyr::mutate(month = lubridate::month(DoB_formatted))

offenders <- offenders %>%
  dplyr::mutate(weekday = lubridate::wday(DoB_formatted, label=TRUE, abbr=FALSE))

offenders <- offenders %>%
  dplyr::mutate(days_before_2000 = lubridate::ymd("2000-01-01") - DoB_formatted)

# 4.2 Exercises

#Read in ftse data using botor
ftse <- botor::s3_read("s3://alpha-r-training/intro-r-training/FTSE_12_14.csv", read_csv)

# To read the file in directly from the wd (for those on borrowed macs you will need to do this) use
ftse <- readr::read_csv("FTSE_12_14.csv")


# 5 Merging and exporting data --------------------------------------------
# 5.1 Merging datasets

# Read in data from s3 on Analytical Platform:
offenders_trial <- botor::s3_read("s3://alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Trial.csv", read_csv)

# Read in data on DOM1 (assuming file in your working directory):
offenders_trial <- readr::read_csv("Offenders_Chicago_Police_Dept_Trial.csv")

offenders_trial <- offenders_trial %>% dplyr::rename(BIRTH_DATE=DoB) 

offenders_merge <- dplyr::inner_join(offenders, offenders_trial, by=c("LAST", "BIRTH_DATE")) 

offenders_merge <- dplyr::inner_join(offenders, offenders_trial, by=c("LAST", "BIRTH_DATE" = "DoB")) 

men <- offenders %>% dplyr::filter(GENDER == "MALE") 
women <- offenders %>% dplyr::filter(GENDER == "FEMALE")
rejoined <- dplyr::bind_rows(men, women)

nrow(rejoined) # 1413 rows

nrow(offenders) # 1413 rows

# 5.2 Handling missing values

height_table <- offenders %>% 
  dplyr::group_by(HEIGHT) %>% 
  dplyr::summarise(Count=n())

View(height_table)

is.na(offenders$HEIGHT)

complete.cases(offenders)

complete_offenders <- offenders %>% 
  dplyr::filter(complete.cases(offenders))

# 5.3 Exporting data
write.csv(complete_offenders, file = "Complete_offenders.csv")

