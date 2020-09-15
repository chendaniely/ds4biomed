# Multiple Chronic Conditions
# Utilization/Spending State Level: All Beneficiaries by Sex and Age, 2007-2017 (ZIP)
# https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Chronic-Conditions/MCC_Main

library(readxl)
library(dplyr)
library(glue)
library(tidyr)
library(purrr)
library(fs)
library(here)
library(readr)

process_gender_sheet <- function(fp, gender) {
  # read in the table with all the extra column variables
  tbl <- read_excel(fp, sheet = gender, col_names = FALSE, skip = 1, na = "*")

  # parse out all the columns to create the new column
  ori_col_names <- names(tbl)

  gender_group <- tbl  %>%
    dplyr::slice(1) %>%
    as.character()

  num_conditions <- tbl  %>%
    dplyr::slice(3) %>%
    as.character()

  variable <- tbl  %>%
    dplyr::slice(4) %>%
    as.character()

  new_col_names <- glue::glue(
    "{variable}::{gender_group}::{num_conditions}"
  )

  # read in only the table with the proper column types
  tbl_data <- read_excel(fp, sheet = gender, skip = 5, na = "*")

  # assign the new column name
  names(tbl_data) <- new_col_names

  # pivot and parse out the values from the new columns
  tbl_long <- tbl_data %>%
    tidyr::pivot_longer(cols = c(-1, -2), names_to = c("variable", "sex", "num_chronic"), names_sep="::")

  sheet_clean <- tbl_long %>%
    tidyr::separate(sex, into = c("sex", "age_group"), sep = gender) %>%
    dplyr::mutate(sex = glue::glue("{gender} {sex}") %>%
                    stringr::str_trim() %>%
                    stringr::str_to_lower(),
                  year = fs::path_file(fp) %>%
                    readr::parse_number()
    ) %>%
    dplyr::rename(
      state = "State::NA::NA",
      state_fips = "State FIPS Code::NA::NA"
    )
  return(sheet_clean)
}

process_sheets <- function(fp, genders = c("Males", "Females")) {
  mf <- purrr::map_df(c("Males", "Females"), ~ process_gender_sheet(fp, .))
  return(mf)
}

file_paths <- fs::dir_ls(here("./data/State_Table_MCC_Utiliz_Spend_by_Sex_and_Age_2017/"))
file_paths

mfy <- purrr::map_df(file_paths, process_sheets)

tidy_example <- mfy %>%
  tidyr::pivot_wider(id_cols = -year, names_from = year, values_from = value) %>%
  dplyr::filter(!stringr::str_detect(sex, "all")) %>%
  dplyr::filter(state != "National")

table(tidy_example$sex)

readr::write_csv(tidy_example, here("./data/cms_utilization.csv"))
