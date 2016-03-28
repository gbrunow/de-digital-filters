function mse = evalIIR(obj, candidates)
    half = obj.order + 1;
    b = candidates(1:half,:);
    a = candidates((half+1):end,:);
    hw = zeros(size(b, 2), size(obj.w, 2));
    for i=1:size(b,2)
        hw(i,:) = polyval(b(:,i), obj.z)./polyval(a(:,i), obj.z);
    end
    mse = evalResponse(obj, abs(hw));
end