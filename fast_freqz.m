function [ h, w ] = fast_freqz( filters, args )
    
    if nargin < 2 || ~iscell(args) || size(args, 2) < 2
        disp('Not enough or invalid arguments.');
        return;
    end
    
    type = args{1};
    freq = args{2};
    
    if size(args, 1) == 2   
        samples = 1024;
    else
        samples = args{3};
    end
    
 
    
    w = linspace(freq(1), freq(end), samples);
    z = exp(-1j*w);
    
    if strcmpi(type, 'IIR')
        b = filters(1:end/2, :);
        a = filters(end/2 + 1 : end, :);
        h = zeros(size(filters,2), length(w));
        for i=1:size(filters,2)
            h(i,:) = polyval(b(:,i), z)./polyval(a(:,i), z);
        end
    elseif strcmpi(type, 'FIR')
        b = filters(1:end, :);
        h = zeros(size(filters,2), length(w));
        for i=1:size(filters,2)
            h(i,:) = polyval(b(:,i), z);
        end
    else
        disp('Invalid filter type.');
        return;
    end
        
end

