

# ui ----------------------------------------------------------------------
mapUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    
    fluidRow(tags$style(type = "#mymap {height: calc(100vh - 250px) !important;}"),
             column(1),
             column(10, leafletOutput(ns("mymap"))),
             column(1)
    )
  )
}


# server ------------------------------------------------------------------
mapServer <- function(input, output, session, data) {
  # create spatial data object
  sp1 <- data %>% 
    st_as_sf(coords = c("Longitude","Latitude"), crs = 4326)
  
  map <- leaflet(options = leafletOptions(minZoom = 1)) %>%
    setView( lng = -105.76356278240084
             , lat = 39.13085942963124
             , zoom = 3 )%>%
    addProviderTiles("OpenStreetMap", group = "OpenStreetMap")%>%
    addCircleMarkers(
      data = sp1,
      label = ~NPGS_Site,
      fillColor = "goldenrod",
      fillOpacity = 1,
      stroke = F)
  output$mymap <- renderLeaflet({map})
}
