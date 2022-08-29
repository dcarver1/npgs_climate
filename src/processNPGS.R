
processNPGS <- function(path){
  d1 <- read_csv(path)%>%
    dplyr::select("NPGS site","Address","Type of site","Latitude","Longitude","Include in Crop Science Report (TRUE/FALSE)")%>%
    dplyr::filter(`Include in Crop Science Report (TRUE/FALSE)` == TRUE)%>% 
    st_as_sf(coords = c("Longitude","Latitude"))%>%
    st_set_crs(value = 4326)
  return(d1)
}