###
# download gmc files from the world clim 2 server 
# carverd@colostate.edu
# 20220830 
###


gmcs <- c("CNRM-ESM2-1", "MIROC6", "CNRM-CM6-1", "MIROC-ES2L")
models <- c("ssp126", "ssp245", "ssp370","ssp585")
catagory <- c("prec","tmax","tmin")
years <- c("2021-2040","2041-2060","2061-2080","2081-2100")

options(timeout=1000)
### rerun before next step to capture the first incomplete download 

# nested loops 
for(i in gmcs){
  path1 <- paste0("analysisData/future/models/",i)
  if(!dir.exists(path1)){
    dir.create(path1)
  }
  for(j in models){
    for(k in catagory){
      for(y in years){
        # construct paths for the url and file name. 
        name1 <- paste0("wc2.1_2.5m_",k,"_",i,"_",j,"_",y,".tif")
        url <- paste0("https://geodata.ucdavis.edu/cmip6/2.5m/",i,"/",j,"/",name1)
        path2 <- paste0(path1,"/",name1)
        print(path2)
        if(!file.exists(path2)){
          # download data
          download.file(url = url,
                        destfile = path2)
          # add a delay to limit the rate of calls on the server 
          Sys.sleep(10)
        }
      }
    }
  }
}
