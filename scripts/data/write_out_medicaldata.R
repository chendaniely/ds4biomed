library(medicaldata)
library(readr)
library(magrittr)
library(openxlsx)

medicaldata::tumorgrowth %>%
  readr::write_csv("./data/medicaldata_tumorgrowth.csv")

medicaldata::tumorgrowth %>%
  openxlsx::write.xlsx("./data/medicaldata_tumorgrowth.xlsx")
