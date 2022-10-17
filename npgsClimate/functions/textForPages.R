aboutText <- function(id){
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
      "The ",tags$em("Historic"),
      " observation on the chart is a measured during the 1970-2000 time period."
    )
}

bioText <- function(id){
  ns <- NS(id)

  tagList(
    h2("Bioclimatic variables "),
    "The bioclimatic variables are summaries of climatic conditions that are very commonly used in species distribution modeling.",
    "They are included here because they provide a more granular evaluation of the factors that influence plant growth.",
    "Note that these measures are more specific the the higher generalized yearly averages (temp min, temp max, and precipitation) and therefore are expected to contain an increased amount of variability.",
    h2("Definitions and Association to Plant Physiology"),
    h3("Temperature Variables"),
    tags$strong("BIO5 = Max Temperature of Warmest Month"),": ",
    
    br(),
    
    tags$strong("BIO6 = Min Temperature of Coldest Month"),": ",
    
    br(),
    tags$strong("BIO8 = Mean Temperature of Wettest Quarter"),": ",
    
    br(),
    tags$strong("BIO9 = Mean Temperature of Driest Quarter"),": ",
    
    br(),
    tags$strong("BIO10 = Mean Temperature of Warmest Quarter"),": ",
    
    br(),
    tags$strong("BIO11 = Mean Temperature of Coldest Quarter"),": ",
    
    br(),
    h3("Precipitation Variables"),
    tags$strong("BIO13 = Precipitation of Wettest Month"),": ",
    
    br(),
    tags$strong("BIO14 = Precipitation of Driest Month"),": ",
    
    br(),
    tags$strong("BIO16 = Precipitation of Wettest Quarter"),": ",
    
    br(),
    tags$strong("BIO17 = Precipitation of Driest Quarter"),": ",
    
    br(),
    tags$strong("BIO18 = Precipitation of Warmest Quarter"),": ",
    
    br(),
    tags$strong("BIO19 = Precipitation of Coldest Quarter"),": ",
    
    br(),
    h2("Data Source Details"),
  )
  
  
  
  
  
  
  
  
  
  
  
  
  

}

climText <- function(id){
  ns <- NS(id)
  
  tagList(
    h2("Method for Selecting Climate Models"),
    
    br(),
  
    h2("Specific Climate Models Used"),
    h3("Temperature"),
    h3("Precipitation")
  )
}
