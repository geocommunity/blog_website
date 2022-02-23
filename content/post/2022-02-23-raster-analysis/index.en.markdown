---
title: Basic Raster Analysis with R
author: Mitch Rudge
date: '2022-02-24'
slug: []
categories:
  - spatial
  - R
  - terra
tags: []
Description: ''
Tags: []
Categories: []
DisableComments: no
---



## Basic Raster Analysis with R

**Mitch Rudge**  
PhD Candidate, UQ Sustainable Minerals Institute  
Twitter: [![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/bukotsunikki.svg?style=social&label=Follow%20%40mitchrudge)](https://twitter.com/mitchrudge)

What we will cover:

1. Raster and vector basics
2. Introducing the Terra package
3. Importing and exporting raster data
4. Dealing with coordinate reference systems
5. Raster data manipulation
6. Raster x Vector operations
7. Compatibility between Raster and Terra
8. Some applied examples
9. A fun new package called Layer! 


What you will need: Installations of R, RStudio and Terra

## 1. Raster and vector basics. 
**Rasters** divide areas into a grid of rectangles of equal size. Each rectangle holds one or more value for a variable of interest. 

**Vectors** consist of a series of coordinates, which make points, lines or polygons. 


![Raster vs vector credit: http://gsp.humboldt.edu/](http://gsp.humboldt.edu/olm/Lessons/GIS/08%20Rasters/Images/convertingdatamodels2.png)
http://gsp.humboldt.edu/


## 2 Introducing the Terra package

<img width="250" src="https://raw.githubusercontent.com/rspatial/terra/master/man/figures/logo.png">


Terra is set to replace the extremely popular Raster package. It is written by the same group of developers at [r spatial](https://github.com/rspatial), led by Robert Hijmans. This means that Terra is compatible with Raster - with some serious advantages.

**Advantages** of Terra over Raster. 
Faster. Unlike Raster, Terra is mostly written in C++, making it much faster for many operations. 

Terra is also simpler than Raster, doing away with the complex data structure of Raster, like Raster layer vs stack vs brick. We will go into this later. 

For now, lets install and load Terra. 




```r
install.packages("terra")
library(terra)
```


## 3. Creating, Importing and exporting rasters

The following is based on examples from the official manual, available at 
https://cran.r-project.org/web/packages/terra/index.html

The ` rast()` function is used to create and import SpatRasters. 

To create a SpatRaster from from scratch, 


```r
x <- terra::rast(nrows=108, ncols=21, xmin=0, xmax=10)
x
## class       : SpatRaster 
## dimensions  : 108, 21, 1  (nrow, ncol, nlyr)
## resolution  : 0.4761905, 1.666667  (x, y)
## extent      : 0, 10, -90, 90  (xmin, xmax, ymin, ymax)
## coord. ref. : lon/lat WGS 84
```

And to import a raster from a file:


```r
f <- system.file("ex/meuse.tif", package="terra") #example data within terra
basename(f)
## [1] "meuse.tif"
```

Now we can read the file with file with rast

```r
r <- rast(f)
r
## class       : SpatRaster 
## dimensions  : 115, 80, 1  (nrow, ncol, nlyr)
## resolution  : 40, 40  (x, y)
## extent      : 178400, 181600, 329400, 334000  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=sterea +lat_0=52.1561605555556 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +datum=WGS84 +units=m +no_defs 
## source      : meuse.tif 
## name        : test 
## min value   :  138 
## max value   : 1736
```


```r
plot(r)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/plot-1.png" width="480" />

To write a SpatRaster to file, we can use the the `writeRaster` function. 


```r
x <- writeRaster(r, "output.tif", overwrite=TRUE)
x
## class       : SpatRaster 
## dimensions  : 115, 80, 1  (nrow, ncol, nlyr)
## resolution  : 40, 40  (x, y)
## extent      : 178400, 181600, 329400, 334000  (xmin, xmax, ymin, ymax)
## coord. ref. : +proj=sterea +lat_0=52.1561605555556 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +datum=WGS84 +units=m +no_defs 
## source      : output.tif 
## name        : test 
## min value   :  138 
## max value   : 1736
```

## 4. Dealing with coordinate reference systems 

Angular coordinate reference systems - require a pair of coordinates and a reference datum to record a location. This datum is a model of the shape of the earth, and is required to estimate the angles of latitude and longitude. 

Common datums include WGS84. 


Projected CRS
These have converted angular coordinates to a cartesion system - which is easier to deal with in terms of making maps and calculating area etc. Planar CRS requires a projection, a datum and a set of parameters.

Projections include Mercator, UTM and Lambert. 

**Defining a CRS**

Terra recommends the use of EPSG database, as PROJ.4 is no longer fully supported. 

To look up an EPSG code, go to https://epsg.org/ and find your CRS.  

Now that you know the EPSG code, you can assign it:

```r
crs(x) <- "EPSG:27561" 
```

Be careful, this only sets the CRS, but doesn't change the underlying data. 
It is not generally recomended that you project raster data recorded in long lat, because it results in a loss of precision. 


## 5. Naming and subsetting SpatRaster layers

Naming the layers of a SpatRaster is pretty straightforward, using the `names()` function. 


```r
s <- rast(system.file("ex/logo.tif", package="terra"))
names(s)
## [1] "red"   "green" "blue"
names(s) <- c("a", "b", "c")
names(s)
## [1] "a" "b" "c"
```

Subsetting the layers of a SpatRaster is also a pretty simple operation. 

You can either use square bracket notation `[]`, the `subset()` function, or `$` notation.

From the [manual](https://cran.r-project.org/web/packages/terra/terra.pdf), here is an example using the R logo. 


```r
subset(s, 2:3) #will select band 2 and 3
#because we changed the names from red, green, blue to a, b c. 
s[[c("a", "b")]] #will also select band 2 and 3
s$a #will select the a (red) band
```

Note that, unlike with Raster, there is no need for different classes like Raster stacks/layers/bricks. 


## 6 Raster summaries

Now that we know how to import a Raster, subset it, and define its CRS, its a good time to start investigating its values.  


The `global()` function can be used to extract values like the average, mean and max cell values. Using the elevation data we have imported, we could work out the highest cell on the map with the following: 


```r

max_h <- global(r, "max", na.rm=TRUE)
max_h
##       max
## test 1736
```

The humble histogram is another useful tool when getting a handle on raster data. Terra allows you to create a frequency distribution histogram with `hist()`:


```r
hist(r)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/hist-1.png" width="480" />

Or if a boxplot is more your style, you can use `boxplot()`:


```r
boxplot(r)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/boxplot-1.png" width="480" />


## 7 Raster data manipulation

There are a huge number of functions within Terra for data manipulation. Here are a few that might be useful. 


**aggregate** and **resample**
These are used to change the resolution of a SpatRaster. 

Aggregate creates a new SpatRaster with with a lower resolution. Users need to provide the factor by which the raster will be reduced.


```r
agg <- aggregate(r, fact = 5, fun = 'mean')
plot(agg)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/aggregate-1.png" width="480" />

You can see that the resolution has been reduced; by a factor of five in this case.

Often in reality, we will need to change rasters from different sources that have different origins and resolutions. To match the resolution and origin, the aggregate function is the way to go. To demonstrate this, we can change the origin of the raster we just aggregated. 


```r
origin(agg) <- c(10.5, 10.5)
```

Then we can resample the original `r` raster to this new agg, with different resolution and a different origin. 


```r
rsm <- terra::resample(r, agg, method= 'bilinear')
```

**crop**
Cropping is one of the most widely used operations when working with Raster data. 
To demonstrate a simple crop, we will need to use a SpatVector - the other major data class used by Terra. 

On the dataset we have been working on, we will use another function: `spatSample`. Another potentially useful function. 

Here, we will randomly generate one point on the elevation raster. 


```r
samp <- spatSample(r, 1, as.points=TRUE)
```

Now we can make a buffer centered on this point using the `buffer()` function. 

```r
buf <- buffer(samp, 100)
```

Now we can crop the buffered area. 


```r
cropped <- crop(r, buf)
plot(cropped)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-7-1.png" width="480" />



**stretch**

Another function that can be required is to stretch the values to a given range. For example, classification can require data that is normalised to 8bit: 0-255. This can be handy if you want to normalise rasters on different scales, such as elevation and reflectance. 


```r
str <- stretch(r) #defaults to 0-255
```


**focal**
Another potentially useful tool is `focal()`, which can be used to clean data. Focal uses a moving window with size `w` and a function to average neighboring cells. Lets do that with the elevation dataset. 


```r
f <- focal(r, w=5, fun="mean")
plot(f)
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-8-1.png" width="480" />


## 8 Compatibility between Raster and Terra

If you are used to using `Raster`, it is not too difficult switch between Raster classes (RasterLayer, RasterStack etc) and SpatRaster using `rast()` function.

Here is an example. 

First install the Raster packages, which is available on CRAN. 


```r
install.packages("raster")
library(raster)
```
Now, using the sample data loaded into Raster, we can create a Raster stack of the r logo. 


```r
stac <- stack(system.file("ex/logo.tif", package="terra")) #This is a raster stack
rst <- rast(stac) #now this is a SpatRaster
```



## 9 A real world example with drone data

In this example, we will use some of my drone data collected from savanna woodlands in north Australia.This is a typical example where we have an orthomosaic, which was derived from a camera (RGB), and a canopy height model, which was derived from LiDAR point cloud. 


First, for the sake of this example, we need to reduce the size of the orthomosaic (1.3+GB is too big). But in reality, we might want that much resolution, depending on what we are trying to do. 



```r
orthopath <- ".../hacky_sac/2022-02-23 Basic raster analysis with R/plot1_ortho.tif"
ortho_reduced_path <- "...2022-02-23 Basic raster analysis with R/plot1_ortho_reduced.tif"
ortho <- rast(orthopath)
res(ortho) #check the resolution 

#now lets reduce it down with aggregate 

#note the filename variable lets us write directly to file
terra::aggregate(ortho, fact = 10, fun = 'mean', filename = ortho_reduced_path)
ortho_reduced <- rast(ortho_reduced_path)
res(ortho_reduced)
```


We can download the reduced orthomosaic [here](https://cloudstor.aarnet.edu.au/plus/s/wCiK6OgptZMoJku)

And the chm [here](https://cloudstor.aarnet.edu.au/plus/s/U5MUyCHYxvWxL6g)


The first thing to do is load the rasters as SpatRasters in R. 


```r
homefolder <- "C:/Users/uqmrudg1/Downloads" #where did you download the files to?
chm_path <- paste0(homefolder, "/", "plot1_chm.tif")
ortho_path <- paste0(homefolder, "/", "plot1_ortho_reduced.tif")

#now read in the files using terra
chm <- rast(chm_path)
ortho <- rast(ortho_path)
```

We will often want to merge different layers into a single raster. Before we can do this, we need to make sure the crs, resolution, origin and extent match. 


```r
#do the crs match?
crs(chm) == crs(ortho)
#do the origins match?
origin(chm) == origin(ortho)
#do the resolutions match?
res(chm) == res(ortho)
#do the extents match?
ext(chm) == ext(ortho)
```

We should see that the CRS matches, but nothing else.

We can use the `resample()` function can help to match the geometries. If we want to keep the higher resolution of the orthomosaic, we can run:


```r
chm_resampled <- resample(chm, ortho, method = "bilinear")
#now, geometry should match
res(chm_resampled) == res(ortho)
origin(chm_resampled) == origin(ortho)
ext(chm_resampled) == ext(ortho)
```

On the right track. lets plot them to have a look. 

```r
plot(chm_resampled)
```

![](images/chm_nottrimmed.PNG)


```r
plot(ortho)
```
![](images/ortho_notcropped.PNG)
We can see that even though they have the same extent - as enforced by the `resample()`, there are a lot of blank cells around the CHM. 

Lets get rid of those blank (NA) cells using the `trim()` function. 


```r
chm_resampled <- trim(chm_resampled)
plot(chm_resampled)
```
![](images/chm_resampled.PNG)

That's better, now lets crop the orthomosaic using the extent of the CHM. 


```r
ortho_cropped <- crop(ortho, chm_resampled)
```


Now the everything should match, and we can finally combine these layers into a single `SpatRaster` object. For this, you can just concatenate the layers: c(layer1, layer2, layer3). 


```r
combined <- c(ortho_cropped, chm_resampled)
plot(combined)
```
![](images/combined_1.PNG)

The band names don't make a lot of sense at this point, so we can rename them using the `names()` function. 


```r
names(combined) <- c('red', 'green', 'blue', 'chm')
```


Finally, prior to doing some analysis, we might want to stretch the chm to 8bit - so its not under-weighted compared to the RGB data. This calls for the `stretch()` function. 


```r
combined$chm <- stretch(combined$chm)
plot(combined)
```
![](images/combined_final.PNG)

Now we have a raster stack we can work with! 


## 10 A cool new package called Layer

One fun little package I stumbled on recently is called `layer`. It doesn't really serve a purpose in terms of analysis, but will be good for making figures that demonstrate the datasets used. 

<img width="250" src="https://raw.githubusercontent.com/cran/layer/8af3637e9b6dbe0b936dbac0318797991a4e9371/man/figures/logo.svg">

Unfortunately, `Layer` calls for `Raster` data, but as we already know, it's easy to convert `Raster` to `SpatRaster` objects.  

But before we get into that, lets further reduce the resolution of the `combined` `SpatRaster`, as there is a lot going on in the background of `Layer` and its pretty slow. 


```r
combined_lowres <- terra::aggregate(combined, fact = 10) #10x less rows and columns
```


```r
install.packages("layer")
install.packages("raster")
library(layer)
library(raster)
```

Now we can provide the layers to `tilt_map`, then `plot_tilted_map`, to create a nice looking tilted stack 
demonstrating our data set. Note within the tile_map function, we convert the SpatRaster to Raster with the `raster()` function. 


```r
tilt_map_1 <- tilt_map(raster(combined_lowres$red))
tilt_map_2 <- tilt_map(raster(combined_lowres$green), x_shift = 0, y_shift = 50)
tilt_map_3 <- tilt_map(raster(combined_lowres$blue), x_shift = 0, y_shift = 100)
tilt_map_4 <- tilt_map(raster(combined_lowres$chm), x_shift = 0, y_shift = 150)

map_list <- list(tilt_map_1, tilt_map_2, tilt_map_3, tilt_map_4)

plot_tiltedmaps(map_list, 
                layer = c("value", "value", "value", "value"),
                palette = c("bilbao", "mako", "rocket", "turbo"),
                color = "grey40")
```
![](images/layer_output.PNG)







