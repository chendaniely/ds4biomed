library(tidyverse)
library(readr)
library(xlsx)

# Leading causes of death data
LCOD <- read_csv("NCHS_-_Leading_Causes_of_Death__United_States.csv")
View(LCOD)
# Data set with median ages of people in each of the 50 states as well as DC and the US overall 
# Sorted by highest median age to lowest median age
med_ages <- as.data.frame(read_excel("med_ages_2018.xlsx"))
View(med_ages)

# Function to calculate age-adjusted death rate 
calc_age_adj_death <- function(state, death_count) {
  census <- tribble(
    ~State, ~avg_age,
    "United States", 37.8,
    "Alabama", 40
  )
  
  avg_age <- census %>%
    dplyr::filter(State == state) %>%
    dplyr::pull(avg_age)
  return(avg_age)
}

# Evalute the function
calc_age_adj_death("Alabama", 2700)

df %>%
  filter(State %in% c("United States", "Alabama")) %>%
  mutate(adj = purrr::map2_dbl(State, Deaths, calc_age_adj_death))

library(tidyverse)

calc_age_adj_death <- function(state, death_count = 37.8) {
  census <- tribble(
    ~State, ~avg_age,
    "United States", 37.8,
    "Alabama", 40
  )
  avg_age <- census %>%
    dplyr::filter(State == state) %>%
    dplyr::pull(avg_age)
  return(avg_age)
}

calc_age_adj_death("Alabama", 2700)

df %>%
  filter(State %in% c("United States", "Alabama")) %>%
  mutate(adj = purrr::map2_dbl(State, Deaths, calc_age_adj_death))

# Get the median age of people in the US to use as a generalization
# We could define this inside of the function
med_US_age <- med_ages[which(med_ages$State == "United States"),]

#' @param death_count - the total death count (integer) from the LCOD dataframe
#' Input example would have 1 value
#' Use on a dataframe of 10 rows
#' hard code the avge state age
#' assumme 1 year and 1 state and 1 LCOD
age_adj_death_rate <- function(death_count){
  return(death_count / med_US_age)
}

# Lizzi's work ====================================================================================

# For calculating age adjusted death rate for all LCOD in a specific state in a specific year for a specific cause
# Using base R
calc_age_adj_death_rate <- function(state_inp, year_inp, cause_inp) {
  # Filter by state, year, and cause to get a row of data
  LCOD_info <- LCOD[which(LCOD$State == state_inp & LCOD$Year == year_inp & LCOD$`Cause Name` == cause_inp),] # this step could be separated out to filter for each variable
  # Get the death count from the row of data created above
  death_count <- LCOD_info$Deaths # could combine this step with the line above - this may be too complicated though
  # Filer by state to get a row of data
  med_age_info <- med_ages[which(med_ages$State == state_inp),]
  # Get the median age of the people in that state from the row of data created above
  median_age <- med_age_info$'Median Age' # could combine this step with the line above - this may be too complicated though
  # Calculate the age adjusted death rate and round to the tenths place
  age_adj_death_rate <- round(death_count / median_age, 1)
  # Return a string containing the info just generated
  return(paste("The age adjusted death rate in", state_inp, "is", age_adj_death_rate))
}

# Test the function
calc_age_adj_death_rate("Maryland", 1999, "Stroke")

# For calculating age adjusted death rate for all LCOD in a specific state in a specific year for a specific cause
# Using tidyverse
calc_age_adj_death_rate <- function(state_inp, year_inp, cause_inp) {
  # Filter by state, year, and cause to get a row of data
  LCOD_info <- filter(LCOD, State == state_inp, Year == year_inp, `Cause Name` == cause_inp) # this step could be separated out to filter for each variable
  # Get the death count from the row of data created above
  death_count <- LCOD_info %>% pull(Deaths)
  # Filer by state to get a row of data
  med_age_info <- filter(med_ages, State == state_inp)
  # Get the median age of the people in that state from the row of data created above
  median_age <- med_age_info %>% pull(`Median Age`)
  # Calculate the age adjusted death rate and round to the tenths place
  age_adj_death_rate <- round(death_count / median_age, 1)
  # Return a string containing the info just generated
  return(paste("The age adjusted death rate in", state_inp, "is", age_adj_death_rate))
}

# Test the function - should be the same as the base R function output and it is!
calc_age_adj_death_rate("Maryland", 1999, "Stroke")
# Compare to the age-adjusted death rate from the LCOD data - note the difference
LCOD[which(LCOD$State == "Maryland" & LCOD$Year == 1999 & LCOD$`Cause Name` == "Stroke"),]

# =================================================================================================

## teach purrr / lappy / mapply
# calc_age_adj_death_rate(deaths, state, census)

age_adj_death_rate <- function(death_count, state, year, med_age) {
  NULL
}
