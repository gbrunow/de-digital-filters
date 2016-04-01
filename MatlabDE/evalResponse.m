function mse = evalResponse(obj, h)
    mse = zeros(1,size(h,1));
    for i=1:size(h,1)
        e = abs(obj.dw - h(i,:));
        mse(i) = mean(e.^2);
    end
end