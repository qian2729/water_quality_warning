function [] = roc(P_event_test,events_flag_test)
    % P_event_test Ԥ���¼������ĸ���
    % events_flag_test ʵ��������¼������ı��
    tprarray = zeros(1,101);
    fprarray = zeros(1,101);
    index = 1;
    for threshold = 0:0.01:1
        pre_event = P_event_test;% Ԥ���¼������ĸ���
        pre_event(pre_event < threshold) = 0;
        pre_event(pre_event >= threshold) = 1;
        ground_true = events_flag_test;%ʵ������µ��¼�����
        true_index = ground_true == 1;%ʵ������·����¼����±�
        should_be_true = pre_event(true_index);%ʵ������·������¼���Ԥ����
        tp = length(find(should_be_true == 1));% true positive 
        fn = length(find(should_be_true == 0));% false positive
        false_index = ground_true == 0;        % ʵ�������δ�����¼����±� 
        should_be_false = pre_event(false_index);%ʵ�������δ�����¼���Ԥ����
        fp = length(find(should_be_false == 1));
        tn = length(find(should_be_false == 0)); 
        tpr = tp / (tp + fn);
        fpr = fp / (fp + tn);
        tprarray(index) = tpr;
        fprarray(index) = fpr;
        index = index + 1;
    end
    plot(fprarray,tprarray);
    title('Roc Curve');
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    