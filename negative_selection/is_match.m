function [ match_result ] = is_match( detector,self_dataset, min_dist )
%ISMATCH Summary of this function goes here
%   Detailed explanation goes here
    match_result = false;
    dataset_size = size(self_dataset,1);

    for i = 1:dataset_size
        dist = norm(detector - self_dataset(i,:));
%         fprintf('dist:%d\n',dist);
        if dist <= min_dist
            match_result = true;
            break;
        end
    end

end

