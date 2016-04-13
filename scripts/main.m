dataset_name = 'feature_dataset_6.mat';
dataset = load(dataset_name);
svmStruct = svmtrain(dataset.train_features,dataset.train_labels,'showplot',true);
