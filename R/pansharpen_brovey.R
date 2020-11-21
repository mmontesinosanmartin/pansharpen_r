# see more info at: http://www.saga-gis.org/saga_tool_doc/2.2.1/imagery_tools_5.html
pansharpen_brovey <- function(saga.path,
                              ms.img,
                              pan.img,
                              r = 1, g = 2, b = 3,
                              resampling = "cubic",
                              overwrite = TRUE,
                              verbose = FALSE)
{
  # translate to SAGA
  tmp.dir <- file.path(getwd(),"tmp")
  dir.create(tmp.dir)
  tmp.ms <- file.path(tmp.dir, "tmp_ms.sdat")
  tmp.pan <- file.path(tmp.dir, "tmp_pan.sdat")
  writeRaster(ms.img[[c(r,g,b)]], tmp.ms, bylayer = TRUE, overwrite = TRUE)
  writeRaster(pan.img, tmp.pan, bylayer = TRUE, overwrite = TRUE)
  red.in <- list.files(tmp.dir, pattern = paste0("*.ms_", r, ".sgrd"), full.names = TRUE)
  green.in <- list.files(tmp.dir, pattern =  paste0("*.ms_", g, ".sgrd"), full.names = TRUE)
  blue.in <- list.files(tmp.dir, pattern =  paste0("*.ms_", b, ".sgrd"), full.names = TRUE)
  pan.in <- list.files(tmp.dir, pattern = "pan.sgrd", full.names = TRUE)
  
  # parameters
  resampling <- switch(
    resampling,
    "ngb" = 0,
    "bilinear" = 1,
    "cubic" = 2,
  )

  # temporary output
  red.out <- file.path(tmp.dir, "sharpened_red.sgrd")
  green.out <- file.path(tmp.dir, "sharpened_green.sgrd")
  blue.out <- file.path(tmp.dir, "sharpened_blue.sgrd")
  all.out <- file.path(tmp.dir, "sharpened_all.sgrd")
  
  # run seeding
  system(paste0(
    saga.path,
    ' -f= ',  'imagery_tools 5 ',
    ' -R ', red.in,
    ' -G ', green.in,
    ' -B ', blue.in,
    ' -PAN ', pan.in,
    ' -R_SHARP ', red.out,
    ' -G_SHARP ', green.out,
    ' -B_SHARP ', blue.out,
    ' -SHARPEN ', all.out,
    ' -RESAMPLING ', resampling
  ), show.output.on.console = verbose)
  
  # output
  out.file <- list(red.out, green.out, blue.out)
  out.file <- lapply(out.file, function(x)gsub("sgrd", "sdat", x))
  out <- readAll(stack(lapply(out.file, raster)))
  names(out) <- paste0(names(ms.img[[c(r,g,b)]]), "_pan")
  crs(out) <- crs(ms.img)
  unlink(tmp.dir, recursive = TRUE)
  return(out)
}
