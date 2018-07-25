# 1 Introduction to R -----------------------------------------------------

# 1.1 Command Console

x <- 3

x

# 1.3 Other windows and getting help

?mean

# 1.4 exercises
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

# set working directory (the following path only works on DOM1)
# setwd("S:/HQ/102PF/Shared/CJG_OMS/OMS/Analytical Services/RACC/Statistical Project Delivery/3. Training and development/R training/Introduction")

# get working directory
getwd()

#2.2 Packages

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

head(offenders,10)

tail(offenders, 2)

offenders[c(500, 502),4:5]

# 2.5 Dataset variables

offenders$GENDER

offenders[,4]

select(offenders, LAST, FIRST)

offenders$weight_kg <- offenders$WEIGHT*0.454

?mutate

offenders <- mutate(offenders, weight_kg = WEIGHT * 0.454)

View(offenders)

offenders <- rename(offenders, DoB = BIRTH_DATE)



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


# Calculations ------------------------------------------------------------

# 3.1 Data classes

class(offenders$WEIGHT)

offenders$WEIGHT <- as.numeric(offenders$WEIGHT)

offenders$WEIGHT <- as.integer(offenders$WEIGHT) 

offenders$GENDER <- as.factor(offenders$GENDER)  

levels(offenders$GENDER)

offenders$GENDER <- relevel(offenders$GENDER, "MALE")

offenders$GENDER <- as.character(offenders$GENDER) 

offenders$tall <- offenders$HEIGHT > 175

class(offenders$tall)

# 3.2 Ifelse

offenders$wt_under_90  <- ifelse(offenders$weight_kg<90, 1, 0)

# 3.3 Grouping and summarising data

?dplyr::summarise
?group_by

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS), Count=n())

regional_gender_average <- ungroup(regional_gender_average)

# 3.4 Filter

offenders %>% group_by(SENTENCE) %>% summarise(Count = n())

crt_order_average <- offenders %>% filter(SENTENCE == "Court_order" & AGE > 50) %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

# 3.6 Exercises -----------------------------------------------------------
# Q1 Using group_by and summarise, calculate the average and median age for females in the West.
offenders %>% group_by(GENDER, REGION) %>%
summarise(mean(AGE), median(AGE))

# Q2 Create a new variable called ‘height_under_150’ which is 1 if under 150 cm and 0 otherwise.
offenders$height_under_150 <- ifelse(offenders$HEIGHT < 150, 1, 0)

# Q3 How many have heights of less than 4 feet, what are their (recorded) heights and gender(s)?
filter(offenders, HEIGHT < 400)

# Q4 Produce a table showing the counts of height including missing values.
counts_of_height <- offenders %>% group_by(HEIGHT) %>%
  summarise(Count=n())


# Dates -------------------------------------------------------------------
# 4.1 
library(lubridate)


Sys.Date()

offenders$DoB_formatted <-  as.Date(offenders$DoB, "%m/%d/%Y")


offenders$b_wkday <- weekdays(offenders$DoB_formatted)

offenders$b_qtr <- quarters(offenders$DoB_formatted)



offenders$b_year <- year(offenders$DoB_formatted)

offenders$b_month <- month(offenders$DoB_formatted)

offenders$b_day <- day(offenders$DoB_formatted)

offenders$days_before_2000 <- as.Date("2000-01-01") - offenders$DoB_formatted

# 4.2 Exercises
# Q1 Read in dataset 'FTSE_12_14.csv' and convert the variable date to class date.

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
ftse <- mutate(ftse, day = day(converted_date))

# add daily performance column
ftse <- mutate(ftse, daily_performance = Close - Open)

# Q3 Work out which day of the week has the highest mean performance using summarise(). 

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

offenders_merge <- dplyr::inner_join(offenders, offenders_trial, by=c("LAST", "DoB")) 

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

# 5.3
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




