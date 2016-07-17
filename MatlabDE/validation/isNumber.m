function [ validation, number ] = isNumber( str, visible )
%[ validation, number ] = isNumber( str );
    number = str2double(str);
    validation = ~isempty(str) || ~visible;
end

