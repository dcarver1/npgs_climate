### 
# processing of climate datasets 
#
#
### 

pacman::p_load(sf,terra,tmap, dplyr, readr, purrr, tidyr)
tmap_mode("view")
# load all functions 
list.files("src", full.names = TRUE) %>% map(source)


# genererate a spatail object of all NPGS sites 
sp1 <- getNPGS()


# Establish base line tmax tmin and precip 
wc1 <- processWC(overwrite = FALSE)

# Generate 3 raster stacks for each time frame/senario
scenerios <- c("ssp585", "ssp126", "ssp370")
years <- c( "2030",
            "2050",
            "2070",
            "2090")


# combine raster data -----------------------------------------------------
# single year
# cpssp585_2030 <- processCP(year = "2050", scenerio = "ssp585", overwrite = TRUE)
# multiple years
ssp126 <- map(years, processCP, scenerio = "ssp126", overwrite = FALSE) 
ssp370 <- map(years, processCP, scenerio = "ssp370", overwrite = FALSE)
ssp585 <- map(years, processCP, scenerio = "ssp585", overwrite = FALSE) 


# extracting values to points ---------------------------------------------

## reference data ----------------------------------------------------------
v1 <- terra::extract(wc1, y = sp1, )
v1_long <- reOrderTidy(v1)
v1_long$emission <- "measured"
v1_long$year <- "1990"
# v1_long <- map(unique(v1$ID), reOrderCurrent, data = v1)%>%
#   purrr::reduce(bind_rows)

## future data -------------------------------------------------------------
# combine list of rasters
rasters <- c(ssp126,ssp370,ssp585)%>%
  map(terra::project, y = sp1)
# extract values and reduce to single dataframe 
vals <-  map(rasters,terra::extract,y= vect(sp1))%>%
  purrr::reduce(left_join,by = "ID")

# reformat to a long data structure 
vals_long <- reOrderTidy(vals)
# vals_long <- map(unique(vals$ID), reOrder, data = vals)%>%
#   purrr::reduce(bind_rows)

# combine dataset-- only long for now 
all_vals_long <- bind_rows(v1_long, vals_long)


# write out content  ------------------------------------------------------
# get reference data from spatial feautres 
sp2 <- select(st_drop_geometry(sp1), "NPGS site","Type of site"  )%>%
  mutate("ID" = 1:23)
data <- left_join(sp2, all_vals_long, by = "ID")

## write out features 
write_csv(data, paste0("outputs/long_Example_", Sys.Date(),".csv"))


### something is up with my projected climate data. Need to get back to the source to 
### figure out the conversion
terra::rast("analysisData/climate models/2.5/bioclim/access_cm2_ssp126_2030s_bio_2_5m_no_tile_tif.tif")

