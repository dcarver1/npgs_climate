
introStatement <- function(){
  p(
    h3("Purpose"),
    "The National Plant Germplasm System", tags$strong("Climate Futures Application"),
    " is a resource for interpreting future climate data.
    This resource highlights locations within the NPGS where germplasm is stored
    or regenerated. The climate futures tool does not provide direct 
    recommendations for climate mitigation efforts. Please view the supporting 
    documentation pages for more information regarding the data showcased in 
    the tool." 
  )
}

mapPage <- function(){
  p(
    "The National Plant Germplasm System has locations throughout North and Central America.",
    "All sites displayed on the map below can be selected for visualization of ",
    "climate data on the", tags$strong("data visualization"), " page of the application."
  )
}

tempText <- function(){
  p(
    "All temperature data presented is the ensamble mean of 10 climate models. Please see ",
    tags$strong("Climate Model Selection"), " for details on the specific models used in the ensamble",
    tags$br(), 
    "Details on the individual bioclimatic indicators can be found on the ",
    tags$strong("Bioclimatic Indicators"), " page."
  )
}

precText <- function(){
  p(
    "All precipitation data presented is the ensamble mean of 10 climate models. Please see ",
    tags$strong("Climate Model Selection"), " for details on the specific models used in the ensamble.",
    "Please note that due to the variability in the temporal and spatial distribution of precipitation ",
    "there is increase varability and uncertain in modelled precititation futures compared to temperature ",
    "based indicators.",
    tags$br(), 
    "Details on the individual bioclimatic indicators can be found on the ",
    tags$strong("Bioclimatic Indicators"), " page.",
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
    h2("Bioclimatic variables "),
    "The bioclimatic variables are summaries of climatic conditions that are very commonly used in species distribution modeling.",
    "They are included here because they provide a more granular evaluation of the factors that influence plant growth.",
    "Note that these measures are more specific the the higher generalized yearly averages (temp min, temp max, and precipitation) and therefore are expected to contain an increased amount of variability.",
    h2("Definitions and Association to Plant Physiology"),
    h3("Temperature Variables"),
    p(
      tags$strong("BIO5 = Max Temperature of Warmest Month"),
    ": ", " direct measure of maximum heat stress experienced by plants in the hottest month of the year."
    ),
    br(),
    
    p(
      tags$strong("BIO6 = Min Temperature of Coldest Month"),
    ": ", " direct measure maximum cold stress experienced by plants in the cold season.", 
    " This measure is more impactful on perennial species, though it does have impacts ",
    "on pest populations, which does influence the management of annual species."
    ),
    br(),
    p(
      tags$strong("BIO8 = Mean Temperature of Wettest Quarter"),
    ": ", "not quite sure how to convey this to plant success"
    ),
    br(),
    p(
    tags$strong("BIO9 = Mean Temperature of Driest Quarter"),
    ": ","Possible reflection of heat and drought stress experienced by species.",
    ),
    br(),
    p(
    tags$strong("BIO10 = Mean Temperature of Warmest Quarter"),
    ": ", "more generalized measure of the potential heat stress experienced by",
    " plants in the hottest period of the year.",
    ),
    br(),
    p(
    tags$strong("BIO11 = Mean Temperature of Coldest Quarter"),
    ": "," generalized measure of potential cold stress experiences by plants in",
    "the coldest period of the year."
    ),
    br(),
    p(
    h3("Precipitation Variables"),
    tags$strong("BIO13 = Precipitation of Wettest Month"),
    ": ","the timing and volume of precipition can drastically effect the viability ",
    "of individual plants. To much water can lead to rot and increase pressure from ",
    " rusts, molds, and other biological agents. Not that sure about these statements."
    ),
    p(
    br(),
    tags$strong("BIO14 = Precipitation of Driest Month"),
    ": ","drought length and intensity can dramatic influence plant viability. ",
    "This measure represents the change in potential for drought in a region."
    ),
    br(),
    p(
    tags$strong("BIO16 = Precipitation of Wettest Quarter"),
    ": ", 
    ),
    br(),
    tags$strong("BIO17 = Precipitation of Driest Quarter"),
    ": ",
    
    br(),
    p(
    tags$strong("BIO18 = Precipitation of Warmest Quarter"),
    ": ", "Generalized precipition measure in summer months."
    ),
    br(),
    p(
    tags$strong("BIO19 = Precipitation of Coldest Quarter"),
    ": ", "Generalized cold stress in winter months. "
    ),
    br(),
    h2("Data Source Details"),
    p(
      "All datasets were gather from ",
      HTML("
           <a href='https://www.worldclim.org/data/cmip6/cmip6climate.html' target='_blank'>WorldClim2</a>
           "),
      ". Data was compiled at the 2.5 minutes spatial resolution. All models are from the ",
      HTML("
           <a href='https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6' target='_blank'>CMIP9</a>
           "),
      " model suite and were downscaled using ",
      HTML("
           <a href='https://rmets.onlinelibrary.wiley.com/doi/full/10.1002/joc.5086' target='_blank'>WorldClim v2.1</a>
           "),
      "as the baseline dataset. The historic data referenced within the application is also ",
      "from WorldClim2 and represents a 30 year average of measure and interpolated values from 1970-2000."
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
