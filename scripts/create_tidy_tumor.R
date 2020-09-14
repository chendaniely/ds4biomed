library(medicaldata)
library(tidyverse)

df <- tumorgrowth %>%
  mutate(Day = str_pad(Day, width = 2, pad = 0)) %>%
  pivot_wider(names_from = Day, values_from = Size) %>%
  select(sort((tidyselect::peek_vars()))) %>%
  select(Group, Grp, ID, everything())

names(df) <- names(df) %>%
  str_replace("^0", "")

df

readr::write_csv(df, "~/../Desktop/tumorgrowth_long.csv")
