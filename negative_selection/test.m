% 利用神经网络的残差，基于否定选择算法进行分类
clear;
clc;
dataset = load('err_dataset');
detector_size = 100;
min_dist = [0.05,0.0005,0.05,0.01,0.005,0.05];
for sensor_type = 1:6
    fprintf('sensor:%d\n',sensor_type);
    detectors{sensor_type} = generate_detectors(detector_size,dataset.err_events_train{sensor_type},min_dist(sensor_type));
    extimate{sensor_type} = apply_detectors(detectors{sensor_type},dataset.err_events_test{sensor_type},min_dist(sensor_type));
end
% subplot(211)
figure;
subplot(211)
hold on;
for i = 1:6
    bar(extimate{i})
end
hold off
subplot(212)
bar(dataset.events_flag_test);
