library(medicaldata)
library(readr)
library(xlsx)
library(magrittr)

medicaldata::tumorgrowth %>%
  readr::write_csv("./data/medicaldata_tumorgrowth.csv")

medicaldata::tumorgrowth %>%
  xlsx::write.xlsx("./data/medicaldata_tumorgrowth.xlsx", row.names = FALSE)
