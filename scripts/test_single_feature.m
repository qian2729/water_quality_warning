addpath('../util');
event_path = '../data/data_with_low_events.txt';
[ event_data,event_label ] = load_data( event_path );
sensor_type = 6;
sensor_data = event_data(:,sensor_type);
window_size = 100;
window_count = size(sensor_data,1) - window_size + 1;
window_features = cell(window_count,1);
net_name = sprintf('net%d.mat',sensor_type);
net = load(net_name);
for i = 1:20:window_count
    if mod(i,100) == 0
        fprintf('processing: %d/%d\n',i,window_count);
    end
    sub_data = sensor_data(i:i + window_size - 1,:);
    sub_event_data = event_data(i:i + window_size - 1,:);
%     plot(sub_data);
    window_features{i} = get_feature_of_window(sub_data',net);
    disp(sum(window_features{i}));
end
features = cell2mat(window_features);
% dlmwrite('no_event_window_features.mat','features');