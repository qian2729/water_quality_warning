function [train_data,train_label,test_data,test_label] = create_train_test_data( data,kFold )
%   split data to train and test 
%   
    part_size = round(size(data,1)/kFold);
    test_size = size(data,1) - (kFold - 1) * part_size;
    train = [data(1:part_size,:);data(part_size + test_size + 1:end,:)];
    test = data(part_size + 1:part_size + test_size,:);
    train_data = train(:,3:8);
    train_label = train(:,2);
    test_data = test(:,3:8);
    test_label = test(:,2);
end

