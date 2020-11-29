library(tmap)
library(raster)
library(sf)
library(grid)
# load
pan.file <- "./Data/small_sample/pan_example.tif"
pan.img <- raster(pan.file)
# show
img <- tm_shape(stretch(pan.img,0,1, minq = 0.01, maxq = 0.99)) +
  tm_raster(
    style = "cont",
    title = "PAN",
    palette = grey.colors(1e3),
    contrast = c(0.,1)) +
  tm_scale_bar(position = c("right","bottom"),text.size = 1) + 
  tm_compass(position = c("right", "top"), text.size = 1) + 
  tm_graticules(n.x = 3, n.y = 3, alpha = 0, labels.size = 1, labels.rot = c(0,90))

# sider map
data("World")
sp.coo <- c(xmin = -10.046637, xmax = 5.097831, ymin = 34.99346, ymax = 44.63523)
sp <- st_sf(st_as_sfc(st_bbox(c(sp.coo)), crs = 4326))
pm <- st_sfc(st_point(c(-1.649321,42.81207)), crs = 4326)
spn.map <- tm_shape(World, bbox = sp) +
  tm_polygons() +
  tm_shape(pm) +
  tm_dots(size = 0.3, col = "red") 

# print
wdir <- "./img"
out.file <- file.path(wdir, "pan.png")
png(out.file, height = 450, width = 550)
img
print(spn.map, vp = viewport(x = 0.16, y = 0.2, width = 0.2, height = 0.2))
dev.off()


ms.file <- "./Data/small_sample/ms_example.tif"
ms.img <- stack(ms.file)
# show
img <- tm_shape(stretch(ms.img, minq = 0.01, maxq = 0.99)) +
  tm_rgb() +
  tm_scale_bar(position = c("right","bottom"),text.size = 1) + 
  tm_compass(position = c("right", "top"), text.size = 1) + 
  tm_graticules(n.x = 3, n.y = 3, alpha = 0, labels.size = 1, labels.rot = c(0,90))

# sider map
data("World")
sp.coo <- c(xmin = -10.046637, xmax = 5.097831, ymin = 34.99346, ymax = 44.63523)
sp <- st_sf(st_as_sfc(st_bbox(c(sp.coo)), crs = 4326))
pm <- st_sfc(st_point(c(-1.649321,42.81207)), crs = 4326)
spn.map <- tm_shape(World, bbox = sp) +
  tm_polygons() +
  tm_shape(pm) +
  tm_dots(size = 0.3, col = "red") 

# print
wdir <- "./img"
out.file <- file.path(wdir, "ms.png")
png(out.file, height = 450, width = 550)
img
print(spn.map, vp = viewport(x = 0.16, y = 0.2, width = 0.2, height = 0.2))
dev.off()
