# Mapping-tools

## Overview
This project aims at gathering some usefull tools to work with GIS whithin R.

## Prerequisites
* R programming language
* R packages 'raster', 'rgdal' and 'rgeos'

## Content
*	**check_epsg.R**: a function to check if two geographical layers are in the same projection system (and reproject them if needed)
*	**plotmap.R**: a fonction to display a vector layer on top of a raster layer
* **Map.pdf**: An exemple of a map of France produced using the check_epsg and plotmap functions (see working example below)

## Working example
```R
## Load R libraries
library( raster )
library( rgdal )
library( rgeos )

## Set-up project
setwd( "/path/to/myMaps/" )
source( "./check_epsg.R" )
source( "./plotmap.R" )

## Import raster layer (= background)
mnt <- raster( "./my_background.tif" )
## Import vector layer
dpt <- readOGR( dsn="./",layer="my_boundaries" )

## Reproject data if needed
reprojXY <- check_epsg( x=mnt,y=dpt )
mnt <- reprojXY$x
dpt <- reprojXY$y

## plotmap function options (Optionnal)
TabCol <- c( "#71ABD8","#6AD055", "#63BF4E", "#88C651", "#ACCC54", "#C6D758", "#DEE45E", "#EFE162", "#E8D65F", "#DECB5B", "#D3BF57", "#CAAC53", "#C39D50", "#B9934C", "#AA8046", "#AC8547", "#BA904C", "#CA9B53", "#E0E0DE", "#F5F4F2")
TabBreaks <- c(-10^9,0,20,100,150,200,300,400,500,600,700,800,1000,1200,1400,1600,1800,2000,2500,3000,10^5)

## Create output map
plotmap( bckgnd=mnt,vct=dpt,breaks=TabBreaks,bckgnd_pal=TabCol )
```
