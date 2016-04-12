%% This script is for train CDBN model

% add model and util functions to matlab path
addpath('../util');
data_path = '../data/data_without_events.txt';
raw_data = load(data_path);
data = raw_data(:,3:8);
par_1 = get_layer_pars(1,60,1);
par_1.ws = 200;
par_1.num_trials = 100;
layer_pars = par_1;
step = 400;
nets = [];
for i = 2:2%size(data,2)
    train_data = {};
    d = data(:,i)';
    d = d(d< mean(d) * 20);
    for j = 1:step:size(data,1)-step
        train_data{ceil(j/step)} = d(j:j + step - 1);
    end
    trained_pars = [];
    trained_pars = cdbn_multilayer(train_data,layer_pars,trained_pars);
    nets(i).trained_pars = trained_pars;
    disp(sum(sum(trained_pars.W)));
end

save('nets.mat','nets');
