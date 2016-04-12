function [ filter ] = remove_outlier_filter( data )
%REMOVEOUTLIER Summary of this function goes here
%   Detailed explanation goes here
    data_std = std(data);   
    data_mean_zero = data - repmat(mean(data),length(data),1);
    daba_abs = abs(data_mean_zero);
    filter = daba_abs < 3 * data_std;
end

