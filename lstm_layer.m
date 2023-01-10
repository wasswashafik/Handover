function [c_t_output, h_t_output] = lstm_layer(x, h_t, c_t, W_i, W_f, W_c, W_o, U_i, U_f, U_c, U_o, b_i, b_f, b_c, b_o)

%f_t = sigmoid(xWf+hUf+bf)          FORGET GATE
%i_t = sigmoid(xWi+hUi+bi)          INPUT GATE
%c_hat_t = tanh(xWc+hUc+bc)         C_t candidates
%c_t = c_t-1 * f_t + i_t * c_hat_t  Update state cell (C_t)
%o_t = sigmoid(xWo+hUo+bo)          OUTPUT GATE
%h_t = o_t*tanh(c_t)                Update output (h_t)


f_t = sigmoid(x * W_f + h_t * U_f + b_f);
i_t = sigmoid(x * W_i + h_t * U_i + b_i);
c_hat_t = tanh(x * W_c + h_t * U_c + b_c);
c_t = c_t .* f_t + i_t .* c_hat_t;
o_t = sigmoid(x * W_o + h_t * U_o + b_o);
h_t = o_t .* tanh(c_t);


c_t_output = c_t; %RECURRENT ACTIVATION FUNCTION
h_t_output = h_t; %ACTIVATION FUNCTION

end

