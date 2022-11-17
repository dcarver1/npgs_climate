# functions for application
corePlot <- function(data){
  vline <- function(x=0) {
    list(
      type = "line",
      x0 = x,
      x1 = x,
      y0 = 0,
      y1 = 1,
      yref = "paper",
      line = list(color = "white", width = 6)
    )
  }
  p1 <-  plot_ly(data = data,  x = ~year)%>%
    add_lines(y = ~value,line = list(shape = "hvh", width = 4, dash = "dot"), 
              color = ~emission, colors = ~color, name = ~emission)%>%
    layout(shapes = list(vline(1), vline(2), vline(3)), 
           hovermode = "x unified")
  return(p1)
}

# bar plot varient 
coreBarPlot <- function(data){
  #grab reference value
  historicReference <- data %>%
    filter(emission == "Historic") %>%
    dplyr::select(value) %>%
    pull()
  # set % down from historic so the historic bar shows on plot
  historic10 <- historicReference - (historicReference *.05)
  
 
  

  data$value2 <- data$value - historic10
  # grab values for the manually define y axis
  range1 <- range(data$value2)
  min <- range1[[1]]
  max <- range1[[2]]
  ## just use min max 
  min <- min(data$value)
  max <- max(data$value)
  
  # minimum based value
  min2 <- min - (min *0.05)
  if(min2 > 0 ){
    data$value2 <- data$value - min2
  }else{
    data$value2 <- data$value + min2
  }

  # plot feature no change to the data 
  p1 <-  plot_ly(data = data, y = ~value, x = ~year, type = "bar",
                 color = ~emission, colors = ~color, name = ~emission
                 # base = historic10,
                 #base = min,
                 #ylim = c(min, max)
                 )%>%
    layout(hovermode = "x unified")

  
  
  # # plot feature 
  # p1 <-  plot_ly(data = data, y = ~value2, x = ~year, type = "bar",
  #                color = ~emission, colors = ~color, name = ~emission,
  #                # base = historic10,
  #                base = min,
  #                ylim = c(min, max))%>%
  #   layout(hovermode = "x unified")
  return(p1)
}




# "bioc_5" Max Temperature of Warmest Month
plotChart_bio5 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
                     xaxis = list(title = 'Year'),
                     yaxis = list(title = 'Max Temperature of Warmest Month (c)'))

  return(p1)
}

# "bioc_6" Min Temperature of Coldest Month
plotChart_bio6 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Min Temperature of Coldest Month (c)'))
  
  return(p1)
}

# "bioc_8" Mean Temperature of Wettest Quarter 
plotChart_bio8 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Temperature of Wettest Quarter  (c)'))
  
  return(p1)
}

# "bioc_9" Mean Temperature of Driest Quarter
plotChart_bio9 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Temperature of Driest Quarter (c)'))
  
  return(p1)
}

# "bioc_10" Mean Temperature of Warmest Quarter
plotChart_bio10 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Temperature of Warmest Quarter (c)'))
  
  return(p1)
}

# "bioc_11" Mean Temperature of Coldest Quarter
plotChart_bio11 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Mean Temperature of Coldest Quarter (c)'))
  
  return(p1)
}






# "bioc_13" Precipitation of Wettest Month
plotChart_bio13 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Wettest Month (mm)'))
}

# "bioc_14" Precipitation of Driest Month
plotChart_bio14 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Driest Month (mm)'))
}

# "bioc_16" Precipitation of Wettest Quarter 
plotChart_bio16 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Wettest Quarter  (mm)'))
}

# "bioc_17" Precipitation of Driest Quarter
plotChart_bio17 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Driest Quarter (mm)'))
}

# "bioc_18" Precipitation of Warmest Quarter
plotChart_bio18 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Warmest Quarter (mm)'))
}

# "bioc_19" Precipitation of Coldest Quarter
plotChart_bio19 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenerio')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Coldest Quarter (mm)'))
  return(p1)
}
