library(raster)

# untar lansat data
untar("./data/LT51980241990098-SC20150107121947.tar.gz", exdir = "./data/LS5")
untar("./data/LC81970242014109-SC20141230042441.tar.gz", exdir = "./data/LS8")

# tif files
in_LS5_B3="./data/LS5/LT51980241990098KIS00_sr_band3.tif"
in_LS5_B4="./data/LS5/LT51980241990098KIS00_sr_band4.tif"
in_LS8_B4="./data/LS8/LC81970242014109LGN00_sr_band4.tif"
in_LS8_B5="./data/LS8/LC81970242014109LGN00_sr_band5.tif"

# create rasters and bricks
rasterlist_LS5 <- c(raster(in_LS5_B3), raster(in_LS5_B4))
brick_LS5 <- brick(rasterlist_LS5)

rasterlist_LS8 <- c(raster(in_LS8_B4), raster(in_LS8_B5))
brick_LS8 <- brick(rasterlist_LS8)

# Landssat 5 = (band4 - band3) / (band4 + band3)
# Landssat 8 = (band5 - band4) / (band5 + band4) 
NDVI_LS5 <- ((brick_LS5[[2]] - brick_LS5[[1]]) / (brick_LS5[[2]] + brick_LS5[[1]]))
NDVI_LS8 <- (brick_LS8[[2]] - brick_LS8[[1]]) / (brick_LS8[[2]] + brick_LS8[[1]])

# define extent of both rasters
inter_extend <- intersect(NDVI_LS5,NDVI_LS8)

# crop at defined extend
NDVI_LS5_cr <- crop(NDVI_LS5, inter_extend)
NDVI_LS8_cr <- crop(NDVI_LS8, inter_extend)

# calculate difference
difference <- NDVI_LS8_cr-NDVI_LS5_cr

plot(difference)

# write output raster
writeRaster(difference, filename="./output/NDVIdifference1990-2014.tif", overwrite=TRUE)





