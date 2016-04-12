function [ pars ] = get_default_layer_pars()
%   return default parameters for cdbn layer
% 
    % Initialization
    pars=[];
    
    pars.ws = 10;   % windows size
    pars.spacing = 1; % pool sapce size
    
    pars.pbias = 0.05;
    pars.pbias_lb = 0.05;
    pars.pbias_lambda = 5;
    pars.bias_mode = 'simple'; 
    
    pars.epsilon = 0.01;
    pars.l2reg = 0.01;
    pars.epsdecay = 0.01;

    pars.std_gaussian = 0.2;
    pars.sigma_start = 0.2; 
    pars.sigma_stop = 0.2; 

    pars.K_CD = 1;  % Etc parameters
    pars.CD_mode = 'exp'; 
    pars.C_sigm = 1; 
    
    pars.num_trials = 1;  
end

    


