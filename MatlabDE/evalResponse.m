function mse = evalResponse(obj, hw)
    mse = zeros(1,size(hw,1));
    for i=1:size(hw,1)
        ew = abs(obj.dw - hw(i,:));
        mse(i) = mean(ew.^2);
    end
end