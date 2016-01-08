library(raster)

getwd()
compareNDVI <- function(){
	list.files(./data)
}

# untar lansat data
untar("./data/LT51980241990098-SC20150107121947.tar.gz", exdir = "./data/LS5")
untar("./data/LC81970242014109-SC20141230042441.tar.gz", exdir = "./data/LS8")



# list tif files
LS5list <- list.files('./data/LS5', pattern = glob2rx('*.tif'), full.names = TRUE)
list.files()

LS5list
brick(LS5list)


?intersect

# Landssat 5 = (band4 - band3) / (band4 + band3)
# Landssat 8 = (band5 - band4) / (band5 + band4) 

in_LS5_B3="./data/LS5/LT51980241990098KIS00_sr_band3.tif"
in_LS5_B4="./data/LS5/LT51980241990098KIS00_sr_band4.tif"
in_LS8_B4="./data/LS8/LC81970242014109LGN00_sr_band4.tif"
in_LS8_B5="./data/LS8/LC81970242014109LGN00_sr_band5.tif"

adf <- brick(in_LS5_B3)
plot(adf)

test <- (($in_LS5_B4(float) - in_LS5_B3(float)) / (in_LS5_B4(float) - in_LS5_B3(float)))

plot(test)

outputfile <- "LS5_NDVI.tif"

gdal_calc.py -A $inputfile --A_band=4 -B $inputfile --B_band=3  --outfile=$outputfile  --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'