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

% Block 4: Set GA options
%-------------------------------------------------------------------------
options.Display='iter';                           %Display GA iterations 
options.PlotFcns={@gaplotbestf @gaplotbestindiv}; %Display GA iterations graph
options.PopulationSize=180;                       %Population size
options.Generations=50;                           %Set number of generations
options.TolFun=1e-6;                              %Set ending critiria
options.CrossoverFcn=@crossoverheuristic;         %Set crossover type  Ⱦɫ�彻������
options.FitnessScalingFcn=@fitscalingprop;        %Set scaling type  ��Ӧ�Ⱥ�����ϵͳ�Դ���
options.MutationFcn= @mutationadaptfeasible;      %Set mutation type  ����
options.SelectionFcn=@selectionroulette;          %Set selection type ѡ��������Ⱥ
options.UseParallel='always';                     %Set parallel computation mode  �������㣨���Զ��CPU���У�

% Block 5: Set low bounds and high bounds for GA x's values.�������Ŵ��㷨�����½�
%-------------------------------------------------------------------------
lb=[0.01*ones(1,6) 0*ones(1,6) 0*ones(1,6) 0*ones(1,6) -10*ones(1,6)]; %Lower bounds ...
%...[winsize upper-threshold-factor lower-threshold-factor upper-filter lower-filter]
ub=[0.2*ones(1,6) 2*ones(1,6) 2*ones(1,6) 10*ones(1,6) 0*ones(1,6)]; %Upper bounds

% Block 6: Caculate error for the training phase  ������в�
%-------------------------------------------------------------------------
for i=1:6
    eval(['Model=net' num2str(i) ';']);                 %Choose the specific parameter network.
    err_events_train{i}=sim(Model,...
        Xdata_events_train{i}')'-Ydata_events_train{i}; %Calculate the errors
end

% Block 7: Solve calibration problem in offline mode  ���Ż�30������
%-------------------------------------------------------------------------
fun=@(x)offline(err_events_train,...                    ����������������OFFLINE����
    events_flag_train,x(1:6),x(7:18),x(19:30));         %Define objective function
xopt= ga(fun,30,[],[],[],[],lb,ub,[],options);          %Solve optimizaion problem
[Z,TPvec,FPvec,B]=fun(xopt);                            %Evaluate optimal solution


% Block 8: Caculate error for the testing phase  ���������ݵĲв����
%-------------------------------------------------------------------------
for i=1:6
    eval(['Model=net' num2str(i) ';']);                       %Choose the specific parameter network.
    err_events_test{i}=sim(Model,...
        Xdata_events_test{i}')'-Ydata_events_test{i};         %Calculate errors
    winsizevec(i)=round(length(err_events_train{i})*xopt(i)); %Add the last window in train data to test data
    err_test_input{i}=[err_events_train{i}(end-winsizevec(i)+2:end) ; err_events_test{i}];
end

% Block 9: Calculate the  performance in the testing phase
% ���ò������ݲ��10��EVENT
%-------------------------------------------------------------------------
[TP_test FP_test P_event_test]= online(err_test_input,events_flag_test,TPvec,FPvec,B,winsizevec,xopt(7:18),xopt(19:30));

