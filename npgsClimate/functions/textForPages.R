
introStatement <- function(){
  p(
    h3("Purpose"),
    "The USDA-National Plant Germplasm System (NPGS)",
    tags$strong("Climate Futures Application"),
    "is a resource that provides and visualizes future climate data for NPGS 
    locations where plant genetic resources are maintained or regenerated. This
    information may be used to help guide genebank efforts to adapt to 
    a changing climate.",
    "Supporting documentation provides information about the data showcased in the tool."
  )
}

mapPage <- function(){
  p(
    "The National Plant Germplasm System has locations throughout North America, Central America and Hawaii.",
    "All sites displayed on the map below can be selected for visualization of ",
    "climate data on the", tags$strong("data visualization"), " page of the application."
  )
}

tempText <- function(){
  p(
    "All temperature data presented is the outcome of 10 climate models.
    Please see the ",
    tags$strong("Climate Model Selection tab"), " for details on the specific
    models used for the resulting outcome.",
    tags$br(), 
    "Details about the individual bioclimatic indicators can be found on the ",
    tags$strong("Bioclimatic Indicators"), " page."
  )
}

precText <- function(){
  p(
    "All precipitation presented is the outcome of 10 climate models. Please see the ",
    tags$strong("Climate Model Selection tab"), " for details on the specific models used for the resulting outcome.",
    "Due variability in the temporal and spatial distribution of modeled precipitation, 
    there is higher variation and uncertainty in this data compared 
    to the temperature dataset.",
    tags$br(), 
    "Details about the individual bioclimatic indicators can be found on the ",
    tags$strong("Bioclimatic Indicators"), " tab.",
  )
}


aboutText <- function(id) {
  ns <- NS(id)
  
  tagList(
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
    "The ",
    tags$em("Historic"),
    " observation on the chart is a measured during the 1970-2000 time period."
  )
}

