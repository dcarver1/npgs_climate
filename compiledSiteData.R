### 
# compile dataset for shiny app 
# carverd@colostate.edu
# 20221102
### 


library(targets)
library(dplyr)
library(sf)

#load datasets 
tar_load(valsWC)
tar_load(valsM)
tar_load(locs)

# split out vals into two df 
#bioc 
v1 <- valsWC %>%
  dplyr::mutate(emission = case_when(
    emission == "ssp126" ~ "SSP126",
    emission == "ssp245" ~ "SSP245",
    emission == "ssp370" ~ "SSP370",
    emission == "ssp585" ~ "SSP585", 
    TRUE~emission
  ))
# monthly 
v2 <- valsM %>%
  dplyr::mutate(emission = case_when(
    emission == "ssp126" ~ "SSP126",
    emission == "ssp245" ~ "SSP245",
    emission == "ssp370" ~ "SSP370",
    emission == "ssp585" ~ "SSP585",
    TRUE~emission
  ))


# bind for reference name 
locs2 <- locs %>%
  sf::st_drop_geometry()%>%
  dplyr::mutate(ID = seq(1,nrow(.),1))%>%
  dplyr::select(ID, `NPGS site`)%>%
  dplyr::mutate(`NPGS site` = case_when(
    `NPGS site` == "Corvallis, Oregon"~ "Oregon, Corvallis",
    `NPGS site` == "Pullman, Washington"~ "Washington, Pullman",
    `NPGS site` == "Aberdeen, Idaho"~ "Idaho, Aberdeen",
    `NPGS site` == "Davis, California"~ "California, Davis",
    `NPGS site` == "Parlier, California"~ "California, Parlier",
    `NPGS site` == "Riverside, California"~ "California, Riverside",
    `NPGS site` == "Hilo, Hawaii"~ "Hawaii, Hilo",
    `NPGS site` == "Fort Collins, Colorado"~ "Colorado, Fort Collins",
    `NPGS site` == "College Station, Texas"~ "Texas, College Station",
    `NPGS site` == "Ames, Iowa"~ "Iowa, Ames",
    `NPGS site` == "Urbana, Illinois"~ "Illinois, Urbana",
    `NPGS site` == "Stuttgart, Arkansas"~ "Arkansas, Stuttgart",
    `NPGS site` == "Columbus, Ohio"~ "Ohio, Columbus",
    `NPGS site` == "Sturgeon Bay, Wisconsin"~"Wisconsin, Sturgeon Bay", 
    `NPGS site` == "Griffin, Georgia"~ "Georgia, Griffin",
    `NPGS site` == "Geneva, New York"~ "New York, Geneva",
    `NPGS site` == "Beltsville, Maryland"~ "Maryland, Beltsville",
    `NPGS site` == "Washington, D.C."~ "D.C., Washington",
    `NPGS site` == "Miami, Florida"~ "Florida, Miami",
    `NPGS site` == "Mayaguez, Puerto Rico"~ "Puerto Rico, Mayaguez",
    `NPGS site` == "Central Ferry, Washington"~ "Washington, Central Ferry",
    `NPGS site` == "Prosser, Washington"~ "Washington, Prosser",
    `NPGS site` == "Isabela, Puerto Rico"~ "Puerto Rico, Isabela",
    `NPGS site` == "St Croix, Virgin Islands" ~ "Virgin Islands, St Croix",
    `NPGS site` == "Thermal, California" ~ "California, Thermal",
    `NPGS site` == "Irvine, California"  ~ "California, Irvine",
    `NPGS site` == "Brownwood, Texas"    ~ "Texas, Brownwood",
    `NPGS site` == "Liberia, Costa Rica" ~ "Costa Rica, Liberia",
    `NPGS site` == "Brownwood, TX"       ~ "Texas, Brownwood",
    `NPGS site` == "Red Run Bog"         ~"Red Run Bog",         
    `NPGS site` == "Cranberry Glades 1"  ~"Cranberry Glades 1",  
    `NPGS site` == "Cranberry Glades 5"  ~"Cranberry Glades 5",  
    `NPGS site` == "Upper Island Lake"   ~"Upper Island Lake",   
    `NPGS site` == "South Prairie"       ~"South Prairie",       
    `NPGS site` == "Little Crater Meadow"~"Little Crater Meadow",
    `NPGS site` == "Lalamilo, HI"~"Hawaii, Lalamilo",
    `NPGS site` == "Volcano, HI" ~"Hawaii, Volcano",
    `NPGS site` == "Paauilo, HI" ~"Hawaii, Paauilo"   
  ))

l1 <- locs2 %>%
  dplyr::left_join(v1, by = "ID" )

# bind for reference name 
l2 <- locs2 %>%
  dplyr::left_join(v2, by = "ID" )

#export to local repo for direct reference 
write.csv(l1, file = "compiledSiteData.csv")
# export basic version to shiny app 
write.csv(l1, file = "npgsClimate/compiledSiteData.csv")
# export to shiny app 
write.csv(l2, file = "npgsClimate/compiledSiteData_monthly.csv")
