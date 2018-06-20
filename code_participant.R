# 2.1

# set working directory (the following path only works on DOM1)
# setwd("S:/HQ/102PF/Shared/CJG_OMS/OMS/Analytical Services/RACC/Statistical Project Delivery/3. Training and development/R training/Introduction")

# get working directory
getwd()

#2.2

# Install packages
install.packages("tidyverse")

# Load packages
library("tidyverse")

help(package=dplyr)

# 2.3

# If the csv file is in your working directory
offenders <- read_csv("Offenders_Chicago_Police_Dept_Main.csv")

# From the Analytical Platform amazon server
offenders <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/Offenders_Chicago_Police_Dept_Main.csv")

# 2.4

View(offenders)

str(offenders)

summary(offenders)

head(offenders,10)

tail(offenders, 2)

offenders[c(500, 502),4:5]

# 2.5

offenders$GENDER

offenders[,4]

select(offenders, LAST, FIRST)

offenders$weight_kg <- offenders$WEIGHT*0.454

?mutate

offenders <- mutate(offenders, weight_kg = WEIGHT * 0.454)

View(offenders)

offenders <- rename(offenders, DoB = BIRTH_DATE)

# 3.1

class(offenders$WEIGHT)

offenders$WEIGHT <- as.numeric(offenders$WEIGHT)

offenders$WEIGHT <- as.integer(offenders$WEIGHT) 

offenders$GENDER <- as.factor(offenders$GENDER)  

levels(offenders$GENDER)

offenders$GENDER <- relevel(offenders$GENDER, "MALE")

offenders$GENDER <- as.character(offenders$GENDER) 

offenders$tall <- offenders$HEIGHT > 175

class(offenders$tall)

# 3.2

offenders$wt_under_90  <- ifelse(offenders$weight_kg<90, 1, 0)

# 3.3

?dplyr::summarise
?group_by

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

regional_gender_average <- offenders %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS), Count=n())

regional_gender_average <- ungroup(regional_gender_average)

# 3.4

offenders %>% group_by(SENTENCE) %>% summarise(Count = n())

crt_order_average <- offenders %>% filter(SENTENCE == "Court_order" & AGE > 50) %>% group_by(REGION, GENDER) %>%
  summarise(Ave = mean(PREV_CONVICTIONS))

# 4.1 

Sys.Date()

offenders$DoB_formatted <-  as.Date(offenders$DoB, "%m/%d/%Y")

offenders$b_wkday <- weekdays(offenders$DoB_formatted)

offenders$b_qtr <- quarters(offenders$DoB_formatted)

library(lubridate)

offenders$b_year <- year(offenders$DoB_formatted)

offenders$b_month <- month(offenders$DoB_formatted)

offenders$b_day <- day(offenders$DoB_formatted)

offenders$days_before_2000 <- as.Date("2000-01-01") - offenders$DoB_formatted

# 5.1

# read in data on DOM1 (assuming file in your working directory):
offenders_trial <- read_csv("Offenders_Chicago_Police_Dept_Trial.csv")

# read in data on analytical platform amazon server:
offenders_trial  <- s3tools::s3_path_to_full_df("alpha-everyone/R_training_intro/Offenders_Chicago_Police_Dept_Trial.csv")

offenders_merge <- dplyr::inner_join(offenders, offenders_trial, by=c("LAST", "DoB")) 

men <- filter(offenders, GENDER == "MALE")

women <- filter(offenders, GENDER == "FEMALE")

rejoined <- bind_rows(men, women)

# 5.2

height_table <- offenders %>% group_by(HEIGHT) %>% summarise(Count=n())

View(height_table)

complete.cases(offenders)

complete_offenders <- filter(offenders, complete.cases(offenders))

# 5.3

write.csv(complete_offenders, file = "Complete_offenders.csv")



