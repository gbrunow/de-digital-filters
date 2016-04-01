function restore = diversifier( mutation, g, n, D, alpha, d, zeta )
    threshold = alpha * d * ((n-g)/g)^zeta;
    restore = abs(mutation) < threshold;
end

