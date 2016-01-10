# Student: William Schuch & Rik van Berkum
# Team: Geodetic Engineers of Utrecht
# Student#: 901120-751-050 & 931112-059-020
# Institute: Wageningen University and Research
# Course: Geo-scripting (GRS-33806)
# Date: 2016-01-08
# Week 1, Lesson 5: Intro to raster

ndviCalc <- function(x) {
	# calculates NDVI
	ndvi <- (x[[2]] - x[[1]]) / (x[[2]] + x[[1]])
	return(ndvi)
}