
# read in csv and convert to sf object 
processNPGS <- function(file){
  d1 <- read_csv(file)%>%
    dplyr::select("NPGS site","Address","Type of site","Latitude","Longitude","Include in Crop Science Report (TRUE/FALSE)")%>%
    dplyr::filter(`Include in Crop Science Report (TRUE/FALSE)` == TRUE)%>% 
    st_as_sf(coords = c("Longitude","Latitude"))%>%
    st_set_crs(value = 4326)
  return(d1)
}

# create a bounding box with a bit more space to ensure all features are 
# included in the extraction
bbox <- function(locationData){
  ##
  # creating a bbox feature to use to clip raster data. This is 0.5 degree larger then extent of points. I want a 
  bb1 <- sf::st_bbox(locationData)
  #xmin
  bb1[1] <- as.numeric(bb1[1]) -0.5
  #xmax
  bb1[3] <- as.numeric(bb1[3]) + 0.5
  #ymin
  bb1[2] <- as.numeric(bb1[2]) -0.5
  #ymax
  bb1[4] <- as.numeric(bb1[4]) +0.5
  return(bb1)
}

# process historic data 
processWC <- function(boundingBox){
  ###
  # temp : 5,6,8,9,10,11
  # prec : 13,14,16,17,18,19 
  ##
  
  # need to add a the terra ext object 
  bb2 <- terra::ext(boundingBox[1],boundingBox[3],boundingBox[2],boundingBox[4])
  

  # temperature bioclim ----------------------------------------------------- 
  # "bioc_5"
  bio5 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_5.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio5) <- "bioc5_1970_2000"
  # "bioc_6"
  bio6 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_6.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio6) <- "bioc6_1970_2000"
  # "bioc_8"
  bio8 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_8.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio8) <- "bioc8_1970_2000"
  # "bioc_9"
  bio9 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_9.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio9) <- "bioc9_1970_2000"
  # "bioc_10"
  bio10 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_10.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio10) <- "bioc10_1970_2000"
  # "bioc_11"
  bio11 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_11.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio11) <- "bioc11_1970_2000"

  # precipitation bioclim ---------------------------------------------------
  # "bioc_13"
  bio13 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_13.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio13) <- "bioc13_1970_2000"
  # "bioc_14"
  bio14 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_14.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio14) <- "bioc14_1970_2000"
  # "bioc_16"
  bio16 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_16.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio16) <- "bioc16_1970_2000"
  # "bioc_17"
  bio17 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_17.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio17) <- "bioc17_1970_2000"
  # "bioc_18"
  bio18 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_18.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio18) <- "bioc18_1970_2000"
  # "bioc_19"
  bio19 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_19.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio19) <- "bioc19_1970_2000"
  
  
  # Combine the data sets 
  rasts <- c(bio5,bio6, bio8, bio9,bio10,bio11, bio13,bio14,bio16,bio17,bio18, bio19)
  .r <- wrap(rasts)
  return(.r) 
}



# process bioclim 
processFutureBio <- function(scenerio,year,boundingBox){
  path <- "climateData/future"
  name <- paste0(scenerio,"_",year)
  
  # need to add a the terra ext object 
  bb2 <- terra::ext(boundingBox[1],boundingBox[3],boundingBox[2],boundingBox[4])
  
  # grab all tmax files
  files <- list.files(path = path, pattern = name,
                      full.names = TRUE, recursive = TRUE )
  # bioclim indicators :"wc2_4","wc2_5","wc2_10","wc2_11", "wc2_15", "wc2_18","wc2_19")
  # temp : 5,6,8,9,10,11
  # prec : 13,14,16,17,18,19 
  indexs<-c("wc2_5","wc2_6","wc2_8", "wc2_9","wc2_10","wc2_11",
            "wc2_13","wc2_14","wc2_16","wc2_17","wc2_18","wc2_19")
  bioIndicators <- c(5,6,8,9,10,11,
                     13,14,16,17,18,19)
  
  #bioclim
  # read in files as rasts and select specifc layers before clipping
  bioc <- files[grepl(x = files, pattern = "bioc")]%>%
    rast(lyrs = bioIndicators)%>% #lyrs = bioIndicators
    crop(bb2)
  
  b2 <- tapp(bioc, index=c(1:12), fun=mean)
  rm(bioc)
  gc()
  
  #names(b2) <- paste0(rep(paste0("bioc_",name,"_"),length(indexs)),indexs)
  #names(b2) <-
  names(b2) <- paste0(rep("bioc",length(indexs)), bioIndicators,"_", rep(name,length(indexs)))
  
  .r <- wrap(b2)
  return(.r)
}



# map processing across all options
processAllBio <- function(scenerio,boundingBox){
  # need to match each scenerio with the four time frames
  scenerios <- rep(scenerio, 4)
  years <- c("2021-2040","2041-2060","2061-2080","2081-2100")
  # call the processfuture function on the two lists
  l2 <- purrr::map2(.x = scenerios, .y = years, .f = processFutureBio, boundingBox = boundingBox)
  return(l2) #convert from list of rasts to single rast
}


# bind and gather to points 
bindRasts <- function(rasters, locs){
  if(length(rasters) == 1){
    r1 <- terra::rast(rasters)
    return(wrap(r1))
  }else{
    r2a <- terra::rast(rasters[[1]])
    r2b <- terra::rast(rasters[[2]])
    r2c <- terra::rast(rasters[[3]])
    r2d <- terra::rast(rasters[[4]])
    r2 <- c(r2a,r2b,r2c,r2d) 
    return(wrap(r2))
  }
}


bindAll <-function(rast1, rast2, rast3, rast4, rast5, locs){
  # extract values and reduce to single dataframe
  r1 <- c(rast(rast1),rast(rast2),rast(rast3),rast(rast4),rast(rast5))
  # extract and tidy
  vals <-  terra::extract(x = r1, y = vect(locs))%>%
    tidyr::gather(key = categories ,value = value, -c(ID))%>%
    tidyr::separate(col = categories, into = c("variable", "emission", "year"), sep = "_")%>%
    dplyr::mutate(variable = case_when(
      ###
      # temp : 5,6,7,8,9
      # prec : 13,14,16,17,18,19 
      ### 
      variable == "bioc5" ~ "bioc_5",
      variable == "bioc6" ~ "bioc_6",
      variable == "bioc8" ~ "bioc_8",
      variable == "bioc9" ~ "bioc_9",
      variable == "bioc10" ~ "bioc_10",
      variable == "bioc11" ~ "bioc_11",
      variable == "bioc13" ~ "bioc_13",
      variable == "bioc14" ~ "bioc_14",
      variable == "bioc15" ~ "bioc_15",
      variable == "bioc16" ~ "bioc_16",
      variable == "bioc17" ~ "bioc_17",
      variable == "bioc18" ~ "bioc_18",
      variable == "bioc19" ~ "bioc_19",
      TRUE ~ variable
    ))
  return(vals)
}
