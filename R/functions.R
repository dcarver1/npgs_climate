
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
  temp <- 2
  
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
processHistWc <- function(boundingBox){
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
  names(bio5) <- "bioc5_historic_1970-2000"
  # "bioc_6"
  bio6 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_6.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio6) <- "bioc6_historic_1970-2000"
  # "bioc_8"
  bio8 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_8.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio8) <- "bioc8_historic_1970-2000"
  # "bioc_9"
  bio9 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_9.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio9) <- "bioc9_historic_1970-2000"
  # "bioc_10"
  bio10 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_10.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio10) <- "bioc10_historic_1970-2000"
  # "bioc_11"
  bio11 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_11.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio11) <- "bioc11_historic_1970-2000"

  # precipitation bioclim ---------------------------------------------------
  # "bioc_13"
  bio13 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_13.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio13) <- "bioc13_historic_1970-2000"
  # "bioc_14"
  bio14 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_14.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio14) <- "bioc14_historic_1970-2000"
  # "bioc_16"
  bio16 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_16.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio16) <- "bioc16_historic_1970-2000"
  # "bioc_17"
  bio17 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_17.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio17) <- "bioc17_historic_1970-2000"
  # "bioc_18"
  bio18 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_18.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio18) <- "bioc18_historic_1970-2000"
  # "bioc_19"
  bio19 <- list.files("climateData/historic", full.names = TRUE, pattern = "bio_19.tif")%>%
    rast()%>%
    terra::crop(bb2)
  names(bio19) <- "bioc19_historic_1970-2000"
  
  
  # Combine the data sets 
  rasts <- c(bio5,bio6, bio8, bio9,bio10,bio11, bio13,bio14,bio16,bio17,bio18, bio19)
  .r <- wrap(rasts)
  return(.r) 
}

