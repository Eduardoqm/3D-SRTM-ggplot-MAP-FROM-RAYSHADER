**### 3D SRTM ggplot MAP FROM RAYSHADER**

> I created this script to plot SRTM maps of ggplot in 3D. But it can be used to plot various graphs made in ggplot that have units of values. The result is beautiful and cool! The example map is from a small park in Brazil.

**Packages**
```
library(rayshader)
library(ggplot2)
library(raster)
library(rgdal)
```

Load SRTM file and vector of park limit 

`srtm=raster("C:/Users/Documents/SRTM_BCB/SRTMGL1_003.elevation.tif")`
![srtm](https://user-images.githubusercontent.com/24628679/60932895-62ecf000-a296-11e9-8b4d-545985efbbed.jpeg)


`bcb=readOGR(dsn = "C:/Users/Eduardo Q Marques/Documents/My Jobs/EQMapas/shapes",layer="limite_reserva_total")`

![bcb](https://user-images.githubusercontent.com/24628679/60932833-21f4db80-a296-11e9-9252-641df8999f8e.jpeg)

Here we will change the projection for the data to be compatible

```
proj=projection(srtm) 
bcb_sr=spTransform(bcb,proj)
```

Here we will mask with the vector

`srtm2=mask(srtm,bcb_sr)
`

Now let's turn the SRTM into points and then get your dataframe to plot

```
srtm3 <- rasterToPoints(srtm2)
srtm4 <- data.frame(srtm3)
colnames(srtm4) = c("lon", "lat", "alt")
```

Mapping in ggplot

```
ggsrtm <- ggplot(srtm4, aes(lon,lat)) +
geom_raster(aes(fill = alt)) +
scale_fill_gradientn("Altitude (m)", colours = terrain.colors(10)) +
labs(title = "Bacaba Park", x = "", y = "") +
scale_x_continuous(breaks = c(-52.341, -52.35250, -52.364))
```

Now let's get the coolest part of the script ... Plot in 3D! First let's write a line to see how it will look... 

`plot_gg(ggsrtm, preview = TRUE)`
![bacaba](https://user-images.githubusercontent.com/24628679/60932922-89129000-a296-11e9-9067-60480387cf37.jpeg)


Now we can configure the size of the window we want and finally plot our map!

`plot_gg(ggsrtm, multicore = TRUE, raytrace = TRUE, scale = 50, windowsize = c(900, 600), zoom = 0.6, phi = 30, theta = 30)`

![bacba3](https://user-images.githubusercontent.com/24628679/60932969-c37c2d00-a296-11e9-9ee6-4743582d578c.jpg)

