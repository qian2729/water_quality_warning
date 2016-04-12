clc
clear
close all

% Block 1: Input file with simulated events
%-------------------------------------------------------------------------
FileNameEvents='data_with_low_events.txt';

% Block 2: Prepare data according to Prepare_Data.m
%-------------------------------------------------------------------------
Prepare_Data

% Block 3: Load the neuaral network for the specific normal condition data file.
%-------------------------------------------------------------------------
load ('trained_neural_networks.mat')


% Block 6: Caculate error for the training phase  £•º∆À„≤–≤Ó
%-------------------------------------------------------------------------
for i=1:6
    eval(['Model=net' num2str(i) ';']);                 %Choose the specific parameter network.
    err_normal_train{i}=sim(Model,...
        Xdata_normal_train{i}')'-Ydata_normal_train{i}; %Calculate the errors
    err_events_test{i} = sim(Model,...
        Xdata_events_test{i}')'-Ydata_events_test{i}; %Calculate the errors
end
train_normal_features = cell2mat(err_normal_train);
test_event_features = cell2mat(err_events_test);



