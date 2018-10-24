check_epsg <- function(x,y, reproject=1, epsgref=NULL ){
##--------------------------------------------------------------------------------  
  # plotmap <- function(bckgnd,vct,bckgnd_pal="terrain.colors",nCols=20,breaks=NULL,resize="To_vct")
  # A function for plotting geographical data.
  #
  #   INPUTS:
  #       x                        - Raster* or Spatial object
  #       y   	 	                 - Raster* or Spatial object
  #       reproject (optional)     - Numeric. Reproject the layers to a common projection
  #                                  system. 1: reproject the layers, 0: do not reproject.
  #                                  Default to 1.
  #       epsgref (optional)       - CRS object or a character string describing a projection
  #                                  and datum in the PROJ.4 format. The projection system the
  #                                  x and y should be reprojected to. Default to NULL, the
  #                                  epsg of the heaviest layer will be kept.
  #   OUTPUTS:
  #       A list containing the reprojected layers and the common projection system.
  #
  ## Exemple :
  # see README.md
  #
  #   Revision: 0.0 Date: 2018/10/24 Carine Poncelet
  #           original function
##--------------------------------------------------------------------------------
  
  ## Retrieve epsg from input layers
  epsg_x <- crs(x,asText=TRUE)
  epsg_y <- crs(y,asText=TRUE)
  Equal_epsg <- ifelse(epsg_x==epsg_y,TRUE,FALSE)
  
  ## Exit if epsg are not defined
  if( is.na(epsg_x) | is.na(epsg_x) ){
    stop( "Input layers projection system(s) not defined", "\n", "Please provide crs() to layer(s)", "\n" )
  }
  
  ## Display messages
  if( Equal_epsg ){
    cat( "The layers are in the same projection system", "\n" )
  }
  if( !Equal_epsg ){
    cat( "The layers are not in the same projection system", "\n" )
  }
  
  ## Prepare for export
  if( reproject == 0 | Equal_epsg ){
    reproj_x <- x
    reproj_y <- y
    epsgref <- crs(x,asText=TRUE)
  }
  
  ## Reproject layers if needed
  if( reproject==1 & !Equal_epsg ){
    
    cat( "Reprojecting layers...", "\n" )
    
    ## Characterize input layers
    is_rst <- c( ifelse( class(x) %in% c("RasterLayer"),TRUE,FALSE ),
                 ifelse( class(y) %in% c("RasterLayer"),TRUE,FALSE ) )
    names(is_rst) <- c("x","y")
    
    
    ## Identify heavy layers (speed up reprojection)
    if( is.null(epsgref) & all(is_rst)==1 ){
      size_lyr <- rbind( dim(x) , dim(y) )
      id_heavy_lyr <- which.max( apply(size_lyr,1,function(z) prod(z)) )
      heavy_lyr <- c("x","y")[id_heavy_lyr]
      epsgref <- crs( eval((parse(text=heavy_lyr))),asText=TRUE )
    }
    if( is.null(epsgref) & sum(is_rst)==1 ){
      heavy_lyr <- c("x","y")[is_rst]
      epsgref <- crs( eval((parse(text=heavy_lyr))),asText=TRUE )
    }
    if( is.null(epsgref) & sum(is_rst)==0 ){
      size_lyr <- rbind( dim(x) , dim(y) )
      id_heavy_lyr <- which.max( apply(size_lyr,1,function(z) prod(z)) )
      epsgref <- crs( eval((parse(text=heavy_lyr))),asText=TRUE )
    }
    if( !is.null(epsgref)){
      epsgref <- as.character(epsgref)
    }
    
    ## Reproject raster(s)
    if( is_rst["x"] & crs(x,asText=TRUE)!=epsgref ){
      projext <- SpatialPoints( rbind(c(extent(x)@xmin,extent(x)@ymin),c(extent(x)@xmax,extent(x)@ymax)),
                     proj4string=crs(x), bbox = NULL )
      projext <- spTransform( projext,epsgref )
      
      reproj_x <- raster( projext,nrows=x@nrows, ncols=x@ncols )
      reproj_x [ ] <- as.matrix(x)
    }
    if( is_rst["x"] & crs(x,asText=TRUE)==epsgref ){
      reproj_x <- x
    }
    
    if( is_rst["y"] & crs(y,asText=TRUE)!=epsgref ){
      projext <- SpatialPoints( rbind(c(extent(y)@xmin,extent(y)@ymin),c(extent(y)@xmax,extent(y)@ymax)),
                                proj4string=crs(y), bbox = NULL )
      projext <- spTransform( projext,epsgref )
      
      reproj_y <- raster( projext,nrows=y@nrows, ncols=y@ncols )
      reproj_y [ ] <- as.matrix(y)
    }
    if( is_rst["y"] & crs(y,asText=TRUE)==epsgref ){
      reproj_y <- y
    }
    ## Reproject vector(s)
    if( !is_rst["x"] & crs(x,asText=TRUE)!=epsgref ){
      reproj_x <- spTransform( x,epsgref )
    }
    if( !is_rst["x"] & crs(x,asText=TRUE)==epsgref ){
      reproj_x <- x
    }
    if( !is_rst["y"] & crs(y,asText=TRUE)!=epsgref ){
      reproj_y <- spTransform( y,epsgref )
    }
    if( !is_rst["y"] & crs(y,asText=TRUE)==epsgref ){
      reproj_y <- y
    }
  }

  ## Return reprojected layers
  result <- list(x=reproj_x,y=reproj_y,Common_epsg=epsgref)
  return(result)
}
