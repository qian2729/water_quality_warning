function [ features,labels ] = get_data_of_feature( root )
%   Given root path, return feature of data in this path
%   and return the activity label
    % add model and util funtions to matlab path
    addpath('../model/');
    % load trained model parameters
    gyro = load('../result/type_GYRO_time_2016_03_02_10_40.mat');
    acc = load('../result/type_ACC_time_2016_03_02_10_02.mat');
    [acc_data,gyro_data] = get_all_activity_data(root);

    features = [];
    labels = [];
    start_pos = 1;
    label = 1;
    for i = 1:size(gyro_data,2)
        end_pos = start_pos + size(gyro_data{i},2) - 1;
        [acc_states,acc_probs] = get_multilayer_inference(acc_data{i},acc.trained_pars,1);
        [gyro_states,gyro_probs] = get_multilayer_inference(gyro_data{i},gyro.trained_pars,1);
        combine_features = get_combine_feature( acc_probs,gyro_probs );
        labels(start_pos:end_pos) = label;
        label = label +  1;
        start_pos = end_pos + 1;
        features = [features;cell2mat(combine_features)];
    end 

end

