function [ feature ] = get_feature_of_window( window_data,model )
%   Given data in the window, return feature 
%
    layer = 1;
    [~,probs] = get_multilayer_inference(window_data,model.trained_pars,layer);
    feature = squeeze(probs)';
%     subplot(2,1,1);
%     ylim([0,1]);
%     bar(feature);
%     subplot(2,1,2);
%     plot(window_data');
%     ylim([0,1]);
%     subplot(3,1,2);
%     bar(abs(event_feature - feature));
%     ylim( [0,0.5] );
    
%     ylim([0,1]);
%     hold on;
%     plot(event_data');
%     hold off;
 end

