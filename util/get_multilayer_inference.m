function [ h_states,h_probs ] = get_multilayer_inference(input,trained_pars,layer)
%GET_MULTILAYER_INFERENCE Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:layer
        trained_par = trained_pars(i);
        [ h_states,h_probs ] = inference(input,trained_par.W,trained_par.hbias_vec,...
                                trained_par.vbias_vec,trained_par.pars );
        if i ~= layer
            input = get_hidden_output_with_matrix(h_states,trained_pars(i));
        end
    end

end

