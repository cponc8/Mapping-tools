# Mapping-tools

## Overview
This project aims at gathering some usefull tools to work with GIS whithin R.

## Prerequisites
* R programming language
* R packages 'raster' and 'rgdal'

## Working example
```R
## Load R libraries
library(raster)
library(rgdal)

## Import specific functions
source("PathTo/check_epsg.R")

## Import data
x <- raster("PathTo/myRaster.tif") # could also be a vector layer
y <- readOGR(dsn="PathTo",layer="myVector") # could also be a raster layer

## Reproject data if needed
reprojXY <- check_epsg(x,y)
x <- reprojXY$x
y <- reprojXY$y
```
