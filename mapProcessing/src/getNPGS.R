

getNPGS <- function(){
  d1 <- read_csv("analysisData/NPGS sites latitudes and longitudes for mapping.csv")%>%
    sf::st_as_sf(coords = c("Longitude", "Latitude"), remove = FALSE)%>%
    sf::st_set_crs(4326)
  return(d1) 
}