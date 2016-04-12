function [ labels ] = apply_detectors( detectors, test_dataset, min_dist )
%   根据训练好的监测器，对测试数据进行推断
%   
    dataset_size = size(test_dataset,1);
    labels = zeros(1,dataset_size);
    
    for i = 1:dataset_size
        if is_match(test_dataset(i,:),detectors,zeros(1,size(detectors,1)),min_dist)
           labels(i) = 1;
           break;
        end
    end
end

