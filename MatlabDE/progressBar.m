function [ percentage ] = progressBar( totalTicks, current, total, showTime, showRemainingTime, showPercentage, cleanConsole, callback )
    totalTicks = 10*floor(totalTicks/10);
    percentage = (current/total);
    tick = round(percentage*totalTicks);
    percentage = percentage * 100;
    progressBar = ['[', repmat('=',1,tick), repmat(' ',1,totalTicks-tick), ']'];
    if (cleanConsole)
        clc;
    end
    if(showPercentage)
        disp([progressBar(1:end/2) sprintf('%1.2f',percentage) '%' progressBar(end/2+1:end)]);
    else
        disp(progressBar);
    end
    if(showTime)
        toc;
    end

    if(showRemainingTime && percentage > 0 )
      seconds = ceil(toc/2.5)*2.5;
      p = ceil(percentage);
      remainingTime = round((seconds/p)*100) - seconds;
      remainingTime = round(remainingTime/10)*10;
      disp(['Remaining about ' num2str(remainingTime, 10) ' seconds.']);
    end

    if nargin > 7
        callback(current);
    end
end
