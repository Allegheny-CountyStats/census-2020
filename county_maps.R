require(readr)
require(dplyr)
require(sf)
require(leaflet)

unfilt <- read_csv("PA_REDISTRICTING_DATA.csv") %>%
  rename(`Total Population` = P0010001,
         `White Alone` = P0010003,
         `Black or African American alone` = P0010004,
         `American Indian and Alaska Native alone` = P0010005,
         `Asian alone` = P0010006,
         `Native Hawaiian and Other Pacific Islander alone` = P0010007,
         `Some Other Race alone` = P0010008,
         `Population of two or more races` = P0010009
  ) %>%
  mutate(INTPTLAT = as.character(INTPTLAT),
         INTPTLON = as.character(INTPTLON))


munis <- st_read("tl_2020_42003_cousub20.shp")

red_munis <- unfilt %>%
  right_join(munis, by = c("GEOCODE" = "GEOID20")) 


counties <- st_read("tl_2020_us_county/tl_2020_us_county.shp") %>%
  filter(STATEFP == "42")
  
counties_pop <- counties  %>%
  left_join(unfilt, by = c("GEOID" = "GEOCODE", "COUNTYNS")) 

popPal <- colorNumeric("YlOrRd", counties_pop$`Total Population`)

leaflet(counties_pop) %>%
  addTiles() %>%
  addPolygons(color = ~popPal(`Total Population`),
              fillOpacity = .65,
              popup = ~paste0(`NAME.x`, ": ", prettyNum(`Total Population`, big.mark = ",")))

blackPal <- colorNumeric("Blues", counties_pop$`Black or African American alone`)

leaflet(counties_pop) %>%
  addTiles() %>%
  addPolygons(color = ~blackPal(`Black or African American alone`),
              fillOpacity = .65,
              label = ~`NAME.x`,
              popup = ~paste0(NAMELSAD, ": ", prettyNum(`Black or African American alone`, big.mark = ",")))
