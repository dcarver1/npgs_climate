
# ui ----------------------------------------------------------------------

graph_UI<-function(id, sitesNPGS, sitesInsitu){
  ns <- NS(id)

  tagList(
           sidebarLayout(
             sidebarPanel(
               ### this keeps the side bar panel in place but only works on large screens
               # style = "position: fixed; overflow: visible;",
               h4("Select location of interest from the drop down menu."),
               p(
                 "NPGS sites are locations where plant genetic resources are 
                 maintained or regenerated (see NPGS Site Location Map tab)",
                 "In situ sites are wild populations protected as genetic resource reserves."
               ),
               # selectInput(ns("variable"), "Location:", sites ),
               selectInput(
                 ns("variable"),
                 label = "Location:",
                  choices = list(
                 "NPGS Sites" = sitesNPGS,
                 "Insitu Sites" = sitesInsitu)),



               h4("Select boxes to toggle which future climate prediction 
                  shared socioeconomic pathway (SSP) will appear on the plots."),
               ### the plots require a historical reference data so I'm excluding the option to re
               ### historical reference for the time being.
               checkboxInput(ns("historic"), label = "1970-2000 measured average (historic)", value = TRUE),
               checkboxInput(ns("ssp126"), label = "Sustainability (SSP1-2.6)", value = TRUE),
               checkboxInput(ns("ssp245"), label = "Middle of the road (SSP2-4.5)", value = TRUE),
               checkboxInput(ns("ssp370"), label = "Inequality (SSP3-7.0)", value = TRUE),
               checkboxInput(ns("ssp585"), label = "Fossil-fueled development (SSP5-8.5)", value = TRUE),
               "Read about Shared Socioeconomic Pathways (",
               tags$a(href = "https://www.ipcc.ch/assessment-report/ar6/",
                      "source", target = "_blank"),
               "/",
               tags$a(href = "https://en.wikipedia.org/wiki/Shared_Socioeconomic_Pathways",
                      "summary", target = "_blank"),
               ")",
               br(),
               "Read more about the bioclimatic Indicators ",
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
                          h3("Average minimum and maximum temperature"),
                          plotlyOutput(ns("tempMonth")),
                          #figure caption 
                          p(
                            "The figure above illustrates the minimum and maximum temperature for each month averaged over a 30 year period (1970-2000).
                            This figure can be used as a quick reference for evaluating the specific monthly and quarterly ranges reference 
                            by the bioclimatic indicators."
                          ),
                          
                          h3("BIO5 = Maximum Temperature of Warmest Month"),
                          "Mean maximum temperature of the warmest month of the year (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio5")),

                          h3("BIO6 = Minimum Temperature of Coldest Month"),
                          "Minimum Temperature of Coldest Month (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio6")),

                          h3("BIO8 = Mean Temperature of Wettest Quarter"),
                          "Mean Temperature of Wettest Quarter (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio8")),

                          h3("BIO9 = Mean Temperature of Driest Quarter"),
                          "Mean Temperature of Driest Quarter (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio9")),

                          h3("BIO10 = Mean Temperature of Warmest Quarter"),
                          "Mean Temperature of Warmest Quarter (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio10")),

                          h3("BIO11 = Mean Temperature of Coldest Quarter"),
                          "Mean Temperature of Coldest Quarter (",intToUtf8(176),"C)",
                          plotlyOutput(ns("bio11")),


                 ),
                 tabPanel(title = "Precipitation",
                          precText(),
                          h3("Total Monthly Precipitation"),
                          plotlyOutput(ns("precMonth")),
                          p(
                            "The figure above illustrates the total precipitation for each month averaged over a 30 year period (1970-2000).
                            This figure can be used as a quick reference for evaluating the specific monthly and quaterly ranges reference 
                            by the bioclimatic indicators."
                          ),
                          
      
                          h3("BIO13 = Precipitation of Wettest Month (mm)"),
                          "Total precipitation of wettest month ",
                          plotlyOutput(ns("bio13")),

                          h3("BIO14 = Precipitation of Driest Month (mm)"),
                          "Total precipitation of driest month ",
                          plotlyOutput(ns("bio14")),

                          h3("BIO16 = Precipitation of Wettest Quarter (mm)"),
                          "Total precipitation of wettest quarter of the year",
                          plotlyOutput(ns("bio16")),

                          h3("BIO17 = Precipitation of Driest Quarter (mm)"),
                          "Total precipitation of driest quarter of the year ",
                          plotlyOutput(ns("bio17")),

                          h3("BIO18 = Precipitation of Warmest Quarter (mm)"),
                          "Total precipitation of the warmest quarter of the year ",
                          plotlyOutput(ns("bio18")),
                          #
                          h3("BIO19 = Precipitation of Coldest Quarter (mm)"),
                          "Total precipitation of the coldest quarter of the year",
                          plotlyOutput(ns("bio19")),
                 )
               ),

               ### table data
               h3("Tabular data for site"),
               "This table contains all the data associated with the individual site. It can be sorted.",
               br(),
               downloadButton(outputId = ns("downloadData"),
                              label = "Download bioclimatic indicator data for this location"),
               br(),
               br(),
               downloadButton(outputId = ns("downloadDataM"),
                              label = "Download monthly precipitation and minimum/maximum temperature data for this location"),
               br(),
               br(),
               DT::dataTableOutput(ns("tableAll"))),
      ),
    )
}


# server ------------------------------------------------------------
graph_server <- function(input,output,session,data, dataM){
  # bioclim data used within the charts and download 
  df2 <-reactive({
    data() %>%
    filter(`NPGS site` == input$variable)
  })
  # monthly tmax, tmin, prec available for download only 
  df2m <- reactive({
    dataM() %>%
      filter(`NPGS.site` == input$variable)
  })
  
  output$tableAll <- renderDataTable({
    DT::datatable(df2() %>% select(-color))
  })
  # filter based on selection options
  df2a <- reactive({
    vals <- c("historic", "SSP126","SSP245","SSP370","SSP585")
    if(input$historic == FALSE){
      vals <- vals[vals != "historic"]
    }
    if(input$ssp126 == FALSE){
      vals <- vals[vals != "SSP126"]
    }
    if(input$ssp245 == FALSE){
      vals <- vals[vals != "SSP245"]
    }
    if(input$ssp370 == FALSE){
      vals <- vals[vals != "SSP370"]
    }
    if(input$ssp585 == FALSE){
      vals <- vals[vals != "SSP585"]
    }
    vals
  })
  
  d2p <- reactive({
    df2() %>%
      filter(emission %in% df2a())
  })
  
  # plot of monthly values 
  output$tempMonth <- renderPlotly({
    temp1 <- df2m()%>%
      filter(variable != "prec")
    plotMonthlyTemp(temp1)
  })
  
  output$precMonth <- renderPlotly({
    prec1 <- df2m()%>%
      filter(variable == "prec")
    plotMonthlyPrec(prec1)
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
  # #download data - bioclim 
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$variable, "_bioclimatic_data.csv", sep = "")
    },
    content = function(file) {
      write.csv(df2() %>% select(-"color"), file, row.names = FALSE)    }
  )
  output$downloadDataM <- downloadHandler(
    filename = function() {
      paste(input$variable, "_monthy_data.csv", sep = "")
    },
    content = function(file) {
      write.csv(df2m() %>% select(-X), file, row.names = FALSE)    }
  )
  
}
