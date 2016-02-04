function E2 = evalFilter( filter, args )
    
    % evalFilter( filter, args )
    % args = {func, type, cutoff, sampleSize, plotEnabled}
    
    if nargin < 2
        disp('Not enough arguments.');
        return;
    elseif nargin > 2
        disp('WARNING: Too many arguments.');
    end
    
    if ~iscell(args)
        disp('Invalid arguments')
        return;
    elseif size(args,2) < 4
        disp('Not enough arguments.');
        return;
    elseif size(args,2) > 5
        disp('WARNING: Too many arguments.');
    end
    
    func = args{1};
    type = args{2};
    cutoff = args{3};
    sampleSize = args{4};
    
    if size(args,2) > 4
        plotEnable = args{5};
    else
        plotEnable = false;
    end
    
    if strcmpi(type, 'IIR')
        b = filter(1:end/2,:);        %num
        a = filter(end/2 + 1:end,:);   %den
        [h, w] = freqz(b,a, sampleSize);
    elseif strcmpi(type, 'FIR')
        b = filter;
        [h, w] = freqz(b, sampleSize);
    else
        disp('Invalid filter.');
        return;
    end
    
    
    
    h = abs(h);
    d = func(w, cutoff*pi);
    e = abs(d - h);

    if plotEnable
        plot(w, d, w, h);
        hold on;
        plot(w, e, 'r--');        
        hold off;
        legend('D(\omega)','H(\omega)','E(\omega)');
        title('Frequency Response');
        xlabel('Frequency (\times\pirad/s)');
        ylabel('Gain');
    end
    
    E2 = sqrt((1/(2*pi))*sum(e.^2));
    
%     output_args = {E2, w, h, d, e};
    
end

