ndviFilt <- function(x,y) {
	x[y > 0.9] <- NA
	x[x >1] <- NA
	x[x <-1] <- NA
	return(x)
}