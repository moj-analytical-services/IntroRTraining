# 2. Processing Data ------------------------------------------------------

# 2.1 Setting up a working directory

# get working directory
getwd()

# set working directory 
setwd("/home")

# 2.2 Packages

# Install packages
install.packages("tidyverse")

# Load packages
library("tidyverse")

help(package=dplyr)

# 2.3 Importing data

# If the csv file is in your working directory
offenders <- read_csv("Offenders_Chicago_Police_Dept_Main.csv")

# From the Analytical Platform amazon server
offenders <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/Offenders_Chicago_Police_Dept_Main.csv")

# 2.4 Inspecting the dataset

View(offenders) # note the capital V!

str(offenders)

summary(offenders)

offenders[500,4]

offenders[c(500, 502),4]

offenders[500,1:5]

# 2.5 Dataset variables

offenders$GENDER

offenders$weight_kg <- offenders$WEIGHT*0.454

View(offenders)

# 2.6 Data classes

class(offenders$WEIGHT)

offenders$WEIGHT <- as.numeric(offenders$WEIGHT)

offenders$WEIGHT <- as.integer(offenders$WEIGHT) 

offenders$GENDER <- as.factor(offenders$GENDER)  

levels(offenders$GENDER)

offenders$GENDER <- relevel(offenders$GENDER, "MALE")

offenders$GENDER <- as.character(offenders$GENDER) 

offenders$tall <- offenders$HEIGHT > 175

class(offenders$tall)

# 2.7 Ifelse

offenders$wt_under_90  <- ifelse(offenders$weight_kg<90, 1, 0)

# 3.	Data wrangling and ‘group by’ calculations --------------------------------------

# 3.1 Grouping and summarising data

?dplyr::summarise
?group_by

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS), Count=n())

regional_gender_average <- ungroup(regional_gender_average)

# 3.2 Filter

offenders %>% group_by(SENTENCE) %>% summarise(Count = n())

crt_order_average <- offenders %>% filter(SENTENCE == "Court_order" & AGE > 50) %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

# 3.3 Select

offenders_anonymous <- select(offenders, -LAST, -FIRST, -BLOCK)

offenders_anonymous <- select(offenders, BIRTH_DATE, WEIGHT, PREV_CONVICTIONS)

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

# Dates -------------------------------------------------------------------
# 4.1 Manipulating dates

library(lubridate)

today()

offenders<- mutate(offenders, DoB_formatted = mdy(BIRTH_DATE))

class(offenders$DoB_formatted)

offenders <- mutate(offenders, day = day(DoB_formatted))

offenders <- mutate(offenders, quarter = quarter(DoB_formatted))

offenders <- mutate(offenders, year = year(DoB_formatted))

offenders <- mutate(offenders, month = month(DoB_formatted))

offenders <- mutate(offenders, weekday = weekdays(DoB_formatted))

offenders <- mutate(offenders, days_before_2000 = ymd("2000-01-01") - DoB_formatted)


# 4.2 Exercises

# read in ftse data
ftse <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/FTSE_12_14.csv")


# 5.1

# 5 Merging and exporting data --------------------------------------------
# 5.1 Merging datasets

# read in data on DOM1 (assuming file in your working directory):
offenders_trial <- read_csv("Offenders_Chicago_Police_Dept_Trial.csv")

# read in data on analytical platform amazon server:
offenders_trial  <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/Offenders_Chicago_Police_Dept_Trial.csv")

offenders_trial <- dplyr::rename(offenders_trial, BIRTH_DATE=DoB) 

offenders_merge <- dplyr::inner_join(offenders, offenders_trial, by=c("LAST", "BIRTH_DATE")) 

men <- filter(offenders, GENDER == "MALE") 
women <- filter(offenders, GENDER == "FEMALE")
rejoined <- bind_rows(men, women)

nrow(rejoined) # 1413 rows

nrow(offenders) # 1413 rows

# 5.2 Handling missing values

height_table <- offenders %>% group_by(HEIGHT) %>% summarise(Count=n())

View(height_table)

complete.cases(offenders)

complete_offenders <- filter(offenders, complete.cases(offenders))

# 5.3 Exporting data
write.csv(complete_offenders, file = "Complete_offenders.csv")

