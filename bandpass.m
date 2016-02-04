function [ h ] = bandpass( w, cutoff )

    h = zeros(size(w));
    h(w < cutoff(1)) = 0;
    h(w >= cutoff(1)) = 1;
    h(w > cutoff(2)) = 0;

end

