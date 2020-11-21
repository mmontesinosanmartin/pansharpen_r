# see more info at: http://www.saga-gis.org/saga_tool_doc/2.2.1/imagery_tools_7.html
pansharpen_pca <- function(saga.path,
                           ms.img,
                           pan.img,
                           method = "ssq",
                           resampling = "cubic",
                           pan.match = "standardized",
                           overwrite = TRUE,
                           verbose = FALSE)
{
  # translate to SAGA
  tmp.dir <- file.path(getwd(),"tmp")
  dir.create(tmp.dir)
  tmp.ms <- file.path(tmp.dir, "tmp_ms.sdat")
  tmp.pan <- file.path(tmp.dir, "tmp_pan.sdat")
  writeRaster(ms.img, tmp.ms, bylayer = TRUE, overwrite = TRUE)
  writeRaster(pan.img, tmp.pan, bylayer = TRUE, overwrite = TRUE)
  ms.in <- list.files(tmp.dir, pattern = "ms.*.sgrd", full.names = TRUE)
  pan.in <- list.files(tmp.dir, pattern = "pan.*.sgrd", full.names = TRUE)
  
  # parameters
  method <- switch(
    method,
    "cor" = 0,
    "vcov" = 1,
    "ssq" = 2)
  resampling <- switch(
    resampling,
    "ngb" = 0,
    "bilinear" = 1,
    "cubic" = 2,
  )
  pan.match <- switch(
    pan.match,
    "normalized" = 0,
    "standardized" = 1,
  )
  overwrite <- as.numeric(overwrite)

  # temporary output
  out.tmp <- file.path(tmp.dir, paste0("sharpened_",1:nlayers(ms.img),".sgrd"))

  # run seeding
  system(paste0(
    saga.path,
    ' -f= ',  ' imagery_tools 7 ',
    ' -GRIDS ', paste(ms.in, collapse = ";"),
    ' -PAN ', pan.in,
    ' -SHARPEN ', paste(out.tmp, collapse = ";"),
    ' -METHOD ', method,
    ' -RESAMPLING ', resampling,
    ' -PAN_MATCH ', pan.match,
    ' -OVERWRITE ', overwrite
  ), show.output.on.console = verbose)
  
  # output
  out.file <- gsub("sgrd", "sdat", out.tmp)
  out <- readAll(stack(lapply(out.file, raster)))
  names(out) <- paste0(names(ms.img), "_pan")
  crs(out) <- crs(ms.img)
  unlink(tmp.dir, recursive = TRUE)
  return(out)
}