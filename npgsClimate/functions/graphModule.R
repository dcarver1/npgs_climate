
# ui ----------------------------------------------------------------------

graph_UI<-function(id, sites){
  ns <- NS(id)
  
  tagList(
           sidebarLayout(
             sidebarPanel(
               ### this keeps the side bar panel in place but only works on large screens 
               # style = "position: fixed; overflow: visible;",
               h4("Select you location of interest from the drop down."),
               selectInput(ns("variable"), "Location:", sites ),
               h4("Select boxes to toggle features on the plots."),
               ### the plots require a historical reference data so I'm excluding the option to re
               ### historical reference for the time being. 
               # checkboxInput("historic", label = "1970-2000 measured average", value = TRUE),
               checkboxInput(ns("ssp126"), label = "Sustainability(ssp126)", value = TRUE),
               checkboxInput(ns("ssp245"), label = "Middle of the road(ssp245)", value = TRUE),
               checkboxInput(ns("ssp370"), label = "Inequality(ssp370)", value = TRUE),
               checkboxInput(ns("ssp585"), label = "Fossil-Fueled Development(ssp585)", value = TRUE),
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
                          plotlyOutput(ns("bio5")),
                          
                          h3("BIO10 = Mean Temperature of Warmest Quarter"),
                          "Mean of the three months that make up the warmest quarter of the year (c)",
                          plotlyOutput(ns("bio10")),
                          
                          h3("BIO11 = Mean Temperature of Coldest Quarter"),
                          "Mean of the three months that make up the coldest quarter of the year  (c)",
                          plotlyOutput(ns("bio11")),
                 ),
                 tabPanel(title = "Precipitation",
                          h3("BIO18 = Precipitation of Warmest Quarter (mm)"),
                          "Total precipitation of the warmest quarter of the year ",
                          plotlyOutput(ns("bio18")),
                          # 
                          h3("BIO19 = Precipitation of Coldest Quarter (mm)"),
                          "Precipitation of the coldest quarter of the year ",
                          plotlyOutput(ns("bio19")),
                 )
               ),
               
               ### table data 
               h3("tabular data for site"),
               "This table contains all the date associated with the individual site. It can be sorted. ",
               br(),
               downloadButton(outputId = ns("downloadData"),
                              label = "Download data for this location"),
               br(),
               br(),
               DT::dataTableOutput(ns("tableAll"))),
      ),
    )
}


# server ------------------------------------------------------------
# graph_server <- function(id, data){
#   shiny::moduleServer(
#     id, 
#     function(input, output, session){
#       df2 <-data() %>%
#           filter(NPGS_Site == input$variable)
#     }
#   )
# }

graph_server <- function(input,output,session,data){
  df2 <-reactive({ 
    data() %>%
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
  # #download data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$variable, "_data.csv", sep = "")
    },
    content = function(file) {
      write.csv(df2(), file, row.names = FALSE)    }
  )
  
}