processHistMonthly <- function(boundingBox){
  # new content
  path <- "climateData/historic"
  
  # need to add a the terra ext object 
  bb2 <- terra::ext(boundingBox[1],boundingBox[3],boundingBox[2],boundingBox[4])
  
  # grab all tmax files
  files <- list.files(path = path, pattern = ".tif",
                      full.names = TRUE, recursive = TRUE )
  
  # tmax 
  tmax <- files[grepl(pattern = "tmax", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  names(tmax) <- paste0("tmax_",1:12,"_historic_1970-2000")
  
  # test extract 
  # df <- terra::extract(x = tmax, y = locs)
  # write.csv(df, "troubleshootingTests/histtmax.csv")
  
  # tmin 
  tmin <- files[grepl(pattern = "tmin", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  names(tmin) <- paste0("tmin_",1:12,"_historic_1970-2000")
  
  # test extract 
  # df <- terra::extract(x = tmin, y = locs)
  # write.csv(df, "troubleshootingTests/histtmin.csv")
  
  # prec
  prec <- files[grepl(pattern = "prec", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  names(prec) <- paste0("prec_",1:12,"_historic_1970-2000")
  
  # test extract 
  # df <- terra::extract(x = prec, y = locs)
  # write.csv(df, "troubleshootingTests/histprec.csv")
  
  # bind features 
  r1 <- c(tmax, tmin, prec)
  # wrap for export 
  .r <- wrap(r1)
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
    rast() %>% # lyrs = bioIndicators this reduce to single raster but I'm not sure what is happening exactly 
    crop(bb2)
  
  ## test extract 
  # df <- terra::extract(x = bioc, y = locs)
  # write.csv(df, "troubleshootingTests/futurebio.csv")
  
  j <- 1
  for(i in indexs){
    print(j)
    b1 <- bioc[[names(bioc) == i]]
    b1m <- app(b1, mean)
    names(b1m) <- i 
    if(j == 1){
      b2<-b1m
    }else{
      b2 <- c(b2, b1m)
    }
    j <- 2
  }
  
  # b2 <- tapp(bioc, index=bioIndicators, fun=mean)
  # rm(bioc)
  # gc()
  # 
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

# process monthly data ----------------------------------------------------
processFutureMonthly <- function(scenerio,year,boundingBox){
  # new content
  val <- 1 
  path <- "climateData/future"
  name <- paste0(scenerio,"_",year) 
  
  # need to add a the terra ext object 
  bb2 <- terra::ext(boundingBox[1],boundingBox[3],boundingBox[2],boundingBox[4])
  
  # grab all tmax files
  files <- list.files(path = path, pattern = name,
                      full.names = TRUE, recursive = TRUE )

  # tmax 
  tmax <- files[grepl(pattern = "tmax", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  
  # test extract 
  # df <- terra::extract(x = tmax, y = locs)
  # write.csv(df, "troubleshootingTests/futuretmax.csv")
  
  j <- 1
  for(i in unique(names(tmax))){
    print(j)
    b1 <- tmax[[names(tmax) == i]]
    b1m <- app(b1, mean)
    names(b1m) <- i 
    if(j == 1){
      b2_tmax<-b1m
    }else{
      b2_tmax <- c(b2_tmax, b1m)
    }
    j <- 2
  }
  # 
  # %>%
  #   tapp(index=c(1:12),fun = mean)
  names(b2_tmax) <- paste0("tmax_",1:12,"_",scenerio,"_",year)
  
  # tmin 
  tmin <- files[grepl(pattern = "tmin", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  
  # test extract 
  # df <- terra::extract(x = tmin, y = locs)
  # write.csv(df, "troubleshootingTests/futuretmin.csv")
  
  j <- 1
  for(i in unique(names(tmin))){
    print(j)
    b1 <- tmin[[names(tmin) == i]]
    b1m <- app(b1, mean)
    names(b1m) <- i 
    if(j == 1){
      b2_tmin<-b1m
    }else{
      b2_tmin <- c(b2_tmin, b1m)
    }
    j <- 2
  }
  
  
  names(b2_tmin) <- paste0("tmin_",1:12,"_",scenerio,"_",year)
  
  # prec
  prec <- files[grepl(pattern = "prec", x = files)]%>%
    rast()%>% #lyrs = bioIndicators
    crop(bb2)
  
  # test extract 
  # df <- terra::extract(x = prec, y = locs)
  # write.csv(df, "troubleshootingTests/futureprec.csv")
  
  j <- 1
  for(i in unique(names(prec))){
    print(j)
    b1 <- prec[[names(prec) == i]]
    b1m <- app(b1, mean)
    names(b1m) <- i 
    if(j == 1){
      b2_prec<-b1m
    }else{
      b2_prec <- c(b2_prec, b1m)
    }
    j <- 2
  }
  
  
  names(b2_prec) <- paste0("prec_",1:12,"_",scenerio,"_",year)
  
  # bind features 
  r1 <- c(b2_tmax, b2_tmin, b2_prec)
  # wrap for export 
  .r <- wrap(r1)
  return(.r)
}

# map processing across all options
processAllMonthly <- function(scenerio,boundingBox){
  # need to match each scenerio with the four time frames
  scenerios <- rep(scenerio, 4)
  years <- c("2021-2040","2041-2060","2061-2080","2081-2100")
  # call the processfuture function on the two lists
  l2 <- purrr::map2(.x = scenerios, .y = years, .f = processFutureMonthly, boundingBox = boundingBox)
  return(l2) #convert from list of rasts to single rast
}

# bind and gather to points 
bindRasts <- function(rasters){
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

bindWC <-function(rast1, rast2, rast3, rast4, rast5,locs){
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

bindMonth <-function(rast1, rast2, rast3, rast4, rast5,locs){
  r1 <- c(rast(rast1),rast(rast2),rast(rast3),rast(rast4), rast(rast5))
  # extract and tidy
  vals <-  terra::extract(x = r1, y = vect(locs))%>%
    tidyr::gather(key = categories ,value = value, -c(ID))%>%
    tidyr::separate(col = categories, into = c("variable","month", "emission", "year"), sep = "_")%>%
    dplyr::mutate(month = case_when(
      month == "1" ~ "January",
      month == "2" ~ "February",
      month == "3" ~ "March",
      month == "4" ~ "April",
      month == "5" ~ "May",
      month == "6" ~ "June",
      month == "7" ~ "July",
      month == "8" ~ "August",
      month == "9" ~ "September",
      month == "10" ~ "October",
      month == "11" ~ "November",
      month == "12" ~ "December",
      TRUE ~ month
    ))
  return(vals)
}
