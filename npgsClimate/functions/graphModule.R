
# ui ----------------------------------------------------------------------

graph_UI<-function(id, sitesNPGS, sitesInsitu){
  ns <- NS(id)
  
  tagList(
           sidebarLayout(
             sidebarPanel(
               ### this keeps the side bar panel in place but only works on large screens 
               # style = "position: fixed; overflow: visible;",
               h4("Select your location of interest from the drop down."),
               p(
                 "NPGS sites are locations where germplasma is store or regenerated.",
                 "Insitu sites are wild populations protected as genetic resource reserves."
               ),
               # selectInput(ns("variable"), "Location:", sites ),
               selectInput(
                 ns("variable"),
                 label = "Location:",
                  choices = list(
                 "NPGS Sites" = sitesNPGS,
                 "Insitu Sites" = sitesInsitu)),
               
               
               
               h4("Select boxes to toggle which Climate Futures will appear on the plots."),
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
             # [1] "bioc_5"  "bioc_6"  "bioc_7"  "bioc_8"  "bioc_9"  "bioc_13" "bioc_14" "bioc_16" "bioc_17"
             # [10] "bioc_18" "bioc_19"
             mainPanel(
               tabsetPanel(
                 tabPanel(title = "Temperature",
                          tempText(),
                          h3("BIO5 = Max Temperature of Warmest Month"),
                          "Mean maximum temperature of the warmest month of the year (c)",
                          plotlyOutput(ns("bio5")),
                          
                          h3("BIO6 =  Min Temperature of Coldest Month"),
                          " Min Temperature of Coldest Month (c)",
                          plotlyOutput(ns("bio6")),
                          
                          h3("BIO8 =Mean Temperature of Wettest Quarter"),
                          "Mean Temperature of Wettest Quarter (c)",
                          plotlyOutput(ns("bio8")),
                          
                          h3("BIO9 = Mean Temperature of Driest Quarter"),
                          "Mean Temperature of Driest Quarter (c)",
                          plotlyOutput(ns("bio9")),
                          
                          h3("BIO10 = Mean Temperature of Warmest Quarter"),
                          "Mean Temperature of Warmest Quarter (c)",
                          plotlyOutput(ns("bio10")),
                          
                          h3("BIO11 = Mean Temperature of Coldest Quarter"),
                          "Mean Temperature of Coldest Quarter (c)",
                          plotlyOutput(ns("bio11")),
                          

                 ),
                 tabPanel(title = "Precipitation",
                          precText(),
                          h3("BIO13 = Precipitation of Wettest Month (mm)"),
                          "Precipitation of Wettest Month ",
                          plotlyOutput(ns("bio13")),
                          
                          h3("BIO14 = Precipitation of Driest Month (mm)"),
                          "Precipitation of Driest Month ",
                          plotlyOutput(ns("bio14")),
                          
                          h3("BIO16 = Precipitation of Wettest Quarter (mm)"),
                          "Precipitation of Wettest Quarter ",
                          plotlyOutput(ns("bio16")),
                          
                          h3("BIO17 = Precipitation of Driest Quarter  (mm)"),
                          "Precipitation of Driest Quarter  ",
                          plotlyOutput(ns("bio17")),
                          
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
    filter(`NPGS site` == input$variable)
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
  # plot of bio6
  output$bio6 <- renderPlotly({
    bio6 <- d2p() %>%
      filter(variable == "bioc_6")
    plotChart_bio6(bio6)
  })
  # plot of bio8
  output$bio8 <- renderPlotly({
    bio8 <- d2p() %>%
      filter(variable == "bioc_8")
    plotChart_bio8(bio8)
  })
  # plot of bio9
  output$bio9 <- renderPlotly({
    bio9 <- d2p() %>%
      filter(variable == "bioc_9")
    plotChart_bio9(bio9)
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
  
  
  # plot of bio13
  output$bio13 <- renderPlotly({
    bio13 <- d2p() %>%
      filter(variable == "bioc_13")
    plotChart_bio13(bio13)
  })
  # plot of bio14
  output$bio14 <- renderPlotly({
    bio14 <- d2p() %>%
      filter(variable == "bioc_14")
    plotChart_bio14(bio14)
  })
  # plot of bio16
  output$bio16 <- renderPlotly({
    bio16 <- d2p() %>%
      filter(variable == "bioc_16")
    plotChart_bio16(bio16)
  })

  # plot of bio17
  output$bio17 <- renderPlotly({
    bio17 <- d2p() %>%
      filter(variable == "bioc_17")
    plotChart_bio17(bio17)
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




