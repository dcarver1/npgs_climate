# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(targets)
library(future)
library(future.callr)
# library(tarchetypes) # Load other packages as needed. # nolint

# Set target options:
tar_option_set(
  packages = c("targets","terra", "dplyr", "tidyr", "sf", "readr","tmap", "purrr","tictoc"), # packages that your targets need to run
  format = "rds" # default storage format
  # Set other options as needed.
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multicore")

# tar_make_future() configuration (okay to leave alone):
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

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
  # process historic data 
  tar_target(historic1, processWC()),
  # # crop 
  # tar_target(historicCrop, cropRasters(historic1, locs)),
  # extract values 
  tar_target(historicData, extractVals(historic1, locs)),
  # ssp585 "2021-2040","2041-2060","2061-2080","2081-2100"
  tar_target(f585_40, processFuture(scenerio = "ssp585", year = "2021-2040")),
  tar_target(f585_60, processFuture(scenerio = "ssp585", year = "2041-2060")),
  tar_target(f585_80, processFuture(scenerio = "ssp585", year = "2061-2080")),
  tar_target(f585_100, processFuture(scenerio = "ssp585", year = "2081-2100")),
  # # crop
  # tar_target(f5c_40, cropRasters(f585_40, locs)),
  # tar_target(f5c_60, cropRasters(f585_60, locs)),
  # tar_target(f5c_80, cropRasters(f585_80, locs)),
  # tar_target(f5c_100, cropRasters(f585_100, locs)),
  # extract
  tar_target(f5d_40, extractVals(f585_40, locs)),
  tar_target(f5d_60, extractVals(f585_60, locs)),
  tar_target(f5d_80, extractVals(f585_80, locs)),
  tar_target(f5d_100, extractVals(f585_100, locs)),
  # bind
  tar_target(allf5d, bind_rows(f5d_40,f5d_60,f5d_80,f5d_100)),
  # ssp370 "2021-2040","2041-2060","2061-2080","2081-2100"
  tar_target(f370_40, processFuture(scenerio = "ssp370", year = "2021-2040")),
  tar_target(f370_60, processFuture(scenerio = "ssp370", year = "2041-2060")),
  tar_target(f370_80, processFuture(scenerio = "ssp370", year = "2061-2080")),
  tar_target(f370_100, processFuture(scenerio = "ssp370", year = "2081-2100")),
  # crop
  # tar_target(f3c_40, cropRasters(f370_40, locs)),
  # tar_target(f3c_60, cropRasters(f370_60, locs)),
  # tar_target(f3c_80, cropRasters(f370_80, locs)),
  # tar_target(f3c_100, cropRasters(f370_100, locs)),
  # extract
  tar_target(f3d_40, extractVals(f370_40, locs)),
  tar_target(f3d_60, extractVals(f370_60, locs)),
  tar_target(f3d_80, extractVals(f370_80, locs)),
  tar_target(f3d_100, extractVals(f370_100, locs)),
  # bind
  tar_target(allf3d, bind_rows(f3d_40,f3d_60,f3d_80,f3d_100)),
  # ssp245 "2021-2040","2041-2060","2061-2080","2081-2100"
  tar_target(f245_40, processFuture(scenerio = "ssp245", year = "2021-2040")),
  tar_target(f245_60, processFuture(scenerio = "ssp245", year = "2041-2060")),
  tar_target(f245_80, processFuture(scenerio = "ssp245", year = "2061-2080")),
  tar_target(f245_100, processFuture(scenerio = "ssp245", year = "2081-2100")),
  # crop
  # tar_target(f2c_40, cropRasters(f245_40, locs)),
  # tar_target(f2c_60, cropRasters(f245_60, locs)),
  # tar_target(f2c_80, cropRasters(f245_80, locs)),
  # tar_target(f2c_100, cropRasters(f245_100, locs)),
  # extract
  tar_target(f2d_40, extractVals(f245_40, locs)),
  tar_target(f2d_60, extractVals(f245_60, locs)),
  tar_target(f2d_80, extractVals(f245_80, locs)),
  tar_target(f2d_100, extractVals(f245_100, locs)),
  # bind
  tar_target(allf2d, bind_rows(f2d_40,f2d_60,f2d_80,f2d_100)),
  # ssp126 "2021-2040","2041-2060","2061-2080","2081-2100"
  tar_target(f126_40, processFuture(scenerio = "ssp126", year = "2021-2040")),
  tar_target(f126_60, processFuture(scenerio = "ssp126", year = "2041-2060")),
  tar_target(f126_80, processFuture(scenerio = "ssp126", year = "2061-2080")),
  tar_target(f126_100, processFuture(scenerio = "ssp126", year = "2081-2100")),
  # crop
  # tar_target(f1c_40, cropRasters(f126_40, locs)),
  # tar_target(f1c_60, cropRasters(f126_60, locs)),
  # tar_target(f1c_80, cropRasters(f126_80, locs)),
  # tar_target(f1c_100, cropRasters(f126_100, locs)),
  # extract
  tar_target(f1d_40, extractVals(f126_40, locs)),
  tar_target(f1d_60, extractVals(f126_60, locs)),
  tar_target(f1d_80, extractVals(f126_80, locs)),
  tar_target(f1d_100, extractVals(f126_100, locs)),
  # bind
  tar_target(allf1d, bind_rows(f1d_40,f1d_60,f1d_80,f1d_100)),
  #bind all
  tar_target(finalValues, bind_rows(historicData, allf1d, allf2d, allf3d, allf5d))
  # 
  ### old process
  # process future data "ssp585", "ssp126", "ssp245", "ssp370")
  # restructure to use parallel computing 
  # tar_target(future126, processAll("ssp126")),
  # tar_target(future245, processAll("ssp245")),
  # tar_target(future370, processAll("ssp370")),
  # tar_target(future585, processAll("ssp585")),
  # tar_target(rasters1, bindrasters(rast1 = historic1,
  #                                  rast2 = future126,
  #                                  rast3 = future245,
  #                                  rast4 = future370,
  #                                  rast5 = future585,
  #                                  locs = locs)),
  # tar_target(vals, extractVals(locs = locs, rasters = rasters1))
)


### 
# notes 
### 
# I can only run the process above at 4 worker before hitting a memory was. This is pushing the ram to 55 gb 
# With that in mind the processall workflow is probably just as good because it at all most is calling 
# There is a datacamp course on parallel computing that I should work through. 
