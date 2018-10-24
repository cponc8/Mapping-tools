plotmap <- function(bckgnd,vct,bckgnd_pal="topo.colors",nCols=20,breaks=NULL,resize="To_vct"){

##--------------------------------------------------------------------------------  
  # plotmap <- function(bckgnd,vct,bckgnd_pal="terrain.colors",nCols=20,breaks=NULL,resize="To_vct")
  # A function for plotting geographical data.
  #
  #   INPUTS:
  #       bckgnd                    - The raster layer to display as background 
  #       vct   	 	                - The vector layer to display as foreground
  #       bckgnd_pal (optional)     - The color palette to use for background displaying.
  #			 	                            Can be either user-defined or one of R's default 
  #			 	                            (e.g.: rainbow, heat.colors, topo.colors, terrain.colors). 
  #                                   Default to terrain.colors.
  #       nCols (optional)          - The number of colors to use for the background.
  #			 	                            This setting will be ignored if breaks are provided. 
  #                                   Default to 20.
  #       breaks (optional)         - A set of finite numeric breakpoints for the colours
  #                                   (used by the image function).
  #       resize (optional)         - Level of zooming for the output figure. Must be one of: 
  #				                            NULL: no zooming performed, "To_vct": crop the 
  #                                   background to the vector extent or "To_bckgnd": crop 
  #                                   the vector to the background extent. Default to "To_vct".
  #
  #   OUTPUTS:
  #       A figure displaying the vector layer on top of the raster layer
  #
  ## Exemple :
  # see README.md
  #
  #   Revision: 0.0 Date: 2018/10/24 Carine Poncelet
  #           original function
##--------------------------------------------------------------------------------
  
  
  ## Prepare data
  if( resize == "To_bckgnd" ){
    ext <- extent(bckgnd)
    vct <- crop (vct,ext, snap="out")
  }
  if( resize == "To_vct" ){
    ext <- extent(vct)
    bckgnd <- crop (bckgnd,ext, snap="out")
  }
  
  ## Define breaks for background
  if( is.null(breaks) ){
    Vals <- values(bckgnd) # as vector to speed up
    breaks <- c(min(Vals,na.rm=TRUE)-0.01*mean(Vals,na.rm=TRUE),
                quantile(Vals,probs=seq(0.01,0.99,length.out=nCols-1)), 
                max(Vals,na.rm=TRUE)+0.01*mean(Vals,na.rm=TRUE) )
  }
  if( !is.null(breaks) ){
    nCols <- length(breaks) - 1
  }
  
  ## Define color for background
  if( length(bckgnd_pal)==1 ){
    bckgnd_pal <- eval(parse(text=sprintf("%s(%s)",bckgnd_pal,nCols)))
  }
  
  ## Display layers
  par( mar=c(2,2,2,2) )
  plot( ext,type="n",xlab=NA,ylab=NA,xaxs="i",yaxs="i",xaxt="n",yaxt="n" )
  image( bckgnd,col=bckgnd_pal,breaks=breaks,add=TRUE )   
  lines( vct,col="black",lwd=1 )
}
