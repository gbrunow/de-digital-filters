filtersEvaluator <- function(filterFunction, cutoff, type = "IIR", samples = 512){
  #source('filters.R')
  
  w <- seq(0, pi, pi/(samples-1))
  dw <- filterFunction(w, cutoff)
  
  if(type == "IIR"){
    
    function(filters){
      if(is.null(dim(filters))){
        filters = matrix(filters, nrow = 1)
      }
      
      end <- dim(filters)[2]
      half <-  end/2
      size <- dim(filters)[1]
      ews <-  vector(mode = "numeric", length = size)
      
      for(i in 1:size){
        b <- filters[i, 1:half]
        a <- filters[i, (half+1):end]
        hw <-  freqz(b,a, n = samples)
        ews[i] <- mse(dw,abs(hw$h))
      }
      ews
    }
    
  } else if(type == "FIR"){
    
    if(is.null(dim(filters))){
      filters = matrix(filters, nrow = 1)
    }
    
    end <- dim(filters)[2]
    half <-  end/2
    size <- dim(filters)[1]
    ews <-  vector(mode = "numeric", length = size)
    
    for(i in 1:size){
      hw <-  freqz(filters[i,1:end], n = samples)
      ews[i] <- mse(dw,hw$h)
    }
     
  } else {
    print("Invalid filter type.")
  }
  
}