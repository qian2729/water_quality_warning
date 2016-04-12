%% 训练单个传感器数据模型

% add model and util functions to matlab path
addpath('../util');
data_path = '../data/data_without_events.txt';
[data,label] = load_data( data_path );
window_size = 100;
par_1 = get_layer_pars(1,20,1);
par_1.ws = window_size;
par_1.num_trials = 4;
layer_pars = par_1;
step = 200;
sensor_type = 6;
train_data = {};
d = data(:,sensor_type)';
d = d(d< mean(d) * 20);
% [d,ps] = mapminmax(d,0,1);
% scale = max(d);
% d = d / scale;
for j = 1:step:size(data,1)-step
    train_data{ceil(j/step)} = d(j:j + step - 1);
end
% train_data{1} = d;
trained_pars = [];
trained_pars = cdbn_multilayer(train_data,layer_pars,trained_pars);
disp(sum(sum(trained_pars.W)));

save_name = sprintf('net%d.mat',sensor_type);
save(save_name,'trained_pars','sensor_type','window_size');
