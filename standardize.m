function [output] = standardize(data, params)

data_std = (data - params(1)) / params(2);

output = data_std;

end