bioText <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Bioclimatic indicators"),
    p("Bioclimatic (BIO) indicators are previously described climate indices that 
    are relevant to climate conditions that relate to species physiology (O’Donnell
      and Ignizio, 2012). Selected temperature and precipitation BIO indicators 
      are provided graphically within the application. In addition, BIO variable 
      data and average monthly high and low temperature as well as precipitation
      data can be downloaded for each genebank location. Predicted climate 
      conditions using BIO indicators provide more specific information than yearly
      averages, which increases their variability, but also increases their 
      usefulness for future climate change planning activities."),
    h2("Bioclimatic indicators presented in the application"),
    
    h3("Temperature indicators"),
    
    p(
      tags$strong("BIO5 = Average Maximum Temperature of Warmest Month: "),
    "The maximum temperature in Celsius of the warmest month in each year
    averaged over the range of years indicated."
    ),
    br(),
    
    p(
      tags$strong("BIO6 = Average Minimum Temperature of Coldest Month: "),
    "The minimum temperature in Celsius of the coldest month in each year
    averaged over the range of years indicated."
    ),
    br(),
    p(
      tags$strong("BIO8 = Mean Temperature of Wettest Quarter: "),
    "This quarterly index approximates mean temperatures that prevail during 
    the wettest season. The wettest quarter is determined by identifying the three
    consecutive months with the highest cumulative precipitation within each 
    calendar year. Means are calculated using the daily (????) temperature averages
    in Celsius for the wettest three months of each year and averaged over the 
    range of years indicated."
    ),
    br(),
    p(
    tags$strong("BIO9 = Mean Temperature of Driest Quarter: "),
    "This quarterly index approximates mean temperatures that prevail during
    the driest quarter. The driest quarter is determined by identifying the three
    consecutive months with the highest cumulative precipitation within each calendar
    year. Means are calculated using the daily (????) temperature averages in 
    Celsius for the driest three months of each year and averaged over the range 
    of years indicated.",
    ),
    br(),
    p(
    tags$strong("BIO10 = Mean Temperature of Warmest Quarter: "),
    "This quarterly index approximates mean temperatures that prevail during
    the warmest quarter. It is calculated by identifying the three consecutive 
    months with the warmest temperatures within each calendar year. Means are 
    calculated using the daily (???) temperature averages in Celsius for the 
    warmest three months of each year and averaged over the range of years indicated.",
    ),
    br(),
    p(
    tags$strong("BIO11 = Mean Temperature of Coldest Quarter: "),
    "This quarterly index approximates mean temperatures that prevail during 
    the coldest quarter. It is calculated by identifying the three consecutive 
    months with the coldest temperatures within each calendar year. Means are 
    calculated using the daily (???) temperature averages in Celsius for the 
    coldest three months of each year and averaged over the range of years indicated."
    ),
    br(),
    h3("Precipitation indicators"),
    p(
    tags$strong("BIO13 = Precipitation of Wettest Month: "),
    "This index identifies the total precipitation that prevails during the 
    wettest month. The cumulative precipitation in millimeters of the wettest 
    month of each calendar year is averaged over the range of years indicated."
    ),
    p(
    br(),
    tags$strong("BIO14 = Precipitation of Driest Month: "),
    "This index identifies the total precipitation that prevails during the 
    driest month. The cumulative precipitation in millimeters of the driest 
    month of each calendar year is averaged over the range of years indicated."
    ),
    br(),
    p(
    tags$strong("BIO16 = Precipitation of Wettest Quarter: "),
    "This quarterly index approximates total precipitation that prevails 
    during the wettest quarter. The wettest quarter is determined by identifying 
    the three consecutive months with the highest cumulative precipitation within
    each calendar year. The cumulative precipitation in millimeters is averaged
    for the wettest three months of each year and averaged over the range of 
    years indicated."
    ),
    br(),
    p(
    tags$strong("BIO17 = Precipitation of Driest Quarter: "),
    "This quarterly index approximates total precipitation that prevails 
    during the driest quarter. The driest quarter is determined by identifying 
    the three consecutive months with the lowest cumulative precipitation within
    each calendar year. The cumulative precipitation in millimeters is averaged 
    for the driest three months of each year and averaged over the range of years
    indicated."
    ),
    br(),
    p(
    tags$strong("BIO18 = Precipitation of Warmest Quarter: "),
    "This quarterly index approximates total precipitation that prevails 
    during the warmest quarter. It is calculated by identifying the three 
    consecutive months with the warmest temperatures within each calendar year. 
    The cumulative precipitation in millimeters for the warmest quarter is 
    averaged over the range of years indicated."
    ),
    br(),
    p(
    tags$strong("BIO19 = Precipitation of Coldest Quarter: "),
    "This quarterly index approximates total precipitation that prevails 
    during the coldest quarter. It is calculated by identifying the three 
    consecutive months with the coldest temperatures within each calendar year. 
    The cumulative precipitation in millimeters for the coldest quarter is 
    averaged over the range of years indicated. "
    ),
    br(),
    h2("Data Source Details"),
    p(
      "All datasets were obtained from ",
      HTML("
           <a href='https://www.worldclim.org/data/cmip6/cmip6climate.html' target='_blank'>WorldClim</a>
           "),
      ". Data were compiled at the 2.5 minutes spatial resolution. All models are from the ",
      HTML("
           <a href='https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6' target='_blank'>CMIP6</a>
           "),
      " model suite and were downscaled using ",
      HTML("
           <a href='https://rmets.onlinelibrary.wiley.com/doi/full/10.1002/joc.5086' target='_blank'>WorldClim v2.1</a>
           "),
      "as the baseline dataset. The historic data referenced within the 
      application are from WorldClim and represent a 30-year average of measure 
      and interpolated values from 1970-2000."
    ),
    h2("Citation"),
    p(
      "O’Donnell, M.S. and Ignizio, D.A. 2012. Bioclimatic predictors for supporting 
      ecological applications in the conterminous United States: U.S. 
      Geological Survey Data Series 691. 10 p."
    )
    
  )
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}

climText <- function(id) {
  ns <- NS(id)
  
  tagList(
    h2("Method for Selecting Climate Models"),
    p(
      "There were multiple factors that influenced the selection of climate data",
      " used within the ensemble models presented in the application.",
      tags$ol(
        tags$strong("Availability through WorldClim2"),
        ": Datasets for CIMP6 models at the 2.5 arc minute resolution needed to be,
              avialble for all SSPs used in this method."
      ),
      tags$ol(
        tags$strong("Moderate representation of CONUS climate"),
        "; Models that had
      moderate representation at the CONUS level as based on average weighted normalized relative
              error define in Ashfaq et. al. 2022 "
      ),
    #   tags$ol(
    #     tags$strong("Can not be considered an execeptually hot model"),
    #     ": Models that are being
    #           observer to run execptually hot were excluded based on https://www.carbonbrief.org/cmip6-the-next-generation-of-climate-models-explained/.
    #           This was only applied to the selection of temperature models as the expectation is that the evaluation
    #           performed in the peer review study is a more substative."
    #   )
     ),
    br(),
    
    h2("Specific Climate Models Used"),
    # h3("Temperature"),
    
    # p(
    #   tags$strong(
    #     "EC-Earth3-Veg",
    #     br(),
    #     "MPI-ESM1-2-HR",
    #     br(),
    #     "MRI-ESM2-0",
    #     br(),
    #     "BCC-CSM2-MR"
    #   )
    # ),
    # 
    # h3("Precipitation"),
    p(
      tags$strong(
        "EC-Earth3-Veg",
        br(),
        "MPI-ESM1-2-HR",
        br(),
        "ACCESS-CM2",
        br(),
        "MRI-ESM2-0",
        br(),
        "MPI-ESM1-2-LR",
        br(),
        "BCC-CSM2-MR",
        br(),
        "HadCEM2-GC31-LL",
        br(),
        "EC-Earth3-Veg-LR",
        br(),
        "CanESM5",
        br(),
        "CNRM-ESM2-1"
      )
    )
  )
}
