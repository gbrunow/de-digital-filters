function [ h ] = lowpass( w, cutoff )
    
    h = zeros(size(w));
    h(w < cutoff) = 1;
    h(w >= cutoff) = 0;

end

