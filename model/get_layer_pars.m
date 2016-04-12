function [ pars ] = get_layer_pars( layer,num_bases,num_channels)
% get layer parameters
% 
    pars = get_default_layer_pars();
    pars.num_channels = num_channels;
    pars.num_bases = num_bases;
    pars.layer = layer;
%     pars.ws = ws;
%     pars.spacing = spacing;
%     pars.num_trials = num_trials;
    fprintf('Layer %d parmeters',layer);
    disp(pars);
end

