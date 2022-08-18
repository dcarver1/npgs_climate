

reOrderClimate <- function(row,data){
  # filter to individual rows 
  t1 <- data[row,]
  
  df2 <- data.frame(matrix(nrow = (ncol(t1)-1), ncol = 5))
  names(df2) <- c("ID", "year", "emission", "variable", "value")
  
  df2$ID <- t1$ID
  df2$year <- c(rep(2030, 9),rep(2050, 9),rep(2070, 9),rep(2090, 9))
  df2$variable <- rep(c("tmax", "tmin", "prec"), 12)
  df2$emission <- rep(c(rep("ssp126", 3), rep("ssp370", 3),rep("ssp585", 3)),4)
  
  for(i in seq_along(df2$ID)){
    y <- as.character(df2[i, "year"])
    e <- df2[i,"emission"]
    v <- df2[i, "variable"]
    
    df2[i,"value"] <- t1 %>%
      dplyr::select(contains(y))%>%
      dplyr::select(contains(e))%>%
      dplyr::select(contains(v))%>%
      pull()
  }
  return(df2)
}


reOrderTidy <- function(data){
 
  d1 <- data %>% 
    tidyr::gather(key = categories ,value = value, -c(ID))%>%
    tidyr::separate(col = categories, into = c("variable", "emission", "year"), sep = "_")
  return(d1)
}

reOrderCurrent <- function(row,data){
  # filter to individual rows 
  t1 <- data[row,]
  
  df2 <- data.frame(matrix(nrow = (ncol(t1)-1), ncol = 5))
  names(df2) <- c("ID", "year", "emission", "variable", "value")
  
  df2$ID <- t1$ID
  df2$year <- 1990
  df2$variable <- rep(c("tmax", "tmin", "prec"))
  df2$emission <- "measured"
  df2$value[1] <- t1$tmax
  df2$value[2] <- t1$tmin
  df2$value[3] <- t1$prec
  
  return(df2)
}

