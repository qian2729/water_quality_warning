addpath('../util');
path = '../data/data_without_events.txt';
event_raw_data = load('../data/data_with_low_events.txt');
event_data = event_raw_data(:,6);
no_event_data = load(path);
sensor_data = no_event_data(:,6);
window_size = 200;
window_count = size(sensor_data,1) - window_size + 1;
window_features = cell(window_count,1);
for i = 1:20:window_count
    if mod(i,100) == 0
        fprintf('processing: %d/%d\n',i,window_count);
    end
    sub_data = sensor_data(i:i + window_size - 1,:);
    sub_event_data = event_data(i:i + window_size - 1,:);
%     plot(sub_data);
    window_features{i} = get_feature_of_window(sub_data',sub_event_data');
%     disp(sum(window_features{i}));
end
features = cell2mat(window_features);
% dlmwrite('no_event_window_features.mat','features');