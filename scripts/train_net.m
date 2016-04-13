%% This script is for train CDBN model

% add model and util functions to matlab path
addpath('../util');
data_path = '../data/data_without_events.txt';
[data,label] = load_data( data_path );
window_size = 100;
par_1 = get_layer_pars(1,30,1);
par_1.ws = window_size;
par_1.num_trials = 1;
layer_pars = par_1;
step = 200;
nets = [];
for i = 1:6
    train_data = {};
    d = data(:,i)';
    d = d(d< mean(d) * 20);
    [d,ps] = mapminmax(d,0,1);
    for j = 1:step:size(data,1)-step
        train_data{ceil(j/step)} = d(j:j + step - 1);
    end
    trained_pars = [];
    trained_pars = cdbn_multilayer(train_data,layer_pars,trained_pars);
    nets(i).trained_pars = trained_pars;
    nets(i).ps = ps;
    nets(i).window_size = window_size;
    nets(i).sensor_type = i;
end
save('nets.mat','nets');
