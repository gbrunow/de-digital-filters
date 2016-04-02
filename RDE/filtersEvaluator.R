filtersEvaluator <- function(filterFunction, cutoff, type = "IIR", samples = 512){
  library('Metrics')
  library('signal')
  
  w <- seq(0, pi, pi/(samples-1))
  dw <- filterFunction(w, cutoff)
  # z <- exp(-1i*w);
  
  if(type == "IIR"){
    
    function(filters){
      if(is.null(dim(filters))){
        filters = matrix(filters, nrow = 1)
      }
      
      end <- dim(filters)[1]
      half <-  end/2
      size <- dim(filters)[2]
      ews <-  vector(mode = "numeric", length = size)
      
      for(i in 1:size){
        b <- filters[1:half, i]
        a <- filters[(half+1):end, i]
        hw <-  freqz(b,a, n = samples)
        # h <- polyval(b, z)/polyval(a, z)
        if(anyNA(hw$h)){
          hw$h[is.nan(hw$h)] <- Inf
        }
        ews[i] <- mse(dw,abs(hw$h))
      }
      ews
    }
    
  } else if(type == "FIR"){
    
    if(is.null(dim(filters))){
      filters = matrix(filters, nrow = 1)
    }
    
    end <- dim(filters)[1]
    half <-  end/2
    size <- dim(filters)[2]
    ews <-  vector(mode = "numeric", length = size)
    
    for(i in 1:size){
      hw <-  freqz(filters[1:end,1], n = samples)
      ews[i] <- mse(dw,hw$h)
    }
     
  } else {
    print("Invalid filter type.")
  }
  
}