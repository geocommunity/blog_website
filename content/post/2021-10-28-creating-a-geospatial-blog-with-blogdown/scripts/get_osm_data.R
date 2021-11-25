# load necessary package
library(osmdata)
library(sf)
# get parks, gardens, woodlands, grassland and protected areas in and around Meanjin
green_space <- opq("Meanjin") %>% 
  add_osm_features(c("\"leisure\" = \"park\"",
                     "\"leisure\" = \"nature_reserve\"",
                     "\"leisure\" = \"garden\"",
                     "\"natural\" = \"wood\"",
                     "\"natural\" = \"grassland\"",
                     "\"boundary\" = \"protected_area\"")) %>% 
  osmdata_sf()

# process the data
library(dplyr)
# only keep simple polygons
green_areas <- green_space$osm_polygons %>% 
  # recode the type of area
  mutate(feature_type = case_when(leisure == "park" ~ "Park",
                                  leisure == "nature_reserve" ~ "Nature reserve",
                                  leisure == "garden" ~ "Garden",
                                  natural == "wood" ~ "Woodland",
                                  natural == "grassland" ~ "Grass",
                                  boundary == "protected_area" ~ "Protected area",
                                  TRUE ~ NA_character_)) %>% 
  # keep only relevant columns
  select(osm_id, name, feature_type) %>% 
  # remove polygons that didn't match in the recoding
  filter(!is.na(feature_type))

# export
st_write(green_areas,
         "content/post/2021-10-28-creating-a-geospatial-blog-with-blogdown/data/green_spaces.geojson")

