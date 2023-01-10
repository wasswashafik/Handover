function [output] = sigmoid(input)

output = (1 + exp(-input)) .^ -1;

end

