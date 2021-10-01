# data/screenshot used for the summative assessment in the
# post workshop survey and long-term survey

library(medicaldata)
library(tidyr)
library(dplyr)
library(writexl)
library(here)

cmv <- medicaldata::cytomegalovirus

dirty <- cmv %>%
  select(ID, age, prior.radiation, aKIRs, donor.cmv, recipient.cmv) %>%
  mutate(recipient.cmv = recode(recipient.cmv,
                                `0` = "recipient_negative",
                                `1` = "recipient_positive")) %>%
  pivot_wider(names_from = donor.cmv,
              values_from = recipient.cmv) %>%
  rename(donor_negative = `0`,
         donor_positive = `1`)

clean <- dirty %>%
  pivot_longer(c(donor_negative, donor_positive),
               names_to = "donor_status",
               values_to = "recipient_status",
               values_drop_na = TRUE)

dirty %>% head(10) %>% writexl::write_xlsx(here("./data/summative-cmv-dirty.xlsx"))
clean %>% head(10) %>% writexl::write_xlsx(here("./data/summative-cmv-clean.xlsx"))
