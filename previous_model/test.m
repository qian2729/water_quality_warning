
% events='StationA_events_flag_train.csv';
% 
% flags= 'StationA_events_flag_train.csv';
% event_data=csvread(events);     %Load normal dataf
% flag_data=csvread(flags);     %Load data with events 
% len = size(event_data,1);
% start = 1500;
% ends = 3000;
% x = start:ends;
% index = 1;
% % subplot(211)
% plot(x,event_data(start:ends,index),'b',x,flag_data(start:ends,index),'g')
% ylim([1.9 2.5])
% % subplot(212)
% % plot(x,events_data(1500:4000,index),'r')
% % ylim([1.8 2.5])
% % %plot(x,normal_data(:,5),'g',x,events_data(:,5),'r')
% 
% 
% 
% % Block 1: Input file with simulated events
% %-------------------------------------------------------------------------
% FileNameEvents='data_with_low_events.txt';
% 
% % Block 2: Prepare data according to Prepare_Data.m
% %-------------------------------------------------------------------------
% Prepare_Data
% 
% % Block 3: Load the neuaral network for the specific normal condition data file.
% %-------------------------------------------------------------------------
% load ('trained_neural_networks.mat')
% 
% % Block 4: Set GA options
% %-------------------------------------------------------------------------
% options.Display='iter';                           %Display GA iterations 
% options.PlotFcns={@gaplotbestf @gaplotbestindiv}; %Display GA iterations graph
% options.PopulationSize=180;                       %Population size
% options.Generations=50;                           %Set number of generations
% options.TolFun=1e-6;                              %Set ending critiria
% options.CrossoverFcn=@crossoverheuristic;         %Set crossover type
% options.FitnessScalingFcn=@fitscalingprop;        %Set scaling type
% options.MutationFcn= @mutationadaptfeasible;      %Set mutation type
% options.SelectionFcn=@selectionroulette;          %Set selection type
% options.UseParallel='always';                     %Set parallel computation mode
% 
% % Block 5: Set low bounds and high bounds for GA x's values.
% %-------------------------------------------------------------------------
% lb=[0.01*ones(1,6) 0*ones(1,6) 0*ones(1,6) 0*ones(1,6) -10*ones(1,6)]; %Lower bounds ...
% %...[winsize upper-threshold-factor lower-threshold-factor upper-filter lower-filter]
% ub=[0.2*ones(1,6) 2*ones(1,6) 2*ones(1,6) 10*ones(1,6) 0*ones(1,6)]; %Upper bounds
% 
% % Block 6: Caculate error for the training phase
% %-------------------------------------------------------------------------
% for i=1:6
%     eval(['Model=net' num2str(i) ';']);                 %Choose the specific parameter network.
%     err_events_train{i}=sim(Model,...
%         Xdata_events_train{i}')'-Ydata_events_train{i}; %Calculate the errors
% end
% 
% fun=@(x)offline(err_events_train,...
%     events_flag_train,x(1:6),x(7:18),x(19:30));         %Define objective function
% xopt= ga(fun,30,[],[],[],[],lb,ub,[],options);          %Solve optimizaion problem
% [Z TPvec FPvec B]=fun(xopt);                            %Evaluate optimal solution
% subplot(211)
% bar(P_event_test)
% subplot(212)
% bar(events_flag_test)
% [TP_test FP_test P_event_test,P_event_single]= online(err_test_input,events_flag_test,TPvec,FPvec,B,winsizevec,xopt(7:18),xopt(19:30));
% x = 1:size(P_event_single,2);
% for i = 1:6
%     subplot(2,3,i);
%     plot(x,P_event_single(i,:),'b',x,events_flag_test,'r');
% end
tprarray = [];
fprarray = [];
for threshold = 0:0.01:1
    pre_event = P_event_test;
    pre_event(pre_event < threshold) = 0;
    pre_event(pre_event >= threshold) = 1;
    ground_true = events_flag_test;
    true_index = find(ground_true == 1);
    should_be_true = pre_event(true_index);
    tp = length(find(should_be_true == 1));
    fn = length(find(should_be_true == 0));
    false_index = find(ground_true == 0);
    should_be_false = pre_event(false_index);
    fp = length(find(should_be_false == 1));
    tn = length(find(should_be_false == 0)); 
    tpr = tp / (tp + fn);
    fpr = fp / (fp + tn);
    tprarray = [tprarray,tpr];
    fprarray = [fprarray,fpr];
end
plot(fprarray,tprarray);

