function pop = diversifier( pop, popOld, g, n, D, alpha, d, zeta )
    threshold = alpha * ((n-g)/g)^zeta;
    restore = abs(sum(pop, 1) - sum(popOld, 1)) < threshold;
    pop(1:D, restore) = popOld(1:D, restore);
end

