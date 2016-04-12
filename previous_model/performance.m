function [good_prediction bad_prediction]=performance(event_prediction,events_flag)
% how many events are found? how many FP events?
y_err_p=event_prediction;
y=events_flag;
a=0;
check=1;
y_numbered=y;
for j=1:length(y)
    if y(j)==1
        check=0;
        y_numbered(j)=a+1;
    end
    if y(j)==0 & check==0;
        a=a+1;
        check=1;
    end
end
    a=0;
    aa=0;
    temp_number1=0;
    temp_number2=0;
    init_true=0;
    init_est=0;
    check=1;
    check1=0;
    flag1=0;
    flag2=0;
    init_est0=0;
        for j=1:length(y_err_p)
        if y_err_p(j)==1
            if flag1==0
                init_est0=init_est;
                init_est=j;
                flag1=1;
            end
            check=0;
            if y(j)==1
                check1=1;
                temp_number2=y_numbered(j);
                if flag2==0
                    init_true=j;
                    flag2=1;
                end
            end
        end
        if y_err_p(j)==0 && check==0
                if temp_number1<temp_number2
                    a=a+1;
                    temp_number1=temp_number2;
                end
                if init_true>init_est || check1==0
                    if init_est0==0 || init_est-init_est0>=0
                    aa=aa+1;
                    end
                end
                check=1;
                check1=0;
                flag1=0;
                flag2=0;
        end
        end
        good_prediction=a;
        bad_prediction=aa;
        
        