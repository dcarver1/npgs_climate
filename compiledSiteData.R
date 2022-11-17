### 
# compile dataset for shiny app 
# carverd@colostate.edu
# 20221102
### 


library(targets)
library(dplyr)

#load datasets 
tar_load(vals)
tar_load(locs)

# bind for reference name 
l1 <- locs %>%
  st_drop_geometry()%>%
  mutate(ID = seq(1,nrow(.),1))%>%
  select(ID, `NPGS site`)%>%
  dplyr::left_join(vals, by = "ID" )
#export to local repo for direct reference 
write.csv(l1, file = "compiledSiteData.csv")
# export basic version to shiny app 
write.csv(l1, file = "npgsClimate/compiledSiteData.csv")
