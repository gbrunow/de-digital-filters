function [ m ] = meanw( items, weights )
% Weighted Mean
    m = sum(weights .* items);
end

