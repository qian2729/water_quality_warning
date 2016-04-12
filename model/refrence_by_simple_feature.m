function [ feature ] = refrence_by_simple_feature( data )
%REFRENCE_BY_SIMPLE_FEATURE Summary of this function goes here
%   Detailed explanation goes here
    mean_f = mean(data);
    max_f = max(data);
    min_f = min(data);
    median_f = median(data);
    std_f = std(data);
    abs_mean_f = mean(abs(data));
    feature = [mean_f; max_f; min_f; median_f; std_f; abs_mean_f];

end

