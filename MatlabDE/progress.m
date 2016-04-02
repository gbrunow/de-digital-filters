function [ out ] = progress(X, message)
    persistent h
    if isempty(h)
        h = waitbar(0,'Please wait...'); 
    end
    if X == 1
        if ~isempty(h)
            close(h);
            clear h;
        end
        uiwait(msgbox(message,['Finished in ' num2str(round(toc)) ' seconds.'], 'modal'));
    else
        waitbar(X, h, message);     
    end
end

