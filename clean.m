function [output] = clean(input, threshold)

if(input > threshold)
    output = 1;
else
    output = 0;
end
%output = input;
end

