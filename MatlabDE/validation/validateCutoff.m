function [ validation, cutoff ] = validateCutoff( cutoff1, cutoff2, band )
% validateCutoff( cutoff1, cutoff2, band )
% band = is bandpass/bandstop
    [validation, cutoff1] = isNumber(cutoff1, true);
    
    validation =  validation && cutoff1 > 0;
    [validation2, cutoff2] =  isNumber(cutoff2, band);
    validation = validation && validation2;
    if validation2 && band && ~isempty(cutoff2)
         validation = validation && cutoff2 > cutoff1;
    end
    
    if band
        cutoff = [ cutoff1 cutoff2 ];
    else
        cutoff = cutoff1;
    end
end