
% �������ݣ�ѵ����ѡ���㷨
max_detectors = 100;
min_dist = 1.95;
detectors = generate_detectors(max_detectors, train_normal_features, min_dist);
inference_label = apply_detectors(detectors,test_event_features,min_dist);
figure;
subplot(2,1,1);
bar(events_flag_test);
subplot(2,1,2);
bar(inference_label);


