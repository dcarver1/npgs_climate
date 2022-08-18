

processWC <- function(overwrite = FALSE){
  f1 <- "analysisData/climate models/2.5/worldClim1.4/averageTmax.tif"
  f2 <- "analysisData/climate models/2.5/worldClim1.4/averageTmin.tif"
  f3 <- "analysisData/climate models/2.5/worldClim1.4/averagePrec.tif"
  
  if(overwrite == FALSE){
    # return a raster stack 
    return(rast(c(f1,f2,f3)))
  }else{
    #normalize function for celcuios values 
    divide10 <- function(i){i/10}
    #tmin: C * 10 
    tmax <- list.files("analysisData/climate models/2.5/worldClim1.4/tmax_2-5m_bil", full.names = TRUE, pattern = ".bil")%>%
      rast()%>%
      terra::app(mean)%>%
      terra::app(divide10)
    names(tmax) <- "tmax_1960_1990"
    
    terra::writeRaster(tmax,filename = f1, overwrite = TRUE)
    
    #tmin 
    tmin <- list.files("analysisData/climate models/2.5/worldClim1.4/tmin_2-5m_bil", full.names = TRUE, pattern = ".bil")%>%
      rast()%>%
      terra::app(mean)%>%
      terra::app(divide10)
    names(tmin) <- "tmin_1960_1990"
    
    terra::writeRaster(tmin,filename = f2, overwrite = TRUE)
    
    #prec 
    prec <- list.files("analysisData/climate models/2.5/worldClim1.4/prec_2-5m_bil", full.names = TRUE, pattern = ".bil")%>%
      rast()%>%
      terra::app(mean)
    names(prec) <- "prec_1960_1990"
    
    terra::writeRaster(prec,filename = f3, overwrite = TRUE)
    
    return(rast(c(f1,f2,f3)))
  }
}