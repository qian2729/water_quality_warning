% load data for train
data_path = '../data/data_without_events.txt';
raw_data = load(data_path);
raw_data = raw_data(1:10000,:);
normal_dataset = create_normal_dataset(raw_data);
save('normal_dataset.mat','normal_dataset');

