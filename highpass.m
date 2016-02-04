function [ h ] = highpass( w, cutoff )
    
    h = zeros(size(w));
    h(w < cutoff) = 0;
    h(w >= cutoff) = 1;

end

