#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(readr)
library(plotly)
library(DT)
sites <- read_csv("npgsSiteData.csv")%>%
  dplyr::select("NPGS site","Address","Type of site","Latitude","Longitude","Include in Crop Science Report (TRUE/FALSE)")%>%
  dplyr::filter(`Include in Crop Science Report (TRUE/FALSE)` == TRUE)%>%
  dplyr::mutate(ID = seq(1,24,1))
df <- read_csv("tidyClimateValues.csv") %>%
  dplyr::left_join(sites, by = "ID" )%>%
  dplyr::select(
    "ID",
    "NPGS_Site" = "NPGS site",
    "Site_Category" = "Type of site",
    "variable",
    "emission",
    "year",
    "value" 
  )%>%
  dplyr::mutate(aveYear = case_when(
    year == "2021-2040" ~ 2030,
    year == "2041-2060" ~ 2050,
    year == "2061-2080" ~ 2070,
    year == "2081-2100" ~ 2090,
    TRUE ~ 2000
  )) %>%
  dplyr::mutate(emission = case_when(
    emission == "1970" ~ "Historic",
    TRUE ~ emission
  ))

d2 <- df%>% filter(ID == 1) %>% filter(variable == "tmax")
plotChart_prec <- function(data){
  p1 <- plot_ly(data = data,  x = ~aveYear, y = ~value, type = 'scatter', mode = 'lines+markers', split = ~emission)%>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Monthly Precipitation(mm)'))
  return(p1)
}
plotChart_tmax <-function(data){
  p1 <- plot_ly(data = data,  x = ~aveYear, y = ~value, type = 'scatter', mode = 'lines+markers', split = ~emission)%>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Monthly Maximum Temperature (c)'),
           plot_bgcolor='#e5ecf6')
  return(p1)
}
plotChart_tmin <-function(data){
  p1 <- plot_ly(data = data,  x = ~aveYear, y = ~value, type = 'scatter', mode = 'lines+markers', split = ~emission)%>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Monthly Minimum Temperature (c)'))
  return(p1)
}




# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Visualization of Future Climate Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          h4("Select you location of interest from the drop down."),
          selectInput("variable", "Location:",
                      # list of npgs sites 
                      c("Corvallis, Oregon","Pullman, Washington","Aberdeen, Idaho","Davis, California",       
                         "Parlier, California","Riverside, California","Hilo, Hawaii","Ft Collins, Colorado",    
                         "College Station, Texas","Ames, Iowa","Urbana, Illinois","Stuttgart, Arkansas",     
                         "Columbus","Sturgeon Bay","Griffin","Geneva",
                         "Beltsville","Washington, D.C.","Central Ferry, WA","Prosser, WA",             
                         "Isabela, Puerto Rico","St Croix, Virgin Islands","Thermal, CA","Irvine, CA")
        ),
        h4("Select boxes to toggle features on the plots."),
        checkboxInput("ssp126", label = "Sustainability(ssp126)", value = TRUE),
        checkboxInput("ssp245", label = "Middle of the road(ssp245)", value = TRUE),
        checkboxInput("ssp370", label = "Inequality(ssp370)", value = TRUE),
        checkboxInput("ssp585", label = "Fossil-Fueled Development(ssp585)", value = TRUE),
        "Read about Share Socialeconomic Pathways ", 
        tags$a(href = "https://en.wikipedia.org/wiki/Shared_Socioeconomic_Pathways",
               "here.", target = "_blank")

      ),

        # Show a plot of the generated distribution
        mainPanel(
          h2("Considerations"),
          "All data presented below is a mean of all 12 months of the year. This tends to generalize trends in the precipitation data due to the seasonality of precipitation. Temperature data includes months that are not relevant to perennial crops.",
          "We can filter what months are used in these evaluations.",
          br(),
          "This website contains a series of visualization that allows you to evaluate current weather patterns. It can be a helpful reference in understanding the seasonality of temperature and precipitation at a given location.",
          tags$a(href = "https://weatherspark.com/y/400/Average-Weather-in-Corvallis-Oregon-United-States-Year-Round",
                 "weatherspark", target = "_blank"),
          br(),
          "All data are projections. There is, in general more confidence around modeled future temperature than precipitation values due to the numerous additional elements affecting precipitation potential.",
          br(),
          "The ",tags$em("Historic"), " observation on the chart is a measure of the observer temperature and precipitation measures during the 1970-2000 time period.",
          h3("Precipitation"),
          "Mean of all 12 monthly total precipitation (mm)",
          plotlyOutput("prec"),
          h3("Maximum Temperature"),
          "Mean of all 12 monthly average maximum temperature (°C)",
          plotlyOutput("tmax"),
          h3("Minimum Temperature"),
          "Mean of all 12 monthly average minimum temperature values",
          plotlyOutput("tmin"),
          h3("tabular data for site"),
          "This table contains all the date associated with the individual site. It can be sorted. ",
          DT::dataTableOutput("tableAll")),        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # filter dataset based on user input 
    df2 <- reactive({
      df %>% 
        filter(NPGS_Site == input$variable)
    })
    
    output$tableAll <- renderDataTable({
      DT::datatable(df2())
    }) 
    
    df2a <- reactive({
      vals <- c("Historic")
      if(input$ssp126 == TRUE){
        vals <- c(vals, "ssp126")
      }
      if(input$ssp245 == TRUE){
        vals <- c(vals, "ssp245")
      }
      if(input$ssp370 == TRUE){
        vals <- c(vals, "ssp370")
      }
      if(input$ssp585 == TRUE){
        vals <- c(vals, "ssp585")
      }
      vals
    })
    
    d2p <- reactive({
      df2() %>% 
      filter(emission %in% df2a())
    })
      
    # plot of prec
    output$prec <- renderPlotly({
      # prec 
      prec1 <- d2p() %>% 
        filter(variable == "prec")
      plotChart_prec(prec1)
    })
    # plot of tmax
    output$tmax <- renderPlotly({
      # tmax
      d2max <- d2p() %>%
        filter(variable == "tmax")
      plotChart_tmax(d2max)
    })
    # plot of tmin
    output$tmin <- renderPlotly({
      # tmax 
      d2min <- d2p() %>% filter(variable == "tmin")
      plotChart_tmin(d2min)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
