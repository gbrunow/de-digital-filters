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
    xlabel('Frequency (rad/samples)');
    ylabel('Gain');
    ax = gca;
    set(ax,'XTick',[0 0.25*pi 0.5*pi 0.75*pi pi])
    set(ax,'XTickLabel',{'0','\pi/4','\pi/2','3\pi/4','\pi'})
    xlim([min(w) max(w)]);
    
    output_args = [error, index];
end

