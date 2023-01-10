function [y]= prediction_filter(u, threshold)

persistent counter_ones
persistent counter_zeros
persistent pull_detected
persistent prev_u
persistent error
persistent prev_error

if isempty(counter_ones)
    counter_ones = 0;
    counter_zeros = 0;
    prev_u = 0;
    error = 0;
    prev_error =0;
end

if u == 1
    counter_ones = counter_ones + 1;
else
    counter_zeros = counter_zeros + 1;     
end

if prev_u == 0 && u == 1
    counter_zeros = 0;
end

if counter_ones > threshold && counter_zeros < threshold
    pull_detected = 1;
else
    pull_detected = 0;
end

if counter_zeros >= threshold
    counter_ones = 0;
end

% if pull_detected == 1 && prev_error ==0
%     error = error_z;
% end
% if pull_detected == 0 && prev_error ~= 0
%     error = prev_error;
% elseif pull_detected == 0 && prev_error == 0
%     error =0;
% end
% 
% prev_error = error;
prev_u = double(u);
% z = error;
y = pull_detected;