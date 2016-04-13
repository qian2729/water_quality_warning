% 加载训练数据
% sensor_type = 6;
% dataset_name = sprintf('feature_dataset_%d.mat',sensor_type);
dataset_name = 'feature_dataset.mat';
dataset = load(dataset_name);

% % 给定数据，训练否定选择算法
max_detectors = 500;
min_dist = 3;
detectors = generate_detectors(max_detectors, dataset.train_features,dataset.train_labels, min_dist);
inference_label = apply_detectors(detectors,dataset.test_features,min_dist);
figure;
subplot(2,1,1);
bar(dataset.test_labels);
subplot(2,1,2);
bar(inference_label);


