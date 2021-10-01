library(RSQLite)
library(fs)
library(purrr)
library(readr)

data_pths <- fs::dir_ls("data/synthea/")
data_fn <- fs::path_file(data_pths) %>% path_ext_remove()

# all the files make too large of a sqlitedb for github

data_pths <- c(
  "data/synthea/encounters.csv",
  "data/synthea/patients.csv"
)

data_fn <- c(
  "encounters",
  "patients"
)

try({fs::file_delete("data/synthea/synthea.sqlite")})

con <- dbConnect(SQLite(), "data/synthea/synthea.sqlite")

purrr::walk2(data_pths, data_fn, function(x, y){dbWriteTable(con, y, read_csv(x))})

dbListTables(con)

# dbWriteTable(con, "patients", patients)
# dbWriteTable(con, "encounters", encounters)

dbDisconnect(con)
