function [ descriptor ] = get_descriptor_from_data_with_model( input,layer_size,acc,gyro )
%   return feature of the input data
%   input: 6 * sample_size;first 3 rows is acc data, last 3 rows is gyro
%   data
%   
    % add model and util funtions to matlab path
    addpath('../util/');
    % load trained model parameters
    
    [acc_state,acc_prob] = get_multilayer_inference_with_matrix(input(1:3,:),acc.trained_pars,layer_size);
    [gyro_state,gyro_prob] = get_multilayer_inference_with_matrix(input(4:6,:),gyro.trained_pars,layer_size);
    acc_des = get_descriptor_with_matrix(acc_prob);
    gyro_des = get_descriptor_with_matrix(gyro_prob);
    descriptor = [acc_des,gyro_des];
end

