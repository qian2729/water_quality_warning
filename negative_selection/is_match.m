function [ match_result ] = is_match( detector,self_dataset,labels, min_dist )
%ISMATCH Summary of this function goes here
%   Detailed explanation goes here
    match_result = false;
    dataset_size = size(self_dataset,1);
    negative_count = 0;
    for i = 1:dataset_size
        dist = norm(detector - self_dataset(i,:));
        if dist <= min_dist
            if labels(i) == 0
                match_result = true;
                break;
            else
                negative_count = negative_count + 1;
            end
        end
    end
    if sum(labels) > 0 && negative_count == 0
       match_result = true; 
    end
end

