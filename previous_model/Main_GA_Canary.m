disp('#####################')
disp('Mashor Housh')
disp('University of Haifa')
disp('17.1.15')
disp('#####################')
%Lower and Upper bounds for parameters
lb=[30 0 2 0.001];                                     %Lower bound
ub=[1000 10 50 0.999];                                 %Upper bound
%Set GA options
options.Display='iter';                                %Display GA iterations 
options.PlotFcns={@gaplotbestf @gaplotbestindiv};      %Display GA iterations graph
options.PopulationSize=25;                             %Population size
options.Generations=50;                                %Set number of generations
options.TolFun=1e-6;                                   %Set ending critiria
options.CrossoverFcn=@crossoverheuristic;              %Set crossover type
options.FitnessScalingFcn=@fitscalingprop;             %Set scaling type
options.MutationFcn= @mutationadaptfeasible;           %Set mutation type
options.SelectionFcn=@selectionroulette;               %Set selection type
options.UseParallel='never';                           %Set parallel computation mode

%Solve calibration problem in offline mode
events_flag=csvread('StationA_events_flag_train.csv',1,0);   %Read events flag for calibration
fun=@(x)GaCanaryObj(x,events_flag);                          %Define objective function
xopt= ga(fun,4,[],[],[],[],lb,ub,[],options);                %Solve optimizaion problem
Z=fun(xopt);                                                 %Evaluate optimal solution
copyfile('conf.yml','optimal_conf.yml')
M = csvread('conf.StationA-summary.csv',1,1);
event_prediction=M(:,3);
[good_prediction bad_prediction]=performance(event_prediction==1,events_flag(1:end-2));

save optimal_canary
