

# trouble shooting the difference between the bio and monthly data 

pacman::p_load(dplyr, tmap)

files <- list.files(path = "troubleshootingTests", full.names = TRUE, 
                    pattern = ".csv")


# future ------------------------------------------------------------------
fBio <- read.csv(files[1]) %>%
  dplyr::select("ID",contains("wc2_5"))%>%
  filter(ID == 1)
View(fBio)

###
# the model in the second position BCC-CSM2-MR 
# has some pretty extreme values on temperature and precitation. going to exclude for now. 
####

fprec <- read.csv(files[2]) %>%
  dplyr::select("ID",contains("03"))%>%
  filter(ID == 1)

ftmax <-read.csv(files[3]) %>%
  dplyr::select("ID",contains("08"))%>%
  filter(ID == 1)

ftmin <- read.csv(files[4]) %>%
  dplyr::select("ID",contains("01"))%>%
  filter(ID == 1)

View(ftmax)
