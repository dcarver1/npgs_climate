

processCP <- function(year, scenerio, overwrite ){
  name <- paste0(scenerio,"_",year)
  f1 <- paste0("analysisData/climate models/2.5/averaged/Tmax_",name,".tif")
  f2 <- paste0("analysisData/climate models/2.5/averaged/Tmin_",name,".tif")
  f3 <- paste0("analysisData/climate models/2.5/averaged/Prec_",name,".tif")
  
  
  if(!FALSE %in% c(isFALSE(overwrite),!FALSE %in% file.exists(f1,f2,f3))){
    # return a raster stack 
    return(rast(c(f1,f2,f3)))
  }else{
  #normalize function for celcuios values 
  divide10 <- function(i){i/10}
  
  files <- list.files("analysisData/climate models/2.5", pattern = paste0(scenerio, "_", year) ,
                      recursive = TRUE, full.names = TRUE)
  
  #tmax: C 
  tmax <- files[grepl(x = files, pattern = "tmax")]%>%
    rast()%>%
    terra::app(mean)
  names(tmax) <- paste0("tmax_",name)
  
  terra::writeRaster(tmax,filename = f1, overwrite = TRUE)
  
  #tmin 
  tmin <- files[grepl(x = files, pattern = "tmin")]%>%
    rast()%>%
    terra::app(mean)
  names(tmin) <- paste0("tmin_",name)
  
  terra::writeRaster(tmin,filename = f2, overwrite = TRUE)
  
  #prec 
  prec <- files[grepl(x = files, pattern = "prec")]%>%
    rast()%>%
    terra::app(mean)
  names(prec) <- paste0("prec_",name)
  
  terra::writeRaster(prec,filename = f3, overwrite = TRUE)

  return(rast(c(f1,f2,f3)))
  }
}
