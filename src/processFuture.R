compileFuture <- function(paths, time, emission){
  
 rasters <- rast(paths)%>%
   terra::app(mean)
   
}





processFuture <- function(path, overwrite){
  files <- list.files(path, pattern = ".tif", full.names = TRUE, recursive = TRUE)
  
  groups <- c("prec", "tmax", "tmin")
  time <- c("2021-2040","2041-2060","2061-2080","2081-2100")
  emission <- c("ssp126", "ssp245","ssp370","ssp585")
  
  for(i in groups){
    f1 <- files[grepl(x = files, pattern = i)]
    for(j in time){
      f2 <- f1[grepl(x = f1, pattern = j )]
      for(k in emission){
        f3 <- f2[grepl(x = f2, pattern = k)]
        fName <- paste0(i,"_",j,"_",k)
        fileName <- paste0("analysisData/future/averaged/",fName,".tif")
        
        if(!file.exists(fileName) | isTRUE(overwrite)){
          r1 <- terra::rast(f3)%>%
            terra::app(mean)
          names(r1) <- fName
          writeRaster(x = r1, filename = fileName, overwrite=TRUE) 
        }
      }
    }
  }
}