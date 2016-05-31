function [ m ] = meanlw( items, weights )
% Weighted Lehmer Mean
    m = sum(weights .* (items.^2))/sum(weights .* items);
end

