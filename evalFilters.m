function [ output_args ] = evalFilters( filters, args )
    
    % evalfilters( filters, args )
    % args_____._____ func
    %          |_____ cutoff
    %          |_____ freqzArgs_____._____ type
    %          |                    |_____ freq
    %          |                    |_____ samples
    %          |_____ extraInfo
    
    
    if nargin < 2 || ~iscell(args) || size(args, 2) < 3
        disp('Not enough or invalid arguments.');
        return;
    end
    
    func = args{1};
    cutoff = args{2};
    freqzArgs = args{3};
    
    [h, w] = fast_freqz(filters, freqzArgs);
    
    h = abs(h);
    d = func(w, cutoff*pi);
    
    errors = ones(size(filters,2),1);
    for i=1:size(filters,2)
        e = abs(d - h(i,:));
        errors(i) = mean(e.^2);
    end

    if size(args, 2) > 3
        extraInfo = args{4};
    else
        extraInfo = false;
    end
    
    if extraInfo
        output_args = { errors, w, h, d, e };
    else
        output_args = errors;  
    end
    
end

