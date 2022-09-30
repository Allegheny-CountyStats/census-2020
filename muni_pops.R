require(tidycensus)
require(dplyr)

dotenv::load_dot_env()

census_api_key(Sys.getenv("census"))

years <- 2016:2019

alco_final <- data.frame()
munis_final <- data.frame()
for (year in years) {
  alco_final <- get_acs("county", state = 42, county = "03", year = year, variable = "B01001_001") %>%
    mutate(year = year) %>%
    bind_rows(alco_final)
  
  munis_final <- get_acs("county subdivision", state = 42, county = "03", year = year, variable = "B01001_001") %>%
    mutate(year = year) %>%
    bind_rows(munis_final)
}

munis_final %>%
  group_by()