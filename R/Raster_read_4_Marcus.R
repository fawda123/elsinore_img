# Raster_read_4_Marcus.R
#   Read georegistered tiff with 4 bands
#   Plot RGB image and CHL samples

proj.dir <- "C:/Users/NikolayN/Documents/Projects/2017/Lake_Elsinore" # This is my directory!!!

gtiff.dir <- "GeoTiff_08_21"
CHL.fn <- "CHL_2017_08_21.csv"
# gtiff.dir <- "GeoTiff_09_06"
# CHL.fn <- "CHL_2017_09_06.csv"
#
# work with raster data
library(raster)
# export GeoTIFFs and other core GIS functions
library(rgdal)
#
giff.fn.list <- list.files( file.path( proj.dir, gtiff.dir ) )
fn_gtiff <- select.list( giff.fn.list )
#
RGB_stack <- stack( file.path( proj.dir, gtiff.dir, fn_gtiff ) );
# Read the CHL samples coordinates
CHL.coords <- read.csv( file.path(proj.dir,CHL.fn), header = FALSE, 
                        stringsAsFactors = FALSE )
names( CHL.coords ) <- c("N","Lat","Lon","CHL")
# Transform CHL coordinates to UTM
coordinates( CHL.coords ) <- ~Lon+Lat
proj4string( CHL.coords ) <- "+proj=longlat +datum=WGS84"
# CHL.coords.utm <- spTransform( CHL.coords, proj4string( RGB_stack ) ) # Results in wrong UTM!!!!!
#     Should be "+zone=11s" instead of "+zone=11 +south"
CHL.coords.utm <- spTransform( CHL.coords, CRS("+proj=utm +zone=11s +datum=WGS84") ) 
#
windows()
par( mar = c(5,7,3,3))
plotRGB( RGB_stack, r = 4, g = 3, b = 1, axes=TRUE, stretch = "lin", asp = 1 )
points( coordinates(CHL.coords.utm)[,"Lon"], coordinates(CHL.coords.utm)[,"Lat"], pch = 21, 
        bg = "red" )
points( coordinates(CHL.coords.utm)[,"Lon"], coordinates(CHL.coords.utm)[,"Lat"], pch = 1, 
        col = "red", cex = 2 )
mtext( side = 1, "UTM easting in meters", cex = 1.5, line = 3 )
mtext( side = 2, "UTM northing in meters", cex = 1.5, line = 5 )
# 
## To extract values from raster - see http://neondataskills.org/R/extract-raster-data-R/




