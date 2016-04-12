function [ trained_pars ] = cdbn_multilayer(input,layer_pars,trained_pars)
%   train multi layer cdbn model
%   input is the training set
%   layer_pars defined model parameters of each layer
%   trained_pars is the trained Weight of each layer
    layer_size = length(layer_pars);

    for i = 1:layer_size
        assert(layer_pars(i).layer == i);
        fprintf('Training layer %d\n',i);
        trained_pars = cdbn(input,layer_pars(i),trained_pars);
        if i ~= layer_size
            input = get_layer_output(input,trained_pars(i));
        end
    end
end

