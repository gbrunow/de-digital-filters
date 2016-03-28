function [ percentage ] = progressBar( totalTicks, current, total, showTime, showPercentage)
    totalTicks = 10*floor(totalTicks/10);
    percentage = (current/total);
    tick = round(percentage*totalTicks);
    percentage = percentage * 100;
    progressBar = ['[', repmat('=',1,tick), repmat(' ',1,totalTicks-tick), ']'];
    clc;
    if(showPercentage)
        disp([progressBar(1:end/2) sprintf('%1.2f',percentage) '%' progressBar(end/2+1:end)]);
    else
        disp(progressBar);
    end
    if(showTime)
        toc;
    end
end

