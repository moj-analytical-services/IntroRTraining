# 1.7 Exercises -----------------------------------------------------------
# Q1 Create a new source code file in which you can store all commands you make during this exercise. Save it as ‘Intro_R_Exercises.R’.

# Q2 Create a new value called y which is equal to 17.
y <- 17
# Q3 Now multiply y by 78. What answer do you get?
y * 78
# Q4 What does the command "head" do?
?head
# Q5 What command might you use to subset a dataset?
?subset


# 2.7 Exercises -----------------------------------------------------------

# Q1 Find the mean, median, max and min for variables AGE and WEIGHT in the dataset offenders.
#Use the below to find the values individually
mean(offenders$AGE)
median(offenders$AGE)
max(offenders$AGE)
min(offenders$AGE)

mean(offenders$WEIGHT)
median(offenders$WEIGHT)
max(offenders$WEIGHT)
min(offenders$WEIGHT)

# or use summary:
summary(offenders$AGE)
summary(offenders$WEIGHT)

# Q2 By changing the SENTENCE class to factor output the levels of this variable. 

class(offenders$SENTENCE)
offenders$SENTENCE<-as.factor(offenders$SENTENCE) #SENTENCE may already be stored as a factor if it is the next line is all that is needed
levels(offenders$SENTENCE)


# 3.6 Exercises -----------------------------------------------------------
# Q1 Using group_by and summarise, calculate the average and median age for females in the West.
offenders %>% 
  filter(GENDER=="FEMALE") %>%
  group_by(GENDER, REGION) %>%
  summarise(mean(AGE), median(AGE))

# Q2 How many have heights of less than 2 metres, what are their (recorded) heights and gender(s)?
offenders %>% 
  select(HEIGHT, GENDER) %>%
  filter(HEIGHT<200)

# Q3 Produce a table showing the counts of height (including missing values).
counts_of_height <- offenders %>% 
  group_by(HEIGHT) %>%
  summarise(Count=n())

View(counts_of_height)

# Q4	Create a new dataset containing PREV_CONVICTIONS and SENTENCE variables, rename 
# SENTENCE as sentence_type, and create a new variable num_convictions that is 
# PREV_CONVICTIONS + 1 (to take account of the latest conviction).
offenders_new <- offenders %>%
  select(SENTENCE, PREV_CONVICTIONS) %>%
  rename(sentence_type = SENTENCE) %>%
  mutate(num_convictions = PREV_CONVICTIONS + 1)

View(offenders_new)


# 4.2 Exercises -----------------------------------------------------------
# Q1 Read in dataset ‘FTSE_12_14.csv’ and convert the variable date to class date. 

# analytical platform amazon server:
ftse <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/FTSE_12_14.csv")

#Or we can use the below to load the data
ftse<-s3tools::read_using(FUN=read.csv, s3_path = "alpha-everyone/R_training_intro/FTSE_12_14.csv") 

## dom1 (if dataset is in working directory):
# ftse <- read_csv("FTSE_12_14.csv")

# first have a look at what format the date is in
str(ftse)

# convert into date format
ftse <- ftse %>%
  mutate(formatted_date = dmy(Date))

# check it worked
class(ftse$formatted_date)

# Q2 Add a variable called day with the day of the week, and another variable called 
# daily_performance for how much the share price has increased or decreased that day 
# (close price - open price). 

# create weekday variable
ftse <- mutate(ftse, weekday = weekdays(formatted_date))

View(ftse)

# add daily performance column
ftse <- mutate(ftse, daily_performance = Close - Open)

View(ftse)

# Q3 Work out which day of the week has the highest mean performance. 

weekday_performance <- ftse %>%
  group_by(weekday) %>%
  summarise(Mean_performance = mean(daily_performance)) %>%
  arrange(desc(Mean_performance))

View(weekday_performance)


# 5.4 Exercises -----------------------------------------------------------
# Q1 Creating a new dataset called offenders_trial_age which includes the data in offenders_trial and the age column of offenders.

# create offenders age dataset with just age column and columns we're joining on
offenders_age <- select(offenders, LAST, DoB=BIRTH_DATE, AGE)

# merge the two datasets
offenders_trial_age <- inner_join(offenders_age, offenders_trial, by=c("LAST", "DoB"))

# Or in one part
offenders_trial_age <- offenders %>% 
  rename("DoB"="BIRTH_DATE") %>%
  select(LAST, DoB, AGE) %>% 
  inner_join(offenders_trial, by=c("LAST", "DoB"))

# Q2 Export the dataset offenders_trial_age to a csv file.
write.csv(offenders_trial_age, "offenders_trial_age.csv")

# Q3(Extension) Using offenders create a new variable HEIGHT_NEW which is as HEIGHT except with the missing values replaced by the average height.
#(hint: you will need to use the ifelse and is.na() functions)

?ifelse
?is.na

mean_height <- mean(offenders$HEIGHT, na.rm = TRUE)

offenders <- offenders %>% 
  mutate(height_new=ifelse(is.na(HEIGHT),mean_height, HEIGHT))



