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


# UI ----------------------------------------------------------------------
ui <- navbarPage(
    theme = bs_theme(version = 5, bootswatch = "litera"),
    ## Application title -------------------------------------------------------
    "Visualization of Future Climate Data",
    ## Charts ------------------------------------------------------------------
    tabPanel(title = "Data Visualization", 
      graph_UI("graphs", sites = sites)
      ),
    
    ## Location Map ------------------------------------------------------------
    tabPanel(title = "NPGS Site Location Map"
           ,mapUI("map")),
    
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
    ## call graph elements -----------------------------------------------------
    callModule(graph_server, id = "graphs" , reactive(df))

    ## render map  -------------------------------------------------------------
    callModule(mapServer,"map", df)
}

# Run the application 
shinyApp(ui = ui, server = server)
