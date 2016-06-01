function [ out ] = progress(X, message, showEndBox)
    if nargin < 3
        showEndBox = true;
    end
    persistent h
    if isempty(h)
        h = waitbar(0,'Please wait...'); 
    end
    if X == 1
        if ~isempty(h)
            close(h);
            clear h;
        end
        if showEndBox
            toc;
            uiwait(msgbox(message,['Finished in ' num2str(round(toc)) ' seconds.'], 'modal'));
        end
    else
        waitbar(X, h, message);     
    end
end

