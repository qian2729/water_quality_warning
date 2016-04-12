function [ features,labels ] = create_feature_of_dataset(data,labels,net)
%   create normal dataset given the input data
%   
    window_size = net.window_size;
    window_count = size(data,1) - window_size + 1;
    sensor_data = data(:,net.sensor_type);
%     sensor_data = mapminmax('apply',sensor_data,net.ps);
    window_features = cell(window_count,1);
    for i = 1:window_count
        if mod(i,100) == 0
            fprintf('processing: %d/%d\n',i,window_count);
        end
        sub_data = sensor_data(i:i + window_size - 1);
        window_features{i} = get_feature_of_window(sub_data',net);
    end
    features = cell2mat(window_features);
    labels = labels(window_size:end);
end

