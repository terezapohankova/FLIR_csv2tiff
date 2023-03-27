###JPG2TEMP
#### via Petra Duriancikova (2022), Tomas Purker (2017), Tereza Phankova (2022)
library(Thermimage)

wd <- setwd("path_to_wd") #working dir
jpg_list <- list.files(path=wd, pattern="*.jpg") #strip JPG extension

n <- 0 #start counter

for(file in jpg_list) { #for file in list of JPGs, strip extension, read the image, extract constants and export to CSV
  n <- n+1
  
  strip_jpg <- str_remove(file, ".jpg") #get rid of JPG
  img <- readflirJPG(file, exiftoolpath="installed") #read JPG by exiftool
  
  cams <- flirsettings(file, exiftoolpath="installed", camvals="") #extract camera and image constants via exif tool
  cams
  #### https://www.rdocumentation.org/packages/Thermimage/versions/4.1.3/topics/raw2temp
  Emissivity <-  cams$Info$Emissivity                    # Image Saved Emissivity
  PlanckR1 <-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
  PlanckB <-     cams$Info$PlanckB                       # Planck B constant for camera  
  PlanckF <-     cams$Info$PlanckF                       # Planck F constant for camera
  PlanckO <-     cams$Info$PlanckO                       # Planck O constant for camera
  PlanckR2 <-    cams$Info$PlanckR2                      # Planck R2 constant for camera
  ATA1 <-        cams$Info$AtmosphericTransAlpha1        # Atmospheric attenuation constant
  ATA2 <-        cams$Info$AtmosphericTransAlpha2        # Atmospheric attenuation constant
  ATB1 <-        cams$Info$AtmosphericTransBeta1         # Atmospheric attenuation constant
  ATB2 <-        cams$Info$AtmosphericTransBeta2         # Atmospheric attenuation constant
  ATX <-         cams$Info$AtmosphericTransX             # Atmospheric attenuation constant
  OD <-          cams$Info$ObjectDistance                # Object distance in metres
  ReflT <-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
  AtmosT <-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
  RH <-          cams$Info$RelativeHumidity              # Relative Humidity
  
  write.csv2(img, paste(rt,"/", strip_jpg,"_RT",".csv", sep=""), row.names = FALSE) #write raw temperature data in CSV
  raw_csv <- read.csv2(paste(rt,"/", strip_jpg,"_RT",".csv", sep="")) #raw temperature data variable for raw2temp
  
  #converting raw temperatures to Celsius
  temp <- round(raw2temp(as.matrix(raw_csv), E=0.83, OD=OD, RTemp=ReflT, ATemp=AtmosT, IRWTemp=ReflT, IRT=1, RH=RH, 
                         PR1=PlanckR1, PB=PlanckB, PF=PlanckF, PO=PlanckO, PR2=PlanckR2, 
                         ATA1=ATA1, ATA2=ATA2, ATB1=ATB1, ATB2=ATB2, ATX=ATX), digits=3)
  write.csv2(temp, paste(temp_final,"/", strip_jpg,"_temp",".csv", sep=""), row.names = FALSE) #write Celsius temperature data in CSV
}
