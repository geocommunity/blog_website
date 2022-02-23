
library(terra)
chmpath <- "C:/Users/uqmrudg1/cloudstor/Shared/hacky_sac/2022-02-23 Basic raster analysis with R/plot1_chm.tif"
orthopath <- "C:/Users/uqmrudg1/cloudstor/Shared/hacky_sac/2022-02-23 Basic raster analysis with R/plot1_ortho.tif"
ortho_reduced_path <- "C:/Users/uqmrudg1/cloudstor/Shared/hacky_sac/2022-02-23 Basic raster analysis with R/plot1_ortho_reduced.tif"

ortho <- rast(orthopath)
res(ortho)

terra::aggregate(ortho, fact = 10, fun = 'mean', filename = ortho_reduced_path)
ortho_reduced <- rast(ortho_reduced_path)

res(ortho_reduced)
chm <- rast(chmpath)
plot(chm)

#Check they have the same CRS
crs(chm) == crs(ortho_reduced)

homefolder <- "C:/Users/uqmrudg1/Downloads"
chm_path <- paste0(homefolder, "/", "plot1_chm.tif")
ortho_path <- paste0(homefolder, "/", "plot1_ortho_reduced.tif")

chm <- rast(chm_path)
ortho <- rast(ortho_path)
#check the resolution, crs and origin
crs(chm) == crs(ortho)

origin(chm) == origin(ortho)
res(chm) == res(ortho)
#different resolution and origin, so we need to use
#the resample function to match them up. 
#we might want to use the higher res ortho, 
#so need to reduce the pixel size of the chm. 



chm_resampled <- resample(chm, ortho, method = "bilinear")
res(chm_resampled) == res(ortho)
origin(chm_resampled) == origin(ortho)

#the chm is a lot smaller than the ortho
plot(ext(ortho))
plot(ext(chm), add=TRUE)

#because we have already run the resample function
#the chm has the same extent as the ortho

#to remove the NAs around the CHM, we can ues the trim()
#function

chm_resampled <- terra::trim(chm_resampled)

#so lets crop the ortho using the extent of the 
#chm. 
ortho_cropped <- crop(ortho, ext(chm_resampled))
ext(ortho_cropped) == ext(chm_resampled)

#now they have the same extent, resolution, crs, 
#and origin. We can stack them as one raster. 

#now we can include them in the same SpatRaster object! 
combined <- c(ortho_cropped, chm_resampled)
plot(combined)

#lets rename the bands! 
names(combined) <- c('red', 'green', 'blue', 'chm')

#and stretch the height values of the chm to 
#8bit, which might be useful down the track
combined$chm <- stretch(combined$chm)

#a cool new package called layer 

install.packages("layer")
library(layer)

#because the process is slow, we will reduce the resolution further 
#with terra::aggregate

combined_lowres <- terra::aggregate(combined, fact = 5) #target / current res gives you factor

tilt_map_1 <- tilt_map(raster(combined_lowres$red))
tilt_map_2 <- tilt_map(raster(combined_lowres$green), x_shift = 0, y_shift = 50)
tilt_map_3 <- tilt_map(raster(combined_lowres$blue), x_shift = 0, y_shift = 100)
tilt_map_4 <- tilt_map(raster(combined_lowres$chm), x_shift = 0, y_shift = 150)

map_list <- list(tilt_map_1, tilt_map_2, tilt_map_3, tilt_map_4)

plot_tiltedmaps(map_list, 
                layer = c("value", "value", "value", "value"),
                palette = c("bilbao", "mako", "rocket", "turbo"),
                color = "grey40")



















