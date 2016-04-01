function mse = evalFIR(obj, candidates)
    b = candidates;
    h = zeros(size(b, 2), size(obj.w, 2));
    for i=1:size(b,2)
        h(i,:) = polyval(b(:,i), obj.z);
    end
    mse = evalResponse(obj, h);
end