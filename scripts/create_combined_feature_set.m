clear;
clc;
path = '../data/data_with_low_events.txt';
event_data = load(path);
% event_data = event_data(1:1000,:);
kFold = 3;
[train_data,train_label,test_data,test_label] = create_train_test_data(event_data,kFold );
nets = load('nets.mat');
for sensor_type = 1:6
    [ train_features{sensor_type},train_labels{sensor_type} ] = create_feature_of_dataset(train_data,train_label,nets.nets(sensor_type));
    [ test_features{sensor_type},test_labels{sensor_type} ] = create_feature_of_dataset(test_data,test_label,nets.nets(sensor_type));
end
train_features = cell2mat(train_features);
train_labels = train_labels{1};
test_features = cell2mat(test_features);
test_labels = test_labels{1};
save('feature_dataset.mat','train_features','train_labels','test_features','test_labels');
clear;