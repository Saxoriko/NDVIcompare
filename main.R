# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Student#: 901120-751-050 & 931112-059-020
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-08
# Week 1, Lesson 5: Intro to raster

rm(list = ls())  # Clear the workspace!
ls() ## no objects left in the workspace

source("R/ndviCalc.R")
source("R/ndviFilt.R")

# load the libraries
library(raster)

# untar lansat data
untar("./data/LT51980241990098-SC20150107121947.tar.gz", exdir = "./data/LS5")
untar("./data/LC81970242014109-SC20141230042441.tar.gz", exdir = "./data/LS8")

# storing tif file paths
in_LS5_B3="./data/LS5/LT51980241990098KIS00_sr_band3.tif"
in_LS5_B4="./data/LS5/LT51980241990098KIS00_sr_band4.tif"
in_LS8_B4="./data/LS8/LC81970242014109LGN00_sr_band4.tif"
in_LS8_B5="./data/LS8/LC81970242014109LGN00_sr_band5.tif"
in_cloud_LS5 <- "./data/LS5/LT51980241990098KIS00_cfmask.tif"
in_cloud_LS8 <- "./data/LS8/LC81970242014109LGN00_cfmask.tif"

# create rasters and bricks
rasterlist_LS5 <- c(raster(in_LS5_B3), raster(in_LS5_B4), raster(in_cloud_LS5))
stack_LS5 <- stack(rasterlist_LS5)

rasterlist_LS8 <- c(raster(in_LS8_B4), raster(in_LS8_B5), raster(in_cloud_LS8))
stack_LS8 <- stack(rasterlist_LS8)

# define extent of both rasters
inter_extend <- intersect(stack_LS5,stack_LS8)

# crop at defined extend
LS5_cr <- crop(stack_LS5, inter_extend)
LS8_cr <- crop(stack_LS8, inter_extend)

# Calculate Normalised Differentation Vegetation Index (NDVI)
# Landssat 5 = (band4 - band3) / (band4 + band3)
# Landssat 8 = (band5 - band4) / (band5 + band4) 

# Define the function to calculate NDVI from 
NDVI_LS5_f <- calc(x=LS5_cr, fun=ndviCalc)
NDVI_LS8_f <- calc(x=LS8_cr, fun=ndviCalc)

# Filter out clear water pixel, cloud shadow, snow and cloud 
NDVI_LS5_f3 <- overlay(x=NDVI_LS5_f, y=LS5_cr[[3]], fun=ndviFilt)
NDVI_LS8_f3 <- overlay(x=NDVI_LS8_f, y=LS8_cr[[3]], fun=ndviFilt)

# calculate difference
difference <- abs(NDVI_LS5_f3-NDVI_LS8_f3)

# show the differences
plot(difference, col = gray.colors(20, start = 0.0, end = 0.9, gamma = 2.2, alpha = NULL))

# write output raster
writeRaster(difference, filename="./output/NDVI_difference_1990-2014.tif", format="GTiff", overwrite=TRUE)

# reprojecting and witing to output
ndviLL5 <- projectRaster(NDVI_LS5_f3, crs='+proj=longlat')
ndviLL8 <- projectRaster(NDVI_LS8_f3, crs='+proj=longlat')
diffLL <- projectRaster(difference, crs='+proj=longlat')

KML(x=ndviLL5, filename='./output/betuwe_NDVI_1990.kml')
KML(x=ndviLL8, filename='./output/betuwe_NDVI_2014.kml')
KML(x=diffLL, filename='./output/NDVI_difference_1990-2014.kml')