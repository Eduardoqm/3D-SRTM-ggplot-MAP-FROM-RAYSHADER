# 3D SRTM ggplot MAP FROM RAYSHADER
#EduardoQM

#Packages---------------------------------------------------------------------------------------------------
library(rayshader)
library(ggplot2)
library(raster)
library(rgdal)

#Load SRTM file---------------------------------------------------------------------------------------
srtm=raster("C:/Users/Documents/SRTM_BCB/SRTMGL1_003.elevation.tif")

#Load vector of park limit
bcb=readOGR(dsn = "C:/Users/Eduardo Q Marques/Documents/My Jobs/EQMapas/shapes",layer="limite_reserva_total")

#Here we will change the projection for the data to be compatible
proj=projection(srtm)
bcb_sr=spTransform(bcb,proj)

#Here we will mask with the vector
srtm2=mask(srtm,bcb_sr)

#Now let's turn the SRTM into points and then get your dataframe to plot
srtm3  <-  rasterToPoints(srtm2)
srtm4 <-  data.frame(srtm3)
colnames(srtm4) = c("lon", "lat", "alt")

#Mapping in ggplot
ggsrtm <- ggplot(srtm4, aes(lon,lat)) +
  geom_raster(aes(fill = alt)) +
  scale_fill_gradientn("Altitude (m)", colours = terrain.colors(10)) +
  labs(title = "Bacaba Park", x = "", y = "") +
  scale_x_continuous(breaks = c(-52.341, -52.35250, -52.364))

#Now let's get the coolest part of the script ... Plot in 3D! First let's write a line to see how it will look...
plot_gg(ggsrtm, preview = TRUE)

#Now we can configure the size of the window we want and finally plot our map!
plot_gg(ggsrtm, multicore = TRUE, raytrace = TRUE, 
        scale = 50, windowsize = c(900, 600), zoom = 0.6, phi = 30, theta = 30)
