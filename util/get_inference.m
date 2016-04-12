function [ h_states,h_probs ] = get_inference(data,trained_par)
%GET_INFERENCE Summary of this function goes here
%   Detailed explanation goes here
    h_states = cell(1,size(data,2));
    h_probs = cell(1,size(data,2));
    for i = 1:size(data,2)
        [h_state,h_prob] = inference(data{i},trained_par.W,trained_par.hbias_vec, trained_par.vbias_vec,trained_par.pars );
        h_states{i} = h_state;
        h_probs{i} = h_prob;
    end
end

