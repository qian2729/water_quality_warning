function [ train_data ] = load_train_dataset(path)
%   load train dataset given the data path
%  
% path  = '../data_without_events.txt';
no_event_data = load(path);
sensor_data = no_event_data(:,4:4);
part_size = 200;
step = part_size / 2;
train_size = floor((size(sensor_data,1) - part_size) / step) + 1;
train_data = cell(train_size,1);
index = 1;
for start = 1:step:size(sensor_data,1) - part_size + 1
    train_data{index} = sensor_data(start:start + part_size - 1,:)';
    index = index + 1;
end

end

