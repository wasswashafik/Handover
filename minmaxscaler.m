function [output] = minmaxscaler(data, params, min_range, max_range)
%UNTITLED4 Summary of this function goes here

data_scaled = (data - params(1)) / (params(2)-params(1));
data_normalized = data_scaled * (max_range - min_range) + min_range;

output = data_normalized;
end

