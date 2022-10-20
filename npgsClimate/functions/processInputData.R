
generateSites <- function(){
  sites <- read_csv("npgsSiteData.csv")%>%
    dplyr::select("NPGS site","Address","Type of site","Latitude","Longitude","Include in Crop Science Report (TRUE/FALSE)")%>%
    dplyr::filter(`Include in Crop Science Report (TRUE/FALSE)` == TRUE)%>%
    dplyr::mutate(ID = seq(1,27,1))  ### this hard code is bad need to replace with either stand alone function or 
  return(sites)
}

processData <- function(sites){
  df <- read_csv("climateAndBioC.csv")%>% ### this is a little odd, it's look toward the project directory
    dplyr::left_join(sites, by = "ID") %>%
    dplyr::select(
      "ID",
      "NPGS_Site" = "NPGS site",
      "Site_Category" = "Type of site",
      "variable",
      "emission",
      "year",
      "value",
      "Latitude",
      "Longitude"
    )%>%
    dplyr::mutate(aveYear = case_when(
      year == "2021-2040" ~ 2030,
      year == "2041-2060" ~ 2050,
      year == "2061-2080" ~ 2070,
      year == "2081-2100" ~ 2090,
      TRUE ~ 1985
    ))%>%
    dplyr::mutate(year = case_when(
      year == "2000" ~ "1970-2000",
      TRUE ~ year
    ))%>% 
    dplyr::mutate(color = case_when(
      emission == "ssp585" ~ "#d7191c",
      emission == "ssp370" ~ "#fdae61",
      emission == "ssp245" ~ "#EDED17",
      emission == "ssp126" ~ "#abd9e9",
      emission == "Historic" ~ "#2c7bb6"))
  return(df)
}
