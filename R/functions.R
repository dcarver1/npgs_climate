

# read in csv and convert to sf object 
processNPGS <- function(file){
  d1 <- read_csv(file)%>%
    dplyr::select("NPGS site","Address","Type of site","Latitude","Longitude","Include in Crop Science Report (TRUE/FALSE)")%>%
    dplyr::filter(`Include in Crop Science Report (TRUE/FALSE)` == TRUE)%>% 
    st_as_sf(coords = c("Longitude","Latitude"))%>%
    st_set_crs(value = 4326)
  return(d1)
}

# process historic data 
processWC <- function(){
  #normalize function for celcuios values 
  # divide10 <- function(i){i/10}
  #tmin: C * 10 
  tmax <- list.files("climateData/historic", full.names = TRUE, pattern = "_tmax_")%>%
    rast()%>%
    terra::app(mean)
  names(tmax) <- "tmax_1970_2000"
  
  #tmin 
  tmin <- list.files("climateData/historic", full.names = TRUE, pattern = "_tmin_")%>%
    rast()%>%
    terra::app(mean)
  names(tmin) <- "tmin_1970_2000"
  

  #prec 
  prec <- list.files("climateData/historic", full.names = TRUE, pattern = "_prec_")%>%
    rast()%>%
    terra::app(mean)
  names(prec) <- "prec_1970_2000"

  rasts <- c(tmax,tmin,prec)
  .r <- wrap(rasts)
  return(.r) 
}

# process future data  
processFuture <- function(scenerio,year){
  path <- "climateData/future"
  name <- paste0(scenerio,"_",year)
  
  # grab all tmax files
  files <- list.files(path = path, pattern = name,
                      full.names = TRUE, recursive = TRUE )
  
  #normalize function for celcuios values
  divide10 <- function(i){i/10}
  
  #tmax: C
  tmax <- files[grepl(x = files, pattern = "tmax")]%>%
    rast()%>%
    terra::app(mean)
  
  names(tmax) <- paste0("tmax_",name)
  
  #tmin
  tmin <- files[grepl(x = files, pattern = "tmin")]%>%
    rast()%>%
    terra::app(mean)
  
  names(tmin) <- paste0("tmin_",name)
  
  #prec
  prec <- files[grepl(x = files, pattern = "prec")]%>%
    rast()%>%
    terra::app(mean)
  
  names(prec) <- paste0("prec_",name)
  
  rasts <- c(tmax,tmin,prec)
  .r <- wrap(rasts)
  return(.r)
}




# extract values to points
extractVals <- function(rasters, locs){
  # extract values and reduce to single dataframe
  r1 <- rast(rasters)
  # extract and tidy
  vals <-  terra::extract(x = r1, y = vect(locs))%>%
    tidyr::gather(key = categories ,value = value, -c(ID))%>%
    tidyr::separate(col = categories, into = c("variable", "emission", "year"), sep = "_")
  return(vals)
}

#bind dataframes 
bindData <- function(datasets){
  df <- dplyr::bind_rows(datasets)
  return(df)
}
  


# map processing across all options
processAll <- function(scenerio){
  # need to match each scenerio with the four time frames
  scenerios <- rep(scenerio, 4)
  years <- c("2021-2040","2041-2060","2061-2080","2081-2100")
  # call the processfuture function on the two lists
  l2 <- purrr::map2(.x = scenerios, .y = years, .f = processFuture)
  return(l2) #convert from list of rasts to single rast
}
# 
# #bind rasters 
bindrasters <- function(rast1, rast2, rast3, rast4, rast5, locs){
  # all terra rast objects are store as wrapped features due to the future package
  # convert then to a list a rasters then reduce the list to single raster
  
  r1 <- terra::rast(rast1)%>%
    crop(locs)
  
  r2a <- terra::rast(rast2[[1]])
  r2b <- terra::rast(rast2[[2]])
  r2c <- terra::rast(rast2[[3]])
  r2d <- terra::rast(rast2[[4]])
  r2 <- c(r2a,r2b,r2c,r2d) %>%
    crop(locs)
  r2<- c(r1,r2)
  rm(r1,r2a,r2b,r2c,r2d)
  gc()
  
  r3a <- terra::rast(rast3[[1]])
  r3b <- terra::rast(rast3[[2]])
  r3c <- terra::rast(rast3[[3]])
  r3d <- terra::rast(rast3[[4]])
  r3 <- c(r3a,r3b,r3c,r3d)%>%
    crop(locs)
  r3 <- c(r2, r3)
  rm(r2,r3a,r3b,r3c,r3d)
  gc()
  
  r4a <- terra::rast(rast4[[1]])
  r4b <- terra::rast(rast4[[2]])
  r4c <- terra::rast(rast4[[3]])
  r4d <- terra::rast(rast4[[4]])
  r4 <- c(r4a,r4b,r4c,r4d)%>%
    crop(locs)
  r4 <- c(r3, r4)
  rm(r3,r4a,r4b,r4c,r4d)
  gc()
  
  r5a <- terra::rast(rast5[[1]])
  r5b <- terra::rast(rast5[[2]])
  r5c <- terra::rast(rast5[[3]])
  r5d <- terra::rast(rast5[[4]])
  r5 <- c(r5a,r5b,r5c,r5d)%>%
    crop(locs)
  r5 <- c(r4, r5)
  rm(r4,r5a,r5b,r5c,r5d)
  gc()  
  .r5 <- wrap(r5)
  return(.r5)
}

