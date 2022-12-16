# !pip install wget

import wget
import os
import sys

#create this bar_progress method which is invoked automatically from wget
def bar_progress(current, total, width=80):
  progress_message = "Downloading: %d%% [%d / %d] bytes" % (current / total * 100, current, total)
  # Don't use print() as it will print in new line every time.
  sys.stdout.write("\r" + progress_message)
  sys.stdout.flush()


gmcs = ["EC-Earth3-Veg","MPI-ESM1-2-HR","ACCESS-CM2","MRI-ESM2-0",
        "MPI-ESM1-2-LR","EC-Earth3-Veg-LR","CanESM5",
        "CNRM-ESM2-1","GISS-E2-1-G", "CNRM-CM6-1"]
        # removed due to data errors "BCC-CSM2-MR"
models = ["ssp126", "ssp245", "ssp370","ssp585"]

category = ["bioc", "tmax", "tmin", "prec"]

years = ["2021-2040","2041-2060","2061-2080","2081-2100"]

for i in gmcs:
  path1 = "climateData/future/" + i
  print(path1)
  if not os.path.exists(path1):
     os.makedirs((path1))
  for j in models :
      for k in category :
        for y in years :
          name1 = "wc2.1_2.5m_"+k+"_"+i+"_"+j+"_"+y+".tif"
          print(name1)
          url = "https://geodata.ucdavis.edu/cmip6/2.5m/"+i+"/"+j+"/"+name1
          path2 =  path1+"/"+name1
          if not os.path.exists(path2):
            wget.download(url=url, out=path2,bar=bar_progress)
