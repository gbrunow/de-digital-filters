source('filtersEvaluator.R')
source('filters.R')
source('JADE.R')
source("fast_freqz.R")

# feedback <- function(pop, score){
#   best <- pop[1:D, order(score)[1]]
#   b <- best[1:(D/2)]
#   a <- best[((D/2)+1):D]
#   r <- freqz(b,a)
#   freqz_plot(r$f, r$h)
#   #plot(r$f,abs(r$h))
# }

cutoff <- 0.5*pi
order <- 5
type <- "IIR"
D <- (order + 1)*2

eval <- filtersEvaluator(highpass, cutoff, type, samples = 512)
filter <- JADE(D, eval, NP = 150, maxASize = 150)
b <- filter[1:(D/2)]
a <- filter[((D/2)+1):D]
r <- freqz(b,a)
freqz_plot(r$f, r$h)