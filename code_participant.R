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

# set working directory 
setwd("~")

# set working directory if "IntroRTraining" repo has been cloned
setwd("~/IntroRTraining")

# 2.2 Packages

# Install packages (unnecessary if on Analytical Platform)
install.packages("tidyverse")

# Load packages
library("tidyverse")

help(package=dplyr)

# 2.3 Importing data

# If the csv file is in your working directory
offenders <- read_csv("Offenders_Chicago_Police_Dept_Main.csv")

# From the Analytical Platform amazon server
offenders <- s3tools::s3_path_to_full_df("alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv")

# From the updated Analytical Platform server
offenders <- botor::s3_read("s3://alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv", read.csv)

# Alternative way to upload the data from the Analytical Platform amazon server if the option above doesn't work
offenders<-s3tools::read_using(FUN=read.csv, s3_path = "alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv") %>% mutate_if(is.factor, as.character)  

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

offenders$WEIGHT <- as.numeric(offenders$WEIGHT)

offenders$WEIGHT <- as.integer(offenders$WEIGHT) 

offenders$GENDER <- as.factor(offenders$GENDER)  

levels(offenders$GENDER)

offenders$GENDER <- relevel(offenders$GENDER, "MALE")

offenders$GENDER <- as.character(offenders$GENDER) 

# 3.	Data wrangling and ‘group by’ calculations --------------------------------------

# 3.1 Select

?dplyr::select

offenders_anonymous <- select(offenders, BIRTH_DATE, WEIGHT, PREV_CONVICTIONS)

offenders_anonymous <- offenders %>% 
  select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS)

offenders_anonymous <- offenders %>% 
  select(-LAST, -FIRST, -BLOCK)

# 3.2 Grouping and summarising data

regional_gender_average <- offenders %>% 
  group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS)) 

regional_gender_average <- offenders %>% 
  group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS), Count=n()) 

regional_gender_average %>% 
  summarise(Count=n())

regional_gender_average %>% 
  ungroup() %>% 
  summarise(Count=n())

# 3.3 Filter

offenders %>% 
  group_by(SENTENCE) %>% 
  summarise(Count = n())

crt_order_average <- offenders %>% 
  filter(SENTENCE == "Court_order" & AGE > 50) %>% 
  group_by(REGION, GENDER) %>% 
  summarise(Ave = mean(PREV_CONVICTIONS))

# 3.4 Rename

offenders_anonymous <- offenders %>%
  select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  rename(DoB = BIRTH_DATE) 

offenders_anonymous <- offenders %>%
  select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  rename(DoB = BIRTH_DATE, Num_prev_convictions = PREV_CONVICTIONS) 

# 3.5 Mutate

?mutate

offenders_anonymous <- offenders %>%
  select(BIRTH_DATE, WEIGHT, PREV_CONVICTIONS) %>%
  rename(DoB = BIRTH_DATE, Num_prev_convictions = PREV_CONVICTIONS) %>%
  mutate(weight_kg = WEIGHT * 0.454)

# 3.6 If_else

offenders <- offenders %>% 
  mutate(weight_under_170 = if_else(WEIGHT<170,1,0))

# Dates -------------------------------------------------------------------
# 4.1 Manipulating dates

library(lubridate)

today()

offenders<- offenders %>% mutate(DoB_formatted = mdy(BIRTH_DATE))

class(offenders$DoB_formatted)

offenders <- offenders %>% mutate(day = day(DoB_formatted))

offenders <- offenders %>% mutate(quarter = quarter(DoB_formatted))

offenders <- offenders %>% mutate(year = year(DoB_formatted))

offenders <- offenders %>% mutate(month = month(DoB_formatted))

offenders <- offenders %>% mutate(weekday = weekdays(DoB_formatted))

offenders <- offenders %>% mutate(days_before_2000 = ymd("2000-01-01") - DoB_formatted)

# 4.2 Exercises

# Read in ftse data
ftse <- s3tools::s3_path_to_full_df("alpha-r-training/intro-r-training/FTSE_12_14.csv")

#Read in ftse data using botor
ftse <- botor::s3_read("s3://alpha-r-training/intro-r-training/ FTSE_12_14.csv", read.csv)

# Alternative way to upload the ftse data from the Analytical Platform amazon server if the option above doesn't work
ftse <-s3tools::read_using(FUN=read.csv, s3_path = "alpha-r-training/intro-r-training/FTSE_12_14.csv") %>% mutate_if(is.factor, as.character)  

# To read the file in directly from the wd (for those on borrowed macs you will need to do this) use
library(readr)
ftse <- read_csv("FTSE_12_14.csv")

# 5 Merging and exporting data --------------------------------------------
# 5.1 Merging datasets

# Read in data on DOM1 (assuming file in your working directory):
offenders_trial <- read_csv("Offenders_Chicago_Police_Dept_Trial.csv")

# Read in data on analytical platform amazon server:
offenders_trial  <- s3tools::s3_path_to_full_df("alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Trial.csv")

# Alternative way to upload the offenders trial data from the Analytical Platform amazon server if the option above doesn't work
offenders_trial <-s3tools::read_using(FUN=read.csv, s3_path = "alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Trial.csv") %>% mutate_if(is.factor, as.character)  

offenders_trial <- offenders_trial %>% 
  rename(BIRTH_DATE=DoB) 

offenders_merge <- inner_join(offenders, offenders_trial, by=c("LAST", "BIRTH_DATE")) 

men <- offenders %>% filter(GENDER == "MALE") 
women <- offenders %>% filter(GENDER == "FEMALE")
rejoined <- bind_rows(men, women)

nrow(rejoined) # 1413 rows

nrow(offenders) # 1413 rows

# 5.2 Handling missing values

height_table <- offenders %>% 
  group_by(HEIGHT) %>% 
  summarise(Count=n())

View(height_table)

is.na(offenders$HEIGHT)

complete.cases(offenders)

complete_offenders <- offenders %>% 
  filter(complete.cases(offenders))

# 5.3 Exporting data
write.csv(complete_offenders, file = "Complete_offenders.csv")

