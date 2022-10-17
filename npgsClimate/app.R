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


# Define UI for application that draws a histogram
#fluidPage
ui <- navbarPage(
    theme = bs_theme(version = 5, bootswatch = "litera"),
    # Application title -------------------------------------------------------
    "Visualization of Future Climate Data",
    # Charts ------------------------------------------------------------------
    # Sidebar with a slider input for number of bins 
    tabPanel(title = "Data Visualization", 
             sidebarLayout(
               sidebarPanel(
                 ### this keeps the side bar panel in place but only works on large screens 
                 # style = "position: fixed; overflow: visible;",
                 h4("Select you location of interest from the drop down."),
                 selectInput("variable", "Location:", sites ),
                 h4("Select boxes to toggle features on the plots."),
                 ### the plots require a historical reference data so I'm excluding the option to re
                 ### historical reference for the time being. 
                 # checkboxInput("historic", label = "1970-2000 measured average", value = TRUE),
                 checkboxInput("ssp126", label = "Sustainability(ssp126)", value = TRUE),
                 checkboxInput("ssp245", label = "Middle of the road(ssp245)", value = TRUE),
                 checkboxInput("ssp370", label = "Inequality(ssp370)", value = TRUE),
                 checkboxInput("ssp585", label = "Fossil-Fueled Development(ssp585)", value = TRUE),
                 "Read about Share Socialeconomic Pathways ", 
                 tags$a(href = "https://en.wikipedia.org/wiki/Shared_Socioeconomic_Pathways",
                        "here.", target = "_blank"),
                 br(),
                 "Read more about the bioclimatic indicators ", 
                 tags$a(href = "https://www.worldclim.org/data/bioclim.html",
                        "here.", target = "_blank"),
                 
               ),
               
               # Show a plot of the generated distribution
               mainPanel(
                 tabsetPanel(
                   tabPanel(title = "Temperature",
                            
                            h3("BIO5 = Max Temperature of Warmest Month"),
                            "Mean maximum temperature of the warmest month of the year (c)",
                            plotlyOutput("bio5"),
                            
                            h3("BIO10 = Mean Temperature of Warmest Quarter"),
                            "Mean of the three months that make up the warmest quarter of the year (c)",
                            plotlyOutput("bio10"),
                            h3("BIO11 = Mean Temperature of Coldest Quarter"),
                            "Mean of the three months that make up the coldest quarter of the year  (c)",
                            plotlyOutput("bio11"),
                   ),
                   tabPanel(title = "Precipitation",
                            h3("BIO18 = Precipitation of Warmest Quarter (mm)"),
                            "Total precipitation of the warmest quarter of the year ",
                            plotlyOutput("bio18"),
                            # 
                            h3("BIO19 = Precipitation of Coldest Quarter (mm)"),
                            "Precipitation of the coldest quarter of the year ",
                            plotlyOutput("bio19"),
                   )
                 ),
     
 
                 h3("tabular data for site"),
                 "This table contains all the date associated with the individual site. It can be sorted. ",
                 br(),
                 downloadButton(outputId = "downloadData",
                                label = "Download data for this location"),
                 br(),
                 br(),
                 DT::dataTableOutput("tableAll")),
             ),
            
    ),

# Location Map ------------------------------------------------------------
  tabPanel(title = "NPGS Site Location Map",
           mapUI("map")
  ),
    
# bioclimatic variables ---------------------------------------------------
    tabPanel(title = "Bioclimatic Indicators",
             bioText("bio")
             ),

# Climate Model Selection -------------------------------------------------
    tabPanel(title = "Climate Model Selection",
             h2("Climate models"),
             climText("clim")
             ),
# about -------------------------------------------------------------------
    tabPanel(title = "About",
             aboutText("about")
    ),
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # filter dataset based on user input 
    df2 <- reactive({
      df %>% 
        filter(NPGS_Site == input$variable)
    })
    
    output$tableAll <- renderDataTable({
      DT::datatable(df2() %>% select(-color))
    }) 
    # filter based on selection options  
    df2a <- reactive({
      vals <- c("Historic", "ssp126","ssp245","ssp370","ssp585")
      # if(input$historic == FALSE){
      #   vals <- vals[vals != "Historic"]
      # }
      if(input$ssp126 == FALSE){
        vals <- vals[vals != "ssp126"]
      }
      if(input$ssp245 == FALSE){
        vals <- vals[vals != "ssp245"]
      }
      if(input$ssp370 == FALSE){
        vals <- vals[vals != "ssp370"]
      }
      if(input$ssp585 == FALSE){
        vals <- vals[vals != "ssp585"]
      }
      vals
    })
    
    d2p <- reactive({
      df2() %>% 
      filter(emission %in% df2a())
    })
    
    # plot of bio5
    output$bio5 <- renderPlotly({
      bio5 <- d2p() %>%
        filter(variable == "bioc_5")
      plotChart_bio5(bio5)
    })
    # plot of bio10
    output$bio10 <- renderPlotly({
      bio10 <- d2p() %>%
        filter(variable == "bioc_10")
      plotChart_bio10(bio10)
    })
    # plot of bio11
    output$bio11 <- renderPlotly({
      bio11 <- d2p() %>%
        filter(variable == "bioc_11")
      plotChart_bio11(bio11)
    })
    # plot of bio15
    output$bio15 <- renderPlotly({
      bio15 <- d2p() %>%
        filter(variable == "bioc_15")
      plotChart_bio15(bio15)
    })
    # # plot of bio18
    output$bio18 <- renderPlotly({
      bio18 <- d2p() %>%
        filter(variable == "bioc_18")
      plotChart_bio18(bio18)
    })
    # plot of bio19
    output$bio19 <- renderPlotly({
      bio19 <- d2p() %>%
        filter(variable == "bioc_19")
      plotChart_bio19(bio19)
    })
    
    #download data
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(input$variable, "_data.csv", sep = "")
      },
      content = function(file) {
        write.csv(df2(), file, row.names = FALSE)    }
    )
# render map  -------------------------------------------------------------
    callModule(mapServer,"map", df)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
