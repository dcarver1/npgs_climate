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

  # plot feature no change to the data 
  p1 <-  plot_ly(data = data, y = ~value, x = ~year, type = "bar",
                 color = ~emission, colors = ~color, name = ~emission
                 # base = historic10,
                 #base = min,
                 #ylim = c(min, max)
                 )%>%
    layout(hovermode = "x unified")

  return(p1)
}


# temperature -------------------------------------------------------------
plotMonthlyTemp <- function(data){
  dfa <- data %>%# this needs to get changed to a historic measure once I have the data 
    dplyr::filter(emission == "historic" & 
                    year == "1970-2000")%>%
    dplyr::mutate(month = case_when(
      month == "January" ~1,
      month =="February"~2,
      month == "March" ~ 3,
      month == "April" ~ 4,
      month == "May" ~ 5,
      month == "June" ~ 6,
      month =="July" ~ 7,
      month == "August" ~8,
      month == "September" ~ 9,
      month == "October" ~ 10,
      month == "November" ~11,
      month == "December" ~12
    ))%>%
    dplyr::mutate(month = month(month,label = TRUE, abbr = TRUE))
  #spilt into two different data frames to add as trace plot
  d1 <- dfa[dfa$variable =="tmax", ]
  d2 <- dfa[dfa$variable == "tmin",]
  # create primary plot layout 
  fig <- plot_ly(data = d2,
                 x = ~month,
                 y = ~value,
                 name = "Minimum Temperature",
                 type = "bar")%>%
    layout(legend=list(title=list(text='Average Monthly Temperature - Historic - 1970-2000'),orientation = 'h'),
           xaxis = list(title = ''),
           yaxis = list(title = paste0('Temperature (',intToUtf8(176),'C)')),
           barmode = 'group',
           hovermode = "x unified")
  # add trace
  fig <- fig %>%
    add_trace(data = d1, 
              x = ~month,
              y = ~value,
              name = "Maximum Temperature",
              type = "bar"
    )
  return(fig)
}


# "bioc_5" Max Temperature of Warmest Month
plotChart_bio5 <- function(data){
  ### this should do somethi to the font size be it seems to be getting over writen by the CSS? 
  t1 <- list(
    family = "Segoe UI",
    size = 36)
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario', font = t1)),
                     xaxis = list(title = 'Year', font = t1 ),
                     yaxis = list(title = paste0('Max Temperature of Warmest Month (',intToUtf8(176),'C)')))

  return(p1)
}

# "bioc_6" Min Temperature of Coldest Month
plotChart_bio6 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = paste0('Minimum Temperature of Coldest Month (',intToUtf8(176),'C)')))
  
  return(p1)
}

# "bioc_8" Mean Temperature of Wettest Quarter 
plotChart_bio8 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = paste0('Mean Temperature of Wettest Quarter (',intToUtf8(176),'C)')))
  
  return(p1)
}

# "bioc_9" Mean Temperature of Driest Quarter
plotChart_bio9 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = paste0('Mean Temperature of Driest Quarter (',intToUtf8(176),'C)')))
  
  return(p1)
}

# "bioc_10" Mean Temperature of Warmest Quarter
plotChart_bio10 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = paste0('Mean Temperature of Warmest Quarter (',intToUtf8(176),'C)')))
  
  return(p1)
}

# "bioc_11" Mean Temperature of Coldest Quarter
plotChart_bio11 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = paste0('Mean Temperature of Coldest Quarter (',intToUtf8(176),'C)')))
  
  return(p1)
}



# prec --------------------------------------------------------------------
## plot montly precipitation values 
plotMonthlyPrec <- function(data){
  dfa <- data %>%# this needs to get changed to a historic measure once I have the data 
    dplyr::filter(emission == "historic" & 
                    year == "1970-2000")%>%
    dplyr::mutate(month = case_when(
      month == "January" ~1,
      month =="February"~2,
      month == "March" ~ 3,
      month == "April" ~ 4,
      month == "May" ~ 5, 
      month == "June" ~ 6, 
      month =="July" ~ 7, 
      month == "August" ~8,
      month == "September" ~ 9,
      month == "October" ~ 10,
      month == "November" ~11,
      month == "December" ~12 
    ))
  dfa$month <- lubridate::month(dfa$month,label = TRUE, abbr = TRUE)
  
  fig <- plot_ly(data = dfa, x = ~month,y = ~value,type = "bar")%>%
    layout(legend=list(title=list(text='Yearly Precipitation - - Historic - 1970-2000'),orientation = 'h'),
           xaxis = list(title = ' '),
           yaxis = list(title = 'Total Precipitation (mm)'),
           hovermode = "x unified")
  
  return(fig)
}


# "bioc_13" Precipitation of Wettest Month
plotChart_bio13 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Wettest Month (mm)'))
}

# "bioc_14" Precipitation of Driest Month
plotChart_bio14 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Driest Month (mm)'))
}

# "bioc_16" Precipitation of Wettest Quarter 
plotChart_bio16 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Wettest Quarter  (mm)'))
}

# "bioc_17" Precipitation of Driest Quarter
plotChart_bio17 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Driest Quarter (mm)'))
}

# "bioc_18" Precipitation of Warmest Quarter
plotChart_bio18 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Warmest Quarter (mm)'))
}

# "bioc_19" Precipitation of Coldest Quarter
plotChart_bio19 <- function(data){
  p1 <- coreBarPlot(data) %>%
    layout(legend=list(title=list(text='Emission Scenario')),
           xaxis = list(title = 'Year'),
           yaxis = list(title = 'Precipitation of Coldest Quarter (mm)'))
  return(p1)
}
