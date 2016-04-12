function [ detectors ] = generate_detectors( max_detectors, self_dataset,labels, min_dist )
%   ���ɼ����
%   max_detectors: ���������
%   self_dataset: ���쳣���ݼ�
%   min_dist�� ƥ����ֵ��<= min_dist Ϊƥ��
    assert(length(self_dataset) >= 1);
    feature_size = length(self_dataset(1,:));
    detectors = zeros(max_detectors, feature_size);
    detector_count = 0;
    while detector_count < max_detectors
       rand_detector = rand(1,feature_size);
       if ~is_match( rand_detector,self_dataset,labels, min_dist) && ...
            ~is_match(rand_detector,detectors, zeros(1,size(detectors,1)), min_dist)
           detector_count = detector_count + 1;
           fprintf('detector count=%d\n',detector_count);
           detectors(detector_count,:) = rand_detector;
       end
    end

end

