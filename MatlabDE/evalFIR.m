function mse = evalFIR(obj, candidates)
    Bs = candidates;
    hw = zeros(size(Bs, 2), size(obj.w, 2));
    for i=1:size(Bs,2)
        hw(i,:) = polyval(Bs(:,i), obj.z);
    end
    mse = evalResponse(obj, hw);
end