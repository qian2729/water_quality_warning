

% Block 1: Input files with and without simulated events
%-------------------------------------------------------------------------
FileNameNormal= 'data_without_events.txt';
normal_data=load(FileNameNormal);     %Load normal data
events_data=load(FileNameEvents);     %Load data with events 

% Block 2: Devide data into three sets and choose train and sets.
%-------------------------------------------------------------------------
kFold=3;
l=round(size(normal_data,1)/kFold);
if kFold*l~=size(normal_data,2)
    ll=size(normal_data,1)-(kFold-1)*l;% test data length
end
AAA=[normal_data,events_data]; % [normal_data events_data]
for i=2%kFold%:-1:1 
    temp=AAA([(i-1)*l+1:(i-1)*l+ll],:); % 将前三分之一和后三分之一数据放在一起，中间三分之一数据放在最后
    AAA([(i-1)*l+1:(i-1)*l+ll],:)=[];
    AAA=[AAA;temp];                             %Place the test set at the end of the data set
end
quality_data1=AAA(:,1:size(normal_data,2));   % 总的没有污染事件的数据  （已经移动位置）      
quality_data=AAA(:,size(normal_data,2)+1:end); % 总的有污染事件的数据    （已经移动位置）  
d_normal=quality_data1(:,3:end);                %Data without events
d_full=quality_data(:,3:end);                   %Data with events
events_flag=quality_data(:,2);                  %Dummy variable 1: event, 0: no-event

% Block 3: Define the explanatory variables for each of the indicators
%-------------------------------------------------------------------------
%％ 调整ANN的输入：t时刻其他五个测量值和t－1时刻该变量的观测值
for idx=1:6
t_lag=1;
lagY=[];
for i=1:t_lag
    temp=d_normal(1,idx)*ones(1,t_lag-i+1);
    temp=[temp';d_normal(1:end-length(temp),idx)];
    lagY=[lagY,temp];
end
Xdata_normal = [d_normal(:,[1:idx-1 idx+1:size(d_normal,2)]) lagY];
Ydata_normal=d_normal(:,idx);
lagY=[];
for i=1:t_lag
    temp=d_full(1,idx)*ones(1,t_lag-i+1);
    temp=[temp';d_full(1:end-length(temp),idx)];
    lagY=[lagY,temp];
end
Xdata_events = [d_full(:,[1:idx-1 idx+1:size(d_full,2)]) lagY];
Ydata_events=d_full(:,idx);
k=size(normal_data,1)-ll;

% Block 4: Save the explanatory and the dependent variables for each of the indicators
%          for both train and test data sets
%-------------------------------------------------------------------------
% 划分好的训练和测试数据（整个模型需要的数据都在这里），x为T-1时刻某一变量的观测值及T时刻其他5个变量的观测值（一行6个变量），
% y为实际t时刻的该变量的真实值
Xdata_normal_train{idx}=Xdata_normal(1:k,:);
Ydata_normal_train{idx}=Ydata_normal(1:k);
Xdata_events_train{idx}=Xdata_events(1:k,:);
Ydata_events_train{idx}=Ydata_events(1:k);
Ydata_normal_test{idx}=Ydata_normal(k+1:end,:);
Xdata_normal_test{idx}=Xdata_normal(k+1:end,:);
Xdata_events_test{idx}=Xdata_events(k+1:end,:);
Ydata_events_test{idx}=Ydata_events(k+1:end,:);
end

% Block 5: Split the events flag into train and test data set
%-------------------------------------------------------------------------
% 将EVENT的类标分为训练数据和测试数据
events_flag_train=events_flag(1:k);
events_flag_test=events_flag(k+1:end);

% Block 6: Clear unnecesery variables
%-------------------------------------------------------------------------
clearvars -except Xdata_normal_train Ydata_normal_train...
    Xdata_events_train Ydata_events_train Xdata_events_test...
    Ydata_events_test events_flag_train events_flag_test...
    Ydata_normal_test Xdata_normal_test ii jj str

