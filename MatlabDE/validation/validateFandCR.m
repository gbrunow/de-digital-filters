function [ validation, number ] = validateFandCR( str, visible )
%[ number, validation ] = validateFandCR( str, visible )
    [validation, number] = isNumber(str, visible);
    validation =  validation && number > 0 && number <= 1;
end

