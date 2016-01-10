# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Student#: 901120-751-050 & 931112-059-020
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-08
# Week 1, Lesson 5: Intro to raster

ndviFilt <- function(x,y) {
	# Filters out: clear water pixel, cloud shadow, snow and cloud 
	x[y > 0.9] <- NA
	# Filters out: NDVI outliers 
	x[x >1] <- NA
	x[x <-1] <- NA
	return(x)
}