function [ output ] = polling(state,spacing)
% get polling output based on hidden layer state
    % remove useless dimention and transport it to channel * time sample
    % size
    state = squeeze(state)';
    n = size(state,2);
    output_size = (n - mod(n,spacing)) / spacing;
    output = zeros(size(state,1),output_size);
    for i = 1:output_size
        output(:,i) = max(state(:,(1 + (i - 1) * spacing):i * spacing),[],2);
    end
end

