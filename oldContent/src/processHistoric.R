
processHistoric <- function(path, overwrite){
    files <- list.files(path, pattern = ".tif", full.names = TRUE)
  
    groups <- c("prec", "tmax", "tmin")
    
    for(i in groups){
      file <- paste0(path,"/averaged/",i,"_historic_1970-2000.tif")
      if(!file.exists(file) | isTRUE(overwrite)){
      f1 <- files[grepl(pattern = i, x = files)]
      raster <- terra::rast(f1)%>%
        terra::app(mean)
      names(raster) <- paste0(i,"_1970-2000_historic")
      terra::writeRaster(raster, filename = file,overwrite=TRUE)
      }
    }
}