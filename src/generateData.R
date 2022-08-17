

generateData <- function(path1,path2,spatialData){
  r1 <- rast(c(
    list.files(path = path1 ,pattern = ".tif",full.names = TRUE),
    list.files(path = path2, pattern = ".tif", full.names = TRUE))
  )
  sp2 <- terra::extract(x = r1, y = spatialData)%>% 
    tidyr::gather(key = categories ,value = value, -c(ID))%>%
    tidyr::separate(col = categories, into = c("variable", "year","emission"), sep = "_")
  
  return(sp2)
}