function [ output ] = get_hidden_output(h_states,trained_par)
%GET_POOLING_OUTPUT Summary of this function goes here
%   Detailed explanation goes here
    output = cell(1,length(h_states));
    for i = 1:length(output)
       output{i} = polling(h_states{i},trained_par.pars.spacing);
    end
end
