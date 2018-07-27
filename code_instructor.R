# 1 Introduction to R -----------------------------------------------------

# 1.5 Command Console

x <- 3

x

x <- c(3, 2, 4)

# 1.6 Other windows and getting help

?mean

# 1.7 exercises
# Q1 Create a new source code file in which you can store all commands you make during this exercise. Save it as ‘Intro_R_Exercises.R’.

# Q2 Create a new value called y which is equal to 17.
y <- 17
# Q3 Now multiply y by 78. What answer do you get?
y * 78
# Q4 What does the command head do?
?head
# Q5 What command might you use to subset a dataset?
?subset


# 2. Processing Data ------------------------------------------------------

# 2.1 Setting up a working directory

# get working directory
getwd()

# set working directory 
setwd("/home")

# 2.2 Packages

# install.packages("tidyverse")

# Load a package
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

# 2 Exercises
# Q1 What are the mean, max and min for variable AGE in the dataset offenders?
# can find these values individually:
mean(offenders$AGE)
max(offenders$AGE)
min(offenders$AGE)

# or use summary:
summary(offenders$AGE)

# Q2 Use mutate to create a new variable providing the number of (full) years over 16 and to drop the original WEIGHT variable.

# first drop the weight column
offenders_new <- select(offenders, -WEIGHT)

# then create years over 16 variable
offenders_new <- mutate(offenders_new, years_over_16 = AGE - 16)

# Q3 Create a new variable called ‘height_under_150’ which is 1 if under 150 cm and 0 otherwise.
offenders$height_under_150 <- ifelse(offenders$HEIGHT < 150, 1, 0)


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

# 3.6 Exercises -----------------------------------------------------------
# Q1 Using group_by and summarise, calculate the average and median age for females in the West.
offenders %>% group_by(GENDER, REGION) %>%
summarise(mean(AGE), median(AGE))

# Q2 How many have heights of less than 4 feet, what are their (recorded) heights and gender(s)?
filter(offenders, HEIGHT < 400)

# Q3 Produce a table showing the counts of height (including missing values).
counts_of_height <- offenders %>% group_by(HEIGHT) %>%
  summarise(Count=n())

# Q4	Create a new dataset containing PREV_CONVICTIONS and SENTENCE variables, rename 
# SENTENCE as sentence_type, and create a new variable num_convictions that is 
# PREV_CONVICTIONS + 1 (to take account of the latest conviction).
offenders_new <- offenders %>%
  select(SENTENCE, PREV_CONVICTIONS) %>%
  rename(sentence_type = SENTENCE) %>%
  mutate(num_convictions = PREV_CONVICTIONS + 1)

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
# Q1 Read in dataset ‘FTSE_12_14.csv’ and convert the variable date to class date. 

# analytical platform amazon server:
ftse <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/FTSE_12_14.csv")

## dom1 (if dataset is in working directory):
# ftse <- read_csv("FTSE_12_14.csv")

# first have a look at what format the date is in
str(ftse)

# covert into date format
ftse <- ftse %>%
  mutate(formatted_date = dmy(Date))

# check it worked
class(ftse$formatted_date)

# Q2 Add a variable called day with the day of the week, and another variable called 
# daily_performance for how much the share price has increased or decreased that day 
# (close price - open price). 

# create weekday variable
ftse <- mutate(ftse, weekday = weekdays(formatted_date))

# add daily performance column
ftse <- mutate(ftse, daily_performance = Close - Open)

# Q3 Work out which day of the week has the highest mean performance. 

weekday_performance <- ftse %>%
  group_by(weekday) %>%
  summarise(Mean_performance = mean(daily_performance)) %>%
  arrange(desc(Mean_performance))

View(weekday_performance)


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

# 5.4 Exercises 
# Q1 Creating a new dataset called offenders_trial_age which includes the data in offenders_trial and the age column of offenders.

# create offenders age dataset with just age column and columns we're joining on
offenders_age <- select(offenders, LAST, DoB, AGE)

# merge the two datasets
offenders_trial_age <- inner_join(offenders_age, offenders_trial, by=c("LAST", "DoB"))

# Or in one part
offenders_trial_age <- offenders %>% select(LAST, DoB, AGE) %>% inner_join(offenders_trial, by=c("LAST", "DoB"))

# Q2 Export the dataset offenders_trial_age to a csv file.
write.csv(offenders_trial_age, "offenders_trial_age.csv")

# Q3 Using offenders create a new variable HEIGHT_NEW which is as HEIGHT except with the missing values replaced by the average height.
mean_height <- mean(offenders$HEIGHT, na.rm = TRUE)

offenders$height_new <- ifelse(is.na(offenders$HEIGHT), mean_height, offenders$HEIGHT)




