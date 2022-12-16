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
library(lubridate)

### 


lapply(X = list.files(path = "functions", full.names = TRUE, recursive = TRUE),
       source)# site locations 
# setwd("/media/dune/T7/usda/cropScience/npgs_climate/npgsClimate/")
### Temp; testing local at to front of file paths 
### npgsClimate/

# Process input datasets --------------------------------------------------
allSites <- generateSites()
df <- processData(allSites)
sites <- sort(unique(df$`NPGS site`))
sitesInsitu <- sites[sites %in% c("Red Run Bog","Cranberry Glades 1","Cranberry Glades 5","Upper Island Lake"
                                  ,"South Prairie","Little Crater Meadow")]
sitesNPGS <-  sites[!sites %in% sitesInsitu]

df2 <- read.csv("compiledSiteData_monthly.csv")
### testing sites for plot features  
testingSite <- df %>%
  dplyr::filter(ID == 3 & variable == "bioc_9" )

# UI ----------------------------------------------------------------------
ui <- navbarPage(
  theme = bs_theme(version = 5, bootswatch = "flatly",
                     primary = "#005895",
                   secondary = "#006a52",
                   success = "#AAB3AA",
                   base_font = font_google("Roboto"),
                   heading_font = font_google("Roboto"),
                   )%>%
    bslib::bs_add_rules(sass::sass_file("www/style.scss")),
    ## Application title -------------------------------------------------------
    "NPGS Climate Futures Application",
    ## Charts ------------------------------------------------------------------
    tabPanel(title = "Data Visualization", 
             introStatement(),
        graph_UI("graphs",sitesNPGS = sitesNPGS,sitesInsitu =sitesInsitu)
      ),
    
    ## Location Map ------------------------------------------------------------
    tabPanel(title = "NPGS Location Map",
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
    callModule(graph_server, id = "graphs" , data = reactive(df), dataM = reactive(df2))
    ## render map  -------------------------------------------------------------
    callModule(mapServer,"map", df)
}

# Run the application 
  shinyApp(ui = ui, server = server)

