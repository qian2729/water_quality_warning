function [Z]=GaCanaryObj(x,events_flag)
%Decision variable
HW=x(1);
OT=x(2);
BED=x(3);
ET=x(4);
%Round Decision varaibles
HW=roundn(HW,0);
OT=roundn(OT,-3);
BED=roundn(BED,0);
ET=roundn(ET,-3);

% Read Template
fid=fopen('Template.yml');
A=textscan(fid,'%s','delimiter','\n','whitespace','');
fclose(fid);
lines=A{1};

%modify paramters
lines{100}=['  history window: ' num2str(HW)];
lines{101}=['  outlier threshold: ' num2str(OT)];
lines{106}=['    window: ' num2str(BED)];
lines{102}=['  event threshold: ' num2str(ET)];

%write paramters
fid=fopen('conf.yml','w');
for i=1:length(lines)
fprintf(fid,'%s',[lines{i} sprintf('\r\n')] );
end
fclose(fid);

%run canry
dos(['"C:\Program Files (x86)\CANARY\bin\canary.exe" ' pwd  '\conf.yml']);

%convert canary data
dos(['"C:\Program Files (x86)\CANARY\bin\canary.exe" --convert ' pwd  '\conf.StationA.edsd']);

% read results
M = csvread('conf.StationA-summary.csv',1,1);
event_prediction=M(:,3);

try
C=confusionmat(events_flag==1,event_prediction==1);                   %Calculate confusion matrix of events
Z=-trace(C);                                                          %Value to be minimized
catch
    try
    C=confusionmat(events_flag(1:end-2)==1,event_prediction==1);     %Calculate confusion matrix of events*
    Z=-trace(C);                                                     %Value to be minimized
    catch
    save debuging_workspace
    end
end

end

%* canary does not report the last two steps in summary.

