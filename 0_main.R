###
# process and render data for the npgs field sites 
# carverd@colostate.edu
# 20220817 
###

pacman::p_load("terra", "dplyr", "tidyr", "sf", "readr","tmap", "purrr","tictoc")

list.files(path = "src", full.names = TRUE, recursive = TRUE) %>% map(source)


# process npgs site data --------------------------------------------------
sp1 <- processNPGS(path = "analysisData/npgsSites/npgsSiteData.csv")%>%
  mutate(ID = 1:nrow(.))

# process wc historic -----------------------------------------------------
processHistoric(path = "analysisData/historic", overwrite = TRUE)

# process future data 
tic()
processFuture(path = "analysisData/future/models", overwrite = TRUE)
toc()


# attach attributes to locations ------------------------------------------------
d1 <- generateData(path1 =  "analysisData/historic/averaged",
                             path2 = "analysisData/future/averaged",
                             spatialData = sp1)

# generate final project --------------------------------------------------
data <- dplyr::left_join(x = sf::st_drop_geometry(sp1), y = d1, by = "ID")%>%
  dplyr::select("ID", "NPGS site","Type of site", "variable", "emission","year","value")
write_csv(data,file = paste0("output/summary_data_",Sys.Date(),".csv"))


