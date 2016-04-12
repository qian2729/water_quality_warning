function [good_prediction, bad_prediction, PHAT]=online(err_events_test,events_flag,TPvec,FPvec,B,winsizevec,tawvec,taw_outliersvec)

for ii=1:6            %Loop over water quality indicator
    
    % Block 1: Get the configiration for the specific indicator
    %-------------------------------------------------------------------------
    err_events=err_events_test{ii};
    winsize=winsizevec(ii);
    taw=[tawvec(ii) tawvec(ii+6)];
    taw_outliers=[taw_outliersvec(ii) taw_outliersvec(ii+6)];
    TP=TPvec(ii);
    FP=FPvec(ii);
    
    % Block 2: Caculate the dynamic thresholds
    %-------------------------------------------------------------------------
    LevelP=0; LevelN=0;              %Intialize
    for i=winsize:length(err_events)
        win_err=err_events(i-winsize+1:i);
        win_err_no_outliers=win_err((win_err<=taw_outliers(1))&(win_err>=taw_outliers(2)));
        MM=mean(win_err_no_outliers);
        SS=std(win_err_no_outliers);
        LevelP(i,1)=MM+taw(1)*SS;
        LevelN(i,1)=MM-taw(2)*SS;
    end
    
    % Block 3: Delete first window since it belong to the train data set
    %-------------------------------------------------------------------------
    err_events=err_events(winsize:end);
    LevelP=LevelP(winsize:end);
    LevelN=LevelN(winsize:end);
    
    % Block 4: Calculate event probablity from each indicator
    %-------------------------------------------------------------------------
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
        P_event(ii,i)=pe;                             %Save indicators probabilities
    end
end

% Block 5: Fuse the single idicators probablity based on the optimal logit model
%-------------------------------------------------------------------------
PHAT=mnrval(B,P_event');
PHAT=PHAT(:,2);

% Block 6: Classify the unified event probablity based on a constant threshold
%-------------------------------------------------------------------------
Pcr=0.9;                               %Set critical probability to alarm events.
event_prediction=1*(PHAT>=Pcr);        %Classify

% Block 7: Count the true postive and false positive events
%-------------------------------------------------------------------------
[good_prediction bad_prediction]=performance(event_prediction,events_flag);


