function [Z TPvec FPvec B good_prediction bad_prediction PHAT]=offline...
    (err_events_train,events_flag,winvec,tawvec,taw_outliersvec)

for ii=1:6           %Loop over water quality indicator
    
    % Block 1: Get the control variables for the specific indicator
    %-------------------------------------------------------------------------
    win=winvec(ii);
    taw=[tawvec(ii) tawvec(ii+6)];
    taw_outliers=[taw_outliersvec(ii) taw_outliersvec(ii+6)];
    
    % Block 2: Caculate the dynamic thresholds
    %-------------------------------------------------------------------------
    LevelP=0; LevelN=0;                                     %Intialize
    winsize=round(length(err_events_train{ii})*win);        %Get window size
    err_events=[err_events_train{ii}(end-winsize+2:end)...  %Add last window size to beginning of the train
        ; err_events_train{ii}];
    for i=winsize:length(err_events)
        win_err=err_events(i-winsize+1:i);
        win_err_no_outliers=win_err((win_err<=taw_outliers(1))&(win_err>=taw_outliers(2)));
        if ~isempty(win_err_no_outliers)
            penalty(ii)=0;
            MM=mean(win_err_no_outliers);
            SS=std(win_err_no_outliers);
            LevelP(i,1)=MM+taw(1)*SS;
            LevelN(i,1)=MM-taw(2)*SS;
        else                                                 %Add penalty if filtered window is empty
            penalty(ii)=1e6;
            LevelP=zeros(length(err_events),1);
            LevelN=zeros(length(err_events),1);
        end
    end
    
    % Block 3: Delete first window since it is not part of the train
    %-------------------------------------------------------------------------
    err_events=err_events(winsize:end);
    LevelP=LevelP(winsize:end);
    LevelN=LevelN(winsize:end);
    
    % Block 4: Caculate the confusion matrix of the outliers
    %-------------------------------------------------------------------------
    outliers=(err_events>LevelP | err_events<LevelN)*1;   %Identify outliers
    C=confusionmat(events_flag,outliers);                 %Calculate confusion matrix of outliers
    TP=C(2,2)/sum(C(2,:));                                %Calculate TPR
    FP=1-C(1,1)/sum(C(1,:));                              %Calculate FPR
    TPvec(ii)=TP;                                         %Save indicators TPR
    FPvec(ii)=FP;                                         %Save indicators FPR
    
    % Block 5: Calculate event probablity from each indicator
    %-------------------------------------------------------------------------
    P_event=0;                    %Initialize
    pe0=1e-5;                     %Set value for initial probability of an event
    alpha=0.6;                    %Set smoothing parameter 0.3<alpha<0.9
    pe=pe0;
    for i=1:length(err_events)    %Iterate Bayse Update Rule
        temp_err=err_events(i);
        if temp_err>LevelP(i) || temp_err<LevelN(i)   %If Outlier then
            pe1=pe;
            pe=TP*pe/(TP*pe+FP*(1-pe));               %Outlier Bayse rule
            pe=alpha*pe+(1-alpha)*pe1;                %Smoothing
            pe=min(pe,0.95);                          %Eliminate convergence to 1
        else
            pe1=pe;
            pe=(1-TP)*pe/((1-TP)*pe+(1-FP)*(1-pe));   %No-Outlier Bayse rule
            pe=alpha*pe+(1-alpha)*pe1;                %Smoothing
            pe=max(pe,pe0);                           %Eliminate convergence to 0
        end
        P_event(i,1)=pe;                              %Save probability vector fro each indicator
    end
    P_event_all{ii}=P_event;                          %Save indicators probabilities
end


% Block 6: Fit Logit model based on the single indicator probabity
%-------------------------------------------------------------------------
P_event=cell2mat(P_event_all);
B=mnrfit(P_event,events_flag+1);                      %Find the maximum liklihood estimator
PHAT=mnrval(B,P_event);                               %Evaluate the Logit model
PHAT=PHAT(:,2);

% Block 7: Classify the unified event probablity based on a variable threshold
%-------------------------------------------------------------------------
Pcr=events_flag*0.5+0.4;               %Set variable critical probability
event_prediction=1*(PHAT>=Pcr);        %Classify

% Block 8: Define the objective function for the calibration
%-------------------------------------------------------------------------
C=confusionmat(events_flag,event_prediction);     %Calculate confusion matrix of events
Z=-trace(C)+sum(penalty);                         %Value to be minimized



