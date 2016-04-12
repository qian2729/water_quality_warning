function [ output ] = get_layer_output(data,trained_pars)
%GET_POOLING_OUTPUT Summary of this function goes here
%   Detailed explanation goes here
    [h_states,~] = get_inference(data,trained_pars);
    output = cell(length(data),1);
    for i = 1:length(output)
       output{i} = polling(h_states{i},trained_pars.pars.spacing);
    end
end

