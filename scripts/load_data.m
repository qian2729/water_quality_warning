function [ data,label ] = load_data( data_path )
%   ����ȥ��ʱ��֮�������
%   ������֪���ݺ�������
    raw_data = load(data_path);
    data = raw_data(:,3:8);
    label = raw_data(:,2);
end

