###
# shiny application for NPGS climate futures 
# carverd@colostate.edu
# 20221102 
###

library(shiny)
library(dplyr)
library(readr)
library(plotly)
library(DT)
library(bslib)
library(sf)
library(leaflet)

lapply(X = list.files(path = "functions", full.names = TRUE, recursive = TRUE),
       source)# site locations 

### Temp; testing local at to front of file paths 
### npgsClimate/

# Process input datasets --------------------------------------------------
allSites <- generateSites()
df <- processData(allSites)
sites <- sort(unique(allSites$`NPGS site`))
sitesInsitu <- sites[sites %in% c("Red Run Bog","Cranberry Glades 1","Cranberry Glades 5","Upper Island Lake"
                                  ,"South Prairie","Little Crater Meadow")]
sitesNPGS <-  sites[!sites %in% sitesInsitu]
  
### testing sites for plot features  
testingSite <- df %>%
  dplyr::filter(ID == 3 & variable == "bioc_9" )
# current content is ok but the problem is that plotly treats zero as the end points 
# of the plot. It need to be the minimum value and move up from that point not relative to zero
  

# UI ----------------------------------------------------------------------
ui <- navbarPage(
    theme = bs_theme(version = 5, bootswatch = "litera"),
    ## Application title -------------------------------------------------------
    "NPGS Climate Futures",
    ## Charts ------------------------------------------------------------------
    tabPanel(title = "Data Visualization", 
             introStatement(),
        graph_UI("graphs",sitesNPGS = sitesNPGS,sitesInsitu =sitesInsitu)
      ),
    
    ## Location Map ------------------------------------------------------------
    tabPanel(title = "NPGS Site Location Map",
             mapPage(),
           mapUI("map")),
    
    ## bioclimatic variables ---------------------------------------------------
    tabPanel(title = "Bioclimatic Indicators"
             ,bioText("bio")),

    ## Climate Model Selection -------------------------------------------------
    tabPanel(title = "Climate Model Selection"
             ,h2("Climate models")
             ,climText("clim")),

    ## about -------------------------------------------------------------------
    tabPanel(title = "About"
             ,aboutText("about"))
)


# SERVER ------------------------------------------------------------------
server <- function(input, output,session) {
    # ## call graph elements -----------------------------------------------------
    callModule(graph_server, id = "graphs" , reactive(df))

    ## render map  -------------------------------------------------------------
    callModule(mapServer,"map", df)
}

# Run the application 
shinyApp(ui = ui, server = server)
