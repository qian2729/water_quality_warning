function [ output ] = get_hidden_output_with_matrix(h_states,trained_par)
%GET_POOLING_OUTPUT Summary of this function goes here
%   Detailed explanation goes here
        output = polling(h_states,trained_par.pars.spacing);
end
