function [ data,label ] = load_data( data_path )
%   返回去掉时间之后的数据
%   并将感知数据和类标分离
    raw_data = load(data_path);
    data = raw_data(:,3:8);
    label = raw_data(:,2);
end

