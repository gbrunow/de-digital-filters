function [ output_args ] = plotBestFilter( args )

    if ~iscell(args) || size(args,2) < 5
        disp('Not enough or invalid arguments.');
    end
    
    errors = args{1};
    w = args{2};
    h = args{3};
    d = args{4};
    e = args{5};
    
    [error, index] = min(errors);
    hbest = h(index, :);
    ebest = abs(d - hbest);
    plot(w, d, w, hbest);
    hold on;
    plot(w, ebest, 'r--');        
    hold off;
    legend('D(\omega)','H(\omega)','E(\omega)');
    title('Frequency Response');
    xlabel('Frequency (\times\pirad/samples)');
    ylabel('Gain');
    
    output_args = [error, index];
end

