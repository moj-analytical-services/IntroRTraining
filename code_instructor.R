# 1.7 Exercises -----------------------------------------------------------
# Q1 Create a new R script file in which you can store all commands you make during this exercise. Save it as ‘Intro_R_Exercises.R’.

# Q2 Create a new value called y which is equal to 17.
y <- 17
# Q3 Now multiply y by 78. What answer do you get?
y * 78
# Q4 What does the command "head" do?
?head


# 2.7 Exercises -----------------------------------------------------------

# Q1 Find the mean and median for the AGE variable in the offenders dataset. 
#Use the below to find the values individually
mean(offenders$AGE)
median(offenders$AGE)

# Q2 Find the max and min for the WEIGHT variable in the offenders dataset.
max(offenders$WEIGHT)
min(offenders$WEIGHT)

# or use summary:
summary(offenders$AGE)
summary(offenders$WEIGHT)

# Q3 By changing the SENTENCE class to factor output the levels of this variable. 

class(offenders$SENTENCE)
offenders$SENTENCE <- as.factor(offenders$SENTENCE) #SENTENCE may already be stored as a factor if it is the next line is all that is needed
levels(offenders$SENTENCE)


# 3.7 Exercises -----------------------------------------------------------
# Q1 Using group_by and summarise, calculate the average and median age for females in the West.
offenders %>%
  dplyr::group_by(GENDER, REGION) %>%
  dplyr::summarise(mean(AGE), median(AGE)) %>%
  dplyr::filter(GENDER == 'FEMALE', REGION == 'West')

# Q2 Using select and filter produce a table of offender’s genders who are over 2m tall. 
offenders %>% 
  dplyr::select(HEIGHT, GENDER) %>%
  dplyr::filter(HEIGHT>200)

# Q3 Produce a table showing the counts of height (including missing values).
counts_of_height <- offenders %>% 
  dplyr::group_by(HEIGHT) %>%
  dplyr::summarise(Count = n())

# Or
counts_of_height <- offenders %>% 
  dplyr::count(HEIGHT)

View(counts_of_height)

# Extension: Q4	Create a new dataset containing PREV_CONVICTIONS and SENTENCE variables, rename 
# SENTENCE as sentence_type, and create a new variable num_convictions that is 
# PREV_CONVICTIONS + 1 (to take account of the latest conviction).
offenders_new <- offenders %>%
  dplyr::select(SENTENCE, PREV_CONVICTIONS) %>%
  dplyr::rename(sentence_type = SENTENCE) %>%
  dplyr::mutate(num_convictions = PREV_CONVICTIONS + 1)

View(offenders_new)


# 4.2 Exercises -----------------------------------------------------------
# Q1 Read in dataset ‘FTSE_12_14.csv’ and convert the variable date to class date. 

# analytical platform amazon server:
ftse <- botor::s3_read("s3://alpha-r-training/intro-r-training/FTSE_12_14.csv", read_csv)

#If dataset is in working directory:
# ftse <- read_csv("FTSE_12_14.csv")

# first have a look at what format the date is in
str(ftse)

# convert into date format
ftse <- ftse %>%
  dplyr::mutate(formatted_date = lubridate::dmy(Date))

# check it worked
class(ftse$formatted_date)

# Q2 Add a variable called day with the day of the week, and another variable called 
# daily_performance for how much the share price has increased or decreased that day 
# (close price - open price). 

# create weekday variable
ftse <- ftse %>% 
  dplyr::mutate(weekday = lubridate::wday(formatted_date, label=TRUE, abbr=FALSE))

View(ftse)

# add daily performance column
ftse <- ftse %>% 
  dplyr::mutate(daily_performance = Close - Open)

View(ftse)

# Q3 Work out which day of the week has the highest mean performance. 

weekday_performance <- ftse %>%
  dplyr::group_by(weekday) %>%
  dplyr::summarise(Mean_performance = mean(daily_performance)) %>%
  dplyr::arrange(desc(Mean_performance))

View(weekday_performance)


# 5.4 Exercises -----------------------------------------------------------
# Q1 Create a new dataset called offenders_trial_age which includes the data in offenders_trial and the age column of offenders.

# create offenders age dataset with just age column and columns we're joining on
offenders_age <- offenders %>%
  dplyr::select(LAST, BIRTH_DATE, AGE)

# merge the two datasets
offenders_trial_age <- inner_join(offenders_age, offenders_trial, by=c("LAST", "BIRTH_DATE"))

# Or in one go
offenders_trial_age <- offenders %>% 
  dplyr::select(LAST, BIRTH_DATE, AGE) %>% 
  dplyr::inner_join(offenders_trial, by=c("LAST", "BIRTH_DATE"))

# Q2 Export the dataset offenders_trial_age to a csv file.
write.csv(offenders_trial_age, "offenders_trial_age.csv")

# Q3(Extension) Using offenders create a new variable HEIGHT_NEW which is as HEIGHT except with the missing values replaced by the average height.
# (hint: you will need to use the ifelse and is.na() functions)

?replace

mean_height <- mean(offenders$HEIGHT, na.rm = TRUE)

offenders <- offenders %>% 
  dplyr::mutate(height_new=replace(HEIGHT, is.na(HEIGHT), mean_height))

# Alternative with if_else function
offenders <- offenders %>% 
  dplyr::mutate(height_new=dplyr::if_else(is.na(HEIGHT), mean_height, HEIGHT))
