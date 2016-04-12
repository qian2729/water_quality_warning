function [ tr_pars ] = cdbn(input, pars,tr_pars)
%% cdbn model
% this function trains one layer of cdbn model 
% input parameters:
% input: input data to this layer
% pars: parameters for this layer
% return:
% tr_pars: trained parameters for this layer
    assert(isfield(pars, 'num_channels'));
    assert(isfield(pars, 'num_bases'));
   
    lay_size = length(tr_pars);
    % Initialization
    if (pars.layer <= lay_size) && (isfield(tr_pars(pars.layer), 'W'))
        W = tr_pars(pars.layer).W; 
    else
        W = 0.01*randn(pars.ws, pars.num_channels, pars.num_bases);
    end
    if (pars.layer <= lay_size) && (isfield(tr_pars(pars.layer), 'vbias_vec'))
        vbias_vec = tr_pars(pars.layer).vbias_vec; 
    else
        vbias_vec = zeros(pars.num_channels,1);
    end
    if (pars.layer <= lay_size) && (isfield(tr_pars(pars.layer), 'hbias_vec'))
        hbias_vec = tr_pars(pars.layer).hbias_vec; 
    else
        hbias_vec = -0.1*ones(pars.num_bases,1); 
    end  
        
    initialmomentum  = 0.5;
    finalmomentum    = 0.9;

    error_history = zeros(1,pars.num_trials);
    sparsity_history = zeros(1,pars.num_trials);

    dWnorm_history_CD= [];
    dWnorm_history_l2= [];

    Winc=0;
    vbiasinc=0;
    hbiasinc=0;
    
    %% main loop!! 
    for t=1:pars.num_trials % number of epochs
        epsilon = pars.epsilon / (1 + pars.epsdecay * t);
        ferr_current_iter = [];
        sparsity_curr_iter = [];

        for i = 1:length(input)
            if (mod(i,80) == 0), fprintf('\n'); end
            fprintf('.');
            imdata = input{i};
            % make sure col number of imdata is mod(size(imdata,2)-ws+1,
            % spacing)==0£¬delete others
            imdata = trim_audio_for_spacing_fixconv(imdata, pars.ws, pars.spacing);
            % transport imdata
            imdatatr = imdata'; 
            % reshape imdatato 3D£¬shape is  sample size * 1 * channel_size
            imdatatr = reshape(imdatatr, [size(imdatatr,1), 1, size(imdatatr,2)]);
            [ferr,dW,dh,dv,poshidprobs,~,~,stat] = ...
                 fobj_tirbm_CD_LB_sparse_audio(imdatatr, W, hbias_vec, ...
                  vbias_vec, pars, pars.CD_mode, pars.bias_mode, pars.spacing, pars.l2reg);

            ferr_current_iter = [ferr_current_iter, ferr];
            sparsity_curr_iter = [sparsity_curr_iter, mean(poshidprobs(:))];

            if t<5,
                momentum = initialmomentum;
            else
                momentum = finalmomentum;
            end

            dWnorm_history_CD(i,t) = stat.dWnorm_CD;
            dWnorm_history_l2(i,t) = stat.dWnorm_l2;

            % update parameters
            Winc = momentum*Winc + epsilon*dW;
            W = W + Winc;

            vbiasinc = momentum*vbiasinc + epsilon*dv;
            vbias_vec = vbias_vec + vbiasinc;

            hbiasinc = momentum*hbiasinc + epsilon*dh;
            hbias_vec = hbias_vec + hbiasinc;
        end

        if (pars.std_gaussian > pars.sigma_stop) % stop decaying after some point
            pars.std_gaussian = pars.std_gaussian*0.99;
        end
        error_history(t) = mean(ferr_current_iter);
        sparsity_history(t) = mean(sparsity_curr_iter);

        fprintf('\nepoch %d error = %g \tsparsity_hid = %g\n', t, mean(ferr_current_iter), mean(sparsity_curr_iter));
    end
    tr_pars(pars.layer).W = W;
    tr_pars(pars.layer).pars = pars;
    tr_pars(pars.layer).vbias_vec = vbias_vec;
    tr_pars(pars.layer).hbias_vec = hbias_vec;
    tr_pars(pars.layer).error_history = error_history;
    tr_pars(pars.layer).sparsity_history = sparsity_history;
    tr_pars(pars.layer).dWnorm_history_CD = dWnorm_history_CD;
    tr_pars(pars.layer).dWnorm_history_l2 = dWnorm_history_l2;
end

