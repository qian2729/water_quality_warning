addpath('../util');
path = '../data/data_without_events.txt';
no_event_data = load(path);



sensor_data = no_event_data(:,4:4);
window_size = 100;
window_count = size(sensor_data,1) - window_size + 1;
window_features = cell(window_count,1);
for i = 1:window_count
    if mod(i,100) == 0
        fprintf('processing: %d/%d\n',i,window_count);
    end
    sub_data = sensor_data(i:i + window_size - 1,:);
    plot(sub_data);
    window_features{i} = get_feature_of_window(sub_data');
end
features = cell2mat(window_features);
dlmwrite('no_event_window_features.mat','features');


kFold = 3;
[data,~,~,~] = create_train_test_data(raw_data,kFold );