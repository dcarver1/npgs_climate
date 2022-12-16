###
# data processing workflow for generating climate futures for NPGS
# carverd@colostate.edu
# 20221102
### 


# Load packages required to define the pipeline:
library(targets)
library(future)
library(future.callr)
# for troubleshooting 
pacman::p_load("targets","terra", "dplyr", "tidyr", "sf", "readr","tmap", "purrr","tictoc")

# Set target options:
tar_option_set(
  packages = c("targets","terra", "dplyr", "tidyr", "sf", "readr","tmap", "purrr","tictoc"), # packages that your targets need to run
  format = "rds",
  memory = "transient",
  garbage_collection = TRUE # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() ### should be able to run workers=4 on 32gb system, maybe more, 3 pushed about 20 with some background draws 



# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/functions.R")
# source("other_functions.R") # Source other scripts as needed. # nolint
plan(callr)

# Replace the target list below with your own:
list(
  # identifies the input file 
  tar_target(file, "npgsSiteData.csv", format = "file"),
  
  # convert file to spatial object
  tar_target(locs, processNPGS(file)),
  
  # create bounding box for cliping features 
    # can't pass the terra extent object to a target so I need to convert it at the 
    # processing call. 
  tar_target(b_box, bbox(locs)),
  
  # process historic data 
  tar_target(historicWC, processHistWc(b_box)),
  tar_target(historicMonth, processHistMonthly(b_box)),

  # Assocaited climate data with individual sites. 10 models usesd for all varibles
  tar_target(future126, processAllBio("ssp126", boundingBox = b_box)),
  tar_target(future245, processAllBio("ssp245", boundingBox = b_box)),
  tar_target(future370, processAllBio("ssp370", boundingBox = b_box)),
  tar_target(future585, processAllBio("ssp585", boundingBox = b_box)),
  # bind rasters across years 
  tar_target(hist1, bindRasts(historicWC)),
  tar_target(fc126, bindRasts(future126)),
  tar_target(fc245, bindRasts(future245)),
  tar_target(fc370, bindRasts(future370)),
  tar_target(fc585, bindRasts(future585)),
  
  
  # process the tmin,tmax,prec data 
  tar_target(future126m, processAllMonthly("ssp126", boundingBox = b_box)),
  tar_target(future245m, processAllMonthly("ssp245", boundingBox = b_box)),
  tar_target(future370m, processAllMonthly("ssp370", boundingBox = b_box)),
  tar_target(future585m, processAllMonthly("ssp585", boundingBox = b_box)),
  
  # bind rasters across years 
  tar_target(histM, bindRasts(historicMonth)),
  tar_target(fc126m, bindRasts(future126m)),
  tar_target(fc245m, bindRasts(future245m)),
  tar_target(fc370m, bindRasts(future370m)),
  tar_target(fc585m, bindRasts(future585m)),
  # Aggregates data
  tar_target(valsWC, bindWC(hist1,fc126,fc245,fc370,fc585, locs)), #50gb memory allocation
  tar_target(valsM, bindMonth(histM,fc126m,fc245m,fc370m,fc585m,locs))

)
# export summary material and send data to shiny app 
source("compiledSiteData.R")
