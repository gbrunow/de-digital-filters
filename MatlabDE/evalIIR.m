function mse = evalIIR(obj, candidates)
    half = obj.order + 1;
    Bs = candidates(1:half,:);
    As = candidates((half+1):end,:);
    hw = zeros(size(Bs, 2), size(obj.w, 2));
    for i=1:size(Bs,2)
        hw(i,:) = polyval(Bs(:,i), obj.z)./polyval(As(:,i), obj.z);
    end
    mse = evalResponse(obj, hw);
end