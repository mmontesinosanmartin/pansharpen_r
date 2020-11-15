compare_vis <- function(...,
                        titles,
                        minq = 0.01,
                        maxq = 0.99,
                        lyout = c(1,2)){
  
  # interactive mode
  tmap_mode("view")
  # pick basemap
  map.base <- tm_basemap("OpenStreetMap")
  # images
  imgs <- list(...)
  nimg <- length(imgs)
                    
  # maps
  maps <- lapply(1:nimg,
    function(i, imgs, minq, maxq, map.base, titles){
      # visual appearance
      img.show <- stretch(imgs[[i]],
                          minv = 0,
                          maxv = 1,
                          minq = minq,
                          maxq = maxq)
      # map construction
      map.base + 
      tm_shape(img.show) +
      tm_rgb(max.value = 1) +
      tm_legend(title = titles[i])
    },
    imgs = imgs,
    minq = minq,
    maxq = maxq,
    map.base = map.base,
    titles = titles
  )
  
  # Map
  tmap_arrange(maps,
               nrow=lyout[1], 
               ncol=lyout[2], 
               sync = TRUE)
}

