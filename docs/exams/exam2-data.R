
##----------------------------------------------------------------------------##
##                                 MTURK DATA                                 ##
##----------------------------------------------------------------------------##

## load packages
library(mwk)

## read data
d <- qualtricks::read_qualtrics(
  "~/Dropbox/JOURN_8016_FA18_November+13,+2018_23.34.csv"
)

## item wordings
items <- attr(d, "descriptions")

## remove preview responses
d <- filter(d, status != "Survey Preview")

## recode condition
d <- d %>%
  mutate(
    ## use timers to code random assignment into conditions
    condition = case_when(
      !is.na(ap_health1timer_last.click) ~ "ap_health",
      !is.na(ap_pol1timer_last.click) ~ "ap_pol",
      !is.na(tw_health1timer_last.click) ~ "tw_health",
      !is.na(tw_pol1timer_last.click) ~ "tw_pol"
    ),
    ## headline format variable
    headline_format = case_when(
      condition %in% c("ap_health", "ap_pol") ~ "apnews.com",
      TRUE ~ "twitter.com"
    ),
    ## headline topic variable
    headline_topic = case_when(
      condition %in% c("ap_health", "tw_health") ~ "Health",
      TRUE ~ "Politics"
    ),
    ## newsworthy variable
    newsworthy = case_when(
      "Not at all newsworthy" == newsworthy ~ 0,
      "Slightly newsworthy" == newsworthy ~ 1,
      "Somewhat newsworthy" == newsworthy ~ 2,
      "Moderately newsworthy" == newsworthy ~ 3,
      "Very newsworthy" == newsworthy ~ 4,
      TRUE ~ NA_real_
    ),
    ## twitter use variable
    twuse = case_when(
      "Never" == twuse ~ 0,
      "Rarely" == twuse ~ 1,
      "Sometimes" == twuse ~ 2,
      "Often" == twuse ~ 3,
      "Very often" == twuse ~ 4
    ),
    ## convert birth year to age
    age = 2018 - born,
    ## recode edu variabe
    edu = case_when(
      edu == "Some high school, no diploma" ~ 1,
      edu == "High school diploma or equivalent" ~ 2,
      edu == "Technical or vocational school after high school" ~ 3,
      edu == "Some college, no degree" ~ 4,
      edu == "Associate's or two-year college degree" ~ 5,
      edu == "Four-year college degree" ~ 6,
      edu == "Graduate or professional school after college, no degree" ~ 7,
      edu == "Graduate or professional degree" ~ 8
    ),
    ## manipulation check--videos and statements are wrong
    mancheck = case_when(
      grepl("videos", mancheck, ignore.case = TRUE) ~ FALSE,
      grepl("statements", mancheck, ignore.case = TRUE) ~ FALSE,
      TRUE ~ TRUE
    )
  )

## rename feeling therm variables
names(d)[grep("therm_|q6", names(d))] <- c("dem_therm", "gop_therm", 
  "sci_therm", "pol_therm", "mov_therm")

## select relevant variables and save
d <- d %>%
  select(party:twuse, 
    mancheck:edu, 
    race, age, 
    headline_format, 
    headline_topic)

## save to file
saveRDS(d, here::here("static", "exams", "exam2-data.rds"))

d
