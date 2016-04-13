clear;
clc;
err_dataset = load('err_dataset');
err_train = cell2mat(err_dataset.err_events_train);
err_train_label = err_dataset.events_flag_train;
err_test = cell2mat(err_dataset.err_events_test);
err_test_label = err_dataset.events_flag_test;

tpr_cell = {};
fpr_cell = {};
index = 0;
legends = [];
for level = 0.1:0.1:1
    tpr_array = [];
    fpr_array = [];
    fprintf('level:%d\n',level);
    for c = 0.1:0.1:20
        fprintf('c:%d\n',c);
        svm_struct = svmtrain(err_train,err_train_label,'KKTViolationLevel',level,'boxconstraint',c, 'kernel_function','rbf');
        extimate = svmclassify(svm_struct,err_test);
%         subplot(211)
%         bar(extimate);
%         subplot(212)
%         bar(err_test_label);

        conf = confusionmat(err_test_label,extimate);
        tp = conf(2,2);
        tn = conf(1,1);
        fn = conf(2,1);
        fp = conf(1,2);
        tpr = tp / (tp + fn);
        fpr = fp / (fp + tn);
        tpr_array = [tpr_array tpr];
        fpr_array = [fpr_array fpr];
    end
    index = index + 1;
    tpr_cell{index} = tpr_array;
    fpr_cell{index} = fpr_array;
    legends{index} = num2str(level);
end
figure

for i = 1:index
    plot(fpr_cell{i},tpr_cell{i},'-o');
    hold on;
end
legend(legends);
hold off;

