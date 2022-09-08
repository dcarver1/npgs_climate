###
# functions for summary document 
# 20220825
# carverd@colostate.edu
###

min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

range01 <- function(x){(x-min(x))/(max(x)-min(x))}

filterGMC <- function(data){
  df <- data %>%
    dplyr::filter(GCM != "BASELINE" , GCM != "ENSEMBLE", GCM !="IPSL.CM6A.LR")%>%
    dplyr::select(GCM, temp = `bio1 (ºC)`, prec = `bio12 (mm)`)
    # drop baseline and ensemble rows 
    # select GCM and bio1 and bio12   
  return(df)
}

rankGMC <- function(data){
  mt <- mean(data$temp)
  mp <- mean(data$prec)
  
  df <- data %>%
    rowwise()%>%
    dplyr::mutate(tempDiff = abs(temp-mt),
                  precDiff = abs(prec-mp))%>%
    ungroup()%>%
    dplyr::mutate(tempNorm = range01(tempDiff),
                  precNorm = range01(precDiff)) %>%
    dplyr::rowwise()%>%
    dplyr::mutate(difference = tempNorm + precNorm)%>%
    dplyr::select(GCM, temp, prec, difference)
                    
  return(df)
}